# TCellGroup — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/cell-group`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | Column |
| Theme | `TCellThemeData`（与 TCell 共用） |
| 禁用 | `onTap: null`（交互禁用） |
| L4 | 构造器 L4 → **`TCellThemeData`** |

## 控制方案

控制类 **A**：`onTap`；无 `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `title` | `Widget?` | L2 | — | 组标题（原 `titleWidget`） |
| | `cells` | `List<TCell>` | L2 | — | `TCell` 子项列表 |
| | `builder` | `CellGroupBuilder?` | L2 | — | 自定义 cell 父组件 |
| ✨ | `scrollable` | `bool` | L1 | `false` | 组内可滚动 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`bordered`（组边框）和 `isShowLastBordered`（最后一项分割线）为 L4 样式，迁入 `TCellThemeData`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `CellGroupBuilder` | `Widget Function(Widget child)?` | `builder` 参数 |
| ✨ | `TCellThemeData` | ThemeExtension | §3 主题配置（与 TCell 共用） |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TCellGroupTheme` | `TCellThemeData.groupVariant` |
| 📦 | `theme` (0.2.x) | `TCellThemeData` |
| 📦 | `style` (0.2.x) | `TCellThemeData` |
| 🗑️ | `bordered` | `TCellThemeData` |
| 🗑️ | `isShowLastBordered` | `TCellThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `title`（`String?`）/ `titleWidget` | `title: Widget?` | 单槽 |
| `TCellGroupTheme` | `TCellThemeData` | 枚举化 |
| `theme` (0.2.x) | `TCellThemeData` | L4 → Theme |
| `style` (0.2.x) | `TCellThemeData` | L4 → Theme |

### ✨ 新增

_无_（复用 [cell.md](./cell.md) 的 `TCellThemeData`）

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TCellStyle` 构造器参数 | 不 export；迁入 `TCellThemeData` | 内部实现 |
| `TCellGroupTheme` | `TCellThemeData` | 枚举化 |
| `bordered` | `TCellThemeData` | L4 样式迁入 Theme |
| `isShowLastBordered` | `TCellThemeData` | L4 样式迁入 Theme |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TCellThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `bordered` | `bordered` | 见 §3 末列 |
| `isShowLastBordered` | `isShowLastBordered` | 见 §3 末列 |
| `theme` (0.2.x) | `groupVariant` | 见 §3 末列 |
| `style` (0.2.x) | `TCellThemeData` | 见 §3 末列 |

> 注：`TCellGroupTheme` 的 `default`/`card` 形态迁入 `TCellThemeData.groupVariant`。

> 子组件内部使用的 `TCellGroup` 也需同步升级，**不借用构造器参数**。

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

### 3.3 TCellThemeData 字段（TCellGroup 相关）

> TDesign 扩展字段（复用 TCell 的 `TCellThemeData`）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `groupVariant` | 组形态（default / card） | `TCellGroupTheme` |
| 📦 | `bordered` | 是否显示组边框 | `bordered` |
| 📦 | `isShowLastBordered` | 最后一项是否显示分割线 | `isShowLastBordered` |
| 📦 | `showBottomBorder` | 是否显示底部分割线 | `bordered`（Cell） |

> 完整字段见 [cell.md §3](./cell.md#3-theme-主题配置)

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_cell_group.dart` — Widget 本体
  - 复用 `TCell` 的 resolve 逻辑

- **底层实现**：包装 Material `Column` + `TCell`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 组标题 | ✅ | `title` 参数 |
| 多 cell 列表 | ✅ | `cells` 参数 |
| 组边框 | ✅ | `bordered` 参数 |

### 4.3 Example 契约

- 覆盖 `title` + `cells` 基本结构
- 覆盖 `bordered` 开关
- 覆盖 `scrollable` 开关

---

### export

- **保留**：`TCellGroup`、`TCellThemeData`（与 TCell 共用）
- **移出**：`TCellGroupTheme`、`TCellStyle`、`t_cell_style.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCellThemeData` · Material: **Column** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `cells` | Material **`Column`** / List | **`TCell` 子项组合** |
| `title` | Material **`Column`** | 组标题 `Widget?` |
| `bordered` / `isShowLastBordered` | **`TCellThemeData`** | 组级边框默认 |
| `groupVariant` | **`TCellThemeData`** | 组级 L4（default / card） |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
