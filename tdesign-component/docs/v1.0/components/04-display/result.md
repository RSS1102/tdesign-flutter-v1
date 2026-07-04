# TResult — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/result`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘结果页组件 |
| Material | 自绘（无 Material 同名控件） |
| Theme | `TResultThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TResultThemeData`** |

## 控制方案

控制类 **A**：`onTap`；**不提供** `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `icon` | `Widget?` | L2 | — | 结果图标 |
| | `title` | `String?` | L2 | — | 标题文案 |
| | `subtitle` | `String?` | L2 | — | 副标题文案（原 `description`） |
| ✨ | `variant` | `TResultVariant` | L1 | `default` | 形态（default / success / warning / error） |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TResultVariant` | `default` · `success` · `warning` · `error` | `variant` 参数 |
| ✨ | `TResultThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🗑️ | `TResultTheme` | `variant` 参数 |
| 📦 | `titleStyle` | `TResultThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TResultTheme` | `variant` | 枚举化 |
| `description` | `subtitle` | 命名对齐 v1.0 |
| `titleStyle` | `TResultThemeData` | L4 → Theme |
| `theme` | `variant` | 命名对齐 v1.0 |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `TResultVariant` | 形态枚举 |
| `variant` | 由 `theme` 迁移 |

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TResultTheme` | `TResultVariant` | 枚举化 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TResultThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `titleStyle` | `titleStyle` | 见 §3 末列 |

> 注：Material `Result` 无对应控件，样式由 TDesign 自绘。

> 子组件内部使用的 `TResult` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TResultThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TResultThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TResultThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `titleStyle` | 标题文字样式 | `titleStyle` |
| 📦 | `iconColor` | 图标颜色映射 | — |
| 📦 | `backgroundColor` | 背景色映射 | — |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_result.dart` — Widget 本体
  - `t_result_resolve.dart` — **唯一**样式合并入口
  - `t_result_theme_data.dart` — `TResultThemeData` ThemeExtension

- **底层实现**：自绘结果页组件（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 形态切换 | ✅ | `variant: TResultVariant.success` |
| 标题样式 | ✅ | `titleStyle` |

### 4.3 Example 契约

- 覆盖 `variant` 各形态
- 覆盖 `icon` / `title` / `subtitle` 内容

---

### export

- **保留**：`TResult`、`TResultVariant`、`TResultThemeData`
- **移出**：`TResultTheme`（enum）、构造器 `titleStyle` 等 L4 Style（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TResultThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `icon` / `title` / `subtitle` | **实例 KEEP** | 结果内容 |
| `variant` | **实例** | 默认图标/语义色映射 |
| `titleStyle` | TDesign **`TResultThemeData`** | 标题 L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
