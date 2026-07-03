# TSideBar — v1.0 定稿

> **状态**：已定稿 | **控制类**：B | **Sprint**：S3  
> **源码**：`lib/src/components/sidebar/` · **类名**：`TSideBar`  
> **官网**：[SideBar 侧边栏](https://tdesign.tencent.com/flutter/components/side-bar) · [guide](../../guide/developer-guide.md)

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
| 实现 | 自绘侧边导航（纵向 `ListView`） |
| Material | 无等价薄包装 |
| Theme | `TSideBarThemeData`（§3） |
| 禁用 | 整栏：`onChanged: null`；单项：`TSideBarItem.disabled` |
| L4 | → `TSideBarThemeData`（§3） |

## 控制方案

控制类 **B**：**仅** `value` + `onChanged`；无 `defaultValue`；**`value` 必填**且由**父 State** 持有。用户点击 → `onChanged`；父组件 `setState` 回写 `value`。命令式切项由父 `setState` 改 `value`，**无** `Controller` 辅助 API。禁用：`onChanged: null`。

**Material 对照**：无同名 SideBar Widget；受控选中对齐 M3 `NavigationBar.selectedIndex` + `onDestinationSelected` / `NavigationRail`；API 统一为 `value` + `onChanged`（→ [controlled.md §1.1](../../foundation/controlled.md#11-导航选中b-类)）。**非** [TIndexes](./indexes.md) 式内部持态。

→ [controlled.md](../../foundation/controlled.md) · [form.md §2](../../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。L4 默认走 §3（`mergeExtension`）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`loading`）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| ✏️ | `value` | `int` | L1 | — | 当前选中项 `value`（原 `defaultValue`）；**必填**；须匹配 `children` 中某项 |
| | `onChanged` | `ValueChanged<int>?` | L3 | — | 选中变化；与 `value` 成对；`null` 禁用整栏 |
| | `children` | `List<TSideBarItem>` | L2 | `[]` | 侧栏项 |
| | `loading` | `bool` | L1 | `false` | **业务态**：是否展示加载 UI（→ §1.1.1） |
| | `loadingWidget` | `Widget?` | L2 | — | 加载占位；与 `loading` 配对；保留 `*Widget` 消歧 → [api.md §2.1](../../foundation/api.md#21-l2-内容槽widget-实例-vs-builder-回调) |

> 样式默认经 `Theme.of(context).extension<TSideBarThemeData>()`；**禁止**构造器 `themeData`（→ [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。  
> 构造器可选 `Key`（`super.key`）见 [api.md §1.1](../../foundation/api.md#11-flutter-keywidget-基建)；**不进上表**。

#### §1.1.1 加载态

`loading` 是 **bool 业务态**，不进 Theme（对齐 [theme.md §2.1「不进 Theme」](../../foundation/theme.md#21-themedata-字段归类v10-裁决)）。

| `loading` | `loadingWidget` | 渲染 |
|-----------|-----------------|------|
| `false` | — | 正常侧栏列表 |
| `true` | `null` | 内置 `TLoading`（circle · large） |
| `true` | 有 | 仅 `loadingWidget` |

```dart
TSideBar(
  value: 0,
  onChanged: (v) => setState(() => _value = v),
  loading: _loading,
  children: [...],
)
```

#### §1.1.2 受控与回调（B 类）

凡选中项变化，**仅**触发 **`onChanged`**（用户点击；父 `setState` 改 `value` 不触发）。

| 触发源 | `onChanged` |
|--------|-------------|
| 用户点击新项 | ✅ |
| 父 `setState` 改 `value` | — |
| 重复点击当前项 | — |
| 点击 `disabled` 项 | — |

```dart
int _value = 0;

TSideBar(
  value: _value,
  onChanged: (v) => setState(() => _value = v),
  children: [
    TSideBarItem(value: 0, label: '选项一'),
    TSideBarItem(value: 1, label: '选项二'),
  ],
)

// 命令式切项：父 State 改 value（不经过 onChanged）
setState(() => _value = 2);
```

**`value` 规则**：

- **必填**；父 State 持初值；**不**自动选中 `children` 首项。
- 须与某项 `TSideBarItem.value` 一致；无匹配项时实现可 assert / 无选中高亮。
- **严格 B 类**：高亮由构造器 **`value`** 驱动；父 `setState` 改 `value` 后须同步高亮（`didUpdateWidget` 跟 `widget.value`），**不**仅靠组件内部 index / 局部 State 持选中态。

### 1.2 类型定义

#### TSideBarItem

| 决策 | 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|------|
| | `label` | `String` | `''` | 标签 |
| | `value` | `int` | `-1` | 项值（与 `TSideBar.value` 对应）；业务传 **唯一非负** `int`，**勿**用默认 `-1` 作真实项 |
| | `icon` | `IconData?` | — | 图标 |
| | `badge` | `TBadge?` | — | 徽标 |
| | `disabled` | `bool` | `false` | 单项禁用 |
| | `textStyle` | `TextStyle?` | — | 项级文字样式（不进 Theme） |

#### 其他类型

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TSideBarStyle` | `normal` · `outline`；形态默认在 Theme |
| | `TSideBarThemeData` | ThemeExtension（§3） |

### 1.3 export

**KEEP**：`TSideBar` · `TSideBarItem` · `TSideBarThemeData` · `TSideBarStyle`。

---

## §2 0.2.x → v1.0

**未改**（§1 无图例项）：`children` · `loading` · `loadingWidget` · `TSideBarItem` 字段

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `defaultValue` | `value` | 父 State 持初值；**必填**；**不**自动选首项 |

### ✏️ 行为对齐（B 类）

| 0.2.x | v1.0 |
|-------|------|
| 点击 → `onSelected` | 点击 → **`onChanged`** |
| `controller.selectTo` / `controller.init` | 父 `setState` 改 `value` / `children` |
| 省略 `value` 自动选首项 | **禁止**；必须传 `value` |
| 构造器 `themeData:` | `mergeExtension(TSideBarThemeData(...))` |

### 🗑️ 移除

| 从（0.2.x） | 怎么改 |
|------------|--------|
| `onSelected` | 统一为 `onChanged` |
| `controller` 构造参数 | 删除；切项 / 列表 / 加载均由父 State + 构造器 `value` / `children` / `loading` |
| `TSideBarController` | 移出 export；不保留命令式 API |
| `SideItemProps` | 内部类型；随 Controller 移除 |

### 📦 迁入 Theme

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| 构造器 `style` / `selectedColor` / `height` 等 L4 | `TSideBarThemeData` | 见 §3 |

---

## §3 Theme 主题配置

`TSideBarThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 / 子树 / 全局 | `mergeExtension(TSideBarThemeData(...))` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TSideBarThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘无 P2 Material 子主题）。

| 决策 | 字段 | 管什么 | 0.2.x 来源 |
|------|------|--------|-----------|
| 📦 | `style` | `normal` / `outline` 形态 | 构造器 `style` |
| 📦 | `selectedColor` / `unSelectedColor` | 文字色 | 同名 |
| 📦 | `selectedBgColor` / `unSelectedBgColor` | 背景色 | 同名 |
| 📦 | `selectedTextStyle` | 选中字形 | 同名 |
| 📦 | `contentPadding` / `height` | 布局 | 同名 |

#### 字段归类：进 Theme 与不进 Theme

本组件为自绘侧边导航（无 Material 等价薄包装）；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TSideBarThemeData`（P1，可主题化）**
- `style`（`normal` / `outline`）· `selectedColor` / `unSelectedColor` / `selectedBgColor` / `unSelectedBgColor` · `selectedTextStyle` · `contentPadding` · `height`

**不进 Theme（构造器 L1/L2/L3）**
- `loading`（L1）· `loadingWidget`（L2）· `value`（L1）· `onChanged`（L3）· `children`（L2）· 项级 `textStyle`（L2）

---

## §4 实现约定 · 测试与 Example 契约

**文件**：`t_sidebar.dart` · `t_sidebar_item.dart` · `t_sidebar_theme_data.dart`（**移除** `t_sidebar_controller.dart`）。

### 布局默认（现网参考）

| 项 | 默认 |
|----|------|
| 最小宽度 | `106` |
| 单项高度 | `56` |
| 列表 | `ListView` · `ClampingScrollPhysics` |

**必测**：受控 `value`+`onChanged`（点击触发）· 父改 `value` 同步高亮 · `onChanged: null` · `disabled` 单项 · `value` 必填不自动首项 · `loading` / `loadingWidget` · `TSideBarStyle` Theme · **无** `onSelected` / `TSideBarController`。

**Example**：`defaultValue→value` · B 类受控示例 · 父 `setState` 切项 · 单项/整栏禁用 · Theme `style` 覆盖。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [sidebar-upgrade-guide.md](./sidebar-upgrade-guide.md)（类名与 **§1** 冲突时以 **§1** 为准）
