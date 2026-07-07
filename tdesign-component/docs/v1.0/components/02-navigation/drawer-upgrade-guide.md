# TDrawer 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Breaking | `contentWidget` → `child` |
| New | 新增 `TDrawerThemeData` ThemeExtension |
| Removed | 移除 `themeData` 构造器参数（改用 `mergeExtension` 子树覆盖） |
| Enhanced | L4 样式参数支持从 ThemeData 读取默认值 |

## 迁移清单

### 1. `contentWidget` → `child`（必改）

**v1.0:**
```dart
TDrawer(
  context,
  visible: true,
  child: Text('自定义内容'),
);
```

### 2. `themeData` 参数已移除 — 改用 `mergeExtension`

`themeData` 构造器参数已移除（对齐 theme.md §2.1）。样式定制通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。

**❌ 已移除:**
```dart
TDrawer(
  context,
  visible: true,
  themeData: TDrawerThemeData(width: 320, backgroundColor: Colors.white),  // 已删除
  items: [...],
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TDrawerThemeData(width: 320, backgroundColor: Colors.white),
  ),
  child: TDrawer(
    context,
    visible: true,
    items: [...],
  ),
);
```

**或全局注入:**
```dart
MaterialApp(
  theme: TThemeBuilder.light(token).mergeExtension(
    const TDrawerThemeData(width: 320),
  ),
  home: ...,
);
```

### 3. 优先级规则

构造器参数 > `Theme.of(context).extension<TDrawerThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/drawer/t_drawer_theme_data.dart` | 新增 |
| `lib/src/components/drawer/t_drawer.dart` | `contentWidget`->`child`；移除 `themeData`；P1 读取 |
| `lib/src/components/drawer/t_drawer_widget.dart` | `contentWidget`->`child` |
| `lib/tdesign_flutter.dart` | 新增 `TDrawerThemeData` export |
| `example/assets/api/drawer_api.md` | 更新 API 文档 |
| `test/components/drawer/t_drawer_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/drawer/t_drawer_test.dart --no-color
dart analyze lib/src/components/drawer/
```
