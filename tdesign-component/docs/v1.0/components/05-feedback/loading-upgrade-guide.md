# TLoading 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TLoadingThemeData` ThemeExtension |
| New | 新增 `themeData` 参数（实例级 Theme 覆盖） |
| Migration | `iconColor`/`textColor`/`axis`/`customIcon`/`duration`/`refreshWidget` 从构造器参数迁入 `TLoadingThemeData` |
| Compatible | `size`/`icon`/`text` 保留为实例参数 |
| Breaking | 移除 `t_circle_indicator.dart` 公开导出（内部 Widget 不再 export） |

## 迁移清单

### 1. L4 样式参数迁入 `TLoadingThemeData`

以下参数从 `TLoading` 构造器移除，改由 `TLoadingThemeData` 提供。

**0.2.x:**
```dart
TLoading(
  size: TLoadingSize.small,
  icon: TLoadingIcon.circle,
  text: '加载中…',
  axis: Axis.horizontal,
  iconColor: Colors.blue,
  textColor: Colors.grey,
  duration: 1500,
  customIcon: MyIcon(),
  refreshWidget: GestureDetector(...),
);
```

**v1.0:**
```dart
TLoading(
  size: TLoadingSize.small,
  icon: TLoadingIcon.circle,
  text: '加载中…',
  themeData: TLoadingThemeData(
    axis: Axis.horizontal,
    iconColor: Colors.blue,
    textColor: Colors.grey,
    duration: 1500,
    customIcon: MyIcon(),
    refreshWidget: GestureDetector(...),
  ),
);
```

### 2. 通过 Theme 子树注入默认样式

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      TLoadingThemeData(axis: Axis.horizontal),
    ],
  ),
  child: TLoading(size: TLoadingSize.small, text: '加载中…'),
);
```

### 3. `t_circle_indicator.dart` 不再公开导出

核心库组件（toast/switch）和 example 页面需改为直接 import：

```dart
import '../loading/t_circle_indicator.dart';  // 核心库
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';  // example
```

## 保留的实例参数

| 参数 | 类型 | 说明 |
|------|------|------|
| `size` | `TLoadingSize` | 尺寸（必填） |
| `icon` | `TLoadingIcon?` | 图标，默认 `circle` |
| `text` | `String?` | 文案 |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/loading/t_loading_theme_data.dart` | 新增 |
| `lib/src/components/loading/t_loading.dart` | 移除 L4 参数，新增 `themeData` |
| `lib/tdesign_flutter.dart` | 移除 `t_circle_indicator.dart` export，新增 `t_loading_theme_data.dart` |
| `lib/src/components/toast/t_toast.dart` | 新增 `t_circle_indicator.dart` 直接 import |
| `lib/src/components/switch/t_switch.dart` | 新增 `t_circle_indicator.dart` 直接 import |
| `example/lib/page/t_loading_page.dart` | 全部改为新 API |
| `example/lib/page/t_image_page.dart` | 新增 `t_circle_indicator.dart` 直接 import |
| `example/assets/api/loading_api.md` | API 文档同步 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/loading
flutter build web --release --no-web-resources-cdn
```
