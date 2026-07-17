# TRadio — v1.0 定稿

> **状态**：规划中 | **控制类**：B | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/radio`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | T2 自绘标准 Radio 指示器与内容布局 |
| Material | `RadioThemeData`（点击热区与交互状态参考） |
| Theme | `TRadioThemeData` |
| 默认指示器 | 圆环；选中时显示实心圆点 |
| 禁用 | `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TRadioThemeData`** |

## 控制方案

控制类 **B**：`value` + `onChanged`；无 `defaultValue`；初值父 State。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

`TRadioGroup` 为互斥组语义，内部仍为单颗 `TRadio` 的 `value` + `onChanged`（对齐 Material `RadioGroup`；**无** `TRadioGroupController`）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `T` | L1 | — | 本选项标识 |
| | `groupValue` | `T?` | L1 | — | 父组件传入的当前选中值 |
| | `onChanged` | `ValueChanged<T>?` | L3 | — | 选中变更 |
| | `title` | `String?` | L2 | — | 主标题文案 |
| | `subTitle` | `String?` | L2 | — | 副标题文案 |
| ✨ | `size` | `TRadioSize` | L1 | `medium` | 尺寸（大/中/小） |
| ✨ | `cardMode` | `bool` | L1 | `false` | 卡片模式 |
| ✨ | `showDivider` | `bool` | L1 | `false` | 列表项底部分割线 |
| ✨ | `contentDirection` | `TContentDirection` | L1 | `right` | 控件与文案排列方向 |
| ✨ | `customIconBuilder` | `TRadioIconBuilder?` | L2 | — | 自定义非标准指示器 |

#### TRadioGroup

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `T?` | L1 | — | 外部受控选中值 |
| | `options` | `List<TRadioOption<T>>` | L2 | — | 数据项；含 value/label/subTitle/disabled |
| | `onChanged` | `ValueChanged<T>?` | L3 | — | 选中值变化；null 时整组禁用 |
| ✨ | `direction` | `Axis` | L1 | `vertical` | 排列方向 |
| ✨ | `columns` | `int` | L1 | `1` | 横向或多列排列的列数 |
| ✨ | `itemBuilder` | `TRadioOptionBuilder<T>?` | L2 | — | 自定义数据项视觉；Group 统一持有交互与语义 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

Radio 只提供圆环加实心圆点这一种标准指示器，不提供方形、勾选或 check-circle 公开变体。特殊视觉通过 `customIconBuilder` 实现，不进入全局 Radio 形态枚举。

#### 卡片与禁用视觉

- 普通列表项禁用时只切换指示器和文案禁用色，不改变整项背景。
- `cardMode` 隐藏默认 Radio 指示器，选中态使用 1.5px 品牌色边框和左上角勾选角标，未选边框透明；禁用且选中时使用禁用色。
- 纵向卡片无副标题时项高 56px、有副标题时 82px，混合内容逐项解析；横向卡片同组等高，任一项有副标题时整组 82px，否则 56px。两种方向均使用 12px 间距和 16px 水平外边距，横向由 `columns` 控制列数。
- Radio 与 Checkbox 共用卡片视觉和排列实现，状态仍由 `value + onChanged` 严格受控。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TRadioSize` | `large` · `medium` · `small` | `size` 参数 |
| ✨ | `TRadioOption<T>` | `value` · `label` · `subTitle` · `disabled` | Group 数据项与单项禁用 |
| ✨ | `TContentDirection` | `left` · `right` | `contentDirection` 参数 |
| ✨ | `TRadioThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TRadioStyle` | 内部实现，不公开 |
| 🚫 | `TRadioVariant` | 删除；Radio 固定为圆环加实心圆点 |
| 🗑️ | `radioStyle` / `radioCheckStyle` | `customIconBuilder` |
| 🚫 | `TRadioGroupController` | 移出 export；组值由父 `value` + `onChanged` |
| 🗑️ | `id` | `value`（B 类受控） |
| 🗑️ | `selectId` | Group 的 `value` |
| 🗑️ | `enable` | `onChanged: null` |
| 🗑️ | `onRadioGroupChange` | `onChanged` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `id` | `value` | 命名对齐 v1.0 |
| `selectId` | Group 的 `value` | 统一严格受控命名 |
| `onRadioGroupChange` | `onChanged` | 命名对齐 v1.0 |
| `enable` | `onChanged: null` | Material 禁用 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TRadioGroupController` | 父 `setState` 改 `value` | 单轨原则 |
| `Group` 构造器 `controller` | 删除 |
| `TRadioVariant` / `radioStyle` / `radioCheckStyle` | `customIconBuilder` | 标准 Radio 不提供多形态 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TRadioThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `selectColor` | `selectColor` | 见 §3 末列 |
| `disableColor` | `disableColor` | 见 §3 末列 |
| `titleColor` | `titleColor` | 见 §3 末列 |
| `subTitleColor` | `subTitleColor` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `titleFont` | `titleFont` | 见 §3 末列 |
| `subTitleFont` | `subTitleFont` | 见 §3 末列 |
| `spacing` / `checkBoxLeftSpace` / `insetSpacing` / `customSpace` | `spacing` | 合并到 spacing |

> 注：Material `RadioThemeData` 的 `fillColor`/`overlayColor`/`splashRadius` 由 Material 子主题处理，TDesign 扩展字段在 `TRadioThemeData` 中。

> 子组件内部使用的 `TRadio` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TRadioThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TRadioThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TRadioThemeData 字段

> TDesign 扩展字段（Material `RadioThemeData` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `selectColor` | 选中态颜色 | `selectColor` |
| 📦 | `disableColor` | 禁用态颜色 | `disableColor` |
| 📦 | `titleColor` | 标题文字颜色 | `titleColor` |
| 📦 | `subTitleColor` | 副标题文字颜色 | `subTitleColor` |
| 📦 | `backgroundColor` | 卡片背景色（cardMode） | `backgroundColor` |
| 📦 | `titleFont` | 标题文字样式 | `titleFont` |
| 📦 | `subTitleFont` | 副标题文字样式 | `subTitleFont` |
| 📦 | `spacing` | 控件与标题间距 | `spacing` / `checkBoxLeftSpace` / `insetSpacing` / `customSpace` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_radio.dart` — Widget 本体
  - `t_radio_resolve.dart` — **唯一**样式合并入口
  - `t_radio_theme_data.dart` — `TRadioThemeData` ThemeExtension

