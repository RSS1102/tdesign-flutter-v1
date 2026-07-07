# TActionSheet 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TActionSheetThemeData` ThemeExtension（13 字段） |
| New | `showListActionSheet`/`showGridActionSheet`/`showGroupActionSheet` 参数支持 P1 `mergeExtension` 子树覆盖 |
| Enhanced | 构造器 + show 方法参数改为可空，支持 `widget.field ?? theme?.field ?? hardDefault` 三级回退 |
| Rename | `onSelected`→`onChanged` |
| Rename | `TActionSheetItemCallback`→`TActionSheetOnChanged` |
| Rename | `description`→`subtitle` |
| Compatible | `showListActionSheet`/`showGridActionSheet`/`showGroupActionSheet` 保留 |

## 迁移清单

### 1. 回调改名

`onSelected`→`onChanged`，`TActionSheetItemCallback`→`TActionSheetOnChanged`。

### 2. 副标题改名

`description`→`subtitle`（列表/宫格副标题参数）。

### 3. 样式定制改用 `mergeExtension`

构造器和 show 方法的参数（`align`/`cancelText`/`count`/`rows`/`itemHeight`/`itemMinWidth`/`showCancel`/`showPagination`/`scrollable`/`useSafeArea` 等）改为可空，支持通过 `Theme.of(context).mergeExtension(TActionSheetThemeData(...))` 子树覆盖。

**✅ v1.0（子树覆盖）:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TActionSheetThemeData(
      itemHeight: 80,
      defaultAlign: TActionSheetAlign.left,
      count: 4,
    ),
  ),
  child: TButton(
    child: Text('打开'),
    onPressed: () {
      TActionSheet.showGridActionSheet(
        context,
        items: [...],
      );
    },
  ),
);
```

### 4. 优先级规则

构造器/show 参数 > `Theme.of(context).extension<TActionSheetThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/action_sheet/t_action_sheet_theme_data.dart` | 新增（13 字段） |
| `lib/src/components/action_sheet/t_action_sheet.dart` | 参数重命名；参数改可空；P1 读取 |
| `lib/src/components/action_sheet/t_action_sheet_list.dart` | 参数重命名 |
| `lib/src/components/action_sheet/t_action_sheet_grid.dart` | 参数重命名 |
| `lib/src/components/action_sheet/t_action_sheet_group.dart` | 参数重命名 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/lib/page/t_action_sheet_page.dart` | 参数重命名 |
| `example/assets/api/action-sheet_api.md` | API 文档同步 |
