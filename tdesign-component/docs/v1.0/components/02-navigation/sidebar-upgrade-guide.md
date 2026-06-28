# TSideBar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Removed | 删除 `defaultValue` 参数（合并到 `value`） |
| New | 新增 `TSideBarThemeData` ThemeExtension |
| New | 新增 `themeData` 参数（子树级主题数据） |
| Enhanced | `style` 改为可选，支持从 ThemeData 读取默认值 |
| Enhanced | L4 样式参数支持从 ThemeData 读取默认值 |

## 迁移清单

### 1. 删除 `defaultValue`（必改）

`defaultValue` 已删除，直接使用 `value` 即可。组件初始化时会自动选中第一项。

**0.2.x:**
```dart
TSideBar(
  defaultValue: 0,
  children: [...],
);
```

**v1.0:**
```dart
TSideBar(
  value: 0,
  children: [...],
);
```

### 2. 新增 `TSideBarThemeData`（推荐）

将样式参数迁入 `TSideBarThemeData`，支持子树级默认值。

**v1.0（ThemeData）:**
```dart
TSideBar(
  themeData: TSideBarThemeData(
    style: TSideBarStyle.outline,
    height: 600,
    selectedColor: Colors.red,
    selectedBgColor: Colors.white,
  ),
  children: [...],
);
```

### 3. 优先级规则

构造器参数 > `themeData` > `Theme.of(context).extension<TSideBarThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/sidebar/t_sidebar_theme_data.dart` | 新增 |
| `lib/src/components/sidebar/t_sidebar.dart` | 删除 `defaultValue`，新增 `themeData`，L4 支持默认值 |
| `lib/tdesign_flutter.dart` | 新增 `TSideBarThemeData`/`TSideBarStyle` export |
| `test/components/sidebar/t_sidebar_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/sidebar/t_sidebar_test.dart --no-color
dart analyze lib/src/components/sidebar/
```
