# TRate — v1.0 定稿

> **状态**：规划中 | **控制类**：C | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/rate`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘连续值控件 |
| Material | 自绘（无 Material 同名控件） |
| Theme | `TRateThemeData` |
| 禁用 | `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TRateThemeData`** |

## 控制方案

控制类 **C**：`value` + `onChanged`（含 `onChangeStart`/`onChangeEnd`）。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `int` | L1 | — | 受控评分值（1-based） |
| | `onChanged` | `ValueChanged<int>?` | L3 | — | 评分变更（每次拖动都触发） |
| ✨ | `onChangeStart` | `ValueChanged<int>?` | L3 | — | 开始拖动时触发 |
| ✨ | `onChangeEnd` | `ValueChanged<int>?` | L3 | — | 结束拖动时触发 |
| ✨ | `count` | `int` | L1 | `5` | 星数 |
| ✨ | `allowHalf` | `bool` | L1 | `false` | 半星开关 |
| ✨ | `icon` | `Widget Function(bool filled)?` | L2 | Theme | 自定义图标 |
| ✨ | `texts` | `List<String>?` | L2 | — | 各评分对应的文案列表 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

_无（复用基础类型）_

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🗑️ | `onChange` | `onChanged` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | 命名对齐 v1.0 |
| `builderText` | 🗑️ 删除 | 与 `texts` 重叠，业务自行实现 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TRateThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `color` | `starColor` | 见 §3 末列 |
| `gap` | `iconGap` | 见 §3 末列 |
| `showText` | `showText` | 见 §3 末列 |
| `textWidth` | `textWidth` | 见 §3 末列 |

> 子组件内部使用的 `TRate` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TRateThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TRateThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TRateThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `starColor` | 星标颜色 | `color` |
| 📦 | `iconGap` | 图标间距 | `gap` |
| 📦 | `showText` | 是否显示文案 | `showText` |
| 📦 | `textWidth` | 文案宽度 | `textWidth` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_rate.dart` — Widget 本体（自绘连续值控件）
  - `t_rate_resolve.dart` — **唯一**样式合并入口
  - `t_rate_theme_data.dart` — `TRateThemeData` ThemeExtension

- **底层实现**：自绘（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染（5 星） |
| 评分变更 | ✅ | `onChanged` 回调正确触发 |
| 半星模式 | ✅ | `allowHalf: true` |
| 自定义图标 | ✅ | `icon` 参数 |
| 文案显示 | ✅ | `texts` 参数 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<int>(...)` |

### 4.3 Example 契约

- 覆盖 `count` 不同星数
- 覆盖 `allowHalf` 半星模式
- 覆盖 `texts` 文案显示
- 提供 Form 桥接示例

---

### export

- **保留**：`TRate`、`TRateThemeData`
- **移出**：`PlacementEnum`、内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TRateThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` / `onChangeStart` / `onChangeEnd` | **C 类 Widget API** | 评分受控；Form → `TFormField` |
| `count` / `allowHalf` | **构造器 L1** | 星数与半星（语义级） |
| `icon` / `texts` | **构造器 L2** | 图标与文案内容 |
| `starColor` / `iconGap` / `showText` / `textWidth` | **`TRateThemeData`** | TDesign 扩展 L4 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
