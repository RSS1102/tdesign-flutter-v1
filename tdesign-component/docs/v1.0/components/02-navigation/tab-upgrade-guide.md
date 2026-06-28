# TTab / TTabBar / TTabBarView 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Breaking | `TTabBarOutlineType` → `TTabBarVariant`（枚举重命名） |
| Breaking | `TTabOutlineType` 删除（合并到 `TTabBarVariant`） |
| Breaking | `outlineType` → `variant`（TTabBar 参数重命名） |
| Breaking | `enable` → `enabled`（TTab 参数重命名） |
| Breaking | `isSlideSwitch` → `physics`（TTabBarView 参数改为 ScrollPhysics） |
| New | 新增 `TTabBarThemeData` ThemeExtension |
| New | 新增 `physics` 参数（TTabBar，替代 isSlideSwitch） |
| Enhanced | L4 样式参数支持从 ThemeData 读取默认值 |

## 迁移清单

### 1. `TTabBarOutlineType` → `TTabBarVariant`（必改）

**0.2.x:**
```dart
TTabBar(
  tabs: [...],
  outlineType: TTabBarOutlineType.capsule,
);
```

**v1.0:**
```dart
TTabBar(
  tabs: [...],
  variant: TTabBarVariant.capsule,
);
```

枚举值映射：
| 0.2.x | v1.0 |
|-------|------|
| `TTabBarOutlineType.filled` | `TTabBarVariant.filled` |
| `TTabBarOutlineType.capsule` | `TTabBarVariant.capsule` |
| `TTabBarOutlineType.card` | `TTabBarVariant.card` |
| `TTabOutlineType.*` | 删除，统一使用 `TTabBarVariant` |

### 2. `enable` → `enabled`（必改）

**0.2.x:**
```dart
TTab(text: '禁用', enable: false);
```

**v1.0:**
```dart
TTab(text: '禁用', enabled: false);
```

### 3. `isSlideSwitch` → `physics`（必改）

**0.2.x:**
```dart
TTabBarView(
  isSlideSwitch: true,
  children: [...],
);
```

**v1.0:**
```dart
TTabBarView(
  physics: BouncingScrollPhysics(),  // 或其他 ScrollPhysics
  children: [...],
);
```

默认行为变更：v1.0 默认不可滑动（`NeverScrollableScrollPhysics`），需手动传入 `physics` 开启滑动。

### 4. 新增 `TTabBarThemeData`（推荐）

**v1.0:**
```dart
TTabBar(
  tabs: [...],
  // 构造器参数优先级高于 Theme
);

// 或全局注入
MaterialApp(
  theme: ThemeData(
    extensions: [
      TTabBarThemeData(
        variant: TTabBarVariant.capsule,
        height: 56,
        backgroundColor: Colors.white,
        defaultPhysics: BouncingScrollPhysics(),
      ),
    ],
  ),
);
```

### 5. 优先级规则

构造器参数 > `Theme.of(context).extension<TTabBarThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/tabs/t_tab_bar_theme_data.dart` | 新增（含 `TTabBarVariant`/`TTabSize` 枚举） |
| `lib/src/components/tabs/t_tab.dart` | `enable`→`enabled`，移除 `outlineType` |
| `lib/src/components/tabs/t_tab_bar.dart` | `outlineType`→`variant`，L4 支持默认值 |
| `lib/src/components/tabs/t_tab_bar_view.dart` | `isSlideSwitch`→`physics` |
| `lib/src/components/tabs/t_horizontal_tab_bar.dart` | 同步 `TTabBarOutlineType`→`TTabBarVariant` |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/tabs/t_tab_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/tabs/t_tab_test.dart --no-color
dart analyze lib/src/components/tabs/
```
