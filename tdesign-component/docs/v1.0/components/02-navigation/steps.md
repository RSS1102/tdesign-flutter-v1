# TSteps — v1.0 定稿

> **状态**：已定稿 | **控制类**：— | **Sprint**：S3  
> **源码**：`lib/src/components/steps/` · **类名**：`TSteps`  
> **官网**：[Steps 步骤条](https://tdesign.tencent.com/flutter/components/steps) · [guide](../../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 0.2.x → v1.0](#2-02x--v10)
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘步骤条（横向/纵向） |
| Material | 无等价薄包装；**非** `Stepper`（分步表单控件） |
| Theme | `TStepsThemeData`（§3） |
| 交互 | **纯展示**；无步骤点击 / `onChanged` |
| L4 | → `TStepsThemeData`（§3） |

## 控制方案

控制类 **`—`**（展示型 value）：`value` 表示**当前步索引**，父 State 传入渲染；**无** `onChanged` 闭环，**非** B 类受控。无 `defaultValue` / Widget 级 `initialValue`。

**Material 对照**：对齐「流程进度展示」语义；**非** Material `Stepper`（`onStepContinue` / `onStepCancel` 等分步表单交互）。导航 **TSteps**（`—`）≠ 输入 **[TStepper](../03-input/stepper.md)**（B/C，`value` + `onChanged`）。

**与 B 类区别**：展示型允许 `activeIndex` 构造器默认 `0` 作回落；父亦可显式传 `value`。切步由业务改父 State（按钮、接口回调等），**不由**步骤条自身点击驱动。

→ [controlled.md §6](../../foundation/controlled.md#控制类-)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。L4 默认走 §3（`mergeExtension`）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`status` / `simple` / `verticalSelect` / `readOnly`）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `steps` | `List<TStepsItemData>` | L2 | — | 步骤数据 |
| ✏️ | `value` | `int?` | L1 | — | 当前步索引（原 `activeIndex`）；展示型，见 **§1.1.1** |
| | `direction` | `TStepsDirection` | L1 | `horizontal` | 横向/纵向 |
| | `readOnly` | `bool?` | L1 | Theme | 流程展示视觉态，见 **§1.1.2** |
| | `status` | `TStepsStatus?` | L1 | Theme | `success` / `error`；可覆盖 Theme |
| | `simple` | `bool?` | L1 | Theme | 简洁模式 |
| | `verticalSelect` | `bool?` | L1 | Theme | 纵向选中样式（右箭头） |

> 样式默认经 `Theme.of(context).extension<TStepsThemeData>()`；**禁止**构造器 `themeData`（→ [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。  
> 构造器可选 `Key`（`super.key`）见 [api.md §1.1](../../foundation/api.md#11-flutter-keywidget-基建)；**不进上表**。  
> **`activeIndex`**：0.2.x 兼容参数，KEEP；新代码用 `value`；解析见 **§1.1.1**。

#### §1.1.1 当前步索引（展示型 value）

有效索引：`effectiveIndex = value ?? activeIndex`（`value` 优先）。

| 参数 | 默认 | 说明 |
|------|------|------|
| `value` | `null` | 推荐；父 State 传入当前步 |
| `activeIndex` | `0` | 仅兼容；`value == null` 时回落 |

**规则**（展示型 `—`，**非** B 类）：

- 父 State 持业务进度；`setState` 改 `value` 后组件须同步激活态（`didUpdateWidget` 跟 `widget.value`）。
- 越界索引实现 **clamp** 至 `[0, steps.length - 1]`（`steps` 为空时为 `0`）。
- **无**步骤点击回调；切步由页面其它控件驱动父 State。

```dart
int _step = 0;

TSteps(
  value: _step,
  steps: [
    TStepsItemData(title: '步骤一', content: '说明'),
    TStepsItemData(title: '步骤二', content: '说明'),
    TStepsItemData(title: '步骤三', content: '说明'),
  ],
)

// 业务驱动切步（非步骤条点击）
ElevatedButton(
  onPressed: _step < 2 ? () => setState(() => _step++) : null,
  child: const Text('下一步'),
)
```

```dart
// 兼容写法（新代码不推荐）
TSteps(steps: [...], activeIndex: 1);

// 等价于 value 优先
TSteps(steps: [...], value: 2, activeIndex: 1); // 生效索引为 2
```

#### §1.1.2 交互与 `readOnly`（纯展示）

v1.0 **不提供** `onTap` / `onChanged` / 步骤级点击 API。步骤条仅渲染进度，**不可**通过点击步骤切换当前步。

| `readOnly` | 视觉语义 |
|------------|----------|
| `false`（默认） | **进行中**：区分已完成 / 当前 / 未完成；当前步标题可加粗 |
| `true` | **流程展示态**：连线与节点按「流程已走完」样式渲染（非「禁用点击」——本身即无点击） |

> **不进 Theme**：`steps` · `value` / `activeIndex` · `direction`。

### 1.2 类型定义

#### TStepsItemData

| 决策 | 参数 | 类型 | 说明 |
|------|------|------|------|
| | `title` | `String?` | 标题 |
| | `content` | `String?` | 内容 |
| | `successIcon` | `IconData?` | 成功图标 |
| | `errorIcon` | `IconData?` | 失败图标 |
| | `customTitle` | `Widget?` | 自定义标题 |
| | `customContent` | `Widget?` | 自定义内容 |

#### 其他类型

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TStepsDirection` | `horizontal` · `vertical` |
| | `TStepsStatus` | `success` · `error`；当前步错误态等 |
| | `TStepsThemeData` | ThemeExtension（§3） |

### 1.3 export

**KEEP**：`TSteps` · `TStepsItemData` · `TStepsDirection` · `TStepsStatus` · `TStepsThemeData`。

---

## §2 0.2.x → v1.0

**未改**（§1 无图例项）：`steps` · `direction` · `TStepsItemData` 字段

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `activeIndex` | `value` | 推荐新名；`activeIndex` KEEP 兼容；`value` 优先 |

### ✏️ 行为澄清

| 0.2.x 误解 | v1.0 |
|-----------|------|
| `readOnly: false` 可点击切步 | **无**步骤点击；切步由父 State + 外部控件 |
| `readOnly: true` 禁用点击 | 实为**流程展示视觉态**（见 §1.1.2） |

### 🗑️ 移除

| 从（0.2.x） | 怎么改 |
|------------|--------|
| 构造器 `themeData:` | `mergeExtension(TStepsThemeData(...))`（→ §3） |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（`TStepsThemeData`） | 怎么改 |
|------------------|---------------------------|--------|
| `status` / `simple` / `verticalSelect` / `readOnly` | 同名字段 | 默认可走 Theme；构造器 L1 可覆盖 |

---

## §3 Theme 主题配置

`TStepsThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 `status` / `simple` / `verticalSelect` / `readOnly` |
| 子树 | `Theme.of(context).mergeExtension(TStepsThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TStepsThemeData` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TStepsThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘非 Material `Stepper`，无 P2）。

| 决策 | 字段 | 管什么 | 0.2.x 来源 |
|------|------|--------|-----------|
| 📦 | `status` | 步骤状态（`success` / `error`） | `status` |
| 📦 | `simple` | 简洁模式 | `simple` |
| 📦 | `verticalSelect` | 纵向选中样式 | `verticalSelect` |
| 📦 | `readOnly` | 流程展示视觉态默认 | `readOnly` |

#### 字段归类：进 Theme 与不进 Theme

本组件为自绘步骤条（**非** Material `Stepper` 分步表单控件），无 Material 等价；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TStepsThemeData`（P1，可主题化）**
- `status`（`success` / `error`）· `simple` · `verticalSelect` · `readOnly`

**不进 Theme（构造器 L1/L2）**
- `steps`（L2）· `value` / `activeIndex`（L1）· `direction`（L1）

---

## §4 实现约定 · 测试与 Example 契约

**文件**：`t_steps.dart` · `t_steps_horizontal.dart` / `t_steps_vertical.dart` · `t_steps_theme_data.dart`。

**Theme 合并**：`status` / `simple` / `verticalSelect` / `readOnly` 须按 §3 优先级解析（构造器 L1 **>** `Theme.extension<TStepsThemeData>()` **>** 内置默认）；**禁止**构造器 `themeData` 参数。

**必测**：横/纵布局 · `value` 驱动激活态 · 父 `setState` 改 `value` 同步 · `value` 优先于 `activeIndex` · `activeIndex` 兼容回落 · 越界 clamp · `readOnly` 两档视觉 · `status: error` 当前步样式 · `simple` · `verticalSelect` · Theme 子树覆盖 · **无**步骤点击 / `onChanged` · **无**构造器 `themeData`。

**Example**：`activeIndex→value` · 父 State + 外部按钮切步 · `readOnly` 流程展示态 · `status: error` · 横纵示例 · Theme `simple` 覆盖。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [steps-upgrade-guide.md](./steps-upgrade-guide.md)（类名与 **§1** 冲突时以 **§1** 为准）
