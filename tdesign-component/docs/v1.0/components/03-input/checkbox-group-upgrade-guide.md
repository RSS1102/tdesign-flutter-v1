# TCheckboxGroup 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChangeGroup` → `onChanged` |
| Rename | `checkedIds` → `value` |
| Delete | 删除 `OnGroupChange` typedef |
| Delete | 删除 `OnCheckBoxGroupChange` typedef |
| Migrate | L4 样式字段迁入 `TCheckboxThemeData`（与 TCheckbox 共用） |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TCheckboxGroup(
  checkedIds: ['1', '2'],
  onChangeGroup: (ids) {},
);
```

**v1.0:**
```dart
TCheckboxGroup(
  value: ['1', '2'],
  onChanged: (ids) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `checkedIds` | `value` | 受控值统一为 value |
| `onChangeGroup` | `onChanged` | 回调命名对齐 v1.0 |

### 2. 删除 typedef

- 删除 `OnGroupChange`，改用 `ValueChanged<List<T>>?`
- 删除 `OnCheckBoxGroupChange`，改用同上

### 3. 共用 TCheckboxThemeData

与 TCheckbox 共用 `TCheckboxThemeData`，L4 字段（`style` / `spacing` 等）迁入 Theme。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/checkbox/t_check_box_group.dart` | 参数重命名 + 删除 typedef |
| `lib/tdesign_flutter.dart` | export 更新 |
