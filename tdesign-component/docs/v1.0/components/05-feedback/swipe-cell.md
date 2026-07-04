# TSwipeCell

> Sprint **S3** | 控制类 **A** | Material: flutter_slidable 包装

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 侧滑控件薄包装 |
| Material | flutter_slidable |
| Theme | `TSwipeCellThemeData` |
| 禁用 | `enabled: false`（行为开关） |
| L4 | 构造器 L4 → **`TSwipeCellThemeData`** |

## 控制方案

控制类 **A**：无 `onTap`（侧滑后操作由 `leftActions`/`rightActions` 的 `onTap` 处理）。禁用：`enabled: false`（行为开关）。

> 注：`enabled` 是侧滑能力开关。侧滑后的点击操作由 `TSwipeAction.onTap` 处理，不在外层 `TSwipeCell` 暴露 `onTap`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `child` | `Widget` | L2 | — | 子组件（列表项内容） |
| ✨ | `leftActions` | `List<TSwipeAction>?` | L2 | — | 左侧滑出的操作项 |
| ✨ | `rightActions` | `List<TSwipeAction>?` | L2 | — | 右侧滑出的操作项 |
| ✨ | `enabled` | `bool` | L1 | `true` | 是否启用侧滑 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`onTap`（外层点击回调）删除。侧滑后操作由 `TSwipeAction.onTap` 处理，组件不暴露冗余回调。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TSwipeAction` | `text` · `onTap` · `danger` | `leftActions` / `rightActions` 数据模型 |
| ✨ | `TSwipeCellThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `backgroundColor` / `actionColor` / `textColor` / `borderRadius` | `TSwipeCellThemeData` |
| 🗑️ | `onTap` | 由 `TSwipeAction.onTap` 处理 |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `backgroundColor` | `TSwipeCellThemeData` | L4 样式迁入 Theme |
| `actionColor` | `TSwipeCellThemeData` | L4 样式迁入 Theme |
| `textColor` | `TSwipeCellThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TSwipeCellThemeData` | L4 样式迁入 Theme |
| `onTap` | 删除 | 由 `TSwipeAction.onTap` 处理 |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TSwipeCellThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `actionColor` | `actionColor` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `TSwipeAction` | 侧滑操作项数据模型 |
| `TSwipeCellThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 `enabled` |
| 子树 | `Theme.of(context).mergeExtension(TSwipeCellThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TSwipeCellThemeData` |

### 3.2 TSwipeCellThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `actionColor` | `Color` | 操作项颜色 | `actionColor` |
| `textColor` | `Color` | 文字颜色 | `textColor` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_swipe_cell.dart` | TSwipeCell Widget |
| `t_swipe_cell_theme_data.dart` | TSwipeCellThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础渲染 | 默认参数正常渲染 |
| 侧滑启用 | `enabled: true` 可侧滑 |
| 侧滑禁用 | `enabled: false` 不可侧滑 |
| 侧滑操作 | `leftActions`/`rightActions` 的 `onTap` 触发 |
| Theme 覆盖 | `mergeExtension(TSwipeCellThemeData(...))` 生效 |

### Example 契约

- 覆盖 `enabled` 开关
- 覆盖侧滑操作项
- 覆盖 Theme 覆盖

### export

- **保留**：`TSwipeCell`、`TSwipeAction`、`TSwipeCellThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| `key` / `delegate` / `actionPane` / `secondaryActions` / `endSecondaryActions` | flutter_slidable **`Slidable`** |
| `backgroundColor` / `actionExtent` / `actionPaneThreshold` | flutter_slidable **`Slidable`** |
| `textStyle` / `backgroundColor` / `margin` | flutter_slidable **`SlideAction`** |
| `backgroundColor` / `actionColor` / `textColor` / `borderRadius` | TDesign **`TSwipeCellThemeData`** |
