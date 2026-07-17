# TSearchBar — v1.0 定稿

> **状态**：已实现 | **控制类**：D | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/search-bar`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| Material | TInput 组合 |
| Theme | `TSearchBarThemeData` |
| 禁用 | `enabled: false` / `readOnly: true` |
| L4 | 构造器 L4 → **`TSearchBarThemeData`** |

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
| ✨ | `hintText` | `String?` | L2 | — | 占位提示文案 |
| ✨ | `needCancel` | `bool` | L1 | `false` | 是否显示取消按钮 |
| ✨ | `cancelText` | `String` | L2 | `'取消'` | 取消按钮文案 |
| ✨ | `onCancelPressed` | `VoidCallback?` | L3 | — | 取消按钮点击 |
| ✨ | `onClearPressed` | `VoidCallback?` | L3 | — | 清除按钮点击 |
| ✨ | `autoFocus` | `bool` | L1 | `false` | 自动聚焦 |
| ✨ | `inputAction` | `TextInputAction` | L1 | `search` | 键盘操作按钮 |
| ✨ | `decoration` | ` InputDecoration?` | L4 | — | P0 逃逸舱（Material 同名） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级
> **D** = 控制类 D 专有（controller/initialValue/enabled/readOnly）

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TSearchBarThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TSearchStyle` | 迁入 `TSearchBarThemeData` |
| 🚫 | `TSearchAlignment` | 迁入 `TSearchBarThemeData` |
| 🗑️ | `placeHolder` | `hintText`（命名对齐 v1.0） |
| 🗑️ | `onTextChanged` | `onChanged` |
| 🗑️ | `onInputClick` | 删除（只读场景用 `readOnly` + `onTap`） |
| 🗑️ | `onTapOutside` | 删除（Material 无此概念） |
| 🗑️ | `onEditComplete` | 删除（Material 无此概念；业务自行监听 FocusNode） |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `placeHolder` | `hintText` | 对齐 Material / TInput |
| `onTextChanged` | `onChanged` | D 类文本通知 |
| `onActionClick` | `onSubmitted` | 命名对齐 v1.0 |
| `TSearchStyle` | `TSearchBarThemeData` | L4 → Theme |
| `TSearchAlignment` | `TSearchBarThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `onInputClick` | `readOnly` + `onTap` | 只读场景 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TSearchBarThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `style` | `variant` | 见 §3 末列 |
| `alignment` | `textAlignment` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `cursorHeight` | `cursorHeight` | 见 §3 末列 |
| `mediumStyle` | `variant` | 见 §3 末列 |
| `autoHeight` | `autoHeight` | 见 §3 末列 |

> 子组件内部使用的 `TSearchBar` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TSearchBarThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TSearchBarThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TSearchBarThemeData 字段

> TDesign 扩展字段（Material 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `variant` | 形态枚举（square/round/medium） | `style` / `mediumStyle` |
| 📦 | `textAlignment` | 文案对齐方式 | `alignment` |
| 📦 | `padding` | 内边距 | `padding` |
| 📦 | `backgroundColor` | 背景色 | `backgroundColor` |
| 📦 | `cursorHeight` | 光标高度 | `cursorHeight` |
| 📦 | `autoHeight` | 自动高度 | `autoHeight` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_search_bar.dart` — Widget 本体
  - `t_search_bar_resolve.dart` — **唯一**样式合并入口
  - `t_search_bar_theme_data.dart` — `TSearchBarThemeData` ThemeExtension

- **底层实现**：包装 Material `TextField`（复用 TInput 逻辑）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 文本输入 | ✅ | `controller` + `onChanged` |
| 取消按钮 | ✅ | `needCancel: true` + `onCancelPressed` |
| 清除按钮 | ✅ | `onClearPressed` 回调 |
| 提交 | ✅ | `onSubmitted` 回调 |
| Form 桥接 | ✅ | `TFormField<String>(...)` |

### 4.3 Example 契约

- 覆盖 `needCancel` 开关
- 覆盖搜索提交流程
- 提供 Form 桥接示例

---

### export

- **保留**：`TSearchBar`、`TSearchBarThemeData`
- **移出**：`TInputController`、`TSearchStyle`、`TSearchAlignment`（迁入 Theme）（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSearchBarThemeData` · Material: **TInput 组合** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `controller` / `initialValue` / `onChanged` / `onSubmitted` | **D 类 Widget API** | 文本受控；Form → `TFormField` |
| `enabled` / `readOnly` / `hintText` / `autoFocus` / `inputAction` | **D 类 Widget API** | 控制类 D 专有参数 |
| `needCancel` / `cancelText` / `onCancelPressed` / `onClearPressed` | **D 类 Widget API** | 搜索条特有交互 |
| 输入区 | 复用 **`TInput` / `TextField`** | `controller`、`hintText`、`onChanged`、`enabled` |
| `variant` / `textAlignment` / `padding` / `backgroundColor` | **`TSearchBarThemeData`** | 搜索条容器样式 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
