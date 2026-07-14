# TabBar — v1.0 定稿

> **状态**：已定稿 | **控制类**：B | **Sprint**：S3 · **Tier T2**  
> **源码**：`lib/src/components/tabbar/` · **类名**：`TTabBar`（0.2.x `TBottomTabBar`）  
> **官网**：[TabBar 标签栏](https://tdesign.tencent.com/flutter/components/tab-bar) · [guide](../../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 0.2.x → v1.0](#2-02x--v10)
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

合并：[bottom-tab-bar-废弃.md](./bottom-tab-bar-废弃.md)。页内选项卡 → [tabs.md](./tabs.md)（`TTabsBar`）。**须先完成 tabs 改名**，再改 `tabbar/`。

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | T2 自绘底部栏 |
| Material | 无等价薄包装（**非** `NavigationBar` 薄包装） |
| Theme | `TTabBarThemeData`（§3） |
| 禁用 | 整栏 `onChanged: null` |
| L4 | → `TTabBarThemeData`（§3） |

## 控制方案

控制类 **B**：**仅** `value` + `onChanged`；无 `defaultValue`；**`value` 必填**且由**父 State** 持有。用户点击 → `onChanged`；父 `setState` 回写 `value`。命令式切 tab 由父 `setState` 改 `value`，**无** `Controller` 辅助 API。禁用：`onChanged: null`。

**Material 对照**：对齐 M3 `NavigationBar`（`selectedIndex` + `onDestinationSelected`）/ `BottomNavigationBar`（`value` + `onTap`）；API 统一为 `value` + `onChanged`（→ [controlled.md §1.1](../../foundation/controlled.md#11-导航选中b-类)）。同类导航选中 → [sidebar.md](./sidebar.md)。**非** [tabs.md](./tabs.md) 的 `TabController` 持态。

→ [controlled.md](../../foundation/controlled.md) · [form.md §2](../../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。L4 默认走 §3（`mergeExtension`）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`variant`）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| ✏️ | `value` | `int` | L1 | — | 选中索引（原 `value`）；**必填**；见 **§1.1.1** |
| ✨ | `onChanged` | `ValueChanged<int>?` | L3 | — | 选中变化；与 `value` 成对；`null` 禁用整栏 |
| | `navigationTabs` | `List<TTabBarItemConfig>` | L2 | — | 底栏项（≥1） |
| ✏️ | `variant` | `TTabBarVariant?` | L1 | Theme | 合并原三枚举；去 positional `basicType` |
| | `useSafeArea` | `bool` | L1 | `true` | 底栏是否避让系统安全区；**布局策略**（→ §1.1.3） |
| | `placeholder` | `bool` | L1 | `true` | 与 `useSafeArea` 配套：是否为安全区补占位 |
| | `needInkWell` | `bool` | L3 | `false` | 是否启用水波纹；能力开关，**不进 Theme** |

> 样式默认经 `Theme.of(context).extension<TTabBarThemeData>()`；**禁止**构造器 `themeData`（→ [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。  
> 构造器可选 `Key`（`super.key`）见 [api.md §1.1](../../foundation/api.md#11-flutter-keywidget-基建)；**不进上表**。  
> **`value`**：0.2.x 兼容参数，KEEP；新代码用 `value`；解析见 **§1.1.1**。

#### §1.1.1 受控与回调（B 类）

有效索引：`effectiveIndex = value ?? value`（`value` 优先；**新代码须传 `value`**）。

凡**选中索引变化**，**仅**触发 **`onChanged`**（用户点击新 tab；父 `setState` 改 `value` **不**触发）。

| 触发源 | `onChanged` | 项 `onTap`（§1.1.2） |
|--------|-------------|----------------------|
| 用户点击**新** tab | ✅ | 按项规则 ✅ |
| 父 `setState` 改 `value` | — | — |
| 重复点击当前 tab | — | 仅 `allowMultipleTaps: true` 时 ✅ |
| `onChanged: null`（整栏禁用） | — | — |

```dart
int _index = 0;

TTabBar(
  value: _index,
  onChanged: (i) => setState(() => _index = i),
  navigationTabs: [
    TTabBarItemConfig(
      tabText: '首页',
      onTap: () => debugPrint('首页项旁听'),
    ),
    TTabBarItemConfig(tabText: '我的', onTap: () {}),
  ],
)

// 命令式切 tab：父 State 改 value（不经过 onChanged）
setState(() => _index = 1);
```

**`value` 规则**：

- **必填**；父 State 持初值；**不**自动选中首项（无 Widget 级默认 index）。
- 须满足 `0 <= value < navigationTabs.length`；越界实现 **assert**（与 0.2.x 一致）。
- **严格 B 类**：高亮由构造器 **`value`** 驱动；父 `setState` 改 `value` 后须同步高亮（`didUpdateWidget` 跟 `widget.value`），**不**仅靠组件内部 index / 局部 State 持选中态。

```dart
TTabBar(value: 1, onChanged: ..., navigationTabs: [...]);

// 父 State 更新 value 后，组件同步高亮
setState(() => _index = 2);
```

#### §1.1.2 项级 `onTap`（L3 旁听）

项 `onTap` 为 **L3 业务旁听**，与 Widget 级 **`onChanged`（选中闭环）** 并存：

- **选中变化**以 `onChanged` + 父回写 `value` 为准；**勿**在项 `onTap` 内自行 `setState` 改选中索引替代 `onChanged`。
- 点击时：若切换到新索引，先走 `onChanged` 闭环，再调项 `onTap`；若重复点击当前项，仅当 `allowMultipleTaps: true` 时调项 `onTap`。
- `onChanged: null` 时整栏不可切换，**不**触发项 `onTap`（对齐 Material 禁用）。

#### §1.1.3 安全区（`useSafeArea`）

对齐 [popup.md](../05-feedback/popup.md#3-theme) · [action-sheet.md](../05-feedback/action-sheet.md)：**`useSafeArea` / `placeholder` 为 L1 布局策略，不进 Theme**。

| 参数 | 默认 | 效果 |
|------|------|------|
| `useSafeArea: true` | ✅ | 底栏内容避开 Home 条等区域 |
| `useSafeArea: false` | | 贴边；页面外层自行 `SafeArea` |
| `placeholder: true` | ✅ | `useSafeArea` 时补底部占位高度 |
| `placeholder: false` | | 不补占位 |

```dart
TTabBar(
  value: _index,
  onChanged: (i) => setState(() => _index = i),
  useSafeArea: false,
  placeholder: false,
  navigationTabs: [...],
)
```

### 1.2 类型定义

#### TTabBarItemConfig

| 决策 | 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|------|
| | `onTap` | `VoidCallback?` | — | L3 项级业务旁听（→ §1.1.2） |
| | `tabText` | `String?` | — | 文案；`variant` 含 text 时必填 |
| | `selectedIcon` / `unselectedIcon` | `Widget?` | — | 图标；含 icon 形态时必填 |
| | `selectTabTextStyle` / `unselectTabTextStyle` | `TextStyle?` | — | 文案样式 |
| | `badgeConfig` | `TTabBarBadgeConfig?` | — | 角标 |
| | `popUpButtonConfig` | `TTabBarPopUpBtnConfig?` | — | 展开面板（`expansionPanel` 形态） |
| | `allowMultipleTaps` | `bool` | `false` | 允许重复点击当前项触发 `onTap` |
| | `onLongPress` | `GestureLongPressCallback?` | — | 长按 |

#### 其他类型

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TTabBar` | Widget |
| ✏️ | `TTabBarVariant` | 底栏形态（合并 `BasicType` · `ComponentType` · `OutlineType`）；与 [tabs.md](./tabs.md) 页内 `TTabBarVariant` **不同域**，落地时独立定义于 `tabbar/` |
| ✏️ | `TTabBarBadgeConfig` | 角标（原 `BadgeConfig`） |
| ✏️ | `TTabBarPopUpBtnConfig` / `TTabBarPopUpShapeConfig` / `TTabBarMenuItem` | 展开面板（原 `PopUpMenuItem`） |
| | `TTabBarIndicatorAnimation` | 指示器动效：`none` · `linear` · `elastic` |
| | `TTabBarThemeData` | ThemeExtension（§3） |

须提供 `TTabBarVariant.fromLegacy(basic, component, outline)` 映射 0.2.x 三枚举；具体枚举值实现阶段在 `t_tab_bar_variant.dart` 补全。

### 1.3 export

**KEEP**（`show` 导出）：`TTabBar` · `TTabBarItemConfig` · `TTabBarBadgeConfig` · `TTabBarPopUpBtnConfig` · `TTabBarPopUpShapeConfig` · `TTabBarMenuItem` · `TTabBarIndicatorAnimation` · `TTabBarVariant` · `TTabBarThemeData`。  
**deprecated 一 minor**：`TBottomTabBar` · `TBottomTabBarTabConfig` · `TBottomTabBarThemeData` · `BadgeConfig`（`tab_bar_deprecated.dart`）；三旧枚举经 **映射函数** 转 `TTabBarVariant`（不可直接 `typedef` 等同）。  
**不 export**：`PopRoute` · `PopupDialog` · `_TTabBarItemWithBadge` 等内部实现。  
PR-2 落地时删除 [tabs.md](./tabs.md) 临时 `typedef TTabBar = TTabsBar`。

---

## §2 0.2.x → v1.0

**未改**（§1 无图例项）：`navigationTabs` 项级角标 / 长按 / 展开面板 · `TTabBarIndicatorAnimation`

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TBottomTabBar` | `TTabBar` | 类名；deprecated 别名保留一 minor |
| `value` | `value` | 推荐新名；`value` KEEP；`value` 优先 |
| — | `onChanged` | **新增** B 类选中闭环 |
| positional `basicType` + `componentType` + `outlineType` | `variant: TTabBarVariant` | 去 positional；`fromLegacy` 迁移 |
| `TBottomTabBarTabConfig` | `TTabBarItemConfig` | 字段同名迁移 |
| `BadgeConfig` / `PopUpMenuItem` | `TTabBarBadgeConfig` / `TTabBarMenuItem` | 改名 |
| `TBottomTabBarThemeData` | `TTabBarThemeData` | ThemeExtension |

### ✏️ 行为对齐（B 类）

| 0.2.x | v1.0 |
|-------|------|
| 点击 tab 仅改内部 `_selectedIndex` | 点击新 tab → **`onChanged`**；父 `setState` 回写 **`value`** |
| 省略 `value` 默认 `0` | 新代码 **`value` 必填**；仅兼容路径可回落 `value` |
| 构造器 `themeData:` | `mergeExtension(TTabBarThemeData(...))` |

### 🗑️ 移除

| 从（0.2.x） | 怎么改 |
|------------|--------|
| 构造器 `themeData:` | `mergeExtension(TTabBarThemeData(...))`（→ §3） |
| 业务 `TTabBarController` 等 | 不引入；切 tab → 父 `setState` 改 `value` |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（`TTabBarThemeData`） | 怎么改 |
|------------------|---------------------------|--------|
| `barHeight` / 分割线 / 背景色 / 动效等 L4 | 同名字段 | 见 §3 |
| `useSafeArea` / `placeholder` / `needInkWell` | — | **保留构造器** L1/L3（不进 Theme） |

---

## §3 Theme 主题配置

`TTabBarThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 `variant`；或子树 `mergeExtension`（→ [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)，**无 P0**） |
| 子树 | `Theme.of(context).mergeExtension(TTabBarThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TTabBarThemeData` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TTabBarThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘无 P2 Material 子主题）。

> 现网 `TBottomTabBarThemeData` 尚无动效字段；实现 `TTabBarThemeData` 时须补齐下列 📦 项。

| 决策 | 字段 | 管什么 | 0.2.x 来源 |
|------|------|--------|-----------|
| ✨ | `defaultVariant` | 默认底栏形态 | — |
| 📦 | `barHeight` / 分割线 / `showTopBorder` / `topBorder` | 栏高与顶部分割 | 同名构造参数 |
| 📦 | `backgroundColor` / `selectedBgColor` / `unselectedBgColor` | 背景色 | 同名 |
| 📦 | `centerDistance` | 图标与文案间距 | 同名 |
| 📦 | `indicatorAnimation` / `animationDuration` / `animationCurve` | 指示器动效 | 同名构造参数 |

#### 字段归类：进 Theme 与不进 Theme

本组件为 T2 自绘底部栏（**非** Material `NavigationBar` 薄包装），**无** Material 等价；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TTabBarThemeData`（P1，可主题化）**
- `barHeight` · `showTopBorder` / `topBorder` · `backgroundColor` · `selectedBgColor` / `unselectedBgColor` · `centerDistance` · `indicatorAnimation` / `animationDuration` / `animationCurve`

**不进 Theme（构造器 L1/L2/L3）**
- `value`（L1）· `onChanged`（L3）· `navigationTabs`（L2）· `useSafeArea`（L1）· `placeholder`（L1）· `needInkWell`（L3）

---

## §4 实现约定 · 测试与 Example 契约

**文件**：`t_bottom_tab_bar.dart` → `t_tab_bar.dart`；`t_bottom_tab_bar_theme_data.dart` → `t_tab_bar_theme_data.dart`；新增 `tab_bar_deprecated.dart` · `t_tab_bar_resolve.dart`（规划）。

**Theme 合并**：L4 字段须按 §3 优先级解析（构造器 L1 **>** `Theme.extension<TTabBarThemeData>()` **>** 内置默认）；**禁止**构造器 `themeData` 参数。

**必测**：基础渲染 · 受控 `value`+`onChanged`（点击新 tab 触发）· 父改 `value` 同步高亮 · `value` 优先于 `value` · `value` 兼容 · 越界 assert · `onChanged: null` 禁用（不切 tab、不触发项 `onTap`）· 项 `onTap` / `allowMultipleTaps` · `variant` 矩阵 · 动效 · `useSafeArea`/`placeholder` · Theme 子树 · deprecated 别名 · export 不泄漏内部类 · **无**业务 Controller · **无**构造器 `themeData`。

**Example**：`value→value` · B 类受控示例 · 项 `onTap` 旁听 · 父 `setState` 切 tab · `onChanged: null` · `useSafeArea` · Theme `defaultVariant` 覆盖。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [tabs.md](./tabs.md) · [bottom-tab-bar-upgrade-guide.md](./bottom-tab-bar-upgrade-guide.md)（类名与 **§1** 冲突时以 **§1** 为准）
