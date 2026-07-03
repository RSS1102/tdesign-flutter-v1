# TDialog

> Sprint **S3** | 控制类 **E** | Material: showDialog 包装

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 对话框薄包装 |
| Material | AlertDialog / Dialog |
| Theme | `TDialogThemeData` |
| 禁用 | 无 Widget 级禁用（命令式组件） |
| L4 | 构造器 L4 → **`TDialogThemeData`** |

## 控制方案

控制类 **E**：命令式调用 `showDialog()` / `pop()`；无 `value` / `onChanged`。禁用：不调 `showDialog`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `title` | `String?` | L2 | — | 标题 |
| | `content` | `String?` | L2 | — | 内容 |
| | `confirmText` | `String?` | L2 | — | 确认按钮文字 |
| | `cancelText` | `String?` | L2 | — | 取消按钮文字 |
| | `onConfirm` | `VoidCallback?` | L3 | — | 确认回调 |
| | `onCancel` | `VoidCallback?` | L3 | — | 取消回调 |
| ✨ | `width` | `double?` | L1 | — | 对话框宽度 |
| ✨ | `closeOnMaskTap` | `bool` | L1 | `true` | 点击遮罩是否关闭 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`showHeader`（是否显示头部）删除。Material `AlertDialog` 固定结构，标题区始终存在；如需隐藏标题，传入 `title: ''` 或不传 `title`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TDialogThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `titleColor` / `contentColor` / `confirmColor` / `cancelColor` / `backgroundColor` / `borderRadius` | `TDialogThemeData` |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `titleColor` | `TDialogThemeData` | L4 样式迁入 Theme |
| `contentColor` | `TDialogThemeData` | L4 样式迁入 Theme |
| `confirmColor` | `TDialogThemeData` | L4 样式迁入 Theme |
| `cancelColor` | `TDialogThemeData` | L4 样式迁入 Theme |
| `backgroundColor` | `TDialogThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TDialogThemeData` | L4 样式迁入 Theme |
| `showHeader` | 删除 | M3 AlertDialog 固定结构 |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TDialogThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `titleColor` | `titleColor` | 见 §3 末列 |
| `contentColor` | `contentColor` | 见 §3 末列 |
| `confirmColor` | `confirmColor` | 见 §3 末列 |
| `cancelColor` | `cancelColor` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `TDialogThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | `showDialog()` 参数 |
| 子树 | `Theme.of(context).mergeExtension(TDialogThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TDialogThemeData` |

### 3.2 TDialogThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `titleColor` | `Color` | 标题颜色 | `titleColor` |
| `contentColor` | `Color` | 内容颜色 | `contentColor` |
| `confirmColor` | `Color` | 确认按钮颜色 | `confirmColor` |
| `cancelColor` | `Color` | 取消按钮颜色 | `cancelColor` |
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_dialog.dart` | TDialog Widget |
| `t_dialog_theme_data.dart` | TDialogThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础渲染 | 默认参数正常渲染 |
| 确认回调 | `onConfirm` 触发 |
| 取消回调 | `onCancel` 触发 |
| Theme 覆盖 | `mergeExtension(TDialogThemeData(...))` 生效 |

### Example 契约

- 覆盖基础对话框
- 覆盖确认/取消回调
- 覆盖 Theme 覆盖

### export

- **保留**：`TDialog`、`TDialogThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| `title` / `content` / `actions` | Material **`AlertDialog`** |
| `backgroundColor` / `elevation` / `insetPadding` | Material **`Dialog`** |
| `titleColor` / `contentColor` / `confirmColor` / `cancelColor` / `borderRadius` | TDesign **`TDialogThemeData`** |
