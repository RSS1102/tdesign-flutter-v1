# TPicker 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChange` → `onChanged` |
| New | 新增 `TPickerThemeData` ThemeExtension（与 TDateTimePicker 共用） |
| Migrate | L4 样式字段迁入 `TPickerThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TPicker(
  items: TPickerColumns([yearItems, monthItems]),
  initialValue: [2024, 1],
  onChange: (col, value) {},
);
```

**v1.0:**
```dart
TPicker(
  items: TPickerColumns([yearItems, monthItems]),
  initialValue: [2024, 1],
  onChanged: (col, value) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `onChange` | `onChanged` | F 类回调，签名 `void Function(int col, TPickerValue value)?` |

### 2. L4 样式字段迁入 `TPickerThemeData`

`height` / `itemCount` / `onColumnScrollEnd`

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/picker/t_picker_theme_data.dart` | 新增（TPickerThemeData，Picker+DateTimePicker 共用） |
| `lib/src/components/picker/t_picker.dart` | 参数重命名 |
| `lib/tdesign_flutter.dart` | 新增 export |
