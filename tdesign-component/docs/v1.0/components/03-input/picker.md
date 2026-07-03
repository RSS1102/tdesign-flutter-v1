# TPicker — v1.0 定稿

> **状态**：规划中 | **控制类**：F | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/picker`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 平铺滚轮面板；不内建弹层 |
| Material | 自绘滚轮（参考 `CupertinoPicker`） |
| Theme | `TPickerThemeData` |
| 禁用 | 项级 `disabled` KEEP；整组 `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TPickerThemeData`** |

## 控制方案

控制类 **F**：`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

`TPicker` 底层为**自绘滚轮**（无 Material 同名控件）。样式默认走 `TPickerThemeData`（P1）；禁用态通过 TDesign Token 颜色实现。P0 逃逸舱 → [theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问（**默认无**）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `List<dynamic>?` | L1 | — | 受控各列选中值 |
| ✨ | `onChanged` | `ValueChanged<List<TPickerValue>>?` | L3 | — | 选中值变更（每次滚动都触发） |
| ✨ | `onConfirmed` | `ValueChanged<List<TPickerValue>>?` | L3 | — | 仅最终选中触发 |
| ✨ | `items` | `List<TPickerColumns \| TPickerLinked>` | L2 | — | 数据源 |
| ✨ | `itemBuilder` | `PickerItemBuilder?` | L2 | Theme | 自定义滚轮项渲染 |
| ✨ | `columnBuilder` | `ColumnBuilder?` | L2 | Theme | 自定义列渲染 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TPickerOption` | `value` · `label` · `disabled` | `items` 数据模型 |
| ✨ | `TPickerValue` | `value` · `label` | 选中快照 |
| ✨ | `TPickerColumnData` | `List<TPickerOption>` | 单列数据 |
| ✨ | `TPickerThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `showPicker` | 调用方用 `TPopup.show(child: TPicker(...))` |
| 🚫 | `TPickerController` | 移出 export；命令式改值 → 父 `setState` 改 `value` |
| 🗑️ | `initialValue` | `value`（F 类受控） |
| 🗑️ | `disabled` 参数 | `onChanged: null` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | 回调函数名替换；每次滚动都触发 |
| `initialValue` | `value` | 初值由父 State + `value` 受控 |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `onConfirmed` | 仅最终选中触发 |

### 🔀 合并

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `height` + `itemCount` | Theme 默认 | 迁入 Theme |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `showPicker` | `TPopup.show(child: TPicker(...))` | 调用方组合范式 |
| `TPickerController` | 父 `setState` 改 `value` | 单轨原则 |
| `disabled` | `onChanged: null` | Material 禁用 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TPickerThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `height` | `pickerHeight` | 见 §3 末列 |
| `itemCount` | `visibleItemCount` | 见 §3 末列 |

> 注：`onColumnScrollEnd` 为内部回调，不暴露给用户。

> 子组件内部使用的 `TPicker` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 + P0 `style`（如有） |
| 子树 | `Theme.of(context).mergeExtension(TPickerThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TPickerThemeData` |

### 3.2 覆盖顺序

`实例 P0 style` **>** resolve（全量合并） **>** Token

### 3.3 TPickerThemeData 字段

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `pickerHeight` | 滚轮面板高度 | `height` |
| 📦 | `visibleItemCount` | 可见项数量 | `itemCount` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_picker.dart` — Widget 本体（平铺滚轮面板）
  - `t_picker_resolve.dart` — **唯一**样式合并入口
  - `t_picker_theme_data.dart` — `TPickerThemeData` ThemeExtension

- **底层实现**：自绘滚轮（参考 `CupertinoPicker`）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 选中值变更 | ✅ | `onChanged` 回调正确触发 |
| 项级禁用 | ✅ | `items` 中 `disabled: true` 的项不可选 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| 多列联动 | ✅ | `TPickerLinked` 联动数据源 |
| Form 桥接 | ✅ | `TFormField<List<TPickerValue>>(...)` |

### 4.3 Example 契约

- 覆盖多列/联动数据源
- 提供 Form 桥接示例

---

## 组合范式（TPopup.show）

> `TPicker` 本身为平铺面板、不内建弹层；以下为**调用方组合范式**——将平铺面板用 `TPopup.show` 承载，或以 `Navigator` 推全屏。
> 弹层的确认/取消/关闭由 `TPopup` 的 options 或 Handle 回调处理，不在 `TPicker` 构造器内。

```dart
// 示例：TPopup.show 包裹 TPicker
TPopup.show(
  context: context,
  child: TPicker(
    value: _selectedValues,
    items: pickerItems,
    onChanged: (value) {
      setState(() => _selectedValues = value);
    },
    onConfirmed: (value) {
      // 仅最终选中触发
      setState(() => _selectedValues = value);
      TPopup.of(context)?.close();
    },
  ),
);
```

---

### export

- **保留**：`TPicker`、`TPickerOption`、`TPickerValue`、`TPickerColumnData`、`TPickerThemeData`
- **移出**：`showPicker`、`TPickerController`、`picker_data.dart`、`picker_keys.dart`、`picker_item.dart` 等（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TPickerThemeData` · Material: **自绘滚轮** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` / `onConfirmed` | **F 类 Widget API** | 选中值受控；Form → `TFormField` |
| `items` / `itemBuilder` | **构造器 L2** | 数据源与项渲染 |
| `pickerHeight` / `visibleItemCount` | **`TPickerThemeData`** | 滚轮视窗 L4 |
| `TPickerOption.disabled` | **数据模型** | 行级不可选 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
