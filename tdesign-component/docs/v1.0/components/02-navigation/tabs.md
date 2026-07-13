# Tabs — v1.0 定稿

> **状态**：已定稿 | **控制类**：— | **Sprint**：S3  
> **源码**：`lib/src/components/tabs/` · **类名**：`TTab` · `TTabsBar` · `TTabsBarView`  
> **官网**：[Tabs 选项卡](https://tdesign.tencent.com/flutter/components/tabs) · [guide](../../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 0.2.x → v1.0](#2-02x--v10)
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

合并：[tab-废弃.md](./tab-废弃.md) · [tab-bar-废弃-ttabbar.md](./tab-bar-废弃-ttabbar.md) · [tab-bar-view-废弃.md](./tab-bar-view-废弃.md)。底部 TabBar → [tab-bar.md](./tab-bar.md)（`TTabBar`）。**本组件先落地**，为底部释放 `TTabBar` 类名。

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | `TTab` + `TTabsBar` + `TTabsBarView` 协作 |
| Material | `Tab` / `TabBar` / `TabBarView` 薄包装 |
| Theme | `TTabsBarThemeData`（三组件共享，§3） |
| 禁用 | `TTab.enabled: false` |
| L4 | → `TTabsBarThemeData`（§3） |

## 控制方案

控制类 **`—`**（Controller 持态）：选中态由共用 **`TabController`** 持有（对齐 Material）；**非** Widget 级 `value` + `onChanged`。`TTabsBar.onTap` 为 L3 旁听。无 `defaultValue` / Widget 级 `initialValue`。

→ [controlled.md §6](../../foundation/controlled.md#控制类-) · [api.md §3](../../foundation/api.md#3-动作回调)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留。`TTabsBar`/`TTab` 其余 L4 样式参数迁入 §3 Theme。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`variant` / `size` / `physics` / `isScrollable` / `tabAlignment`）。

### 1.1 构造器参数

#### TTab

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `text` / `child` / `icon` | — | L2 | — | KEEP |
| | `badge` | `TBadge?` | L2 | — | KEEP |
| | `size` | `TTabSize` | L1 | `small` | `large` · `small` |
| ✏️ | `enabled` | `bool` | L3 | `true` | 原 `enable` |

#### TTabsBar

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `tabs` | `List<TTab>` | L2 | — | KEEP |
| | `controller` | `TabController?` | L1 | — | 与 `TTabsBarView` 共用 |
| ✏️ | `variant` | `TTabsBarVariant?` | L1 | Theme | 原 `outlineType` |
| ✨ | `isScrollable` | `bool?` | L1 | Theme | 是否可横向滚动；对齐 Material `TabBar.isScrollable`（能力开关，不进 Theme） |
| ✨ | `tabAlignment` | `TabAlignment?` | L1 | Material 默认 | 对齐 Material `TabBar.tabAlignment` |
| | `onTap` | `ValueChanged<int>?` | L3 | — | L3 旁听 |

#### TTabsBarView

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `children` | `List<Widget>` | L2 | — | KEEP |
| | `controller` | `TabController?` | L1 | — | KEEP |
| ✏️ | `physics` | `ScrollPhysics?` | L1 | Theme | 原 `isSlideSwitch` |
| ✨ | `dragStartBehavior` / `clipBehavior` | — | L1 | Material 默认 | 对齐 Material |

### 1.2 类型定义

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TTab` | 单项 |
| | `TTabSize` | `large` · `small`（默认 `small`） |
| ✏️ | `TTabsBar` | 选项卡栏（原 `TTabBar`） |
| ✏️ | `TTabsBarView` | 内容区（原 `TTabBarView`） |
| ✏️ | `TTabsBarVariant` | `filled` · `capsule` · `card`（原 `TTabBarOutlineType`） |
| ✏️ | `TTabsBarThemeData` | 三组件共享 Theme |

### 1.3 export

**KEEP**（`show`）：`TTab` · `TTabSize` · `TTabsBar` · `TTabsBarView` · `TTabsBarThemeData` · `TTabsBarVariant`。  
**deprecated**：`TTabBarView` · `TTabBarThemeData` · `TTabBarVariant`（`tabs_deprecated.dart`）；PR-1 临时 `typedef TTabBar = TTabsBar`，[tab-bar.md](./tab-bar.md) PR-2 后删除。  
**不 export**：`THorizontalTabBar` · `TTabBarIndicator` 等内部实现。

---

## §2 0.2.x → v1.0

**未改**（§1 无图例项）：`tabs` · `controller` · `onTap` · `children` · `text` / `child` / `icon` · `badge` · `size`

| 从 | 到 |
|---|---|
| `TTabBar` | `TTabsBar` |
| `TTabBarView` | `TTabsBarView` |
| `TTabBarThemeData` | `TTabsBarThemeData` |
| `TTabBarOutlineType` / `outlineType` | `TTabsBarVariant` / `variant` |
| `enable` | `enabled` |
| `isSlideSwitch` | `physics`（可滑传 `BouncingScrollPhysics()`） |
| `width`（构造器） | 迁入 `TTabsBarThemeData.width`（§3） |
| `TTabsBar` / `TTab` 其余构造器 L4 | 迁入 `TTabsBarThemeData`（§3） |

---

## §3 Theme 主题配置

`TTabsBarThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 `variant` / `size` / `physics` / `isScrollable` / `tabAlignment` |
| 子树 | `Theme.of(context).mergeExtension(TTabsBarThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TTabsBarThemeData` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TTabsBarThemeData`）**>** `P2` Material `TabBarTheme` **>** `P3` `ThemeData` **>** `P4` Token。

| 决策 | 字段 | 管什么 | 0.2.x 来源 |
|------|------|--------|-----------|
| 📦 | **TTab** `iconMargin` / `contentHeight` / `textMargin` / `labelStyle` | 单项样式 | `TTab` 构造器 L4 |
| 📦 | **TTabsBar** `variant` | 栏形态 | `outlineType` |
| 📦 | **TTabsBar** `width`（栏宽） / `indicator*` / `label*` / `divider*` | 栏样式 | `TTabBar` 构造器 L4 |
| 📦 | **TTabsBarView** `defaultPhysics` | 默认滑动（**行为默认**，非样式 L4） | 原默认不可滑动 |

#### 字段归类：进 Theme 与不进 Theme

本组件为 Material `TabBar` 薄包装；已按 [theme.md §4](../../foundation/theme.md#4-material-vs-themeextension) 确认：进 Theme 字段中，Material 已有者走 P2 子主题，TDesign 设计稿必需且 M3 无对应者进 P1 `TTabsBarThemeData`。

**进 Theme**
- P2（Material `TabBar` / `TabBarTheme` 已有）：`indicatorColor` · `indicatorSize` · `labelStyle` · `unselectedLabelStyle` · `dividerColor`
- P1（`TTabsBarThemeData`，TDesign 扩展）：`variant`（`capsule` / `card`）· `width`（栏宽）· `iconMargin` · `contentHeight` · `textMargin` · `defaultPhysics`（行为默认）

**不进 Theme（构造器 L1）**
- `isScrollable` · `tabAlignment`（对齐 Material `TabBar` 构造器，M3 不可主题化）

---

## §4 实现约定 · 测试与 Example 契约

**文件**：`t_tab_bar.dart` → `t_tabs_bar.dart` · `t_tab_bar_view.dart` → `t_tabs_bar_view.dart` · `t_tab_bar_theme_data.dart` → `t_tabs_bar_theme_data.dart`；新增 `tabs_deprecated.dart`；删除或内聚 `t_horizontal_tab_bar.dart`。

**必测**：`TTabsBar` + `TTabsBarView` 联动 · `enabled: false` · `variant` 矩阵 · `physics` · deprecated 别名 · export 收敛。

**Example**：`t_tabs_page.dart` 仅用 `TTabsBar` / `TTabsBarView`（底部示例见 [tab-bar.md](./tab-bar.md)）。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [tab-bar.md](./tab-bar.md) · [tab-upgrade-guide.md](./tab-upgrade-guide.md)（类名以 §1 为准）
