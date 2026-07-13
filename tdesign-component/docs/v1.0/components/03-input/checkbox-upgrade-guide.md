# TCheckbox 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `checked` → `value` |
| Rename | `enable` → `enabled` |
| Rename | `onCheckBoxChanged` → `onChanged` |
| Delete | 删除 `OnCheckValueChanged` typedef |
| Delete | 删除旧 `TCheckboxStyle` 枚举（迁入 Theme） |
| New | 新增 `TCheckboxThemeData` ThemeExtension |
| Migrate | L4 样式字段迁入 `TCheckboxThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TCheckbox(
  checked: true,
  enable: false,
  onCheckBoxChanged: (val) {},
);
```

**v1.0:**
```dart
TCheckbox(
  value: true,
  enabled: false,
  onChanged: (val) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `checked` | `value` | 受控值统一为 value |
| `enable` | `enabled` | 禁用参数 |
| `onCheckBoxChanged` | `onChanged` | 回调命名对齐 v1.0 |

### 2. 删除 typedef

删除 `OnCheckValueChanged`，改用 Flutter 内置 `ValueChanged<bool?>?`。

### 3. 禁用方式

B 类组件禁用用 `enabled: false`，不用 `onChanged: null`。

### 4. L4 样式字段迁入 `TCheckboxThemeData`

`TCheckboxStyle` 枚举 / `style` / `selectColor` / `disableColor` / `titleColor` / `subTitleColor` / `backgroundColor` / `spacing` / `checkBoxLeftSpace` / `insetSpacing` / `customSpace`

> **注意**：`TCheckboxStyle` 枚举（circle/square/check）原在 `t_check_box.dart` 中定义，v1.0 迁入 `t_checkbox_theme_data.dart`，旧定义已删除以避免类型冲突。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/checkbox/t_checkbox_theme_data.dart` | 新增（TCheckboxThemeData + TCheckboxStyle 枚举） |
| `lib/src/components/checkbox/t_check_box.dart` | 参数重命名 + 删除旧 TCheckboxStyle 枚举 + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 新增 export |
