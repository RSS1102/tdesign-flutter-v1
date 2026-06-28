# TDrawer 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Breaking | `contentWidget` → `child` |
| New | 新增 `TDrawerThemeData` ThemeExtension |
| New | 新增 `themeData` 参数（子树级主题数据） |
| Enhanced | L4 样式参数支持从 ThemeData 读取默认值 |

## 迁移清单

### 1. `contentWidget` → `child`（必改）

`TDrawer` 和 `TDrawerWidget` 的 `contentWidget` 参数改名为 `child`，语义更清晰，符合 Flutter 官方约定。

**0.2.x:**
```dart
TDrawer(
  context,
  visible: true,
  contentWidget: Text('自定义内容'),
);
```

**v1.0:**
```dart
TDrawer(
  context,
  visible: true,
  child: Text('自定义内容'),
);
```

### 2. 新增 `TDrawerThemeData`（推荐）

将宽度、背景色、边框等 L4 样式参数迁入 `TDrawerThemeData`，支持子树级默认值。

**0.2.x（逐个传参）:**
```dart
TDrawer(
  context,
  visible: true,
  width: 320,
  backgroundColor: Colors.white,
  bordered: false,
  isShowLastBordered: false,
  hover: false,
  items: [...],
);
```

**v1.0（ThemeData）:**
```dart
TDrawer(
  context,
  visible: true,
  themeData: TDrawerThemeData(
    width: 320,
    backgroundColor: Colors.white,
    bordered: false,
    isShowLastBordered: false,
    hover: false,
  ),
  items: [...],
);
```

**或全局注入:**
```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      TDrawerThemeData(
        width: 320,
        backgroundColor: Colors.white,
      ),
    ],
  ),
  home: ...,
);
```

### 3. 优先级规则

构造器参数 > `themeData` > `Theme.of(context).extension<TDrawerThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/drawer/t_drawer_theme_data.dart` | 新增 |
| `lib/src/components/drawer/t_drawer.dart` | `contentWidget`->`child`，新增 `themeData` |
| `lib/src/components/drawer/t_drawer_widget.dart` | `contentWidget`->`child` |
| `lib/tdesign_flutter.dart` | 新增 `TDrawerThemeData` export |
| `example/assets/api/drawer_api.md` | 更新 API 文档 |
| `example/lib/page/t_drawer_page.dart` | 更新 Demo 页面 |
| `test/components/drawer/t_drawer_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/drawer/t_drawer_test.dart --no-color
dart analyze lib/src/components/drawer/ 
```
