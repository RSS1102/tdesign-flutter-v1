# TMessage 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TMessageThemeData` ThemeExtension |
| New | 新增 `TMessageVariant` 枚举（原 `MessageTheme`） |
| Rename | `MessageTheme`→`TMessageVariant` |
| Rename | `MessageLink`→`TMessageLink` |
| Rename | `MessageMarquee`→`TMessageMarquee` |
| Rename | `theme`→`variant`（构造器参数与字段） |

## 迁移清单

### 1. 枚举与类改名

| 0.2.x | v1.0 |
|-------|------|
| `MessageTheme` | `TMessageVariant` |
| `MessageLink` | `TMessageLink` |
| `MessageMarquee` | `TMessageMarquee` |

### 2. 参数改名

`theme`→`variant`。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/message/t_message_theme_data.dart` | 新增 |
| `lib/src/components/message/t_message.dart` | 枚举/类/参数重命名 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/lib/page/t_message_page.dart` | 参数重命名 |
| `example/assets/api/message_api.md` | API 文档同步 |
