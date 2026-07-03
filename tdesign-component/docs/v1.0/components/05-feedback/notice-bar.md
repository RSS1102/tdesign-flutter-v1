# TNoticeBar

> Sprint **S3** | 控制类 **A** | Material: 自绘

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | 自绘（Material 无对应控件） |
| Theme | `TNoticeBarThemeData` |
| 禁用 | `onTap: null`（交互禁用） |
| L4 | 构造器 L4 → **`TNoticeBarThemeData`** |

## 控制方案

控制类 **A**：`onTap`；无 `value`。禁用：`onTap: null`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `text` | `String` | L2 | — | 通知文案 |
| | `prefix` | `Widget?` | L2 | — | 左侧图标/组件 |
| ✨ | `variant` | `TNoticeBarVariant` | L1 | `primary` | 形态（primary / warning / error / success） |
| ✨ | `closable` | `bool` | L1 | `false` | 是否可关闭 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |
| | `onClose` | `VoidCallback?` | L3 | — | 关闭回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`scrollable`（是否滚动显示）删除。滚动行为由业务层 `SingleChildScrollView` 实现，组件不越界。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TNoticeBarVariant` | `primary` · `warning` · `error` · `success` | `variant` 参数 |
| ✨ | `TNoticeBarThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `backgroundColor` / `textColor` / `fontSize` / `padding` / `borderRadius` | `TNoticeBarThemeData` |
| 🗑️ | `scrollable` | 滚动由业务层 `SingleChildScrollView` 实现 |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `backgroundColor` | `TNoticeBarThemeData` | L4 样式迁入 Theme |
| `textColor` | `TNoticeBarThemeData` | L4 样式迁入 Theme |
| `fontSize` | `TNoticeBarThemeData` | L4 样式迁入 Theme |
| `padding` | `TNoticeBarThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TNoticeBarThemeData` | L4 样式迁入 Theme |
| `scrollable` | 删除 | 滚动由业务层实现 |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TNoticeBarThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `fontSize` | `fontSize` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `TNoticeBarVariant` | 形态枚举 |
| `TNoticeBarThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 `variant` + P0 `style`（如有） |
| 子树 | `Theme.of(context).mergeExtension(TNoticeBarThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TNoticeBarThemeData` |

### 3.2 TNoticeBarThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `textColor` | `Color` | 文字颜色 | `textColor` |
| `fontSize` | `double` | 字体大小 | `fontSize` |
| `padding` | `EdgeInsets` | 内边距 | `padding` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_notice_bar.dart` | TNoticeBar Widget |
| `t_notice_bar_theme_data.dart` | TNoticeBarThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础渲染 | 默认参数正常渲染 |
| 形态切换 | `variant: TNoticeBarVariant.warning` |
| Theme 覆盖 | `mergeExtension(TNoticeBarThemeData(...))` 生效 |

### Example 契约

- 覆盖 `variant` 形态
- 覆盖 Theme 覆盖

### export

- **保留**：`TNoticeBar`、`TNoticeBarVariant`、`TNoticeBarThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| — | Material 无对应控件 |
| `backgroundColor` / `textColor` / `fontSize` / `padding` / `borderRadius` | TDesign **`TNoticeBarThemeData`** |
