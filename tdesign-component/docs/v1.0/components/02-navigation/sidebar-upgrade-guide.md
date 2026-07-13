# TSideBar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Removed | 删除 `defaultValue` 参数（合并到 `value`） |
| New | 新增 `TSideBarThemeData` ThemeExtension |
| Removed | 移除 `themeData` 构造器参数（改用 `mergeExtension` 子树覆盖） |
| Enhanced | `style` 改为可选，支持从 ThemeData 读取默认值 |

## 迁移清单

### 1. 删除 `defaultValue`（必改）

`defaultValue` 已删除，直接使用 `value` 即可。

**0.2.x:**
```dart
TSideBar(defaultValue: 0, children: [...]);
```

**v1.0:**
```dart
TSideBar(value: 0, children: [...]);
```

### 2. `themeData` 参数已移除 — 改用 `mergeExtension`

`themeData` 构造器参数已移除（对齐 theme.md §2.1）。样式定制通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。

**❌ 已移除:**
```dart
TSideBar(
  themeData: TSideBarThemeData(style: TSideBarStyle.outline, height: 600),  // 已删除
  children: [...],
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TSideBarThemeData(style: TSideBarStyle.outline, height: 600),
  ),
  child: TSideBar(children: [...]),
);
```

### 3. 优先级规则

构造器参数 > `Theme.of(context).extension<TSideBarThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/sidebar/t_sidebar_theme_data.dart` | 新增 |
| `lib/src/components/sidebar/t_sidebar.dart` | 删除 `defaultValue`；移除 `themeData`；P1 读取 |
| `lib/tdesign_flutter.dart` | 新增 `TSideBarThemeData`/`TSideBarStyle` export |
| `test/components/sidebar/t_sidebar_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/sidebar/t_sidebar_test.dart --no-color
dart analyze lib/src/components/sidebar/
```
