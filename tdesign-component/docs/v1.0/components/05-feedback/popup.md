# TPopup

> Sprint **S3** | 控制类 **E** | Material: PopupMenuButton / Overlay 包装

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 弹层薄包装 |
| Material | PopupMenuButton / Overlay |
| Theme | `TPopupThemeData` |
| 禁用 | 无 Widget 级禁用（弹层组件） |
| L4 | 构造器 L4 → **`TPopupThemeData`** |

## 控制方案

控制类 **E**：命令式调用 `showPopup()` / `hidePopup()` 控制显隐；**不提供**声明式 `visible` / `value` / `onChanged`。禁用：不调 `showPopup()`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `child` | `Widget` | L2 | — | 触发弹层的子组件 |
| | `content` | `Widget` | L2 | — | 弹层内容 |
| ✨ | `placement` | `TPopupPlacement` | L1 | `bottom` | 弹出位置 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`offset`（弹层偏移）为 L4 样式，迁入 `TPopupThemeData.offset`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TPopupPlacement` | `top` · `bottom` · `left` · `right` | `placement` 参数 |
| ✨ | `TPopupThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `backgroundColor` / `borderRadius` / `padding` / `offset` | `TPopupThemeData` |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `backgroundColor` | `TPopupThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TPopupThemeData` | L4 样式迁入 Theme |
| `padding` | `TPopupThemeData` | L4 样式迁入 Theme |
| `offset` | `TPopupThemeData` | L4 样式迁入 Theme |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TPopupThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `offset` | `offset` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `TPopupPlacement` | 弹出位置枚举 |
| `TPopupThemeData` | ThemeExtension |

#### TPopup 业务壳约定

`TPopup` 是所有浮层类组件（Drawer / ActionSheet / DropdownMenu / Popover）的统一底座，**仅负责弹层容器与定位**。浮层策略（`showOverlay` / `closeOnOverlayClick` / `closeOnMaskTap` 等）由各自的命令式 `showXxx()` 持有，**不在 `TPopup` 构造器重复声明**，以避免跨组件重复定义；各业务壳按需透传自身的浮层策略参数即可。

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | `showPopup()` 参数（`placement` 等） |
| 子树 | `Theme.of(context).mergeExtension(TPopupThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TPopupThemeData` |

### 3.2 TPopupThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |
| `padding` | `EdgeInsets` | 内边距 | `padding` |
| `offset` | `Offset` | 弹层偏移 | `offset` |

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_popup.dart` | TPopup Widget |
| `t_popup_theme_data.dart` | TPopupThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础渲染 | 默认参数正常渲染 |
| 弹出位置 | `placement: TPopupPlacement.bottom` |
| Theme 覆盖 | `mergeExtension(TPopupThemeData(...))` 生效 |

### Example 契约

- 覆盖 `placement` 组合
- 覆盖 Theme 覆盖

### export

- **保留**：`TPopup`、`TPopupPlacement`、`TPopupThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| `child` / `onSelected` / `shape` / `elevation` / `menuConstraints` | Material **`PopupMenuButton`** |
| `backgroundColor` / `elevation` / `shadowColor` / `surfaceTintColor` | Material **`PopupMenuItem`** |
| `backgroundColor` / `borderRadius` / `padding` | TDesign **`TPopupThemeData`** |
