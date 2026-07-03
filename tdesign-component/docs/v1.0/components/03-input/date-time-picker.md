# TDateTimePicker — v1.0 定稿

> **状态**：规划中 | **控制类**：F | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/date-time-picker`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 平铺滚轮面板；底层复用 `TPicker` 能力；不内建弹层 |
| Material | Cupertino/Material 滚轮对照 |
| Theme | `TPickerThemeData`（与 TPicker 共用） |
| 禁用 | 项级 `disabled` KEEP；整组 `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | mode/start/end/steps 等 → **`TPickerThemeData`** |

## 控制方案

控制类 **F**：`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

`TDateTimePicker` 底层复用 `TPicker` 能力，专注于日期时间列的渲染。样式默认走 `TPickerThemeData`（P1）；禁用态通过 TDesign Token 颜色实现。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `DateTime \| TDateTimePickerValue?` | L1 | — | 受控选中时刻 |
| ✨ | `onChanged` | `ValueChanged<DateTime>?` | L3 | — | 选中时刻变更（每次滚动都触发） |
| ✨ | `onConfirmed` | `ValueChanged<DateTime>?` | L3 | — | 仅最终选中触发 |
| ✨ | `mode` | `DateTimePickerMode` | L1 | `date` | 日期/时间/日期时间 |
| ✨ | `showWeek` | `bool` | L1 | `false` | 是否显示星期列 |
| ✨ | `minDate` | `DateTime?` | L2 | — | 最小可选日期 |
| ✨ | `maxDate` | `DateTime?` | L2 | — | 最大可选日期 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `DateTimePickerMode` | `date` · `time` · `dateTime` | `mode` 参数 |
| ✨ | `TDateTimePickerValue` | 选中快照 | `value` 参数 |
| 🔄 | `TPickerThemeData` | ThemeExtension | 与 TPicker 共用 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `showDateTimePicker` | 调用方用 `TPopup.show(child: TDateTimePicker(...))` |
| 🗑️ | `initialValue` | `value`（F 类受控） |

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
| `start` / `end` | `minDate` / `maxDate` | 参数重命名 |
| `renderLabel` | Theme `columnLabelBuilder` | 迁入 Theme |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `showDateTimePicker` | `TPopup.show(child: TDateTimePicker(...))` | 调用方组合范式 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TPickerThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `renderLabel` | `columnLabelBuilder` | 见 §3 末列 |

> 注：`mode`、`showWeek`、`minDate`/`maxDate` 为语义级/数据级参数，保留在构造器 L1/L2。
> `steps`（步进）为内部逻辑，不暴露给用户。

> 子组件内部使用的 `TDateTimePicker` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TPickerThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TPickerThemeData` |

### 3.2 覆盖顺序

`实例 P0 style` **>** resolve（全量合并） **>** Token

### 3.3 TPickerThemeData 字段

> 与 `TPicker` 共用 `TPickerThemeData`，日期时间特有字段：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `columnLabelBuilder` | 列标签自定义渲染 | `renderLabel` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_date_time_picker.dart` — Widget 本体（平铺滚轮面板）
  - 复用 `TPicker` 的滚轮渲染能力

- **底层实现**：自绘滚轮（参考 `CupertinoPicker`）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染（date 模式） |
| time 模式 | ✅ | `mode: DateTimePickerMode.time` |
| dateTime 模式 | ✅ | `mode: DateTimePickerMode.dateTime` |
| 选中时刻变更 | ✅ | `onChanged` 回调正确触发 |
| 项级禁用 | ✅ | `minDate` / `maxDate` 区间外不可选 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<DateTime>(...)` |

### 4.3 Example 契约

- 覆盖 `mode`（`date` / `time` / `dateTime`）组合
- 提供 Form 桥接示例

---

## 组合范式（TPopup.show）

> `TDateTimePicker` 本身为平铺面板、不内建弹层；以下为**调用方组合范式**——将平铺面板用 `TPopup.show` 承载，或以 `Navigator` 推全屏。
> 弹层的确认/取消/关闭由 `TPopup` 的 options 或 Handle 回调处理，不在 `TDateTimePicker` 构造器内。

```dart
// 示例：TPopup.show 包裹 TDateTimePicker
TPopup.show(
  context: context,
  child: TDateTimePicker(
    value: _selectedDateTime,
    mode: DateTimePickerMode.dateTime,
    onChanged: (value) {
      setState(() => _selectedDateTime = value);
    },
    onConfirmed: (value) {
      // 仅最终选中触发
      setState(() => _selectedDateTime = value);
      TPopup.of(context)?.close();
    },
    minDate: DateTime.now().subtract(const Duration(days: 365)),
    maxDate: DateTime.now().add(const Duration(days: 365)),
  ),
);
```

---

### export

- **保留**：`TDateTimePicker`、`DateTimePickerMode`、`TDateTimePickerValue`、`TPickerThemeData`
- **移出**：`showDateTimePicker`、`t_date_time_picker_internal.dart` 等（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TPickerThemeData` · Material: **自绘滚轮** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` / `onConfirmed` | **F 类 Widget API** | 日期时间受控；Form → `TFormField` |
| `mode` | **构造器 L1** | 日期/时间/日期时间模式 |
| `showWeek` | **构造器 L1** | 是否显示星期列 |
| `minDate` / `maxDate` | **构造器 L2** | 可选区间 |
| `columnLabelBuilder` | **`TPickerThemeData`** | 列标签 L4 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
