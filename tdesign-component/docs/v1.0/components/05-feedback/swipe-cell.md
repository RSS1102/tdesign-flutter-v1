# TSwipeCell — v1.0 定稿

> Sprint **S3** | 控制类 **—** | Material: flutter_slidable 包装
> 源码：`lib/src/components/swipe-cell` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 侧滑容器；**行为**留构造器 L3，**样式/动效**进 Theme |
| Material | flutter_slidable 包装 |
| Theme | `TSwipeCellThemeData`（色、间距、`duration`/`curve` 等） |
| 禁用 | 侧滑能力用 `enabled: false`（**非** A/B 类 `onPressed`/`onChanged`） |
| L4 | 样式默认 → `TSwipeCellThemeData` |

## 控制方案

无受控 `value`；展开态由 `SlidableController` / `opened` 等 **实例行为** 管理（**不进 Theme**）。


---

## 1. API

### 保留（实例 L1–L3）

| 符号 | 层级 | 说明 |
| --- | --- | --- |
| `child` | L2 | 主内容 |
| `left` / `right` | L2 | 操作区 actions |
| `TSwipeDirection` | L1 | 滑动方向 |
| `controller` | L1 | `SlidableController` |
| `direction` | L1 | 滑动方向约束 |
| `opened` | L3 | 是否展开（行为） |
| `groupTag` | L3 | 分组互斥 |
| `closeWhenOpened` / `closeWhenTapped` | L3 | 关闭策略 |
| `dragStartBehavior` | L3 | 拖拽起始行为 |
| `onChanged` | L3 | 展开态变化（原 `onChange`） |
| `enabled` | L3 | `false` 禁用侧滑（原 `disabled`） |
| `close` / `of` | — | static 工具方法 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| `onChange` | `onChanged` | 命名对齐 v1.0 |
| `disabled` | `enabled: false` | 侧滑专用禁用 |
| `slidableKey` | 构造器 / 内部 | **不进 Theme** |
| `cell` | `child` | 内容槽语义名 |
| `opened` / `groupTag` / `closeWhenOpened` / `closeWhenTapped` / `dragStartBehavior` | 构造器 L3 **KEEP** | 行为 → [theme.md §2.1](../foundation/theme.md#21-themedata-字段归类v10-裁决) |
| `duration`（及 `curve`） | `TSwipeCellThemeData` | 动效参数可进 Theme |

### 废弃

_无_

### export

- **保留**：`TSwipeCell`、`TSwipeDirection`、`TSwipeCellThemeData`
- **移出**：`flutter_slidable` re-export、`t_swipe_cell_inherited.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TSwipeCellThemeData` · 字段归类 → [theme.md §2.1](../foundation/theme.md#21-themedata-字段归类v10-裁决) · **禁止**构造器 `themeData`

### 进 Theme vs 留实例

| 字段 | 落点 | 说明 |
| --- | --- | --- |
| `duration` / `curve` | **`TSwipeCellThemeData`** | 过渡动效参数 |
| 操作区色 / 圆角 / 间距 | **`TSwipeCellThemeData`** | 样式 |
| `opened` / `closeWhen*` / `dragStartBehavior` / `groupTag` | **构造器 L3** | 行为策略 |
| `child` / `left` / `right` / `controller` | **实例** | 内容与控制 |
