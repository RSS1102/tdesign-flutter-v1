# TBottomTabBar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `value` 参数（替代 `currentIndex`，优先级更高） |
| New | 新增 `TBottomTabBarThemeData` ThemeExtension |
| New | 新增 `themeData` 参数 |
| Compatible | `currentIndex` 保留向后兼容 |

## 迁移清单

### 1. 新增 `value` 参数（推荐）

`value` 是 `currentIndex` 的 v1.0 别名，优先级更高。

**0.2.x:**
```dart
TBottomTabBar(
  TBottomTabBarBasicType.text,
  currentIndex: 1,
  navigationTabs: [...],
);
```

**v1.0:**
```dart
TBottomTabBar(
  TBottomTabBarBasicType.text,
  value: 1,
  navigationTabs: [...],
);
```

### 2. 新增 `TBottomTabBarThemeData`

**v1.0:**
```dart
TBottomTabBar(
  TBottomTabBarBasicType.text,
  navigationTabs: [...],
  themeData: TBottomTabBarThemeData(
    barHeight: 64,
    selectedBgColor: Colors.red,
  ),
);
```

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/tabbar/t_bottom_tab_bar_theme_data.dart` | 新增 |
| `lib/src/components/tabbar/t_bottom_tab_bar.dart` | 新增 `value`/`themeData` |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/tabbar/t_bottom_tab_bar_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/tabbar/t_bottom_tab_bar_test.dart --no-color
```
