# TIndexes 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `onChanged` 参数（替代 `onChange`，推荐使用） |
| New | 新增 `TIndexesThemeData` ThemeExtension |
| Removed | 移除 `themeData` 构造器参数（改用 `mergeExtension` 子树覆盖） |
| Compatible | `onChange` 保留向后兼容，同时触发 |

## 迁移清单

### 1. 新增 `onChanged` 参数（推荐）

`onChanged` 是 `onChange` 的 v1.0 别名。两个回调同时存在时会同时触发。

**v1.0:**
```dart
TIndexes(
  onChanged: (index) { ... },
  builderContent: ...,
);
```

### 2. `themeData` 参数已移除 — 改用 `mergeExtension`

`themeData` 构造器参数已移除（对齐 theme.md §2.1）。样式定制通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。

**❌ 已移除:**
```dart
TIndexes(
  themeData: TIndexesThemeData(capsuleTheme: true),  // 已删除
  builderContent: ...,
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TIndexesThemeData(capsuleTheme: true),
  ),
  child: TIndexes(builderContent: ...),
);
```

### 3. 优先级规则

构造器参数 > `Theme.of(context).extension<TIndexesThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/indexes/t_indexes_theme_data.dart` | 新增 |
| `lib/src/components/indexes/t_indexes.dart` | 新增 `onChanged`；移除 `themeData`；P1 读取 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/indexes/t_indexes_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/indexes/t_indexes_test.dart --no-color
```
