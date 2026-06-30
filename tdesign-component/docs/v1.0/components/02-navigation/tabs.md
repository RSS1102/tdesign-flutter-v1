# Tabs — v1.0 定稿

> Sprint **S3** | 源码：`lib/src/components/tabs` · [guide](../guide/developer-guide.md)  
> 官网 [Tabs 选项卡](https://tdesign.tencent.com/flutter/components/tabs) · 涵盖 **TTab** · **TTabBar** · **TTabBarView**

**读法**：新写 v1.0 → **§1**（按子组件查表 + **§2** Theme）；0.2.x 升级 → 各子组件迁移表 · [tab-upgrade-guide.md](./tab-upgrade-guide.md)

**合并说明**：以下废弃文件（一组件一文件）已并入本文档：[tab-废弃.md](./tab-废弃.md) · [tab-bar-废弃-ttabbar.md](./tab-bar-废弃-ttabbar.md) · [tab-bar-view-废弃.md](./tab-bar-view-废弃.md)。

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件组合；样式进共享 `TTabBarThemeData` |
| Material | Tab · Material TabBar · TabBarView |
| Theme | `TTabBarThemeData`（三组件共享） |
| 禁用 | TTab：`enabled: false`；容器无统一 bool |
| L4 | 构造器 L4 → `TTabBarThemeData` |

`TTabBar` 与 `TTabBarView` 共用 `TabController`；`TTabBarView` 默认 `physics: NeverScrollableScrollPhysics()`（与 0.2.x 一致）。

## 受控

无受控 value；按子交互控件控制类处理。

---

## 1. API

### TTab

#### 保留

| 符号 | 说明 |
| --- | --- |
| TTabSize | 尺寸/位置枚举保留 |
| size | 选项卡尺寸 |
| text | KEEP：L1–L3 高频 / Material 同名 |
| child | KEEP：L1–L3 高频 / Material 同名 |
| icon | KEEP：L1–L3 高频 / Material 同名 |

#### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TTabOutlineType | variant 枚举 | 对齐 Material |
| enable | enabled: false | Material 禁用 |
| badge | TTabBarThemeData | L4 → Theme |
| iconMargin | TTabBarThemeData | L4 → Theme |
| height | TTabBarThemeData | L4 → Theme |
| contentHeight | TTabBarThemeData | L4 → Theme |
| textMargin | TTabBarThemeData | L4 → Theme |
| outlineType | TTabBarThemeData | L4 → Theme |
| calculatedHeight | TTabBarThemeData | L4 → Theme |

#### 废弃

_无_

#### 新增

_无_

---

### TTabBar

#### 保留

| 符号 | 说明 |
| --- | --- |
| width | tabBar宽度 |
| controller | KEEP：L1–L3 高频 / Material 同名 |

#### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TTabBarOutlineType | variant 枚举 | 对齐 Material |
| labelStyle | TTabBarThemeData | L4 → Theme |
| unselectedLabelStyle | TTabBarThemeData | L4 → Theme |
| decoration | TTabBarThemeData | L4 → Theme |
| backgroundColor | TTabBarThemeData | L4 → Theme |
| indicatorColor | TTabBarThemeData | L4 → Theme |
| indicatorHeight | TTabBarThemeData | L4 → Theme |
| indicatorWidth | TTabBarThemeData | L4 → Theme |
| labelColor | TTabBarThemeData | L4 → Theme |
| unselectedLabelColor | TTabBarThemeData | L4 → Theme |
| isScrollable | TTabBarThemeData | L4 → Theme |
| height | TTabBarThemeData | L4 → Theme |
| indicatorPadding | TTabBarThemeData | L4 → Theme |
| indicator | TTabBarThemeData | L4 → Theme |
| showIndicator | TTabBarThemeData | L4 → Theme |
| physics | TTabBarThemeData | L4 → Theme |
| labelPadding | TTabBarThemeData | L4 → Theme |
| outlineType | TTabBarThemeData | L4 → Theme |
| dividerColor | TTabBarThemeData | L4 → Theme |
| dividerHeight | TTabBarThemeData | L4 → Theme |
| selectedBgColor | TTabBarThemeData | L4 → Theme |
| unSelectedBgColor | TTabBarThemeData | L4 → Theme |
| tabAlignment | TTabBarThemeData | L4 → Theme |

#### 废弃

_无_

#### 新增

_无_

禁用：读子项 [TTab.enabled](#ttab)。

---

### TTabBarView

#### 保留

| 符号 | 说明 |
| --- | --- |
| children | KEEP：Material `TabBarView.children` |
| controller | Material `TabBarView.controller`；与 TTabBar 共用 `TabController` |

#### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| isSlideSwitch | physics | 对齐 Material |
| — | — | 新增 Material `dragStartBehavior` / `clipBehavior`（可选） |
| 默认不可滑动 | physics: NeverScrollableScrollPhysics() | L4 → Theme |

#### 废弃

| 符号 | 原因 |
| --- | --- |
| isSlideSwitch | 由 `physics` 表达 |

#### 新增

| 符号 | 说明 |
| --- | --- |
| physics | Material `TabBarView.physics` |
| dragStartBehavior | Material `TabBarView.dragStartBehavior` |
| clipBehavior | Material `TabBarView.clipBehavior` |

---

### export（合计）

- **保留**：`TTab`、`TTabSize`、`TTabBar`、`TTabBarVariant`、`TTabBarView`、`TTabBarThemeData`
- **移出**：`TTabBarOutlineType`（改名 `TTabBarVariant`）、`t_horizontal_tab_bar.dart` fork、内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TTabBarThemeData` · 三组件共享 · [theme.md](../foundation/theme.md)

### TTab

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `indicatorColor` / `labelStyle` / `dividerColor` | Material **`TabBarTheme`** | Tab 指示器与标签 |
| `conMarg` | TDesign **`TTabBarThemeData`** | 0.2.x L4 迁入（§1 TTab 迁移表） |

### TTabBar

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `tabs` / `controller` | Material **`TabBar`** | **实例 KEEP**；与 Material 同级 |
| `onTap` | Material **`TabBar.onTap`** | **`ValueChanged<int>?`**；保留名（[api §3](../foundation/api.md#3-动作回调)） |
| `isScrollable` / `tabAlignment` | Material **`TabBar`** | 可滚动与对齐 |
| `indicatorColor` / `indicatorWeight` / `indicatorPadding` / `indicator` | Material **`TabBarTheme`** | 指示器 |
| `labelColor` / `unselectedLabelColor` / `labelStyle` / `unselectedLabelStyle` | Material **`TabBarTheme`** | 标签样式 |
| `dividerColor` / `dividerHeight` | Material **`TabBarTheme`** | 底部分割线 |
| `overlayColor` / `splashFactory` | Material **`TabBarTheme`** | 水波纹 |
| `enableFeedback` | Material **`TabBar`** | 触觉；≠ 禁用 |
| `variant`（outlineType）/ `selectedBgColor` / `unSelectedBgColor` / `decoration` | TDesign **`TTabBarThemeData`** | TDesign 胶囊/卡片形态与块背景 |

### TTabBarView

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `children` | Material **`TabBarView`** | 页面列表 |
| `controller` | Material **`TabBarView`** | 与 **`TabBar`** 共享 |
| `physics` | Material **`TabBarView`** | 是否允许手势滑页；0.2.x `isSlideSwitch` 映射 |
| `dragStartBehavior` | Material **`TabBarView`** | 拖拽行为 |
| `clipBehavior` | Material **`TabBarView`** | 裁剪 |
| 默认 `physics` | TDesign **`TTabBarThemeData`** | 默认 **`NeverScrollableScrollPhysics`**（与 0.2.x 一致） |
| Tab 指示器/标签样式 | Material **`TabBarTheme`** | 属 **TTabBar**，非 TabBarView |
