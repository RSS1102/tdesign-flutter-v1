# TActionSheet

> Sprint **S3** | 控制类 **E** | Material: showModalBottomSheet 包装

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 底部弹层薄包装 |
| Material | showModalBottomSheet |
| Theme | `TActionSheetThemeData` |
| 禁用 | 无 Widget 级禁用（命令式组件） |
| L4 | 构造器 L4 → **`TActionSheetThemeData`** |

## 控制方案

控制类 **E**：命令式调用 `showActionSheet()` / `hideActionSheet()`；无 `value` / `onChanged`。禁用：不调 `showActionSheet`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `actions` | `List<TActionSheetItem>` | L2 | — | 操作项列表 |
| | `cancelText` | `String?` | L2 | — | 取消按钮文字 |
| | `onActionTap` | `ValueChanged<int>?` | L3 | — | 操作项点击回调 |
| | `onCancel` | `VoidCallback?` | L3 | — | 取消回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TActionSheetItem` | `text` · `danger` | `actions` 数据模型 |
| ✨ | `TActionSheetThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `backgroundColor` / `textColor` / `cancelColor` / `borderRadius` | `TActionSheetThemeData` |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `backgroundColor` | `TActionSheetThemeData` | L4 样式迁入 Theme |
| `textColor` | `TActionSheetThemeData` | L4 样式迁入 Theme |
| `cancelColor` | `TActionSheetThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TActionSheetThemeData` | L4 样式迁入 Theme |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TActionSheetThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `cancelColor` | `cancelColor` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `showActionSheet()` | 命令式显示 ActionSheet |
| `TActionSheetItem` | 操作项数据模型 |
| `TActionSheetThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | `showActionSheet()` 参数 |
| 子树 | `Theme.of(context).mergeExtension(TActionSheetThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TActionSheetThemeData` |

### 3.2 TActionSheetThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `textColor` | `Color` | 文字颜色 | `textColor` |
| `cancelColor` | `Color` | 取消按钮颜色 | `cancelColor` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_action_sheet.dart` | 命令式 API（showActionSheet / hideActionSheet） |
| `t_action_sheet_theme_data.dart` | TActionSheetThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础显示 | `showActionSheet(context, actions: [...])` 正常显示 |
| 操作项点击 | `onActionTap` 触发 |
| 取消回调 | `onCancel` 触发 |
| Theme 覆盖 | `mergeExtension(TActionSheetThemeData(...))` 生效 |

### Example 契约

- 覆盖 `showActionSheet` 基本用法
- 覆盖操作项点击/取消回调
- 覆盖 Theme 覆盖

### export

- **保留**：`showActionSheet`、`hideActionSheet`、`TActionSheetItem`、`TActionSheetThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| `backgroundColor` / `elevation` / `shape` / `constraints` | Material **`showModalBottomSheet`** |
| `backgroundColor` / `borderRadius` / `textColor` / `cancelColor` | TDesign **`TActionSheetThemeData`** |
