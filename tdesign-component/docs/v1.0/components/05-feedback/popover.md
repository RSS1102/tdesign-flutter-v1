# TPopover

> Sprint **S3** | 控制类 **E** | Material: Overlay + 自绘

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 弹层薄包装 |
| Material | Overlay + 自绘 |
| Theme | `TPopoverThemeData` |
| 禁用 | 无 Widget 级禁用（弹层组件） |
| L4 | 构造器 L4 → **`TPopoverThemeData`** |

## 控制方案

控制类 **E**：命令式调用 `showPopover()` / `hidePopover()` 或 `visible: true/false`；无 `value` / `onChanged`。禁用：不调 `showPopover` 或 `visible: false`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `target` | `Widget` | L2 | — | 触发弹层的子组件 |
| | `content` | `Widget` | L2 | — | 弹层内容 |
| ✨ | `placement` | `TPopoverPlacement` | L1 | `top` | 弹出位置 |
| ✨ | `visible` | `bool` | L1 | `false` | 是否显示（受控） |
| | `onVisibleChange` | `ValueChanged<bool>?` | L3 | — | 显示状态变更 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`offset`（弹层偏移）为 L4 样式，迁入 `TPopoverThemeData.offset`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TPopoverPlacement` | `top` · `bottom` · `left` · `right` · `auto` | `placement` 参数 |
| ✨ | `TPopoverThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `backgroundColor` / `borderRadius` / `padding` / `arrow` / `offset` | `TPopoverThemeData` |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `backgroundColor` | `TPopoverThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TPopoverThemeData` | L4 样式迁入 Theme |
| `padding` | `TPopoverThemeData` | L4 样式迁入 Theme |
| `arrow` | `TPopoverThemeData` | L4 样式迁入 Theme |
| `offset` | `TPopoverThemeData` | L4 样式迁入 Theme |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TPopoverThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `arrow` | `showArrow` | 见 §3 末列 |
| `offset` | `offset` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `TPopoverPlacement` | 弹出位置枚举 |
| `showPopover()` | 命令式显示 Popover |
| `TPopoverThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | `showPopover()` 参数 |
| 子树 | `Theme.of(context).mergeExtension(TPopoverThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TPopoverThemeData` |

### 3.2 TPopoverThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |
| `padding` | `EdgeInsets` | 内边距 | `padding` |
| `showArrow` | `bool` | 是否显示箭头 | `arrow` |
| `offset` | `Offset` | 弹层偏移 | `offset` |

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_popover.dart` | TPopover Widget / 命令式 API |
| `t_popover_theme_data.dart` | TPopoverThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础渲染 | 默认参数正常渲染 |
| 弹出位置 | `placement: TPopoverPlacement.bottom` |
| Theme 覆盖 | `mergeExtension(TPopoverThemeData(...))` 生效 |

### Example 契约

- 覆盖 `placement` 组合
- 覆盖 Theme 覆盖

### export

- **保留**：`TPopover`、`showPopover`、`hidePopover`、`TPopoverPlacement`、`TPopoverThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| `behavior` / `clickThrough` / `shape` / `elevation` | Material **`PopupMenuItem`** |
| `backgroundColor` / `borderRadius` / `padding` / `showArrow` | TDesign **`TPopoverThemeData`** |
