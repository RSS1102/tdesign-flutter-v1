# TInput — v1.0 定稿

> **状态**：规划中 | **控制类**：D | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/input`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| Material | TextField |
| Theme | `TInputThemeData` |
| 禁用 | `enabled: false` / `readOnly: true` |
| L4 | 构造器 L4 → **`TInputThemeData`** |

## 控制方案

控制类 **D**：`controller` 主路径 / `initialValue` 辅（init 一次）；无 `defaultValue`；初值父 State 或 controller。

禁用：`enabled: false`（完全禁用）/ `readOnly: true`（只读可聚焦）。

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
| ✨ | `prefix` | `Widget?` | L2 | — | 前缀 Widget |
| ✨ | `suffix` | `Widget?` | L2 | — | 后缀 Widget |
| ✨ | `maxLines` | `int?` | L1 | `1` | 最大行数 |
| ✨ | `maxLength` | `int?` | L1 | — | 最大字数 |
| ✨ | `autofocus` | `bool` | L1 | `false` | 自动聚焦 |
| ✨ | `focusNode` | `FocusNode?` | L1 | — | 焦点管理 |
| ✨ | `inputType` | `TextInputType` | L1 | `text` | 键盘类型 |
| ✨ | `textAlign` | `TextAlign` | L1 | `left` | 对齐方式 |
| ✨ | `decoration` | `InputDecoration?` | L4 | — | P0 逃逸舱（Material 同名） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级
> **D** = 控制类 D 专有（controller/initialValue/enabled/readOnly）

### 1.2 类型定义

_无（复用 Material 类型）_

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TInputStyle` | 内部实现，不公开 |
| 🚫 | `TCardStyle` | 迁入 `TInputThemeData` |
| 🗑️ | `leftLabel` | `label`（命名对齐 v1.0） |
| 🗑️ | `leftIcon` | `prefix`（命名对齐 v1.0） |
| 🗑️ | `type` | `decoration`（通过 P0 逃逸舱实现） |
| 🗑️ | `cardStyle` | `TInputThemeData` |
| 🗑️ | `rightWidget` | `suffix`（命名对齐 v1.0） |
| 🗑️ | `layout` | `decoration`（通过 P0 逃逸舱实现） |
| 🗑️ | `obscureText` | `TextInputType.visiblePassword` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TInputType` | `TInputLayout` | 命名对齐 v1.0 |
| `leftLabel` | `label` | 命名对齐 v1.0 |
| `leftIcon` | `prefix` | 命名对齐 v1.0 |
| `type` | `layout` | 命名对齐 v1.0 |
| `cardStyle` | `TInputThemeData` | L4 → Theme |
| `rightWidget` | `suffix` | 命名对齐 v1.0 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `leftLabelSpace` | `TInputThemeData` | 间距合并 |
| `leftContentSpace` | `TInputThemeData` | 间距合并 |
| `clearIconSize` | `TInputThemeData` | 迁入 Theme |
| `needClear` | `TInputThemeData.showClearButton` | 默认值 |
| `spacer` | 删除 | 与 `contentPadding` 重复 |

### 📦 迁入 Theme

_无（所有 L4 参数通过 `decoration` P0 逃逸舱实现）_

> 注：Material `InputDecorationTheme` 的 `border`/`enabledBorder`/`errorBorder`/`focusedBorder`/`disabledBorder`/`fillColor`/`filled`/`contentPadding`/`isDense`/`hintStyle`/`labelStyle`/`helperStyle`/`errorStyle`/`prefixIconColor`/`suffixIconColor`/`iconColor` 由 Material 子主题处理，TDesign 扩展字段在 `TInputThemeData` 中。

> 子组件内部使用的 `TInput` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TInputThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TInputThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TInputThemeData 字段

_无（所有 L4 参数通过 `decoration` P0 逃逸舱实现）_

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_input.dart` — Widget 本体
  - `t_input_resolve.dart` — **唯一**样式合并入口
  - `t_input_theme_data.dart` — `TInputThemeData` ThemeExtension

- **底层实现**：包装 Material `TextField`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 文本输入 | ✅ | `controller` + `onChanged` |
| 提交 | ✅ | `onSubmitted` 回调 |
| 密码模式 | ✅ | `TextInputType.visiblePassword` |
| 只读模式 | ✅ | `readOnly: true` |
| 禁用模式 | ✅ | `enabled: false` |
| Form 桥接 | ✅ | `TFormField<String>(...)` |

### 4.3 Example 契约

- 覆盖 `TextInputType.visiblePassword` 密码模式
- 提供 Form 桥接示例

---

### 1.1 构造器参数（续）

#### TInput.multiline() — 多行 factory

> 推荐的多行输入入口；底层复用 `TextField` `maxLines: null`。

```dart
TInput.multiline(
  controller: _controller,
  hintText: '请输入多行内容',
  maxLines: null,
  onChanged: (value) { ... },
)
```

---

### export

- **保留**：`TInput`、`TInputThemeData`、`TInput.multiline()`、`TFormField`
- **移出**：`TInputController`、`TInputLayout`、`TInputStyle` / `TCardStyle`、内部 `input_view.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TInputThemeData` · Material: **TextField** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `controller` / `initialValue` / `onChanged` / `onSubmitted` | **D 类 Widget API** | 文本受控；Form → `TFormField` |
| `enabled` / `readOnly` / `label` / `hintText` / `prefix` / `suffix` | **D 类 Widget API** | 控制类 D 专有参数 |
| `maxLines` / `maxLength` / `autofocus` / `focusNode` / `inputType` / `textAlign` | **D 类 Widget API** | 语义级参数 |
| `decoration` | **P0 逃逸舱** | Material `TextField.decoration` 同名（四问①通过） |
| `border` / `enabledBorder` / `errorBorder` / `focusedBorder` / `disabledBorder` | Material **`InputDecorationTheme`** | 边框三态 |
| `fillColor` / `filled` / `contentPadding` / `isDense` | Material **`InputDecorationTheme`** | 背景与内边距 |
| `hintStyle` / `labelStyle` / `helperStyle` / `errorStyle` | Material **`InputDecorationTheme`** | 文案样式 |
| `prefixIconColor` / `suffixIconColor` / `iconColor` | Material **`InputDecorationTheme`** | 图标色 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
