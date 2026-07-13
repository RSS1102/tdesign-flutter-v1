# TPopover 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TPopoverThemeData` ThemeExtension |
| New | 新增 `TPopoverColorScheme` 枚举（原 `TPopoverTheme`） |
| Rename | `TPopoverTheme`→`TPopoverColorScheme` |
| Rename | `theme`→`colorScheme`（构造器参数与字段） |
| Rename | `overlayColor`→`barrierColor` |
| Compatible | `showPopover`/`TPopoverPlacement` 保留 |

## 迁移清单

### 1. 枚举改名

`TPopoverTheme`→`TPopoverColorScheme`（dark/light/info/success/warning/error）。

### 2. 参数改名

| 0.2.x | v1.0 |
|-------|------|
| `theme` | `colorScheme` |
| `overlayColor` | `barrierColor` |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/popover/t_popover_theme_data.dart` | 新增 |
| `lib/src/components/popover/t_popover.dart` | 参数重命名 |
| `lib/src/components/popover/t_popover_widget.dart` | 枚举/字段重命名 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/lib/page/t_popover_page.dart` | 参数重命名 |
| `example/assets/api/popover_api.md` | API 文档同步 |
