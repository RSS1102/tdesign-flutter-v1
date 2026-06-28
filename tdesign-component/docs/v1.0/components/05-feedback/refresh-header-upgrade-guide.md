# TRefreshHeader 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TRefreshThemeData` ThemeExtension |
| New | 新增 `themeData` 参数（实例级 Theme 覆盖） |
| Migration | `loadingIcon`/`backgroundColor`/`extent`/`triggerDistance`/`float`/`completeDuration`/`infiniteOffset`/`overScroll` 从构造器参数迁入 `TRefreshThemeData`（参数保留为可选覆盖） |
| Compatible | `enableHapticFeedback`/`enableInfiniteRefresh` 保留为实例参数（≠ 禁用） |

## 迁移清单

### 1. L4 样式参数迁入 `TRefreshThemeData`

以下参数的默认值改由 `TRefreshThemeData` 提供，构造器参数保留为可选覆盖。

**0.2.x:**
```dart
TRefreshHeader(
  extent: 64.0,
  triggerDistance: 64.0,
  float: true,
  loadingIcon: TLoadingIcon.activity,
  backgroundColor: Colors.white,
  completeDuration: Duration(seconds: 2),
  overScroll: false,
);
```

**v1.0:**
```dart
TRefreshHeader(
  themeData: TRefreshThemeData(
    extent: 64.0,
    triggerDistance: 64.0,
    float: true,
    loadingIcon: TLoadingIcon.activity,
    backgroundColor: Colors.white,
    completeDuration: Duration(seconds: 2),
    overScroll: false,
  ),
);
```

### 2. 通过 Theme 子树注入默认样式

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      TRefreshThemeData(extent: 64.0, triggerDistance: 64.0),
    ],
  ),
  child: EasyRefresh(header: TRefreshHeader(), ...),
);
```

### 3. 保留的实例参数

| 参数 | 类型 | 说明 |
|------|------|------|
| `enableHapticFeedback` | `bool` | 开启震动反馈（≠ 禁用，默认 `true`） |
| `enableInfiniteRefresh` | `bool` | 是否开启无限刷新（≠ 禁用，默认 `false`） |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/refresh/t_refresh_theme_data.dart` | 新增 |
| `lib/src/components/refresh/t_refresh_header.dart` | L4 参数改为可选，新增 `themeData` |
| `lib/tdesign_flutter.dart` | 新增 `t_refresh_theme_data.dart` export |
| `example/assets/api/pull-down-refresh_api.md` | API 文档同步 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/refresh
flutter build web --release --no-web-resources-cdn
```
