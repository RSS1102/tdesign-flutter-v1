# TToast 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TToastThemeData` ThemeExtension（原 `TToastConfig`） |
| Rename | `TToastConfig`→`TToastThemeData` |
| Compatible | `duration` 已为 `Duration` 类型，无需迁移 |
| Compatible | `showText`/`showIconText`/`showSuccess`/`showWarning`/`showFail`/`showLoading` 保留 |
| Compatible | `dismissToast`/`dismissAll`/`dismissLoading` 保留 |

## 迁移清单

### 1. 配置类改名

`TToastConfig`→`TToastThemeData`。字段不变，改为 ThemeExtension 模式。

### 2. duration 已为 Duration

TToast 的 `duration` 参数在 0.2.x 中已经是 `Duration` 类型，无需迁移。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/toast/t_toast_theme_data.dart` | 新增 |
| `lib/src/components/toast/t_toast.dart` | `TToastConfig`→`TToastThemeData` |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/assets/api/toast_api.md` | API 文档同步 |
