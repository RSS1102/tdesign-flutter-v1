# TForm / TFormItem / TFormField — v1.0 定稿

> **状态**：规划中 | **控制类**：—（容器）/ B（字段） | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/form`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `Form` + `FormState` + `FormField` |
| Material | `Form` / `FormState` / `FormField` |
| Theme | `TFormThemeData` |
| 禁用 | 容器无 `disabled`；字段级 `enabled: false` / `readOnly: true` |
| L4 | 构造器 L4 → **`TFormThemeData`** |

## 控制方案

- **TForm**（容器）：无受控 value；按子交互控件控制类处理
- **TFormField\<T\>**（字段）：控制类 B（value + onChanged）；Form 校验 → Material `FormState`

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

#### TForm（表单容器）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `key` | `GlobalKey\<TFormState\>?` | — | — | 表单状态管理 |
| | `autovalidateMode` | `AutovalidateMode` | L1 | `onSubmit` | 校验时机 |
| | `onChanged` | `VoidCallback?` | L3 | — | 任意字段变更时触发 |
| | `onWillPop` | `WillPopCallback?` | L3 | — | 退场回调 |
| ✨ | `showErrorMessage` | `bool` | L1 | `true` | 是否展示错误文案 |
| ✨ | `scrollToFirstError` | `ScrollToFirstError?` | L3 | — | 校验失败后滚动到首个错误 |
| ✨ | `onSubmit` | `ValueChanged\<Map\<String, dynamic\>\>?` | L3 | — | 校验通过后回调 |
| | `child` | `Widget` | L2 | — | 表单内容（`TFormItem` 组合） |

#### TFormItem（表单项布局）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `label` | `String?` | L2 | — | 标签文案 |
| | `labelWidth` | `double?` | L1 | — | 标签宽度（L1 因为是布局约束） |
| | `required` | `bool` | L1 | `false` | 是否必填（视觉标记） |
| | `help` | `String?` | L2 | — | 辅助说明文案 |
| | `extra` | `Widget?` | L2 | — | 额外信息（如字数统计） |
| | `child` | `Widget` | L2 | — | 表单字段容器（`TFormField(...)` 组合入口） |

#### TFormField\<T\>（字段桥接）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `name` | `String` | L1 | — | 字段名（收集时的 key） |
| | `value` | `T?` | B | — | 受控值 |
| | `onChanged` | `ValueChanged\<T\>?` | L3 | — | 值变更 |
| | `validator` | `FormFieldValidator\<T\>?` | L3 | — | 校验函数 |
| | `rules` | `List\<String\>?` | L3 | — | 跨端规则表（编译为 validator） |
| | `enabled` | `bool` | L1 | `true` | 是否启用 |
| | `decoration` | `InputDecoration?` | L4 | — | P0 逃逸舱 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级
> **B** = 控制类 B 专有（TFormField 受控）

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TFormThemeData` | ThemeExtension | §3 主题配置 |
| ✨ | `TFormState` | — | 表单状态管理 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🗑️ | `data` | `TFormField.name` 收集 |
| 🗑️ | `TFormItemType` | `child: TFormField(...)` 组合式 |
| 🗑️ | `btnGroup` | 业务自建 |
| 🗑️ | `preventSubmitDefault` | 删除 |
| 🗑️ | `submitWithWarningMessage` | 删除自研逻辑 |
| 🗑️ | `TFormValidation.check()` | Material `FormState.validate()` |
| 🗑️ | `disabled` | 各字段 `enabled: false` |
| 🗑️ | `formShowErrorMessage` | `showErrorMessage` |
| 🗑️ | `formController` | `controller` |
| 🗑️ | `items` | `child` 组合式 |
| 🗑️ | `labelWidget` | `label` |
| 🗑️ | `formRules` / `itemRule` | `TFormField.rules` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `items` | `child` | 组合式 |
| `formShowErrorMessage` | `showErrorMessage` | 参数重命名 |
| `formController` | `controller` | 参数重命名 |
| `colon` | `TFormThemeData.showColon` | L4 → Theme |
| `labelWidth`（TForm） | `TFormThemeData.labelWidth` | L4 → Theme |
| `isHorizontal` | `layout: TFormLayout` | 命名对齐 v1.0 |
| `labelWidget` | `label` | 参数重命名 |
| `formRules` / `itemRule` | `TFormField.rules` | 迁入子树 |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `TFormField\<T\>` | 字段桥接组件 |
| `TFormController` | `submit()` / `reset()` / 触达 `FormState` |
| `autovalidateMode` | 对齐 Material `Form.autovalidateMode` |
| `scrollToFirstError` | 校验失败后滚动到首个错误项 |

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `data` | `TFormField.name` 收集 | 集中式 Map → 分布式 name |
| `TFormItemType` | `child: TFormField(...)` | 硬编码 → 组合式 |
| `btnGroup` | 业务自建 | 移出 Form |
| `preventSubmitDefault` | 删除 | Material Form 无此概念 |
| `submitWithWarningMessage` | 删除 | 自研逻辑 |
| `TFormValidation.check()` | `FormState.validate()` | Material 校验 |
| `disabled` | 各字段 `enabled: false` | 废弃容器级禁用 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TFormThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `colon` | `showColon` | 见 §3 末列 |
| `labelWidth`（TForm） | `labelWidth` | 见 §3 末列 |

