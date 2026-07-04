# TEmpty — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/empty`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘空态组件 |
| Material | 自绘（无 Material 同名控件） |
| Theme | `TEmptyThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TEmptyThemeData`** |

## 控制方案

控制类 **A**：`onTap`；**不提供** `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `image` | `Widget?` | L2 | — | 自定义插图（图标或图片 Widget，替代默认插图） |
| | `title` | `String?` | L2 | — | 主文案（原 `emptyText`） |
| ✨ | `variant` | `TEmptyVariant` | L1 | `plain` | 形态（plain / operation） |
| | `operation` | `Widget?` | L2 | — | 操作区（原 `customOperationWidget` / `operationText`） |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TEmptyVariant` | `plain` · `operation` | `variant` 参数 |
| ✨ | `TEmptyThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🗑️ | `TEmptyType` | `variant` 参数 |
| 🗑️ | `TTapEvent` | `VoidCallback? onTap` |
| 📦 | `emptyTextColor` / `emptyTextFont` / `operationTheme` | `TEmptyThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TEmptyType` | `variant` | 枚举化 |
| `onTapEvent` | `onTap` | 命名对齐 v1.0 |
| `type` | `variant` | 命名对齐 v1.0 |
| `operationText` / `customOperationWidget` | `operation` | 单槽 |
| `emptyTextColor` | `TEmptyThemeData` | L4 → Theme |
| `emptyTextFont` | `TEmptyThemeData` | L4 → Theme |
| `operationTheme` | `TEmptyThemeData` | L4 → Theme |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `TEmptyVariant` | 形态枚举 |
| `variant` | 由 `type` 迁移 |
| `onTap` | 由 `onTapEvent` 迁移 |

### 🔀 合并

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `icon` | `image` | 单插图槽：图标/图片统一用 `image`（`Widget?`）表达 |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TEmptyType` | `TEmptyVariant` | 枚举化 |
| `TTapEvent` | `VoidCallback?` | 废弃 typedef |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TEmptyThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `emptyTextColor` | `textColor` | 见 §3 末列 |
| `emptyTextFont` | `textFont` | 见 §3 末列 |
| `operationTheme` | `operationTheme` | 见 §3 末列 |

> 注：Material `Empty` 无对应控件，样式由 TDesign 自绘。

> 子组件内部使用的 `TEmpty` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TEmptyThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TEmptyThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TEmptyThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `textColor` | 文案颜色 | `emptyTextColor` |
| 📦 | `textFont` | 文案字体 | `emptyTextFont` |
| 📦 | `operationTheme` | 操作区样式 | `operationTheme` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_empty.dart` — Widget 本体
  - `t_empty_resolve.dart` — **唯一**样式合并入口
  - `t_empty_theme_data.dart` — `TEmptyThemeData` ThemeExtension

- **底层实现**：自绘空态组件（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 形态切换 | ✅ | `variant: TEmptyVariant.operation` |
| 自定义插图 | ✅ | `image` 参数 |
| 操作区 | ✅ | `operation` 参数 |

### 4.3 Example 契约

- 覆盖 `variant` 形态切换
- 覆盖 `image` 自定义插图
- 覆盖 `operation` 操作区

---

### export

- **保留**：`TEmpty`、`TEmptyVariant`、`TEmptyThemeData`
- **移出**：`TEmptyType`（改名 `TEmptyVariant`）、`TTapEvent`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TEmptyThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| 文案 / 插图 / 操作区 | **实例 KEEP** | 业务空态内容 |
| `onTap` | Material **Button** 惯例 | 内置操作按钮禁用 |
| 文案色/字号/默认按钮配色 | TDesign **`TEmptyThemeData`** | L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
