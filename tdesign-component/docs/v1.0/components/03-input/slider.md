# TSlider — v1.0 定稿

> **状态**：规划中 | **控制类**：C | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/slider`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 连续值控件薄包装 |
| Material | Slider / RangeSlider |
| Theme | `TSliderThemeData` |
| 禁用 | `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TSliderThemeData`** |

## 控制方案

控制类 **C**：`value` + `onChanged`（含 `onChangeStart`/`onChangeEnd`）。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `double` | L1 | — | 受控滑块值 |
| | `onChanged` | `ValueChanged<double>?` | L3 | — | 值变更（每次拖动都触发） |
| ✨ | `onChangeStart` | `ValueChanged<double>?` | L3 | — | 开始拖动时触发 |
| ✨ | `onChangeEnd` | `ValueChanged<double>?` | L3 | — | 结束拖动时触发 |
| ✨ | `min` | `double` | L1 | `0.0` | 最小值 |
| ✨ | `max` | `double` | L1 | `1.0` | 最大值 |
| ✨ | `divisions` | `int?` | L1 | — | 刻度数（null = 连续） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TSliderThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🗑️ | `leftLabel` | `label`（命名对齐 v1.0） |
| 🗑️ | `onTap` | 删除（Material Slider 无此项；交互走 `onChanged`） |
| 🗑️ | `onThumbTextTap` | 删除（Material 无；低频，文档组合示例替代） |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `leftLabel` | `label` | 命名对齐 v1.0 |
| `onTap` | 删除 | Material Slider 无此项；交互走 `onChanged` |
| `onThumbTextTap` | 删除 | Material 无；低频，文档组合示例替代 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TSliderThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `boxDecoration` | `boxDecoration` | 见 §3 末列 |
| `sliderThemeData` | 合并到 TSliderThemeData | 见 §3 末列 |

> 注：Material `SliderThemeData` 的 `activeTrackColor`/`inactiveTrackColor`/`thumbColor`/`overlayColor` 等由 Material 子主题处理，TDesign 扩展字段在 `TSliderThemeData` 中。

> 子组件内部使用的 `TSlider` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TSliderThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TSliderThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TSliderThemeData 字段

> TDesign 扩展字段（Material `SliderThemeData` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `boxDecoration` | 滑条外层容器装饰 | `boxDecoration` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_slider.dart` — Widget 本体
  - `t_slider_resolve.dart` — **唯一**样式合并入口
  - `t_slider_theme_data.dart` — `TSliderThemeData` ThemeExtension

- **底层实现**：包装 Material `Slider` / `RangeSlider`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 值变更 | ✅ | `onChanged` 回调正确触发 |
| 范围限制 | ✅ | `min` / `max` 边界 |
| 刻度模式 | ✅ | `divisions` 离散值 |
| 生命周期回调 | ✅ | `onChangeStart` / `onChangeEnd` |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<double>(...)` |

### 4.3 Example 契约

- 覆盖 `value` 范围（min/max）
- 覆盖 `divisions` 刻度模式
- 提供 Form 桥接示例

---

### export

- **保留**：`TSlider`、`TRangeSlider`、`TSliderThemeData`
- **移出**：`Position`、旧普通类 `TSliderThemeData`（非 Extension）、`slider/_shapes/` 内部 Shape（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSliderThemeData` · Material: **Slider / RangeSlider** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value` / `onChanged` / `onChangeStart` / `onChangeEnd` | **C 类 Widget API** | 值受控；Form → `TFormField` |
| `min` / `max` / `divisions` | **构造器 L1** | 数值边界与刻度 |
| `activeTrackColor` / `inactiveTrackColor` / `disabledActiveTrackColor` / `disabledInactiveTrackColor` | Material **`SliderThemeData`** | 轨道三态色 |
| `thumbColor` / `overlayColor` / `valueIndicatorColor` | Material **`SliderThemeData`** | thumb 与 overlay |
| `trackHeight` / `thumbShape` / `overlayShape` / `valueIndicatorShape` / `showValueIndicator` | Material **`SliderThemeData`** | 形状与尺寸 |
| `activeTickMarkColor` / `inactiveTickMarkColor` / `tickMarkShape` | Material **`SliderThemeData`** | 刻度 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
