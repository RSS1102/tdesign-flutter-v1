# TTreeSelect 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChange` → `onChanged` |
| Rename | `defaultValue` → `value` |
| New | 新增 `TTreeSelectThemeData` ThemeExtension |
| Migrate | L4 样式字段迁入 `TTreeSelectThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TTreeSelect(
  options: options,
  defaultValue: values,
  onChange: (val, level) {},
);
```

**v1.0:**
```dart
TTreeSelect(
  options: options,
  value: values,
  onChanged: (val, level) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `defaultValue` | `value` | 受控选中项，初值由父 State 持有 |
| `onChange` | `onChanged` | 命名对齐 v1.0 |

### 2. State 同步修复

`_TTreeSelectState` 中 `oldWidget.defaultValue` 引用需同步改为 `oldWidget.value`。

### 3. L4 样式字段迁入 `TTreeSelectThemeData`

`TTreeSelectStyle` / `style` / `height` / `outwardCornerRadius`

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/tree/t_tree_select_theme_data.dart` | 新增（TTreeSelectThemeData） |
| `lib/src/components/tree/t_tree_select.dart` | 参数重命名 + State 引用同步 + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 新增 export |
