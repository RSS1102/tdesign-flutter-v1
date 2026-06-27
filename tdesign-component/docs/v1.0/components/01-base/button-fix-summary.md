# TButton 渐变支持 & M3 防污染 — 修复摘要

> 日期：2026-06-26  
> 分支：`feat/huihuixiaotx_20260620_base`

---

## 改动文件

| 文件 | 改动状态 |
|------|----------|
| `lib/src/components/button/t_button_resolve.dart` | 修改 |
| `lib/src/components/button/t_button.dart` | 修改（含新增辅助方法） |

---

## 背景

- **Material 3 (M3)** 的 `ElevatedButton` 有一组默认样式字段（`backgroundColor`、`overlayColor`、`surfaceTintColor` 等），如果 TDesign 的 `ButtonStyle` merge 未显式覆盖这些字段，就会被 M3 默认值"污染"，导致按钮呈现非预期的视觉效果。
- **渐变按钮** 在 Web 平台上无法正常渲染：`Container` 包裹 `ElevatedButton` 的方式因 M3 `MaterialType.button` 绘制不透明覆盖层而失败，即使设置 `backgroundColor: Colors.transparent` 也不生效。

---

## 修复 1：M3 防污染字段

### 1.1 四个 variant 颜色解析方法

在 `_resolveFillColors` / `_resolveOutlineColors` / `_resolveTextColors` / `_resolveGhostColors` 四个方法返回的 `ButtonStyle` 中，补齐三个字段：

```dart
overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
```

| 字段 | M3 默认值 | 污染影响 | 修复 |
|------|-----------|----------|------|
| `overlayColor` | M3 hover/pressed 叠加色 | 在自定义背景上叠加额外色彩 | 强制 `transparent` |
| `surfaceTintColor` | `ColorScheme.primary` | 对按钮表面"染色" | 强制 `transparent` |
| `shadowColor` | `ColorScheme.shadow` | 与 TDesign 扁平化设计冲突 | 强制 `transparent` |

### 1.2 渐变时的强制覆盖

在 `TButtonResolve.resolve()` 的渐变分支中（P0 之前），设置：

```dart
if (hasGradient) {
  resolved = resolved.merge(
    ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll<Color?>(null),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
    ),
  );
}
```

> `backgroundColor: null` 触发 `ButtonStyleButton` 内部使用 `MaterialType.transparency`，理论上让背景完全透明。

---

## 修复 2：渐变渲染彻底重写

### 2.1 问题根因

调试过程：
1. Theme 传递正确 → `hasGradient=true`, `gradient=LinearGradient(...)`
2. `Container(color: Colors.green)` 包裹测试 → **四角可见绿色，按钮主体仍被蓝色覆盖**
3. 结论：**Flutter Web 上，`ElevatedButton` 的 M3 `MaterialType.button` 即使设置 `backgroundColor: Colors.transparent`，也会绘制不透明覆盖层**

多种尝试均失败的方案：
- `WidgetStatePropertyAll<Color?>(null)` via `ButtonStyle.merge` → 不生效
- `ElevatedButton.styleFrom(backgroundColor: Colors.transparent)` → 不生效
- `ElevatedButton.styleFrom` merge 到 `resolvedStyle` → 不生效

### 2.2 最终方案：放弃 ElevatedButton，使用原生控件

渐变模式下完全放弃 `ElevatedButton`，改用以下原生 Flutter 控件栈：

```
IntrinsicWidth
  └─ ConstrainedBox(minHeight, minWidth)
       └─ Container(BoxDecoration: gradient + borderRadius)
            └─ Material(type: MaterialType.transparency)
                 └─ InkWell(onTap, borderRadius)
                      └─ Padding
                           └─ IconTheme + DefaultTextStyle (fgColor)
                                └─ Row(icon + text)
```

### 2.3 关键组件说明

| 组件 | 作用 |
|------|------|
| `IntrinsicWidth` | 防止容器在 `Wrap` 等布局中无线扩展 |
| `ConstrainedBox` | 补齐 `ElevatedButton.minimumSize` 的高度/宽度约束 |
| `Container(BoxDecoration: gradient)` | 绘制渐变背景 |
| `Material(type: transparency)` | 真正的透明 Material 层，仅提供 Ink 水波纹 |
| `InkWell` | 替代 `ElevatedButton` 的点击交互和水波纹效果 |
| `IconTheme` / `DefaultTextStyle` | 从 `resolvedStyle.foregroundColor` 提取前景色，手动应用到图标和文本 |

### 2.4 代码结构

```dart
// t_button.dart build() 方法
if (gradient != null) {
  // 渐变模式：原生控件栈
  final shape = theme?.effectiveShape ?? TButtonShape.rectangle;
  final borderRadius = BorderRadius.all(Radius.circular(_borderRadiusForShape(shape)));

  // 前景色
  final Set<WidgetState> states = {if (widget.onPressed == null) WidgetState.disabled};
  final Color? fgColor = resolvedStyle.foregroundColor?.resolve(states);

  // Padding
  final EdgeInsets padding = _gradientPadding(effectiveSize, ...);

  // 最小尺寸
  final double minHeight = _sideLengthForSize(effectiveSize);

  // 构建控件栈（见 2.2）
  button = IntrinsicWidth(
    child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: ..., minHeight: minHeight),
      child: Container(
        decoration: BoxDecoration(gradient: gradient, borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        child: Material(type: MaterialType.transparency, ...),
      ),
    ),
  );
} else {
  // 非渐变模式：继续使用 ElevatedButton
  button = ElevatedButton(onPressed: ..., style: resolvedStyle, child: content);
}
```

### 2.5 新增辅助方法

| 方法 | 说明 |
|------|------|
| `_gradientPadding(TButtonSize, bool, bool, TButtonShape)` | 对齐 `_resolveSize` 计算渐变按钮的 padding |
| `_fontSizeForButton(TButtonSize)` | 返回对应尺寸的默认字体大小 |
| `_sideLengthForSize(TButtonSize)` | 返回对应尺寸的按钮边长（对齐 `_resolveSize.sideLength`） |

### 2.6 Demo 验证

Demo 页面路径：`example/lib/page/t_button_page.dart` → `_buildGradientButton`

测试入口：`http://localhost:38094/#button?showAction=1` → 底部「单元测试」模块 → 「渐变色背景按钮」

三个测试用例：
1. `LinearGradient(colors: [Colors.red, Colors.blue])` — 默认水平渐变
2. `LinearGradient(begin: topCenter, end: bottomCenter)` — 纵向渐变
3. `LinearGradient(begin: centerRight, end: centerLeft)` — 反向水平渐变

---

## 完整改动 diff 摘要

### `t_button_resolve.dart`

```diff
 // ===== 四个 variant 颜色解析方法中新增 =====
 _resolveFillColors / _resolveOutlineColors / _resolveTextColors / _resolveGhostColors:
+  overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
+  surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
+  shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),

 // ===== 渐变分支 =====
 if (hasGradient) {
   resolved = resolved.merge(
     ButtonStyle(
-      backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
+      backgroundColor: const WidgetStatePropertyAll<Color?>(null),
+      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
+      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
+      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
     ),
   );
 }
```

### `t_button.dart`

```diff
 // ===== build() 方法重写 =====
- 创建 ElevatedButton → Container 包裹
+ 渐变模式：原生控件栈 (IntrinsicWidth → ConstrainedBox → Container → Material → InkWell → Padding)
+ 非渐变模式：保持 ElevatedButton 不变

 // ===== 新增辅助方法 =====
+ _gradientPadding()
+ _fontSizeForButton()
+ _sideLengthForSize()
```
