# TIndexes — v1.0 定稿

> **状态**：已定稿 | **控制类**：— | **Sprint**：S3  
> **源码**：`lib/src/components/indexes/` · **类名**：`TIndexes` · `TIndexesList` · `TIndexesAnchor`  
> **官网**：[Indexes 索引](https://tdesign.tencent.com/flutter/components/indexes) · [guide](../../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 0.2.x → v1.0](#2-02x--v10)
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘索引（`CustomScrollView` + 右侧字母条 + 吸顶锚点） |
| Material | 无等价薄包装 |
| Theme | `TIndexesThemeData`（§3） |
| 禁用 | 无 Widget 级禁用；交互由业务包裹 |
| L4 | 布局/样式默认 → `TIndexesThemeData`；`sticky` / `reverse` 留构造器 L3 |

## 控制方案

控制类 **`—`**：无 `value` + `onChanged` 闭环；激活索引组件内部持有（`ValueNotifier`），**初值恒为 `indexList` 首项**（无 Widget 级初值 API）。`onChanged` / `onSelect` 为 **L3 通知回调**（旁听业务态，父组件自行 `setState`）；**非** B/C/F 式 `value` 受控。无 `defaultValue` / Widget 级 `initialValue`。

| 回调 | 触发时机 |
|------|----------|
| `onChanged` | 激活索引变化（滚动吸顶 **或** 点击侧栏） |
| `onSelect` | **仅**点击右侧索引条；`TIndexes` 对外仅传 `newIndex`，内部 `TIndexesList` 使用 `(newIndex, oldIndex)` |
| `onChange` | KEEP；与 `onChanged` 同时触发 |

→ [controlled.md](../../foundation/controlled.md) · [api.md §3 动作回调](../../foundation/api.md#3-动作回调)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留。L4 默认走 §3，构造器 L1 可覆盖布局/样式项。Builder 命名 → [api.md §2.1](../../foundation/api.md#21-l2-内容槽widget-实例-vs-builder-回调)。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`indexListMaxHeight` / `stickyOffset` / `capsuleTheme`）。

### 1.1 构造器参数

#### TIndexes

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `indexList` | `List<String>?` | L2 | A–Z | 索引字符列表 |
| ✏️ | `contentBuilder` | `Widget? Function(BuildContext, String)` | L2 | — | 按索引构建内容（必填；原 `builderContent`） |
| ✏️ | `anchorBuilder` | `Widget? Function(BuildContext, String, bool)?` | L2 | — | 自定义锚点；`bool` 为吸顶态 |
| ✏️ | `indexBuilder` | `Widget Function(BuildContext, String, bool)?` | L2 | — | 自定义侧边索引项；`bool` 为激活态 |
| | `scrollController` | `ScrollController?` | L1 | — | 滚动控制器（可选） |
| ✏️ | `onChanged` | `ValueChanged<String>?` | L3 | — | 激活索引变化通知（推荐；原 `onChange`） |
| | `onChange` | `ValueChanged<String>?` | L3 | — | KEEP；与 `onChanged` 同时触发 |
| | `onSelect` | `ValueChanged<String>?` | L3 | — | 点击侧栏；仅 `newIndex` |
| | `sticky` | `bool?` | L3 | `true` | 锚点吸顶 |
| | `reverse` | `bool?` | L3 | `false` | 反向滚动置顶 |
| | `indexListMaxHeight` | `double?` | L1 | Theme | 索引条最大高度（父容器比例） |
| | `stickyOffset` | `double?` | L1 | Theme | 吸顶偏移 |
| | `capsuleTheme` | `bool?` | L1 | Theme | 胶囊样式 |

> 样式默认经 `Theme.of(context).extension<TIndexesThemeData>()`；单颗定制用 `Theme` 子树 `mergeExtension`（**禁止**构造器 `themeData` → [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。

#### TIndexesList

右侧索引条；与 `TIndexes` 组合或单独用于自定义布局。

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `indexList` | `List<String>` | L2 | — | 索引字符列表（必填） |
| | `activeIndex` | `ValueNotifier<String>` | L1 | — | 激活索引（与锚点共用） |
| | `onSelect` | `void Function(String, String)` | L3 | — | `(newIndex, oldIndex)` |
| | `indexListMaxHeight` | `double?` | L1 | Theme / `0.8` | 侧栏最大高度比例 |
| ✏️ | `indexBuilder` | `Widget Function(BuildContext, String, bool)?` | L2 | — | 原 `builderIndex` |

#### TIndexesAnchor

锚点标题；与 `TIndexes` 组合或单独用于自定义布局。

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `text` | `String` | L2 | — | 锚点字母（必填） |
| | `sticky` | `bool` | L3 | — | 是否吸顶 |
| | `capsuleTheme` | `bool` | L1 | — | 胶囊样式 |
| | `activeIndex` | `ValueNotifier<String>` | L1 | — | 与 `TIndexesList` 共用 |
| ✏️ | `anchorBuilder` | `Widget? Function(BuildContext, String, bool)?` | L2 | — | 原 `builderAnchor` |

### 1.2 类型定义

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TIndexes` | 索引容器（内容区 + 侧栏） |
| | `TIndexesList` | 右侧索引条子组件 |
| | `TIndexesAnchor` | 锚点标题子组件 |
| | `TIndexesThemeData` | ThemeExtension（§3） |

### 1.3 export

**KEEP**：`TIndexes` · `TIndexesList` · `TIndexesAnchor` · `TIndexesThemeData`。  
**不 export**：`sticky_header` 内部实现。

---

## §2 0.2.x → v1.0

**未改**（§1 无图例项）：`indexList` · `scrollController` · `onSelect` · `onChange` · `sticky` · `reverse` · `indexListMaxHeight` · `stickyOffset` · `capsuleTheme`

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `builderContent` | `contentBuilder` | 全局替换（含 `TIndexes`） |
| `builderAnchor` | `anchorBuilder` | 全局替换（含 `TIndexes` · `TIndexesAnchor`） |
| `builderIndex` | `indexBuilder` | 全局替换（含 `TIndexes` · `TIndexesList`） |
| `onChange` | `onChanged` | 推荐新名；`onChange` KEEP 双触发 |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| 构造器 `themeData` | `Theme` 子树 `mergeExtension` | 见 §3 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（`TIndexesThemeData`） | 怎么改 |
|------------------|---------------------------|--------|
| `indexListMaxHeight` / `stickyOffset` / `capsuleTheme` | 同名字段 | 默认可走 Theme；构造器 L1 可覆盖 |
| `sticky` / `reverse` | **不迁入** | 保留构造器 L3 |

---

## §3 Theme 主题配置

`TIndexesThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 L1（`indexListMaxHeight` 等） |
| 子树 | `Theme.of(context).mergeExtension(TIndexesThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TIndexesThemeData` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TIndexesThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘无 P2 Material 子主题）。行为项 `sticky` / `reverse` 仅构造器 L3，**不进 Theme**。

| 决策 | 字段 | 管什么 | 0.2.x 来源 |
|------|------|--------|-----------|
| 📦 | `indexListMaxHeight` | 侧栏最大高度比例 | 同名构造器 |
| 📦 | `stickyOffset` | 吸顶偏移 | 同名构造器 |
| 📦 | `capsuleTheme` | 胶囊锚点样式 | 同名构造器 |

#### 字段归类：进 Theme 与不进 Theme

本组件为自绘索引（无 Material 等价薄包装）；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TIndexesThemeData`（P1，可主题化）**
- `indexListMaxHeight` · `stickyOffset` · `capsuleTheme`

**不进 Theme（构造器 L1/L2/L3）**
- `sticky` · `reverse`（L3 行为项）
- `indexList` · `scrollController` · `onChanged` · `onSelect` · `onChange`（L1/L2/L3）

---

## §4 实现约定 · 测试与 Example 契约

**文件**：`t_indexes.dart` · `t_indexes_list.dart` · `t_indexes_anchor.dart` · `t_indexes_theme_data.dart`。

**必测**：默认 A–Z · 侧栏点击滚动 · `onChanged`/`onSelect`/`onChange` 分工 · 吸顶 · `sticky`/`reverse` · 自定义 `*Builder` · Theme 子树 · 取消 `sticky_header` 对外 export。

**Example**：`builderContent`→`contentBuilder` · 自定义 anchor/index · `capsuleTheme` · `sticky`/`reverse`。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [indexes-upgrade-guide.md](./indexes-upgrade-guide.md)