- **底层实现**：自绘圆环与实心圆点；列表组合是否复用 `TCell` 待 Cell v1.0 定稿后决定。
- **形态约束**：Radio 无公开形态枚举；不得增加方形、勾选或 check-circle 默认变体。

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 互斥选中 | ✅ | Group 内仅一个选中 |
| 选中变更 | ✅ | `onChanged` 回调正确触发 |
| 卡片模式 | ✅ | `cardMode: true` |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<T>(...)` |

### 4.3 Example 契约

- 覆盖 `TRadioGroup` 互斥选中
- 提供 Form 桥接示例

---

## 组合范式（TRadioGroup）

> 互斥组语义；内部仍为单颗 `TRadio` 的 `value` + `onChanged`。

```dart
// 示例：TRadioGroup 互斥选中
TRadioGroup<String>(
  value: _selected,
  onChanged: (value) {
    setState(() => _selected = value);
  },
  options: const [
    TRadioOption(value: 'a', label: '选项A'),
    TRadioOption(value: 'b', label: '选项B'),
  ],
)
```

---

### export

- **保留**：`TRadio`、`TRadioGroup`、`TRadioOption`、`TRadioThemeData`、`TRadioSize`、`TContentDirection`
- **移出**：`TRadioStyle`、`HollowCircle` 等内部绘制类、`TRadioGroupController`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TRadioThemeData` · Material: **Radio / RadioListTile / RadioGroup** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value`（单颗） | Material **`Radio.value`** | 本选项标识 |
| `value`（Group） | Material **`RadioGroup.groupValue`** | 外部受控的组选中值 |
| `onChanged` | Material **`Radio.onChanged`** / **`RadioGroup.onChanged`** | `null` 禁用 |
| `title` / `subTitle` | Material **`RadioListTile`** | 映射 title / subTitle |
| `fillColor` / `overlayColor` / `splashRadius` / `visualDensity` / `materialTapTargetSize` | Material **`RadioThemeData`** | 三态（`WidgetStateProperty`） |
| 标准指示器 | **TRadio 内部绘制** | 圆环加实心圆点；无公开 variant |
| `disableColor` / `selectColor` / 文案色 / `spacing` | **`TRadioThemeData`** | 0.2.x 构造器 L4 迁入 |
| `cardMode` | **TDesign 扩展** | 布局 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
