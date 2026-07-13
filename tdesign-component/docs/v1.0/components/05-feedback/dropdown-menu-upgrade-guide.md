# TDropdownMenu 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TDropdownThemeData` ThemeExtension |
| Rename | `onChange`→`onChanged`（TDropdownItem） |
| Compatible | `TDropdownMenu`/`TDropdownItem`/`TDropdownItemOption`/`TDropdownItemController` 保留 |
| Compatible | `multiple`/`onConfirm`/`onReset`/`onMenuOpened`/`onMenuClosed` 保留 |

## 迁移清单

### 1. 回调改名

`onChange`→`onChanged`（TDropdownItem 的回调参数）。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/dropdown_menu/t_dropdown_theme_data.dart` | 新增 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/lib/page/t_dropdown_menu_page.dart` | `onChange`→`onChanged` |
| `example/assets/api/dropdown-menu_api.md` | API 文档同步 |