> 子组件内部使用的 `TForm` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TFormThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TFormThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TFormThemeData 字段

> TDesign 扩展字段（Material `Form` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `showColon` | 标签后冒号 | `colon` |
| 📦 | `labelWidth` | 标签宽度 | `labelWidth`（TForm） |
| 📦 | `labelAlign` | 标签对齐 | — |
| 📦 | `itemSpacing` | 项间距 | — |
| 📦 | `errorColor` | 错误色 | — |
| 📦 | `helpColor` | 辅助说明色 | — |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_form.dart` — TForm 容器
  - `t_form_item.dart` — TFormItem 布局
  - `t_form_field.dart` — TFormField 字段桥接
  - `t_form_theme_data.dart` — TFormThemeData ThemeExtension

- **底层实现**：包装 Material `Form` + `FormState` + `FormField`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 表单校验 | ✅ | `FormState.validate()` |
| 字段收集 | ✅ | `TFormField.name` → Map |
| 错误展示 | ✅ | `showErrorMessage: true` |
| 滚动到错误 | ✅ | `scrollToFirstError` |
| Form 桥接 | ✅ | `TFormField` 与各控件配合 |

### 4.3 Example 契约

- 覆盖 `TForm` + `TFormItem` + `TFormField` 完整结构
- 覆盖表单校验流程
- 覆盖字段收集流程

---

## 组合范式

> TForm + TFormItem + TFormField 三位一体；字段级受控由各控件控制类决定。

```dart
// 示例：完整表单结构
TForm(
  key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  showErrorMessage: true,
  onSubmit: (data) {
    // 校验通过后的数据
  },
  child: Column(
    children: [
      TFormItem(
        label: '用户名',
        required: true,
        child: TFormField<String>(
          name: 'username',
          child: TInput(
            controller: _usernameController,
            hintText: '请输入用户名',
          ),
        ),
      ),
      TFormItem(
        label: '密码',
        required: true,
        child: TFormField<String>(
          name: 'password',
          child: TInput(
            inputType: TextInputType.visiblePassword,
            hintText: '请输入密码',
          ),
        ),
      ),
    ],
  ),
)
```

---

### export

- **保留**：`TForm`、`TFormItem`、`TFormField`、`TFormThemeData`、`TFormController`、`TFormState`
- **移出**：`TFormItemType`、`TFormValidation`、内部校验引擎（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TFormThemeData` · Material: **Form + FormState + FormField** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `autovalidateMode` / `FormState` | Material **`Form`** | 校验时机与状态机 |
| `onChanged`（字段级） | Material **`FormField`** | 经子树 `TFormField` 上报 |
| `showErrorMessage` | TDesign 扩展 | 错误展示开关 |
| `scrollToFirstError` | TDesign 扩展 | 滚动到首个错误 |
| `showColon` / `labelWidth` / `labelAlign` | **`TFormThemeData`** | 标签区 L4 |
| `itemSpacing` / `errorColor` / `helpColor` | **`TFormThemeData`** | 布局与颜色 L4 |
| `child` 组合式 | Flutter 组合 | 替代 0.2.x `items` / `TFormItemType` |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [form.md](../foundation/form.md)
