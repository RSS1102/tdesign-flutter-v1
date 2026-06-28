# TUpload 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `TUploadBoxType` → `TUploadVariant` |
| Rename | `TUploadType` → `TUploadAction` |
| Rename | `onClick` → `onPressed` |
| Rename | `onChange` → `onChanged` |
| Delete | 删除旧 `TUploadVariant` 枚举（迁入 Theme） |
| New | 新增 `TUploadThemeData` ThemeExtension |
| Migrate | L4 样式字段迁入 `TUploadThemeData` |

## 迁移清单

### 1. 枚举重命名

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `TUploadBoxType` | `TUploadVariant` | 上传框样式枚举 |
| `TUploadType` | `TUploadAction` | 上传操作类型枚举 |

### 2. 参数重命名

**0.2.x:**
```dart
TUpload(
  files: files,
  onClick: (key) {},
  onChange: (files, type) {},
);
```

**v1.0:**
```dart
TUpload(
  files: files,
  onPressed: (key) {},
  onChanged: (files, type) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `onClick` | `onPressed` | 命名对齐 v1.0 |
| `onChange` | `onChanged` | 命名对齐 v1.0 |
| `type: TUploadBoxType.circle` | `type: TUploadVariant.circle` | 枚举重命名 |

### 3. 禁用方式

保留 `disabled: true` 参数。

### 4. L4 样式字段迁入 `TUploadThemeData`

`height` / `wrapSpacing` / `wrapRunSpacing` / `wrapAlignment`

> **注意**：`TUploadVariant` 枚举原在 `t_upload.dart` 中定义，v1.0 迁入 `t_upload_theme_data.dart`，旧定义已删除以避免类型冲突。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/upload/t_upload_theme_data.dart` | 新增（TUploadThemeData + TUploadVariant） |
| `lib/src/components/upload/t_upload.dart` | 枚举重命名 + 参数重命名 + 删除旧 TUploadVariant + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 新增 export |
