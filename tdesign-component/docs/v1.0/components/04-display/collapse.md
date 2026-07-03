# TCollapse — v1.0 定稿

> **状态**：规划中 | **控制类**：B（手风琴模式）/ C（多开模式） | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/collapse`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | ExpansionPanelList / ExpansionPanel |
| Theme | `TCollapseThemeData` |
| 禁用 | 容器无统一 bool；面板级由 `onExpansionChanged` 回调控制 |
| L4 | 构造器 L4 → **`TCollapseThemeData`** |

## 控制方案

- **手风琴模式**（`mode: TCollapseMode.accordion`）：控制类 **B**，`value` 表示当前展开的 panel，`onChanged` 回调
- **多开模式**（`mode: TCollapseMode.multiple`）：控制类 **C**，`onExpansionChanged` 回调 `(index, isExpanded)`

> 注：Material `ExpansionPanel` 无受控 value，展开状态由 `isExpanded` 参数控制；v1.0 手风琴模式提供 `value` + `onChanged` 简化受控。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| ✨ | `mode` | `TCollapseMode` | L1 | `multiple` | 展开模式（accordion / multiple） |
| ✨ | `value` | `Object?` | L1 | — | 手风琴模式下当前展开 panel 的 value |
| | `children` | `List<TCollapsePanel>` | L2 | — | 面板列表 |
| | `animationDuration` | `Duration?` | L1 | — | 动画时长 |
| | `elevation` | `double?` | L1 | — | 阴影高度 |
| | `onExpansionChanged` | `ExpansionPanelCallback?` | L3 | — | 多开模式展开回调 `(index, isExpanded)` |
| | `onChanged` | `ValueChanged<Object?>?` | L3 | — | 手风琴模式受控回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 TCollapsePanel 参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `Object?` | L1 | — | 面板唯一标识（手风琴模式必填） |
| | `header` | `Widget?` | L2 | — | 标题区（Material `ExpansionPanel.headerBuilder`） |
| | `body` | `Widget?` | L2 | — | 内容区（Material `ExpansionPanel.body`） |
| | `isExpanded` | `bool` | L1 | `false` | 是否展开（多开模式） |
| | `canTapOnHeader` | `bool` | L1 | `true` | 标题是否可点击 |
| | `expandIconTextBuilder` | `Widget? Function(bool isExpanded)?` | L2 | — | 展开图标旁说明文案 |

### 1.3 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TCollapseMode` | `accordion` · `multiple` | `mode` 参数 |
| ✨ | `TCollapsePanel` | Widget | `children` 数据模型 |
| ✨ | `TCollapseThemeData` | ThemeExtension | §3 主题配置 |

### 1.4 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TCollapseStyle` | `TCollapseThemeData.style` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TCollapseStyle` | `TCollapseThemeData.style` | L4 → Theme |
| `style` | `TCollapseThemeData` | L4 → Theme |
| `expansionCallback` | `onExpansionChanged` | 对齐 Material |
| `initialOpenPanelValue` | `value` | 命名对齐 v1.0 |
| `backgroundColor` | `TCollapseThemeData` | L4 → Theme |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `TCollapseMode` | 展开模式枚举 |
| `mode` | 展开模式参数 |
| `onChanged` | 手风琴模式受控回调 |

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TCollapseThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `TCollapseStyle` | `style` | 见 §3 末列 |
| `style` | `style` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |

> 注：Material `ExpansionPanelList` 的 `animationDuration`/`elevation`/`expansionCallback` 与 Flutter 同名，**KEEP** 构造器。

> 子组件内部使用的 `TCollapse` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TCollapseThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TCollapseThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TCollapseThemeData 字段

> TDesign 扩展字段（Material `ExpansionPanelList` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `style` | 面板样式（block / card） | `TCollapseStyle` |
| 📦 | `backgroundColor` | 默认面板背景 | `backgroundColor` |
| 📦 | `expandIconTextBuilder` | 展开按钮旁文案 | — |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_collapse.dart` — Widget 本体
  - `t_collapse_resolve.dart` — **唯一**样式合并入口
  - `t_collapse_theme_data.dart` — `TCollapseThemeData` ThemeExtension

- **底层实现**：包装 Material `ExpansionPanelList` / `ExpansionPanel`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 多开模式 | ✅ | `mode: TCollapseMode.multiple` |
| 手风琴模式 | ✅ | `mode: TCollapseMode.accordion` + `value` + `onChanged` |
| 面板展开 | ✅ | `onExpansionChanged` 回调 |

### 4.3 Example 契约

- 覆盖 `mode` 多开/手风琴模式切换
- 覆盖 `value` + `onChanged` 手风琴受控
- 覆盖 `onExpansionChanged` 多开回调

---

### export

- **保留**：`TCollapse`、`TCollapsePanel`、`TCollapseMode`、`TCollapseThemeData`
- **移出**：`TCollapseStyle`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCollapseThemeData` · Material: **ExpansionPanelList / ExpansionPanel** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `children` | Material **`ExpansionPanelList`** | `List<ExpansionPanel>` → `TCollapsePanel` |
| `onExpansionChanged` | Material **`expansionCallback`** | `(int index, bool isExpanded)` |
| `animationDuration` / `elevation` | Material **`ExpansionPanelList`** | 实例 KEEP |
| `headerBuilder` / `body` / `isExpanded` | Material **`ExpansionPanel`** | 面板结构 |
| `value`（Panel） | Material **`ExpansionPanel.value`** | 手风琴模式必填且互异 |
| `value`（Collapse 手风琴） | **受控扩展** | 当前展开 panel 的 `value` |
| `style`（block/card） | TDesign **`TCollapseThemeData`** | Material 无 block/card 语义 |
| `expandIconTextBuilder` | TDesign 扩展 | 展开按钮旁文案 |
| `backgroundColor` | TDesign **`TCollapseThemeData`** | 默认面板背景 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
