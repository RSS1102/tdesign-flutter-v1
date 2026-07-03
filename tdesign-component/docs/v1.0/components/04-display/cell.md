# TCell — v1.0 定稿

> Sprint **S3** | 控制类 **A** | Material: ListTile
> 源码：`lib/src/components/cell` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装（ListTile 系保留 `onTap`） |
| Material | ListTile |
| Theme | `TCellThemeData` |
| 禁用 | 不设 `disabled` 参数。 |
| L4 | 构造器 L4 → `TCellThemeData` |

## 控制方案

`onPressed` / `onTap`；无 `value`。禁用：回调 `null`。


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| arrow | 是否显示右侧箭头 |
| title | 标题区（`Widget?`） |
| TCellAlign | 保留 |
| bordered | 保留 |
| subtitle | 副标题区（`Widget?`；原 `description`） |
| prefix | 左侧区（`Widget?`；原 `leftIcon`） |
| onTap | 由 `onClick` 迁移；`GestureTapCallback?` |
| onLongPress | 保留 — Material `ListTile.onLongPress` |
| image | 左侧图片区（`Widget?`） |
| imageSize / imageCircle | 图片尺寸与圆形裁剪 |
| note | 右侧 note 区（`Widget?`） |
| noteMaxWidth / noteMaxLine | note 布局约束 |
| trailing | 最右图标区（`Widget?`；原 `rightIcon`） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| `title`（`String?`）/ `titleWidget` | `title: Widget?` | §2.1 单槽 |
| `description` / `descriptionWidget` / `subtitleWidget` | `subtitle: Widget?` | 命名对齐 + 单槽 |
| `leftIcon` / `leftIconWidget` | `prefix: Widget?` | 命名对齐 + 单槽 |
| `image` / `imageWidget` | `image: Widget?` | §2.1 单槽 |
| `note`（`String?`）/ `noteWidget` | `note: Widget?` | §2.1 单槽 |
| `rightIcon` / `rightIconWidget` | `trailing: Widget?` | §2.1 单槽 |
| onClick | onTap | 命名对齐 v1.0 |
| disabled | onTap: null | Material 禁用 |
| style | TCellThemeData | L4 → Theme |
| align | TCellThemeData | L4 → Theme |
| hover | TCellThemeData | L4 → Theme |
| showBottomBorder | TCellThemeData | L4 → Theme |
| height | TCellThemeData | L4 → Theme |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TCellClick | 废弃 → `GestureTapCallback? onTap`（同 Material `ListTile.onTap`） |

### 新增

_无_

### export

- **保留**：`TCell`、`TCellAlign`、`TCellThemeData`
- **移出**：`TCellStyle`、`TCellClick`（废弃 typedef）（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TCellThemeData` · Material: **ListTile** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `title` / `subtitle` / `leading` / `trailing` | Material **`ListTile`** | 映射 `title` / `subtitle` / `prefix`+`image` / `note`+`trailing`+`arrow` |
| `onTap` / `onLongPress` | Material **`ListTile`** | `GestureTapCallback?` |
| `title` / `subtitle` / `prefix` / `note` / `trailing` / `image` | **实例 `Widget?`** | 每行内容不同；文案 `Text('…')` |
| `titleColor` / `iconColor` / `contentPadding` / `dense` | Material **`ListTileTheme`** | 默认样式 |
| `note` 区 / `arrow` 布局 | TDesign 扩展 | Material ListTile 无 note 语义 |
| `bordered` / `hover` / `height` 默认 | TDesign **`TCellThemeData`** | L4 默认 |
