# TCheckbox — v1.0 定稿

> **状态**：规划中 | **控制类**：B | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/checkbox`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | Checkbox |
| Theme | `TCheckboxThemeData` |
| 禁用 | `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TCheckboxThemeData`** |

## 控制方案

控制类 **B**：`value` + `onChanged`；无 `defaultValue`；初值父 State。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

`TCheckboxGroup` 为批量管理语义，内部仍为单颗 `TCheckbox` 的 `value` + `onChanged`。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

#### TCheckbox（单个复选框）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `bool?` | L1 | — | 受控选中态（三态：true/false/null） |
| | `onChanged` | `ValueChanged<bool?>?` | L3 | — | 选中态变更 |
| | `title` | `String?` | L2 | — | 主标题文案 |
| | `subTitle` | `String?` | L2 | — | 副标题文案 |
| ✨ | `size` | `TCheckboxSize` | L1 | `medium` | 尺寸（大/中/小） |
| ✨ | `cardMode` | `bool` | L1 | `false` | 卡片模式 |
| ✨ | `customIconBuilder` | `Widget Function(bool checked)?` | L2 | — | 自定义 Checkbox 图标 |
| ✨ | `contentDirection` | `TContentDirection` | L1 | `right` | 控件与文案排列方向 |
| ✨ | `showDivider` | `bool` | L1 | `false` | 列表项底部分割线 |

#### TCheckboxGroup（复选框组）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `List<T>` | L1 | — | 受控选中项列表（由 `checkedIds` 迁移） |
| | `onChanged` | `ValueChanged<List<T>>?` | L3 | — | 选中项列表变更 |
| ✨ | `customIconBuilder` | `Widget Function(bool checked)?` | L2 | — | 自定义 Checkbox 图标 |
| ✨ | `contentDirection` | `TContentDirection` | L1 | `right` | 控件与文案排列方向 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TCheckboxSize` | `large` · `medium` · `small` | `size` 参数 |
| ✨ | `TContentDirection` | `left` · `right` | `contentDirection` 参数 |
| ✨ | `TCheckboxThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TCheckboxStyle` | 内部实现，不公开 |
| 🚫 | `TCheckboxGroupController` | 移出 export；组值由父 `value` + `onChanged` |
| 🗑️ | `checked` | `value`（B 类受控） |
| 🗑️ | `checkedIds` | `TCheckboxGroup.value`（B 类受控） |
| 🗑️ | `enable` | `onChanged: null` |
| 🗑️ | `onCheckBoxChanged` | `onChanged` |
| 🗑️ | `onChangeGroup` | `TCheckboxGroup.onChanged` |
| 🗑️ | `customContentBuilder` | 删除（与 `customIconBuilder` 重叠） |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `checked` | `value` | 受控统一为 value |
| `checkedIds` | `TCheckboxGroup.value` | 组受控统一为 value |
| `onCheckBoxChanged` | `onChanged` | 回调函数名替换 |
| `onChangeGroup` | `TCheckboxGroup.onChanged` | 组回调函数名替换 |
| `enable` | `onChanged: null` | Material 禁用 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TCheckboxStyle` | `TCheckboxThemeData` | L4 迁入 Theme |
| `TCheckboxGroupController` | 父 `setState` 改 `value` | 单轨原则 |
| `id` | `title` | 参数重命名 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TCheckboxThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `selectColor` | `selectColor` | 见 §3 末列 |
| `disableColor` | `disableColor` | 见 §3 末列 |
| `titleColor` | `titleColor` | 见 §3 末列 |
| `subTitleColor` | `subTitleColor` | 见 §3 末列 |
| `titleFont` | `titleFont` | 见 §3 末列 |
| `subTitleFont` | `subTitleFont` | 见 §3 末列 |
| `insetSpacing` | `insetSpacing` | 见 §3 末列 |
| `spacing` | `spacing` | 见 §3 末列 |
| `checkBoxLeftSpace` | `spacing` | 合并到 spacing |
| `customSpace` | `spacing` | 合并到 spacing |

> 注：Material `CheckboxThemeData` 的 `fillColor`/`checkColor`/`overlayColor`/`splashRadius` 由 Material 子主题处理，TDesign 扩展字段（`backgroundColor`/`selectColor` 等）在 `TCheckboxThemeData` 中。

> 子组件内部使用的 `TCheckbox` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TCheckboxThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TCheckboxThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TCheckboxThemeData 字段

> TDesign 扩展字段（Material `CheckboxThemeData` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `backgroundColor` | 卡片背景色（cardMode） | `backgroundColor` |
| 📦 | `selectColor` | 选中态颜色 | `selectColor` |
| 📦 | `disableColor` | 禁用态颜色 | `disableColor` |
| 📦 | `titleColor` | 标题文字颜色 | `titleColor` |
| 📦 | `subTitleColor` | 副标题文字颜色 | `subTitleColor` |
| 📦 | `titleFont` | 标题文字样式 | `titleFont` |
| 📦 | `subTitleFont` | 副标题文字样式 | `subTitleFont` |
| 📦 | `insetSpacing` | 控件内边距 | `insetSpacing` |
| 📦 | `spacing` | 控件与标题间距 | `spacing` / `checkBoxLeftSpace` / `customSpace` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_checkbox.dart` — Widget 本体
  - `t_checkbox_resolve.dart` — **唯一**样式合并入口
  - `t_checkbox_theme_data.dart` — `TCheckboxThemeData` ThemeExtension

