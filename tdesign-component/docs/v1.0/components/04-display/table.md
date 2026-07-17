# TTable — v1.0 定稿

> **状态**：规划中 | **控制类**：— | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/table`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；**CSS 式**样式进 Theme |
| Material | 自绘 |
| Theme | `TTableThemeData` |
| 禁用 | 无 Widget 级 bool。 |
| L4 | `bordered` / `stripe` / `rowHeight` / `height` 等 → **`TTableThemeData`** |

## 控制方案

控制类 **—**（纯展示/布局）：无受控 value；按子交互控件控制类处理。

### 选择列 Checkbox 密度

Table 的选择列是明确的紧凑型 Checkbox 消费者。Table 单元格负责外围布局，内部 Checkbox 通过局部 Material `CheckboxThemeData` 显式使用：

- `visualDensity: VisualDensity.compact`
- `materialTapTargetSize: MaterialTapTargetSize.shrinkWrap`

该配置只能作用于选择列子树，不得修改应用全局 Checkbox 密度，也不得依赖 `TCheckbox.title == null` 自动进入紧凑模式。Checkbox 指示器尺寸、点击热区和 Table 行高分别归各自组件所有。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

> 业务态 / 结构开关 / 槽位 Widget **不进 Theme**（对齐 [theme.md §2.1](../../foundation/theme.md#21-themedata-字段归类v10-裁决)）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `columns` | `List<TTableCol>` | L2 | — | 列定义 |
| | `data` | `List<Map>` | L2 | — | 行数据 |
| | `loading` | `bool` | L1 | `false` | **业务态**：是否展示加载 UI（**非** Theme） |
| | `loadingWidget` | `Widget?` | L2 | — | 加载占位；与 `loading` 配对 |
| | `empty` | `Widget?` | L2 | — | 空数据占位 |
| | `footer` | `Widget?` | L2 | — | 表尾（原 `footerWidget`） |
| | `onCellTap` | `VoidCallback?` | L3 | — | 单元格点击回调 |
| | `onScroll` | `ScrollCallback?` | L3 | — | 滚动回调 |
| | `onSelect` | `ValueChanged<bool>?` | L3 | — | 单元格选择回调 |
| | `onRowSelect` | `ValueChanged<bool>?` | L3 | — | 行选择回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 TTableCol 类型

| 决策 | 字段 | 类型 | 说明 |
|------|------|------|------|
| | `title` | `String` | 列标题 |
| | `dataIndex` | `String` | 数据字段名 |
| | `width` | `double?` | 列宽 |
| | `align` | `TTableAlign?` | 对齐方式 |
| | `fixed` | `TTableFixed?` | 固定位置（left / right） |
| | `render` | `Widget Function(Map data)?` | 自定义渲染 |

### 1.3 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TTableCol` | — | `columns` 数据模型 |
| ✨ | `TTableAlign` | `left` · `center` · `right` | 列对齐 |
| ✨ | `TTableFixed` | `left` · `right` | 列固定位置 |
| ✨ | `TTableThemeData` | ThemeExtension | §3 主题配置 |

### 1.4 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | 内部 `*Style` | `TTableThemeData` |
| 📦 | 表格渲染 helper | 内部实现 |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `footerWidget` | `footer` | 命名对齐 v1.0 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TTableThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `bordered` | `bordered` | 见 §3 末列 |
| `stripe` | `stripe` | 见 §3 末列 |
| `rowHeight` | `rowHeight` | 见 §3 末列 |
| `height` | `height` | 见 §3 末列 |
| `width` | `width` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |

### 保留在构造器（不进 Theme）

| 字段 | 原因 |
|------|------|
| `loading` | bool 业务态 |
| `loadingWidget` | Widget 槽位 |
| `empty` / `footer` | Widget 槽位 |
| `columns` / `data` / 回调 | 实例数据与 L3 |

> **纠正**：勿将 `loading` / `loadingWidget` 迁入 `TTableThemeData`（与 Sidebar 同类；现网过渡 Theme 含此二字段，重构时移除）。

> 子组件内部使用的 `TTable` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TTableThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TTableThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TTableThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `bordered` | 是否显示边框 | `bordered` |
| 📦 | `stripe` | 是否斑马纹 | `stripe` |
| 📦 | `rowHeight` | 行高 | `rowHeight` |
| 📦 | `height` | 表格高度 | `height` |
| 📦 | `width` | 表格宽度 | `width` |
| 📦 | `backgroundColor` | 背景色 | `backgroundColor` |

> **不进 Theme**：`loading` · `loadingWidget` · `empty` · `footer` · `columns` / `data` · 回调。

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_table.dart` — Widget 本体
  - `t_table_resolve.dart` — **唯一**样式合并入口
  - `t_table_theme_data.dart` — `TTableThemeData` ThemeExtension

- **底层实现**：自绘表格组件（无 Material 同名控件）
- **选择列**：内部 `TCheckbox` 使用局部 Material compact Theme；禁止 Checkbox 父组件特判或无标题隐式 compact。

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 加载态 | ✅ | `loading` / `loadingWidget` |
| 空态 | ✅ | `empty` 参数 |
| 边框/斑马纹 | ✅ | Theme `bordered` / `stripe` |
| 选择列密度 | ✅ | compact + shrinkWrap 不撑大行高，且只影响选择列子树 |

### 4.3 Example 契约

- 覆盖 `loading` / `loadingWidget` 加载态
- 覆盖 `empty` 空态
- 覆盖 Theme 子树配置

---

### export

- **保留**：`TTable`、`TTableCol`、`TTableAlign`、`TTableFixed`、`TTableThemeData`
- **移出**：内部 `*Style`、表格渲染 helper（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TTableThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `columns` / `data` | **实例 KEEP** | 表格数据 |
| `loading` / `loadingWidget` | **实例 KEEP** | 业务态 |
| `empty` / `footer` | **实例 KEEP** | Widget 槽位 |
| `bordered` / `stripe` / `rowHeight` / `height` / `width` / `backgroundColor` | TDesign **`TTableThemeData`** | CSS 式样式默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
