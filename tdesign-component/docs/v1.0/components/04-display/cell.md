# TCell — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/cell`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | ListTile |
| Theme | `TCellThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TCellThemeData`** |

## 控制方案

控制类 **A**：`onTap`；无 `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `title` | `Widget?` | L2 | — | 标题区 |
| | `subtitle` | `Widget?` | L2 | — | 副标题区（原 `description`） |
| | `prefix` | `Widget?` | L2 | — | 左侧区（原 `leftIcon`） |
| | `image` | `Widget?` | L2 | — | 左侧图片区 |
| | `note` | `Widget?` | L2 | — | 右侧 note 区 |
| | `trailing` | `Widget?` | L2 | — | 最右图标区（原 `rightIcon`） |
| ✨ | `arrow` | `bool` | L1 | `false` | 是否显示右侧箭头 |
| ✨ | `align` | `TCellAlign` | L1 | `center` | 内容对齐方式 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |
| | `onLongPress` | `GestureLongPressCallback?` | L3 | — | 长按回调（Material `ListTile.onLongPress`） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`bordered`（底部分割线）为 L4 样式，迁入 `TCellThemeData.showBottomBorder`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TCellAlign` | `center` · `start` · `end` | `align` 参数 |
| ✨ | `TCellThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TCellStyle` | `TCellThemeData` |
| 📦 | `TCellClick` | `GestureTapCallback? onTap` |
| 🗑️ | `disabled` | `onTap: null` |
| 🗑️ | `bordered` | `TCellThemeData.showBottomBorder` |
| 📦 | `style` / `align` / `hover` / `showBottomBorder` / `height` | `TCellThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `title`（`String?`）/ `titleWidget` | `title: Widget?` | 单槽 |
| `description` / `descriptionWidget` / `subtitleWidget` | `subtitle: Widget?` | 命名对齐 + 单槽 |
| `leftIcon` / `leftIconWidget` | `prefix: Widget?` | 命名对齐 + 单槽 |
| `image` / `imageWidget` | `image: Widget?` | 单槽 |
| `note`（`String?`）/ `noteWidget` | `note: Widget?` | 单槽 |
| `rightIcon` / `rightIconWidget` | `trailing: Widget?` | 单槽 |
| `onClick` | `onTap` | 命名对齐 v1.0 |
| `disabled` | `onTap: null` | Material 禁用 |
| `style` | `TCellThemeData` | L4 → Theme |
| `align` | `TCellThemeData` | L4 → Theme |
| `hover` | `TCellThemeData` | L4 → Theme |
| `showBottomBorder` | `TCellThemeData` | L4 → Theme |
| `height` | `TCellThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TCellClick` | `GestureTapCallback? onTap` | 废弃 typedef |
| `bordered` | `TCellThemeData.showBottomBorder` | L4 样式迁入 Theme |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TCellThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `bordered` | `showBottomBorder` | 见 §3 末列 |
| `style` | `style` | 见 §3 末列 |
| `align` | `defaultAlign` | 见 §3 末列 |
| `hover` | `hoverColor` | 见 §3 末列 |
| `showBottomBorder` | `showBottomBorder` | 见 §3 末列 |
| `height` | `height` | 见 §3 末列 |

> 注：Material `ListTileTheme` 的 `titleTextstyle`/`subtitleTextstyle`/`leadingAndTrailingTextStyle`/`contentPadding`/`dense`/`shape`/`tileColor`/`selectedColor`/`iconColor`/`textColor` 由 Material 子主题处理，TDesign 扩展字段在 `TCellThemeData` 中。

> 子组件内部使用的 `TCell` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TCellThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TCellThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TCellThemeData 字段

> TDesign 扩展字段（Material `ListTileTheme` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `showBottomBorder` | 是否显示底部分割线 | `bordered` / `showBottomBorder` |
| 📦 | `style` | 单元格样式枚举 | `style` |
| 📦 | `defaultAlign` | 默认对齐方式 | `align` |
| 📦 | `hoverColor` | 悬停背景色 | `hover` |
| 📦 | `height` | 单元格高度 | `height` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_cell.dart` — Widget 本体
  - `t_cell_resolve.dart` — **唯一**样式合并入口
  - `t_cell_theme_data.dart` — `TCellThemeData` ThemeExtension

- **底层实现**：包装 Material `ListTile`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 箭头显示 | ✅ | `arrow: true` |
| 点击交互 | ✅ | `onTap` 回调 |
| 长按交互 | ✅ | `onLongPress` 回调 |

### 4.3 Example 契约

- 覆盖 `title` / `subtitle` / `prefix` / `note` / `trailing` 各区域
- 覆盖 `arrow` 开关
- 覆盖 `onTap` / `onLongPress` 交互

---

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
| `titleTextstyle` / `subtitleTextstyle` / `leadingAndTrailingTextStyle` / `contentPadding` / `dense` / `iconColor` / `textColor` | Material **`ListTileTheme`** | 默认样式 |
| `note` 区 / `arrow` 布局 | TDesign 扩展 | Material ListTile 无 note 语义 |
| `style` / `hover` / `height` 默认 | TDesign **`TCellThemeData`** | L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
