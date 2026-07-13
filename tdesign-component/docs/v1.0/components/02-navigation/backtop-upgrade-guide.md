# TBackTop — v1.0 升级指南

> T2 自绘组件升级 | S3 交付 | 2026-06-27

---

## 1. 变更概览

| 类别 | 0.2.x | v1.0 | 影响 |
|------|--------|------|------|
| 禁用 | 无禁用语义 | A 类：`onPressed: null` | 组件禁用态 |
| 回调 | `onClick` | **`onPressed`** | 改名；`null` 表禁用 |
| 形状枚举 | `TBackTopStyle`（circle / halfCircle） | **`TBackTopShape`** | 枚举改名；迁入 Theme |
| 主题枚举 | `TBackTopTheme`（light / dark） | **`TBackTopColorScheme`** | 枚举改名；迁入 Theme |
| 形状参数 | 构造器 `style` | **Theme `shape`** | 迁入 `TBackTopThemeData` |
| 主题参数 | 构造器 `theme` | **Theme `colorScheme`** | 迁入 `TBackTopThemeData` |
| 显隐控制 | 页面手写 `ScrollController.addListener` + `setState` | **构造器 `visibilityOffset`** | 内置显隐逻辑 |
| 无障碍 | 无 | **构造器 `tooltip`** + Theme 默认 | 新增 |
| Theme | 无组件级 Theme | **`TBackTopThemeData`**（ThemeExtension） | 新增能力 |

---

## 2. 迁移清单

### 2.1 枚举改名

| 0.2.x | v1.0 |
|--------|------|
| `TBackTopStyle.circle` | `TBackTopShape.circle` |
| `TBackTopStyle.halfCircle` | `TBackTopShape.halfCircle` |
| `TBackTopTheme.light` | `TBackTopColorScheme.light` |
| `TBackTopTheme.dark` | `TBackTopColorScheme.dark` |

### 2.2 构造器参数迁移

```dart
// ❌ 0.2.x
TBackTop(
  controller: controller,
  theme: TBackTopTheme.light,
  style: TBackTopStyle.circle,
  showText: true,
  onClick: () { print('clicked'); },
)

// ✅ v1.0（实例级设置）
TBackTop(
  controller: controller,
  colorScheme: TBackTopColorScheme.light,
  shape: TBackTopShape.circle,
  showText: true,
  onPressed: () { print('clicked'); },
)
```

### 2.3 L4 样式迁入 Theme

0.2.x 中 `theme` 和 `style` 是构造器必传参数，v1.0 迁入 `TBackTopThemeData`：

```dart
// ✅ v1.0：全局注入
MaterialApp(
  theme: ThemeData(
    extensions: const [
      TBackTopThemeData(
        shape: TBackTopShape.circle,
        colorScheme: TBackTopColorScheme.light,
        defaultVisibilityOffset: 100,
      ),
    ],
  ),
)

// ✅ v1.0：子树注入
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      const TBackTopThemeData(shape: TBackTopShape.halfCircle),
    ],
  ),
  child: TBackTop(controller: scrollController, onPressed: () {}),
)
```

### 2.4 显隐控制迁移

0.2.x 需要在页面中手写监听：

```dart
// ❌ 0.2.x：手写 ScrollController.addListener + setState
controller.addListener(() {
  final shouldShow = controller.offset >= 100;
  if (shouldShow != showBackTop) {
    setState(() { showBackTop = shouldShow; });
  }
});
Visibility(visible: showBackTop, child: TBackTop(...))

// ✅ v1.0：内置显隐
TBackTop(
  controller: controller,
  visibilityOffset: 100,  // 滚动 ≥ 100 时自动显示
)
```

也可以通过 Theme 统一设置：

```dart
// Theme 配置默认阈值
const TBackTopThemeData(defaultVisibilityOffset: 100)

// 构造器可覆盖
TBackTop(controller: controller, visibilityOffset: 200)
```

### 2.5 半圆形态贴边

```dart
// ❌ 0.2.x：外层 Positioned + 硬编码 right: -16
Positioned(right: -16, bottom: 10, child: TBackTop(style: TBackTopStyle.halfCircle, ...))

// ✅ v1.0：仍可外层 Positioned，或通过 Theme 配置
const TBackTopThemeData(halfCircleRightInset: -16)
```

### 2.6 禁用态

```dart
// ❌ 0.2.x：无禁用语义
// ✅ v1.0：A 类 onPressed: null 即禁用
TBackTop(onPressed: null)  // 不响应点击
```

### 2.7 tooltip 无障碍

```dart
// 自定义 tooltip
TBackTop(tooltip: '回到页面顶部', onPressed: () {})

// 未传时使用 i18n resource 默认文案（中文：返回顶部）
TBackTop(onPressed: () {})
```

---

## 3. 优先级链

```
构造器参数 (shape / colorScheme / visibilityOffset / tooltip)
  > TBackTopThemeData (子树 ThemeExtension 注入)
    > 内部默认值 (circle / light / 始终可见)
```

---

## 4. 文件清单

| 文件 | 操作 |
|------|------|
| `lib/src/components/backtop/t_backtop.dart` | ✏️ 重构（onClick→onPressed、theme→colorScheme、style→shape 迁 Theme、新增 visibilityOffset/tooltip） |
| `lib/src/components/backtop/t_backtop_theme_data.dart` | 🆕 新建（TBackTopThemeData + TBackTopShape + TBackTopColorScheme） |
| `lib/tdesign_flutter.dart` | ✏️ export 新增 ThemeData/枚举 |
| `example/lib/page/t_backtop_page.dart` | ✏️ 重写为 v1.0 API |
| `example/assets/api/back-top_api.md` | ✏️ API 文档更新 |
| `test/components/backtop/t_backtop_test.dart` | 🆕 新建（28 个测试） |
| `docs/v1.0/components/02-navigation/backtop-upgrade-guide.md` | 🆕 本文档 |

---

## 5. 快速验证

```bash
# 运行测试
flutter test test/components/backtop/t_backtop_test.dart

# 编译检查
dart analyze lib/src/components/backtop/
```

预期：**28 tests passed**，**0 ERROR**。
