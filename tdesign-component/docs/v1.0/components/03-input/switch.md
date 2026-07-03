# TSwitch — v1.0 定稿

> **状态**：规划中 | **控制类**：B | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/switch`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | Switch.adaptive |
| Theme | `TSwitchThemeData` |
| 禁用 | `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TSwitchThemeData`** |

## 控制方案

控制类 **B**：`value` + `onChanged`；无 `defaultValue`；初值父 State。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。命令式改值 → 父 `setState` 改 `value`（对齐 Material `Switch`；**无** `TSwitchController`）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `bool` | L1 | — | 受控开关态 |
| | `onChanged` | `ValueChanged<bool>?` | L3 | — | 开关态变更 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TSwitchThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TSwitchController` | 移出 export；B 类仅 `value` + `onChanged` |
| 🗑️ | `isOn` | `value`（B 类受控） |
| 🗑️ | `enable` | `onChanged: null` |
| 🗑️ | `OnSwitchChanged` | `ValueChanged<bool>?` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `isOn` | `value` | 受控统一为 value |
| `enable` | `onChanged: null` | Material 禁用 |
| `OnSwitchChanged` | `ValueChanged<bool>?` | 对齐 Material 回调签名 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TSwitchController` | 父 `setState` 改 `value` | 单轨原则 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TSwitchThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `trackOnColor` | `trackOnColor` | 见 §3 末列 |
| `trackOffColor` | `trackOffColor` | 见 §3 末列 |
| `thumbContentOnColor` | `thumbContentOnColor` | 见 §3 末列 |
| `thumbContentOffColor` | `thumbContentOffColor` | 见 §3 末列 |
| `thumbContentOnFont` | `thumbContentOnFont` | 见 §3 末列 |
| `thumbContentOffFont` | `thumbContentOffFont` | 见 §3 末列 |
| `type` / `TSwitchType` | `TSwitchThemeData.variant` | 枚举化 |

> 注：Material `SwitchThemeData` 的 `trackColor`/`thumbColor`/`overlayColor`/`splashRadius` 由 Material 子主题处理，TDesign 扩展字段在 `TSwitchThemeData` 中。

> 子组件内部使用的 `TSwitch` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TSwitchThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TSwitchThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TSwitchThemeData 字段

> TDesign 扩展字段（Material `SwitchThemeData` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `trackOnColor` | 开启态轨道颜色 | `trackOnColor` |
| 📦 | `trackOffColor` | 关闭态轨道颜色 | `trackOffColor` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_switch.dart` — Widget 本体
  - `t_switch_resolve.dart` — **唯一**样式合并入口
  - `t_switch_theme_data.dart` — `TSwitchThemeData` ThemeExtension

- **底层实现**：包装 Material `Switch.adaptive`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 开关切换 | ✅ | `value: true` / `false` |
| 选中变更 | ✅ | `onChanged` 回调正确触发 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<bool>(...)` |

### 4.3 Example 契约

- 覆盖 `value` 两态（true/false）
- 提供 Form 桥接示例

---

### export

- **保留**：`TSwitch`、`TSwitchThemeData`
- **移出**：`TSwitchType`、`TSwitchSize`、`TSwitchVariant`、`OnSwitchChanged`、`TSwitchController`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSwitchThemeData` · Material: **Switch.adaptive** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` | **B 类 Widget API** | 开关态受控；Form → `TFormField` |
| `trackColor` / `thumbColor` / `overlayColor` / `splashRadius` / `materialTapTargetSize` | Material **`SwitchThemeData`** | 三态（`WidgetStateProperty`） |
| `trackOnColor` / `trackOffColor` | **`TSwitchThemeData`** | TDesign 扩展颜色 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
