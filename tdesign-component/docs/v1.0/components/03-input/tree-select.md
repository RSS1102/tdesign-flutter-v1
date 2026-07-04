# TTreeSelect — v1.0 定稿

> **状态**：规划中 | **控制类**：F | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/tree`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 平铺多列树形面板；不内建弹层 |
| Material | 自绘多列 |
| Theme | `TTreeSelectThemeData` |
| 禁用 | 项级 `disabled` KEEP；整组 `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TTreeSelectThemeData`** |

## 控制方案

控制类 **F**：`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

`TTreeSelect` 底层为**自绘多列树形**（无 Material 同名控件）。样式默认走 `TTreeSelectThemeData`（P1）；禁用态通过 TDesign Token 颜色实现。P0 逃逸舱 → [theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问（**默认无**）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `options` | `List<TreeSelectOption>` | L2 | — | 树形数据源 |
| | `value` | `dynamic?` | L1 | — | 受控选中项（单选）或 `List<dynamic>?`（多选） |
| ✨ | `onChanged` | `ValueChanged<dynamic>?` | L3 | — | 选中项变更（每次选中都触发） |
| ✨ | `onConfirmed` | `ValueChanged<dynamic>?` | L3 | — | 仅最终选中触发 |
| ✨ | `multiple` | `bool` | L1 | `false` | 单选 / 多选 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TreeSelectOption` | `value` · `label` · `disabled` · `children` | `options` 数据模型 |
| ✨ | `TTreeSelectThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `showTreeSelect` | 调用方用 `TPopup.show(child: TTreeSelect(...))` |
| 🚫 | `TTreeSelectStyle` | 内部实现，不公开 |
| 🗑️ | `defaultValue` | `value`（F 类受控） |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | 回调函数名替换；每次选中都触发 |
| `initialValue` | `value` | 初值由父 State + `value` 受控 |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `onConfirmed` | 仅最终选中触发 |

### 🔀 合并

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| 无 | 无 |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `showTreeSelect` | `TPopup.show(child: TTreeSelect(...))` | 调用方组合范式 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TTreeSelectThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `height` | `columnHeight` | 见 §3 末列 |
| `columnWidth` | `columnWidth` | 见 §3 末列 |
| `style` | `variant` | 见 §3 末列 |
| `outwardCornerRadius` | `panelRadius` | 见 §3 末列 |

> 子组件内部使用的 `TTreeSelect` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TTreeSelectThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TTreeSelectThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TTreeSelectThemeData 字段

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `columnHeight` | 列高度 | `height` |
| 📦 | `columnWidth` | 列宽度 | `columnWidth` |
| 📦 | `panelRadius` | 面板圆角 | `outwardCornerRadius` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_tree_select.dart` — Widget 本体（平铺多列树形面板）
  - `t_tree_select_resolve.dart` — **唯一**样式合并入口
  - `t_tree_select_theme_data.dart` — `TTreeSelectThemeData` ThemeExtension

- **底层实现**：自绘多列树形（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染（单选） |
| 多选模式 | ✅ | `multiple: true` |
| 选中项变更 | ✅ | `onChanged` 回调正确触发 |
| 项级禁用 | ✅ | `options` 中 `disabled: true` 的项不可选 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<dynamic>(...)` |

### 4.3 Example 契约

- 覆盖 `multiple`（单选 / 多选）组合
- 提供 Form 桥接示例

---

## 组合范式（TPopup.show）

> `TTreeSelect` 本身为平铺面板、不内建弹层；以下为**调用方组合范式**——将平铺面板用 `TPopup.show` 承载，或以 `Navigator` 推全屏。
> 弹层的确认/取消/关闭由 `TPopup` 的 options 或 Handle 回调处理，不在 `TTreeSelect` 构造器内。

```dart
// 示例：TPopup.show 包裹 TTreeSelect
TPopup.show(
  context: context,
  child: TTreeSelect(
    options: treeOptions,
    value: _selectedValue,
    multiple: false,
    onChanged: (value) {
      setState(() => _selectedValue = value);
    },
    onConfirmed: (value) {
      // 仅最终选中触发
      setState(() => _selectedValue = value);
      TPopup.of(context)?.close();
    },
  ),
);
```

---

### export

- **保留**：`TTreeSelect`、`TreeSelectOption`、`TTreeSelectThemeData`
- **移出**：`showTreeSelect`、`TTreeSelectStyle` 等（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TTreeSelectThemeData` · Material: **—（自绘多列树形）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `options` / `value` / `multiple` | **F 类 Widget API** | 树形数据与选中受控 |
| `columnHeight` / `columnWidth` / `panelRadius` | **`TTreeSelectThemeData`** | 列布局与面板 L4 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
