# TCascader — v1.0 定稿

> **状态**：规划中 | **控制类**：F | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/cascader`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 平铺级联面板；不内建弹层 |
| Material | 自绘多列 |
| Theme | `TCascaderThemeData` |
| 禁用 | 项级 `disabled` KEEP；整组 `onChanged: null`（自动应用 TDesign Token 禁用色） |
| L4 | 构造器 L4 → **`TCascaderThemeData`** |

## 控制方案

控制类 **F**：`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色，如 `textDisabledColor`）。

`TCascader` 底层为**自绘多列**（无 Material 同名控件）。样式默认走 `TCascaderThemeData`（P1）；禁用态通过 TDesign Token 颜色实现（非硬编码透明度）。P0 逃逸舱 → [theme.md §2.2](../foundation/theme.md#22-p0-逃逸舱判定) 四问（**默认无**）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `data` | `List<Map>` | L2 | — | 级联数据源 |
| ✨ | `value` | `List<MultiCascaderListModel>?` | L1 | — | 受控选中路径 |
| ✨ | `onChanged` | `ValueChanged<List<MultiCascaderListModel>>?` | L3 | — | 选中路径变更（每次选中都触发） |
| ✨ | `onConfirmed` | `ValueChanged<List<MultiCascaderListModel>>?` | L3 | — | 仅最终选中触发（到达最后一层） |
| ✨ | `variant` | `TCascaderVariant` | L1 | `step` | 面板形态（`step` / `tab`） |
| ✨ | `isLetterSort` | `bool` | L1 | `false` | 字母索引排序 |
| ✨ | `subTitles` | `List<String>?` | L2 | — | 各级列标题 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TCascaderVariant` | `step` · `tab` | `variant` 参数（面板形态） |
| ✨ | `MultiCascaderListModel` | `value` · `label` · `disabled` · `children` | `data` 数据模型 |
| ✨ | `TCascaderThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `showMultiCascader` | 调用方用 `TPopup.show(child: TCascader(...))` |
| 🚫 | `TMultiCascader` | 内部实现，不公开 |
| 🚫 | `TCustomTab` | 内部实现，不公开 |
| 🗑️ | `initialIndexes` / `initialData` | `value`（F 类受控） |
| 🗑️ | `TTheme.of` 取蒙层色 | `Theme.of(context)` + `TCascaderThemeData.barrierColor` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onChange` | `onChanged` | 回调函数名替换；每次选中都触发 |
| `initialIndexes` / `initialData` | `value` | 初值由父 State + `value` 受控 |
| `theme`（`step` / `tab` 字符串） | `variant`（`TCascaderVariant`） | 枚举化 |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `onConfirmed` | 仅最终选中触发（到达最后一层） |

### 🔀 合并

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `title` + `titleStyle` | `titleStyle`（Theme 默认） | 迁入 Theme，构造器只留 `title` |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `showMultiCascader` | `TPopup.show(child: TCascader(...))` | 调用方组合范式 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TCascaderThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `title` / `titleStyle` | `titleStyle` | 见 §3 末列 |
| `cascaderHeight` | `columnHeight` | 见 §3 末列 |
| `backgroundColor` / `topRadius` | `panelColor` / `panelRadius` | 见 §3 末列 |

> 注：0.2.x `theme`（`step`/`tab`）已改为构造器参数 `variant`（见 §1.1），不进 Theme。

> 子组件内部使用的 `TCascader` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 `variant` |
| 子树 | `Theme.of(context).mergeExtension(TCascaderThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TCascaderThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TCascaderThemeData 字段

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `titleStyle` | 面板标题文案样式 | `title` / `titleStyle` |
| 📦 | `columnHeight` | 列视窗高度 | `cascaderHeight` |
| 📦 | `panelColor` | 面板背景色 | `backgroundColor` |
| 📦 | `panelRadius` | 面板圆角 | `topRadius` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_cascader.dart` — Widget 本体（平铺级联面板）
  - `t_cascader_resolve.dart` — **唯一**样式合并入口
  - `t_cascader_theme_data.dart` — `TCascaderThemeData` ThemeExtension

- **底层实现**：自绘多列（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染（step 形态） |
| tab 形态 | ✅ | `variant: TCascaderVariant.tab` |
| 选中路径变更 | ✅ | `onChanged` 回调正确触发 |
| 项级禁用 | ✅ | `data` 中 `disabled: true` 的项不可选 |
| 整组禁用 | ✅ | `onChanged: null` 不可交互 |
| 字母排序 | ✅ | `isLetterSort: true` 右侧字母索引 |
| Form 桥接 | ✅ | `TFormField<List<MultiCascaderListModel>>(...)` |

### 4.3 Example 契约

- 覆盖 `variant`（`step` / `tab`）组合
- 覆盖 `isLetterSort` 开关
- 提供 Form 桥接示例

---

## 组合范式（TPopup.show）

> `TCascader` 本身为平铺面板、不内建弹层；以下为**调用方组合范式**——将平铺面板用 `TPopup.show` 承载，或以 `Navigator` 推全屏。
> 弹层的确认/取消/关闭由 `TPopup` 的 options 或 Handle 回调处理，不在 `TCascader` 构造器内。

```dart
// 示例：TPopup.show 包裹 TCascader
TPopup.show(
  context: context,
  child: TCascader(
    data: cascaderData,
    value: _selected,
    onChanged: (value) {
      setState(() => _selected = value);
      // 每次选中都触发，可用于中间层切换
    },
    onConfirmed: (value) {
      // 仅最终选中触发（到达最后一层）
      setState(() => _selected = value);
      TPopup.of(context)?.close();
    },
  ),
);
```

---

### export

- **保留**：`TCascader`、`MultiCascaderListModel`、`TCascaderThemeData`、`TCascaderVariant`
- **移出**：`showMultiCascader`、`TCascaderAction`、`TMultiCascader` 内部实现、`TCustomTab` 等（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCascaderThemeData` · Material: **—（自绘多列）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `data` / `subTitles` / `isLetterSort` | **构造器 L2** | 业务数据与列标题 |
| `value` / `onChanged` / `onConfirmed` | **F 类 Widget API** | 选中路径受控；Form → `TFormField` |
| `variant` / `columnHeight` / 面板色圆角 | **`TCascaderThemeData`** | step/tab 与列布局 L4 |
| `barrierColor` / `transitionDuration` | **TPopup Theme** | 蒙层与动画由 `TPopup.show` 控制 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
