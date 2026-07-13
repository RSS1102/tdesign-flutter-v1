# TRate 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChange` → `onChanged` |
| New | 新增 `TRateThemeData` ThemeExtension |
| Migrate | L4 样式字段迁入 `TRateThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TRate(
  count: 5,
  value: 3,
  onChange: (val) {},
);
```

**v1.0:**
```dart
TRate(
  count: 5,
  value: 3,
  onChanged: (val) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `onChange` | `onChanged` | 命名对齐 v1.0 |

### 2. 禁用方式

保留 `disabled: true` 参数（C 类组件）。

### 3. L4 样式字段迁入 `TRateThemeData`

`color` / `allowHalf` / `count` / `gap` / `placement` / `showText` / `textWidth` / `mainAxisAlignment` / `crossAxisAlignment` / `mainAxisSize` / `iconTextGap`

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/rate/t_rate_theme_data.dart` | 新增（TRateThemeData） |
| `lib/src/components/rate/t_rate.dart` | 参数重命名 + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 新增 export |
