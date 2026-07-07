# TSlider 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `leftLabel` → `label` |
| Rename | `onChange` → `onChanged` |
| ✨ New | `TSliderThemeData` 改为 `ThemeExtension<TSliderThemeData>`（原 PODO 已重构） |
| 🚫 Remove | **移除 `TSlider`/`TRangeSlider` 构造器 `sliderThemeData:` 参数**（统一走 `mergeExtension` 子树注入） |
| 🚫 Remove | **移除 `TSliderThemeData` 构造器 `context:` 参数**（不再持有 `BuildContext`） |
| Migration | 4 个 Thumb Shape 类：`buildContext` 参数 → `Color strokeColor` 参数 |
| Migration | `sliderThemeData` getter → `sliderThemeData(TThemeData token)` 方法（延迟颜色解析） |

> **关键决策**：原 0.2.x 的 `TSliderThemeData` 是持有 `BuildContext?` 的 PODO，与 Widget 深度耦合。
> v1.0 已将其重构为标准 `ThemeExtension`，移除 BuildContext 依赖，颜色延迟到
> `normal(token)`/`capsule(token)` 方法中解析。子树覆盖统一用 `mergeExtension`。

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TSlider(
  leftLabel: '亮度',
  onChange: (val) {},
);
```

**v1.0:**
```dart
TSlider(
  label: '亮度',
  onChanged: (val) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `leftLabel` | `label` | 标签文案 |
| `onChange` | `onChanged` | 回调命名对齐 v1.0 |

### 2. `TSliderThemeData` 构造器变更

`TSliderThemeData` 不再接收 `BuildContext`，颜色字段改为可空，延迟到 `normal(token)`/`capsule(token)` 中解析。

**0.2.x（PODO + BuildContext）：**
```dart
TSliderThemeData(
  context: context,          // ❌ 已移除
  trackHeight: 6,
  activeTrackColor: Colors.blue,
  // ...
);
```

**v1.0（ThemeExtension，无 BuildContext）：**
```dart
TSliderThemeData(
  trackHeight: 6,
  activeTrackColor: Colors.blue,   // 可空，null 表示回退 Token
  // 颜色字段均为可空，normal(token)/capsule(token) 内会回退到 token
);
```

### 3. 移除 `sliderThemeData:` 构造器参数

`TSlider` / `TRangeSlider` 构造器不再接受 `sliderThemeData:` 参数，统一从 `Theme.of(context).extension<TSliderThemeData>()` 读取，子树覆盖用 `mergeExtension`。

**0.2.x（构造器注入）：**
```dart
TSlider(
  value: 0.5,
  onChanged: (v) {},
  sliderThemeData: TSliderThemeData(
    context: context,
    activeTrackColor: Colors.red,
  ),
);
```

**v1.0（子树注入）：**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    TSliderThemeData(activeTrackColor: Colors.red),
  ),
  child: TSlider(
    value: 0.5,
    onChanged: (v) {},
  ),
);
```

> ❌ 禁止 `copyWith(extensions: [...])`：会覆盖父级其它 Extension。
> ✅ 统一用 `mergeExtension(...)`：仅替换 `TSliderThemeData`，保留 `TThemeData` 等。

### 4. 胶囊型 / 默认型切换

`TSliderThemeData` 提供 `normal(TThemeData token)` 和 `capsule(TThemeData token)` 两个工厂方法，
分别产出默认形态和胶囊形态的主题数据。Widget 内部会根据 `TSliderThemeData` 的 `_capsule` 标志选择。

子树注入胶囊型主题：

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    TSliderThemeData().capsule(context.tTheme),
  ),
  child: TSlider(
    value: 0.5,
    onChanged: (v) {},
  ),
);
```

### 5. Thumb Shape 类改造

4 个 Thumb Shape 类的 `paint()` 方法参数变更：

| Shape 类 | 0.2.x 参数 | v1.0 参数 |
|----------|-----------|-----------|
| `TRoundSliderThumbShape` | `BuildContext? buildContext` | `Color strokeColor` |
| `TRoundRangeSliderThumbShape` | `BuildContext? buildContext` | `Color strokeColor` |
| `TCapsuleSliderThumbShape` | `BuildContext? buildContext` | `Color strokeColor` |
| `TCapsuleRangeSliderThumbShape` | `BuildContext? buildContext` | `Color strokeColor` |

`paint()` 内不再调用 `buildContext.tTheme.componentStrokeColor`，直接使用传入的 `strokeColor`。
该值由 `normal(token)`/`capsule(token)` 在创建 Shape 时传入 `token.componentStrokeColor`。

### 6. `sliderThemeData` getter → 方法

`TSliderThemeData.sliderThemeData` 原为 getter（内部读 `context.tTheme`），
现改为 `sliderThemeData(TThemeData token)` 方法，由调用方传入 token：

```dart
// 0.2.x（getter，依赖内部 context）
final data = tSliderThemeData.sliderThemeData;

// v1.0（方法，token 由调用方传入）
final data = tSliderThemeData.sliderThemeData(context.tTheme);
```

## 保留的实例参数

| 参数 | 类型 | 说明 |
|------|------|------|
| `value` | `double` | 当前值（必填） |
| `label` | `String?` | 左侧标签 |
| `rightLabel` | `String?` | 右侧标签 |
| `onChanged` | `ValueChanged<double>?` | 滑动变化回调（null = 禁用） |
| `onChangeStart` | `ValueChanged<double>?` | 滑动开始回调 |
| `onChangeEnd` | `ValueChanged<double>?` | 滑动结束回调 |
| `onTap` | `Function(Offset, double)?` | Thumb 点击回调 |
| `onThumbTextTap` | `Function(Offset, double)?` | Thumb 浮标文字点击回调 |
| `boxDecoration` | `Decoration?` | 自定义盒子样式 |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/slider/t_slider_theme.dart` | `TSliderThemeData` 改为 ThemeExtension；移除 `context` 字段；`normal()`/`capsule()` 接收 token；4 个 Thumb Shape 改 `strokeColor` 参数 |
| `lib/src/components/slider/t_slider.dart` | 移除 `sliderThemeData:` 构造参数；build 内从 `Theme.of(context).extension` 读取 |
| `example/lib/page/t_slider_page.dart` | 22+ 处 `sliderThemeData:` → `mergeExtension` 子树注入；移除 `context: context` 参数 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/slider
flutter build web --release --no-web-resources-cdn
```

## 后续修复（2026-07-06）

### Thumb/Scale 文字颜色跟肤修复

`TSliderThemeData` 的 `thumbTextStyle`/`disabledThumbTextStyle`/`scaleTextStyle`/`disabledScaleTextStyle` 颜色延迟解析未实现——8 个 Shape 的 paint 方法直接使用 `themeData.thumbTextStyle`（默认 null），TextSpan(style: null) 渲染为黑色。

**修复**：在 `TSliderThemeData` 中新增 `_token` 字段（由 `sliderThemeData(token)` 方法设置）+ 4 个 `effective*` getter：
- `effectiveThumbTextStyle` = `TextStyle(color: token.textColorPrimary).merge(thumbTextStyle)`
- `effectiveDisabledThumbTextStyle` = `TextStyle(color: token.textDisabledColor).merge(disabledThumbTextStyle)`
- `effectiveScaleTextStyle` = `TextStyle(color: token.textColorSecondary).merge(scaleTextStyle)`
- `effectiveDisabledScaleTextStyle` = `TextStyle(color: token.textDisabledColor).merge(disabledScaleTextStyle)`

8 个 paint 方法的 `themeData.thumbTextStyle` → `themeData.effectiveThumbTextStyle` 等。
