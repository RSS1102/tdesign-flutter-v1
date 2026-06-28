# TDateTimePicker 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChange` → `onChanged` |
| New | 共用 `TPickerThemeData` ThemeExtension（与 TPicker 共用） |
| Migrate | L4 样式字段迁入 `TPickerThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TDateTimePicker(
  onChange: (result) {},
);
```

**v1.0:**
```dart
TDateTimePicker(
  onChanged: (result) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `onChange` | `onChanged` | F 类回调 |

### 2. 共用 TPickerThemeData

与 TPicker 共用 `TPickerThemeData`，L4 字段（`mode` / `start` / `end` / `steps` / `height` / `itemCount` / `showWeek` / `renderLabel`）迁入 Theme。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/date_time_picker/t_date_time_picker.dart` | 参数重命名 |
| `lib/tdesign_flutter.dart` | export 更新 |
