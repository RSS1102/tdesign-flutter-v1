# TRadio 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `enable` → `enabled` |
| Delete | 删除 `OnRadioGroupChange` typedef |
| Delete | 删除旧 `TRadioStyle` 枚举（迁入 Theme） |
| New | 新增 `TRadioThemeData` ThemeExtension |
| Keep | 保留 `TRadio extends TCheckbox` 继承架构 |
| Migrate | L4 样式字段迁入 `TRadioThemeData` |

> **关键决策**：TRadio 与 TCheckboxGroup 深度耦合，保留 `extends TCheckbox` 继承架构，未重构为包装 Material Radio。

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TRadio(
  enable: false,
  radioStyle: TRadioStyle.circle,
);
```

**v1.0:**
```dart
TRadio(
  enabled: false,
  radioStyle: TRadioStyle.circle,
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `enable` | `enabled` | 禁用参数 |

### 2. 删除 typedef

删除 `OnRadioGroupChange`，改用 Flutter 内置 `ValueChanged<T>?`。

### 3. TRadioGroup 回调

`TRadioGroup` 构造函数使用 `onRadioGroupChange: void Function(String? selectedId)?`（非父类 `onChanged`）。

### 4. L4 样式字段迁入 `TRadioThemeData`

`TRadioStyle` 枚举 / `radioStyle` / `radioCheckStyle` / `selectColor` / `disableColor` / `titleColor` / `subTitleColor` / `backgroundColor` / `titleFont` / `subTitleFont` / `spacing` / `checkBoxLeftSpace` / `insetSpacing` / `customSpace`

> **注意**：`TRadioStyle` 枚举（circle/square/check/hollowCircle）原在 `t_radio.dart` 中定义，v1.0 迁入 `t_radio_theme_data.dart`，旧定义已删除以避免类型冲突。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/radio/t_radio_theme_data.dart` | 新增（TRadioThemeData + TRadioStyle 枚举） |
| `lib/src/components/radio/t_radio.dart` | 参数重命名 + 删除旧 TRadioStyle 枚举 + 删除 typedef |
| `lib/tdesign_flutter.dart` | 新增 export |
