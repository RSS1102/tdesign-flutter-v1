# TTimeCounter — v1.0 定稿

> **状态**：规划中 | **控制类**：E | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/time-counter`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 命令式定时器组件 |
| Material | 自绘（Timer 实现） |
| Theme | `TTimeCounterThemeData` |
| 禁用 | 无 Widget 级 bool；命令式由 `controller` 控制 |
| L4 | 构造器 L4 → **`TTimeCounterThemeData`** |

## 控制方案

控制类 **E**：命令式 `controller`（`TTimeCounterController`）为主；`time` 为初始时长，`onChanged` / `onFinish` 为回调通知。无 Widget 级 `disabled`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `controller` | `TTimeCounterController?` | E | — | 命令式控制器（start / pause / reset） |
| | `time` | `int` | L2 | — | 计时时长（毫秒） |
| | `format` | `String?` | L2 | — | 时间格式（如 `mm:ss`） |
| | `content` | `Widget Function(int time)?` | L2 | — | 自定义展示内容 |
| ✨ | `direction` | `TTimeCounterDirection` | L1 | `down` | 计时方向（down / up） |
| ✨ | `autoStart` | `bool` | L1 | `true` | 是否自动开始 |
| | `onChanged` | `ValueChanged<int>?` | L3 | — | tick 回调（剩余毫秒） |
| | `onFinish` | `VoidCallback?` | L3 | — | 完成回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级
> **E** = 控制类 E 专有（controller）

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TTimeCounterDirection` | `down` · `up` | `direction` 参数 |
| ✨ | `TTimeCounterController` | `start()` · `pause()` · `reset()` | 命令式控制 |
| ✨ | `TTimeCounterThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `style` (0.2.x) / `millisecond` / `splitWithUnit` / `theme` (0.2.x) | `TTimeCounterThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | 命名对齐 v1.0 |
| `style` (0.2.x) | `TTimeCounterThemeData` | L4 → Theme |
| `millisecond` | `TTimeCounterThemeData` | L4 → Theme |
| `splitWithUnit` | `TTimeCounterThemeData` | L4 → Theme |
| `theme` (0.2.x) | `TTimeCounterThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TTimeCounterThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `style` (0.2.x) | `style` | 见 §3 末列 |
| `millisecond` | `showMillisecond` | 见 §3 末列 |
| `splitWithUnit` | `splitWithUnit` | 见 §3 末列 |

> 注：Material 无对应控件，样式由 TDesign 自绘。

> 子组件内部使用的 `TTimeCounter` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TTimeCounterThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TTimeCounterThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TTimeCounterThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `style` | 数字块样式枚举 | `style` |
| 📦 | `showMillisecond` | 是否显示毫秒 | `millisecond` |
| 📦 | `splitWithUnit` | 是否带单位分割（如 `01:30:45`） | `splitWithUnit` |
| 📦 | `backgroundColor` | 背景色 | — |
| 📦 | `textColor` | 文字颜色 | — |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_time_counter.dart` — Widget 本体
  - `t_time_counter_controller.dart` — `TTimeCounterController`
  - `t_time_counter_theme_data.dart` — `TTimeCounterThemeData` ThemeExtension

- **底层实现**：自绘数字块 + Timer

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 倒计时 | ✅ | `direction: TTimeCounterDirection.down` |
| 正计时 | ✅ | `direction: TTimeCounterDirection.up` |
| tick 回调 | ✅ | `onChanged` 回调 |
| 完成回调 | ✅ | `onFinish` 回调 |
| 命令式控制 | ✅ | `controller.start()` / `pause()` / `reset()` |

### 4.3 Example 契约

- 覆盖 `direction` 倒计时/正计时
- 覆盖 `format` 时间格式
- 覆盖 `controller` 命令式控制

---

### export

- **保留**：`TTimeCounter`、`TTimeCounterController`、`TTimeCounterDirection`、`TTimeCounterThemeData`
- **移出**：`TTimeCounterStyle`、`t_time_counter_style.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TTimeCounterThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `time` / `format` / `content` | **实例 KEEP** | 倒计时/正计时核心数据 |
| `onChanged` / `onFinish` | **实例 KEEP** | tick 与完成回调 |
| `controller` | **实例 KEEP** | 开始/暂停/重置 |
| `style` / 数字块 L4 / `showMillisecond` / `splitWithUnit` | TDesign **`TTimeCounterThemeData`** | 视觉默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
