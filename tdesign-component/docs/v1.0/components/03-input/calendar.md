# TCalendar — v1.0 定稿

> **状态**：规划中 | **控制类**：F | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/calendar`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 平铺月历面板；不内建弹层 |
| Material | 自绘 |
| Theme | `TCalendarThemeData` |
| 禁用 | 项级 `disabled` KEEP；整组 `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TCalendarThemeData`** |

## 控制方案

控制类 **F**：`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

`TCalendar` 底层为**自绘月历**（无 Material 同名控件）。样式默认走 `TCalendarThemeData`（P1）；禁用态通过 TDesign Token 颜色实现。P0 逃逸舱 → [theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问（**默认无**）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `List<DateTime>?` | L1 | — | 受控选中日期（单选: 1 个；范围: 2 个） |
| ✨ | `onChanged` | `ValueChanged<List<DateTime>>?` | L3 | — | 选中日期变更（每次选中都触发） |
| ✨ | `onConfirmed` | `ValueChanged<List<DateTime>>?` | L3 | — | 仅最终选中触发 |
| ✏️ | `mode` | `TCalendarMode` | L1 | `single` | 选择模式（single / range） |
| ✨ | `minDate` | `DateTime?` | L2 | — | 最小可选日期 |
| ✨ | `maxDate` | `DateTime?` | L2 | — | 最大可选日期 |
| ✨ | `anchorDate` | `DateTime?` | L1 | — | 初始锚定月（首屏优先级：anchorDate → value 所在月 → 今天） |
| ✨ | `onMonthChanged` | `ValueChanged<DateTime>?` | L3 | — | 翻月通知 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✏️ | `TCalendarMode` | `single` · `range` | `mode` 参数（选择模式） |
| ✨ | `DateSelectType` | `normal` · `selected` · `start` · `end` · `disabled` | 单元格选中态 |
| ✨ | `TCalendarThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `showCalendar` | 调用方用 `TPopup.show(child: TCalendar(...))` |
| 🚫 | `TCalendarStyle` | 内部实现，不公开 |
| 🗑️ | `initialValue` | `value`（F 类受控） |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | 回调函数名替换；每次选中都触发 |
| `initialValue` | `value` | 初值由父 State + `value` 受控 |
| `type` / `CalendarType` | `mode`（`TCalendarMode`） | 枚举化，避免与视觉形态 `variant` 混淆 |

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
| `showCalendar` | `TPopup.show(child: TCalendar(...))` | 调用方组合范式 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TCalendarThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `height` | `panelHeight` | 见 §3 末列 |

> 注：`style` / `cellBuilder` / `monthTitleBuilder` / `subtitleBuilder` 等 builder 类字段已在 v1.0 从构造器移除，统一由 Theme 默认 builder 提供。

> 子组件内部使用的 `TCalendar` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 `mode` + P0 `style`（如有） |
| 子树 | `Theme.of(context).mergeExtension(TCalendarThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TCalendarThemeData` |

### 3.2 覆盖顺序

`实例 P0 style` **>** resolve（全量合并） **>** Token

### 3.3 TCalendarThemeData 字段

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `panelHeight` | 面板高度 | `height` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_calendar.dart` — Widget 本体（平铺月历面板）
  - `t_calendar_resolve.dart` — **唯一**样式合并入口
  - `t_calendar_theme_data.dart` — `TCalendarThemeData` ThemeExtension

- **底层实现**：自绘月历（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染（single 模式） |
| range 模式 | ✅ | `mode: TCalendarMode.range` |
| 选中日期变更 | ✅ | `onChanged` 回调正确触发 |
| 项级禁用 | ✅ | `minDate` / `maxDate` 区间外格不可选 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| 翻月通知 | ✅ | `onMonthChanged` 回调正确触发 |
| Form 桥接 | ✅ | `TFormField<List<DateTime>>(...)` |

### 4.3 Example 契约

- 覆盖 `mode`（`single` / `range`）组合
- 覆盖 `minDate` / `maxDate` 区间限制
- 提供 Form 桥接示例

---

## 组合范式（TPopup.show）

> `TCalendar` 本身为平铺面板、不内建弹层；以下为**调用方组合范式**——将平铺面板用 `TPopup.show` 承载，或以 `Navigator` 推全屏。
> 弹层的确认/取消/关闭由 `TPopup` 的 options 或 Handle 回调处理，不在 `TCalendar` 构造器内。

```dart
// 示例：TPopup.show 包裹 TCalendar
TPopup.show(
  context: context,
  child: TCalendar(
    value: _selectedDates,
    onChanged: (value) {
      setState(() => _selectedDates = value);
    },
    onConfirmed: (value) {
      // 仅最终选中触发
      setState(() => _selectedDates = value);
      TPopup.of(context)?.close();
    },
    minDate: DateTime.now().subtract(const Duration(days: 365)),
    maxDate: DateTime.now().add(const Duration(days: 365)),
  ),
);
```

---

### export

- **保留**：`TCalendar`、`TCalendarMode`、`DateSelectType`、`TCalendarThemeData`
- **移出**：`TCalendarVariant`、`TCalendarStyle`、`showCalendar` 等（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCalendarThemeData` · Material: **—（自绘月历）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` / `onConfirmed` | **F 类 Widget API** | 日期受控；Form → `TFormField` |
| `mode` | **构造器 L1** | 选择模式（single / range） |
| `anchorDate` | **构造器 L1** | 初始锚定月 |
| `minDate` / `maxDate` | **构造器 L2** | 可选区间 |
| `onMonthChanged` | **构造器 L3** | 翻月回调 |
| `panelHeight` | **`TCalendarThemeData`** | 面板高度 L4 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
