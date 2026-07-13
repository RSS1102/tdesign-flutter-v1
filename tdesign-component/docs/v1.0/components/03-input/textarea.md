# TTextarea — v1.0 定稿

> **状态**：规划中 | **控制类**：D | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/textarea`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| Material | TextField multiline |
| Theme | `TInputThemeData`（与 TInput 共用） |
| 禁用 | `enabled: false` / `readOnly: true` |
| L4 | 构造器 L4 → **`TInputThemeData`** |

## 控制方案

控制类 **D**：`controller` 主路径 / `initialValue` 辅（init 一次）；无 `defaultValue`；初值父 State 或 controller。

禁用：`enabled: false`（完全禁用）/ `readOnly: true`（只读可聚焦）。

**主路径**：`TInput.multiline()` 为唯一多行入口；`TTextarea` 仅作语义别名（非独立控制方案）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `controller` | `TextEditingController?` | D | — | 主路径受控（推荐） |
| | `initialValue` | `String?` | D | — | 辅路径（init 一次，与 controller 互斥） |
| | `onChanged` | `ValueChanged<String>?` | L3 | — | 文本变更通知 |
| | `onSubmitted` | `ValueChanged<String>?` | L3 | — | 提交回调 |
| ✨ | `enabled` | `bool` | L1 | `true` | 完全禁用 |
| ✨ | `readOnly` | `bool` | L1 | `false` | 只读可聚焦 |
| ✨ | `label` | `String?` | L2 | — | 标签文案 |
| ✨ | `hintText` | `String?` | L2 | — | 占位提示文案 |
| ✨ | `maxLines` | `int?` | L1 | `null` | 最大行数（null = 无限） |
| ✨ | `maxLength` | `int?` | L1 | — | 最大字数 |
| ✨ | `autofocus` | `bool` | L1 | `false` | 自动聚焦 |
| ✨ | `focusNode` | `FocusNode?` | L1 | — | 焦点管理 |
| ✨ | `decoration` | ` InputDecoration?` | L4 | — | P0 逃逸舱（Material 同名） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级
> **D** = 控制类 D 专有（controller/initialValue/enabled/readOnly）

### 1.2 类型定义

_无（复用 TInput 类型）_

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🗑️ | `TTextareaLayout` | 删除（TInput.multiline() 为主路径） |
| 🗑️ | `textareaDecoration` | `decoration`（P0 逃逸舱） |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TTextareaLayout` | `TInputLayout` | 合并枚举 |
| `textareaDecoration` | `decoration` | 合并进单一 P0 逃逸舱 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

_与 TInput 共用 `TInputThemeData`，无额外迁移_

> 子组件内部使用的 `TTextarea` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

_与 TInput 共用 `TInputThemeData`，见 [input.md §3](./input.md#3-theme-主题配置)_

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_textarea.dart` — Widget 本体（语义别名）
  - 复用 `TInput` 的 resolve 逻辑

- **底层实现**：包装 Material `TextField`（`maxLines: null`）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染（多行） |
| 文本输入 | ✅ | `controller` + `onChanged` |
| 无限行 | ✅ | `maxLines: null` |
| Form 桥接 | ✅ | `TFormField<String>(...)` |

### 4.3 Example 契约

- 推荐使用 `TInput.multiline()`
- `TTextarea` 仅作语义别名

---

### export

- **保留**：`TTextarea`、`TInputThemeData`（与 TInput 共用）、`TFormField`
- **移出**：`TTextareaLayout`、独立 `TTextareaThemeData`（不新建）、`textareaDecoration`（合并进 `decoration`）

---

## 推荐主路径

> `TInput.multiline()` 为唯一多行入口；`TTextarea` 为其别名。

```dart
// 推荐：TInput.multiline()
TInput.multiline(
  controller: _controller,
  hintText: '请输入多行内容',
  maxLines: null,
  onChanged: (value) { ... },
)

// 别名：TTextarea（等价）
TTextarea(
  controller: _controller,
  hintText: '请输入多行内容',
  maxLines: null,
  onChanged: (value) { ... },
)
```

---

## 2. Theme

`TInputThemeData` · Material: **TextField multiline** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `controller` / `initialValue` / `onChanged` / `onSubmitted` | **D 类 Widget API** | 文本受控；Form → `TFormField` |
| `enabled` / `readOnly` / `label` / `hintText` | **D 类 Widget API** | 控制类 D 专有参数 |
| `maxLines` / `maxLength` / `autofocus` / `focusNode` | **D 类 Widget API** | 语义级参数 |
| `decoration` | **P0 逃逸舱** | Material `TextField.decoration` 同名 |
| `InputDecorationTheme` 各字段 | Material **`inputDecorationTheme`** | 边框/背景/hint |
| 多行 `minLines` / `autosize` 默认 | **`TInputThemeData`** | 与 TInput 共用 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
