# TTable — v1.0 定稿

> Sprint **S4** | 控制类 **—** | Material: 自绘
> 源码：`lib/src/components/table` · [guide](../../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；**CSS 式**样式进 Theme |
| Material | 自绘 |
| Theme | `TTableThemeData`（色 · 边距 · 行高 · 斑马纹等） |
| 禁用 | 无 Widget 级 bool。 |
| L4 | `bordered` / `stripe` / `rowHeight` / `height` 等 → **`TTableThemeData`** |

## 控制方案

无受控 value；按子交互控件控制类处理。

---

## §1 v1.0 定稿 API

> 业务态 / 结构开关 / 槽位 Widget **不进 Theme**（对齐 [theme.md §2.1](../../foundation/theme.md#21-themedata-字段归类v10-裁决) · [sidebar.md §1.1.1](../02-navigation/sidebar.md#111-加载态)）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `columns` | `List<TTableCol>` | L2 | — | 列定义 |
| | `data` | `List<Map>` | L2 | — | 行数据 |
| | `loading` | `bool` | L1 | `false` | **业务态**：是否展示加载 UI（**非** Theme） |
| | `loadingWidget` | `Widget?` | L2 | — | 加载占位；与 `loading` 配对；保留 `*Widget` 消歧 → [api.md §2.1](../../foundation/api.md#21-l2-内容槽widget-实例-vs-builder-回调) |
| | `showHeader` | `bool` | L1 | `true` | **结构开关**：是否渲染表头行 |
| | `empty` | `Widget?` | L2 | — | 空数据占位 |
| | `footer` | `Widget?` | L2 | — | 表尾（原 `footerWidget`） |
| | `onCellTap` / `onScroll` | 回调 | L3 | — | 单元格与滚动 |
| | `onSelect` / `onRowSelect` | 回调 | L3 | — | 行选择 |

> 样式默认经 `Theme.of(context).extension<TTableThemeData>()`；**禁止**构造器 `themeData`。

#### §1.1.1 加载态

`loading` 为 **bool 业务态**（此刻是否加载），不进 Theme。`loadingWidget` 为槽位，未传时用组件内置默认加载 UI。

| `loading` | `loadingWidget` | 渲染 |
|-----------|-----------------|------|
| `false` | — | 正常表格 |
| `true` | `null` | 内置加载占位 |
| `true` | 有 | 仅 `loadingWidget` |

### 1.2 类型定义 · export

**KEEP**：`TTable` · `TTableCol` · `TTableThemeData`。

**移出**：内部 `*Style`、表格渲染 helper（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）。

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从 | 到 |
|----|-----|
| `footerWidget` | `footer: Widget?` |

### 📦 迁入 Theme（仅 CSS 式默认）

| 从 | 到 |
|----|-----|
| `bordered` / `stripe` | `TTableThemeData` |
| `rowHeight` / `height` / `width` | `TTableThemeData` |
| `backgroundColor` / `defaultSort` | `TTableThemeData` |

### 保留在构造器（不进 Theme）

| 字段 | 原因 |
|------|------|
| `loading` | bool 业务态 |
| `loadingWidget` | Widget 槽位 |
| `showHeader` | 结构能力开关 |
| `empty` / `footer` | Widget 槽位 |
| `columns` / `data` / 回调 | 实例数据与 L3 |

> **纠正**：勿将 `loading` / `loadingWidget` 迁入 `TTableThemeData`（与 Sidebar 同类；现网过渡 Theme 含此二字段，重构时移除）。

---

## §3 Theme 主题配置

`TTableThemeData` · [theme.md](../../foundation/theme.md)

| 字段 | 说明 |
|------|------|
| `bordered` / `stripe` | 边框 / 斑马纹 |
| `height` / `rowHeight` / `width` | 尺寸 |
| `backgroundColor` / `defaultSort` | 背景 · 默认排序 |

> **不进 Theme**：`loading` · `loadingWidget` · `showHeader` · `empty` · `footer` · `columns` / `data` · 回调。

---

## §4 实现约定 · 测试与 Example 契约

**必测**：`loading` / `loadingWidget` · `showHeader` · 空态 `empty` · Theme 子树 · 行选择回调。

> [api.md](../../foundation/api.md) · [testing.md](../../guide/testing.md)
