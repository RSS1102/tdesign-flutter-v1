# TBackTop — v1.0 定稿

> **状态**：已定稿 | **控制类**：A | **Sprint**：S3 · **Tier T2**  
> **源码**：`lib/src/components/backtop/` · **类名**：`TBackTop`  
> **官网**：[BackTop 返回顶部](https://tdesign.tencent.com/flutter/components/back-top) · [guide](../../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 0.2.x → v1.0](#2-02x--v10)
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

与 [TFab](../01-base/fab.md) 区分：BackTop 专用于滚动回顶。

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | T2 自绘（`GestureDetector` + `Container`） |
| Material | 无等价薄包装 |
| Theme | `TBackTopThemeData`（§3） |
| 禁用 | `onPressed: null` |
| L4 | → `TBackTopThemeData`（§3） |

## 控制方案

控制类 **A**：`onPressed` 动作回调；`null` 禁用。无 `value` / `onChanged`。

→ [controlled.md](../../foundation/controlled.md)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留。`shape` 等 L4 默认走 §3，可实例覆盖。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `controller` | `ScrollController?` | L1 | — | 绑定滚动；有效时点击先回顶 |
| | `showText` | `bool` | L2 | `false` | 是否展示文案（i18n） |
| ✏️ | `onPressed` | `VoidCallback?` | L3 | — | `null` 禁用；未传时回顶后无额外回调 |
| ✨ | `visibilityOffset` | `double?` | L1 | Theme | 偏移 ≥ 阈值才显示 |
| ✨ | `tooltip` | `String?` | L2 | resource 默认 | 无障碍提示；外包 `Tooltip`；见 **tooltip 与无障碍** |
| | `shape` | `TBackTopShape?` | L1 | Theme | 可覆盖 Theme |

**点击行为**：`onPressed == null` 不可点；`controller` 有效则先 `animateTo(0)` 再调 `onPressed`；无 `controller` 仅调 `onPressed`。

#### tooltip 与无障碍

BackTop 默认仅图标（`showText: false`），读屏（VoiceOver / TalkBack）无法从视觉推断用途。v1.0 **始终**外包 Flutter `Tooltip`，`tooltip` 提供控件语义名称（0.2.x 无此能力）。

| 场景 | 行为 |
|------|------|
| 传入 `tooltip` | 作为 `Tooltip.message`；桌面/Web 悬停、移动端长按显示提示；读屏聚焦时朗读 |
| 未传 | 回退 `context.resource` 组合文案（中文：「返回顶部」） |
| `onPressed: null`（禁用） | 仍保留 `Tooltip`；读屏可获知按钮用途，点击区 `onTap` 为 `null` |

与 `showText` 区别：`showText` 控制按钮上**可见**文案；`tooltip` 为**不可见**语义提示，二者独立——`showText: false` 时界面仍简洁，读屏用户仍可通过 `tooltip` 理解按钮。

与 [TFab](../01-base/fab.md) 差异：Fab 拆分 `tooltip`（悬停提示）与 `semanticLabel`（读屏标签）；BackTop 以 `tooltip` 统一承担（纯图标回顶场景足够）。

### 1.2 类型定义

| 决策 | 类型 | 说明 |
|------|------|------|
| ✏️ | `TBackTopShape` | `circle` · `halfCircle`（原 `TBackTopStyle`） |
| ✨ | `TBackTopThemeData` | ThemeExtension（§3） |

### 1.3 export

**KEEP**：`TBackTop` · `TBackTopShape` · `TBackTopThemeData`。  
**不 export**：内部定位辅助（可与 Fab 共用，不公开）· 0.2.x `TBackTopTheme` / `TBackTopColorScheme`（明/暗配色改由 `ThemeData.brightness` 驱动，见 §3）。

---

## §2 0.2.x → v1.0

**未改**（§1 无图例项）：`controller` · `showText` · `shape`（语义保留，枚举改名见下）

| 从 | 到 |
|---|---|
| `onClick` | `onPressed` |
| `style` / `TBackTopStyle` | Theme `shape` / `TBackTopShape` |
| `theme` / `TBackTopTheme` | **删除**；明/暗配色跟随 `ThemeData.brightness` + Token（§3） |
| 页面 `ScrollController.addListener` 控显隐 | `visibilityOffset` 内置监听 |
| —（无无障碍） | `tooltip`（✨ 外包 `Tooltip` + resource 默认）· `TBackTopThemeData`（✨） |

---

## §3 Theme 主题配置

`TBackTopThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 `shape` / `visibilityOffset` |
| 子树 | `Theme.of(context).mergeExtension(TBackTopThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TBackTopThemeData` |

覆盖：构造器 L1 **>** Theme **>** Token。

**配色**：不暴露 `colorScheme` / `theme` 构造器或 Theme 字段；背景/边框/文字色由 `Theme.of(context).brightness` 选 Token（亮模式灰阶浅底，暗模式灰阶深底）。

| 决策 | 字段 | 管什么 | 0.2.x 来源 |
|------|------|--------|-----------|
| 📦 | `shape` | 外形 | `style` |
| ✨ | `defaultVisibilityOffset` | 显隐阈值 | demo 硬编码 100 |
| ✨ | `defaultRight` / `defaultBottom` | 定位 | — |
| ✨ | `halfCircleRightInset` | 半圆贴边 | 0.2 `Positioned(right: -16)` |

---

## §4 实现约定 · 测试与 Example 契约

**文件**：`t_backtop.dart` · `t_backtop_theme_data.dart` · `t_backtop_visibility.dart`（可选）。

**必测**：`onPressed: null` · `shape` 两态 · `showText` · `brightness` 配色 · `visibilityOffset` · `tooltip`（自定义 / resource 默认 / 禁用时仍可用）· 回顶防抖 · Theme 子树。

**Example**：内置显隐为主路径；`halfCircle` 贴边示例；与 Fab 同页区分用途。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [fab.md](../01-base/fab.md) · [backtop-upgrade-guide.md](./backtop-upgrade-guide.md)
