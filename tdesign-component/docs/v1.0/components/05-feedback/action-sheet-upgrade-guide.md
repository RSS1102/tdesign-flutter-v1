# TActionSheet 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TActionSheetThemeData` ThemeExtension |
| Rename | `onSelected`→`onChanged` |
| Rename | `TActionSheetItemCallback`→`TActionSheetOnChanged` |
| Rename | `description`→`subtitle` |
| Compatible | `showListActionSheet`/`showGridActionSheet`/`showGroupActionSheet` 保留 |

## 迁移清单

### 1. 回调改名

`onSelected`→`onChanged`，`TActionSheetItemCallback`→`TActionSheetOnChanged`。

### 2. 副标题改名

`description`→`subtitle`（列表/宫格副标题参数）。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/action_sheet/t_action_sheet_theme_data.dart` | 新增 |
| `lib/src/components/action_sheet/t_action_sheet.dart` + 子文件 | 参数重命名 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/lib/page/t_action_sheet_page.dart` | 参数重命名 |
| `example/assets/api/action-sheet_api.md` | API 文档同步 |
