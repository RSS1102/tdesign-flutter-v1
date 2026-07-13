# TDivider 0.2.x → V1.0 升级指南

> 基于 [divider.md V1.0 定稿](./divider.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | V1.0 |
|------|-------|------|
| **方向** | `direction` / `Axis` | `layout` / `TDividerLayout` |
| **对齐** | `alignment` / `TextAlignment` | `align` / `TDividerAlign` |
| **虚线** | `isDashed: true` | `dashed: true` |
| **内容** | `text` + `widget` 双通道 | `child` 单一通道 |
| **线粗** | 构造器 `height` / `width` | `TDividerThemeData.thickness` |
| **样式** | 构造器传 `color`/`margin`/`gapPadding`/`textStyle` | 迁入 `TDividerThemeData` |
| **移除** | `hideLine` / `direction` / `TextAlignment` | 无等价或改用布局 |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删 | 增 |
|----|----|
| `enum TextAlignment { left, center, right }` | `enum TDividerAlign { left, center, right }` |
| — | `enum TDividerLayout { horizontal, vertical }`（新增） |

### 2.2 构造器参数对照

| 0.2.x 参数 | V1.0 方案 | 迁移方式 |
|------------|----------|---------|
| `direction: Axis.horizontal` | `layout: TDividerLayout.horizontal`（默认） | 可不写 |
| `direction: Axis.vertical` | `layout: TDividerLayout.vertical` | 参数改名 |
| `isDashed: true` | `dashed: true` | 直接改名 |
| `alignment: TextAlignment.left` | `align: TDividerAlign.left` | 枚举 + 参数改名 |
| `text: 'XXX'` | `child: Text('XXX')` | text → child |
| `widget: someWidget` | `child: someWidget` | 合并到 child |
| `hideLine: true` | 删除 | 无等价替代 |
| `color: Colors.red` | `TDividerThemeData(color: Colors.red)` | 迁入 Theme |
| `height: 2` | `TDividerThemeData(thickness: 2)` | 迁入 Theme |
| `width: 0.5` | `TDividerThemeData(thickness: 0.5)` | 迁入 Theme |
| `margin: EdgeInsets.only(left: 16)` | `Padding` 包裹 或 `TDividerThemeData(margin: ...)` | 迁入 Theme 或外包 Padding |
| `gapPadding: EdgeInsets.only(horizontal: 12)` | `TDividerThemeData(gapPadding: ...)` | 迁入 Theme |
| `textStyle: TextStyle(...)` | `TDividerThemeData(textStyle: ...)` | 迁入 Theme |

### 2.3 完整示例

```dart
// === 0.2.x ===
TDivider(
  text: '文字信息',
  alignment: TextAlignment.left,
  isDashed: true,
  color: Colors.red,
  height: 2,
  margin: EdgeInsets.only(left: 16),
),

// === V1.0 ===
TDivider(
  child: Text('文字信息'),
  align: TDividerAlign.left,
  dashed: true,

  // 颜色、线粗、外边距等通过 Theme 子树注入：
  // Theme(
  //   data: Theme.of(context).copyWith(
  //     extensions: [
  //       TDividerThemeData(
  //         color: Colors.red,
  //         thickness: 2,
  //         indent: 16,
  //       ),
  //     ],
  //   ),
  //   child: TDivider(...),
  // ),
),
```

### 2.4 竖线迁移

```dart
// === 0.2.x ===
TDivider(
  width: 0.5,
  height: 56,
  isDashed: true,       // 竖线虚线在新版不支持
  direction: Axis.vertical,
),

// === V1.0 ===
SizedBox(
  height: 56,
  child: TDivider(layout: TDividerLayout.vertical),
  // dashed / align / child 在 vertical 时被忽略
),
```

### 2.5 间距块迁移

```dart
// === 0.2.x（间距块） ===
TDivider(height: 24, color: Colors.transparent),

// === V1.0 ===
SizedBox(height: 24),
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      TDividerThemeData(
        color: Colors.grey,
        thickness: 2,
        indent: 16,
      ),
    ],
  ),
  child: const TDivider(),
),

// 全局注入
MaterialApp(
  theme: ThemeData(
    extensions: [
      TDividerThemeData(thickness: 1),
    ],
  ),
  ...
)
```

---

## 4. resolve 优先级

```
构造器 L1/L2 (layout / align / dashed / child)
  > TDividerThemeData (color / thickness / margin / gapPadding / textStyle / indent / endIndent)
    > Material DividerTheme (P2 fallback)
      > Token (P4 fallback)
```

---

## 5. 升级检查清单

- [ ] `TextAlignment` → `TDividerAlign`，所有引用已替换
- [ ] `isDashed` → `dashed`
- [ ] `text: 'xxx'` → `child: Text('xxx')`
- [ ] `widget: xxx` → `child: xxx`
- [ ] `height` / `width` → 迁入 `TDividerThemeData.thickness`
- [ ] `color` / `margin` / `gapPadding` / `textStyle` → 迁入 `TDividerThemeData`
- [ ] 竖线用 `layout: TDividerLayout.vertical` + 外包 `SizedBox` 定高
- [ ] 间距块替换为 `SizedBox`
- [ ] `hideLine` 逻辑改为外层布局实现
- [ ] `direction: Axis` → `layout: TDividerLayout`
