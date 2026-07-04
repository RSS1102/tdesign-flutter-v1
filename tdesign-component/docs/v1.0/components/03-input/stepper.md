# TStepper — v1.0 定稿

> **状态**：规划中 | **控制类**：C | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/stepper`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | IconButton + TextField |
| Theme | `TStepperThemeData` |
| 禁用 | `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TStepperThemeData`** |

## 控制方案

控制类 **C**：`value` + `onChanged`（含 `onChangeStart`/`onChangeEnd`）。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `num` | L1 | — | 受控数值 |
| | `onChanged` | `ValueChanged<num>?` | L3 | — | 数值变更 |
| ✨ | `min` | `num` | L1 | `0` | 最小值 |
| ✨ | `max` | `num` | L1 | `100` | 最大值 |
| ✨ | `step` | `num` | L1 | `1` | 步长 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TStepperVariant` | `normal` · `filled` | `variant` 参数 |
| ✨ | `TStepperThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TStepperTheme` | 枚举迁入 `TStepperThemeData.variant` |
| 🗑️ | `defaultValue` | `value`（C 类受控） |
| 🗑️ | `disabled` | `onChanged: null` |
| 🗑️ | `onChange` | `onChanged` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | C 类受控 |
| `TStepperTheme` | `TStepperThemeData.variant` | 枚举化 |
| `theme` | `TStepperThemeData.variant` | 枚举化 |
| `disabled` | `onChanged: null` | Material 禁用 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `defaultValue` | 父 State 持有 `value` | 初值由父 State |
| `disabled` | `onChanged: null` | Material 禁用 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TStepperThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `inputWidth` | `inputWidth` | 见 §3 末列 |
| `colorScheme` | `variant` | 见 §3 末列 |

> 注：Material `InputDecorationTheme` / `IconButtonTheme` 的样式由 Material 子主题处理，TDesign 扩展字段在 `TStepperThemeData` 中。

> 子组件内部使用的 `TStepper` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TStepperThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TStepperThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TStepperThemeData 字段

> TDesign 扩展字段（Material 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `variant` | 形态/配色枚举（normal / filled） | `colorScheme` / `theme` / `TStepperTheme` |
| 📦 | `inputWidth` | 输入框宽度 | `inputWidth` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_stepper.dart` — Widget 本体
  - `t_stepper_resolve.dart` — **唯一**样式合并入口
  - `t_stepper_theme_data.dart` — `TStepperThemeData` ThemeExtension

- **底层实现**：包装 Material `IconButton` + `TextField`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 数值变更 | ✅ | `onChanged` 回调正确触发 |
| 边界限制 | ✅ | `min` / `max` 边界 |
| 步长控制 | ✅ | `step` 步进 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<num>(...)` |

### 4.3 Example 契约

- 覆盖 `min`/`max`/`step` 边界
- 提供 Form 桥接示例

---

### export

- **保留**：`TStepper`、`TStepperThemeData`、`TStepperVariant`
- **移出**：`TStepperSize`、`TStepperOverlimitType`、`TStepperTheme`（enum）、`defaultValue`/`disabled` 废弃参数相关 export（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TStepperThemeData` · Material: **IconButton + TextField** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | **C 类 Widget API** | 数值受控；Form → `TFormField` |
| `min` / `max` / `step` | **构造器 L1** | 数值边界与步进（语义级） |
| 按钮区 | Material **`IconButtonTheme`** | +/- 图标按钮 |
| 输入区 | Material **`InputDecorationTheme`** | 中间数字框 |
| `inputWidth` | **`TStepperThemeData`** | TDesign 扩展布局 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
