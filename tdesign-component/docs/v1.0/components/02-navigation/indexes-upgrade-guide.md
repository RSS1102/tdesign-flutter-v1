# TIndexes 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `onChanged` 参数（替代 `onChange`，推荐使用） |
| New | 新增 `TIndexesThemeData` ThemeExtension |
| New | 新增 `themeData` 参数 |
| Compatible | `onChange` 保留向后兼容，同时触发 |
| Enhanced | L4 样式参数支持从 ThemeData 读取默认值 |

## 迁移清单

### 1. 新增 `onChanged` 参数（推荐）

`onChanged` 是 `onChange` 的 v1.0 别名。两个回调同时存在时会同时触发。

**0.2.x:**
```dart
TIndexes(
  onChange: (index) { ... },
  builderContent: ...,
);
```

**v1.0:**
```dart
TIndexes(
  onChanged: (index) { ... },
  builderContent: ...,
);
```

### 2. 新增 `TIndexesThemeData`

**v1.0:**
```dart
TIndexes(
  themeData: TIndexesThemeData(
    capsuleTheme: true,
    stickyOffset: 10,
  ),
  builderContent: ...,
);
```

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/indexes/t_indexes_theme_data.dart` | 新增 |
| `lib/src/components/indexes/t_indexes.dart` | 新增 `onChanged`/`themeData` |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/indexes/t_indexes_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/indexes/t_indexes_test.dart --no-color
```