- **底层实现**：包装 Material `Checkbox` / `CheckboxListTile`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 三态切换 | ✅ | `value: true` / `false` / `null` |
| 选中态变更 | ✅ | `onChanged` 回调正确触发 |
| 卡片模式 | ✅ | `cardMode: true` |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| Form 桥接 | ✅ | `TFormField<bool?>(...)` |

### 4.3 Example 契约

- 覆盖 `value` 三态（true/false/null）
- 覆盖 `cardMode` 开关
- 提供 Form 桥接示例

---

## 组合范式（TCheckboxGroup）

> 批量管理语义；`value: List<T>` 由 `checkedIds` 迁移；内部仍为单颗 `TCheckbox` 的 `value` + `onChanged`。

```dart
// 示例：TCheckboxGroup 批量管理
TCheckboxGroup<String>(
  value: _selectedValues,  // List<String>，由 checkedIds 迁移
  onChanged: (values) {
    setState(() => _selectedValues = values);
  },
  children: [
    TCheckbox(value: true, onChanged: ..., title: '选项1'),
    TCheckbox(value: false, onChanged: ..., title: '选项2'),
  ],
)
```

---

### export

- **保留**：`TCheckbox`、`TCheckboxGroup`、`TCheckboxSize`、`TContentDirection`、`TCheckboxThemeData`
- **移出**：`TCheckboxStyle`、`TCheckboxGroupController`、`OnGroupChange`、`OnCheckBoxGroupChange`、内部 `HollowCircle` 等绘制类（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCheckboxThemeData` · Material: **Checkbox** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `value`（单颗） | **B 类 Widget API** | 选中态受控；Form → `TFormField` |
| `value`（Group） | **B 类 Widget API** | 选中项列表受控；Form → `TFormField<List<T>>` |
| `title` / `subTitle` | **构造器 L2** | 文案内容 |
| `size` / `cardMode` / `contentDirection` / `showDivider` | **构造器 L1** | 语义级参数 |
| `backgroundColor` / `selectColor` / `titleColor` / `spacing` 等 | **`TCheckboxThemeData`** | TDesign 扩展 L4 |
| `fillColor` / `checkColor` / `overlayColor` / `splashRadius` | Material **`CheckboxThemeData`** | 三态（`WidgetStateProperty`） |
| `side` / `shape` / `visualDensity` / `materialTapTargetSize` | Material **`CheckboxThemeData`** | 边框与形状 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
