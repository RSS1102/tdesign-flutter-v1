# TBadge — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/badge`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | Badge M3 |
| Theme | `TBadgeThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TBadgeThemeData`** |

## 控制方案

控制类 **A**：`onTap`；**不提供** `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `count` | `int` | L2 | — | 红点数量 |
| | `maxCount` | `int?` | L2 | — | 最大显示数量（超出显示 `99+`） |
| ✨ | `variant` | `TBadgeVariant` | L1 | `normal` | 形态（normal / small / dot），同时控制尺寸 |
| ✨ | `border` | `bool` | L1 | `false` | 是否显示边框 |
| ✨ | `showZero` | `bool` | L1 | `true` | 是否显示 0 |
| | `child` | `Widget` | L2 | — | 被包裹的内容 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TBadgeVariant` | `normal` · `small` · `dot` | `variant` 参数（同时控制形态和尺寸） |
| ✨ | `TBadgeThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TBadgeType` | `variant` 参数 |
| 🗑️ | `TBadgeSize` | `variant` 参数（同时控制形态和尺寸） |
| 📦 | `border` (0.2.x) / `color` / `textColor` / `message` / `widthLarge` / `widthSmall` / `padding` / `showZero` (0.2.x) | `TBadgeThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TBadgeType` | `variant` | 枚举化 |
| `variant` | `variant` | v1.0 语义形态 |
| `border` (0.2.x) | `border` | 参数保留 |
| `color` | `TBadgeThemeData` | L4 → Theme |
| `textColor` | `TBadgeThemeData` | L4 → Theme |
| `message` | `TBadgeThemeData` | L4 → Theme |
| `widthLarge` | `TBadgeThemeData` | L4 → Theme |
| `widthSmall` | `TBadgeThemeData` | L4 → Theme |
| `padding` | `TBadgeThemeData` | L4 → Theme |
| `showZero` (0.2.x) | `showZero` | 参数保留 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 原因 |
|------------|------|
| `size` | 与 `variant` 语义重叠，删除；用 `variant` 控制形态和尺寸 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TBadgeThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `color` | `backgroundColor` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `message` | `message` | 见 §3 末列 |
| `widthLarge` | `largeWidth` | 见 §3 末列 |
| `widthSmall` | `smallWidth` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `showZero` (0.2.x) | `showZero` | 见 §3 末列 |

> 注：Material `BadgeTheme` 的 `backgroundColor`/`textColor`/`padding`/`alignment` 由 Material 子主题处理，TDesign 扩展字段在 `TBadgeThemeData` 中。

> 子组件内部使用的 `TBadge` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TBadgeThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TBadgeThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TBadgeThemeData 字段

> TDesign 扩展字段（Material `BadgeTheme` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `backgroundColor` | 底色 | `color` |
| 📦 | `textColor` | 文字色 | `textColor` |
| 📦 | `message` | 消息文案（如 `new`） | `message` |
| 📦 | `largeWidth` | 大尺寸宽度 | `widthLarge` |
| 📦 | `smallWidth` | 小尺寸宽度 | `widthSmall` |
| 📦 | `padding` | 内边距 | `padding` |
| 📦 | `showZero` | 是否显示 0 默认值 | `showZero` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_badge.dart` — Widget 本体
  - `t_badge_resolve.dart` — **唯一**样式合并入口
  - `t_badge_theme_data.dart` — `TBadgeThemeData` ThemeExtension

- **底层实现**：包装 Material `Badge` M3

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 数字红点 | ✅ | `count` 参数 |
| 最大值 | ✅ | `maxCount` 超出显示 |
| 形态切换 | ✅ | `variant: TBadgeVariant.dot` |
| 点击交互 | ✅ | `onTap` 回调 |

### 4.3 Example 契约

- 覆盖 `count` 数字红点
- 覆盖 `variant` 形态切换
- 覆盖 `maxCount` 最大值

---

### export

- **保留**：`TBadge`、`TBadgeVariant`、`TBadgeThemeData`
- **移出**：`TBadgeSize`、内部 `*Style`、绘制 helper（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TBadgeThemeData` · Material: **Badge M3** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundColor` / `textColor` / `padding` / `alignment` | Material **`BadgeTheme`**（或组件默认） | 徽标底色与文案 |
| `variant` | TDesign **`TBadgeThemeData`** | 原 `TBadgeType` / `type` |
| `border` / `largeWidth` / `smallWidth` / `showZero` / `message` | TDesign 扩展 | Material Badge 无独立 border/双宽度语义 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
