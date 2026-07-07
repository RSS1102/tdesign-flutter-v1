# TBottomTabBar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `value` 参数（替代 `currentIndex`，优先级更高） |
| New | 新增 `TBottomTabBarThemeData` ThemeExtension |
| Removed | 移除 `themeData` 构造器参数（改用 `mergeExtension` 子树覆盖） |
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

### 2. `themeData` 参数已移除 — 改用 `mergeExtension`

`themeData` 构造器参数已移除（对齐 theme.md §2.1「禁止构造器 themeData」）。样式定制通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。

**❌ 已移除:**
```dart
TBottomTabBar(
  TBottomTabBarBasicType.text,
  navigationTabs: [...],
  themeData: TBottomTabBarThemeData(barHeight: 64),  // 已删除
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TBottomTabBarThemeData(barHeight: 64),
  ),
  child: TBottomTabBar(
    TBottomTabBarBasicType.text,
    navigationTabs: [...],
  ),
);
```

### 3. 优先级规则

构造器参数 > `Theme.of(context).extension<TBottomTabBarThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/tabbar/t_bottom_tab_bar_theme_data.dart` | 新增 |
| `lib/src/components/tabbar/t_bottom_tab_bar.dart` | 新增 `value`；移除 `themeData`；P1 读取 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/tabbar/t_bottom_tab_bar_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/tabbar/t_bottom_tab_bar_test.dart --no-color
```
