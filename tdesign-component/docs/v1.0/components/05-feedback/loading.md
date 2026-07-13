# TLoading

> Sprint **S3** | 控制类 **A** | Material: CircularProgressIndicator / LinearProgressIndicator 包装

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | CircularProgressIndicator / LinearProgressIndicator |
| Theme | `TLoadingThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TLoadingThemeData`** |

## 控制方案

控制类 **A**：`onTap`；**不提供** `value`。禁用：`onTap: null`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `child` | `Widget?` | L2 | — | 自定义内容（替代默认圆环） |
| ✨ | `variant` | `TLoadingVariant` | L1 | `circular` | 形态（circular / linear） |
| | `text` | `String?` | L2 | — | 加载文案 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`size`（尺寸）为 L4 样式，迁入 `TLoadingThemeData.defaultSize`。`textPadding`（文字内边距）删除，由业务层 `Text` 控制。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TLoadingVariant` | `circular` · `linear` | `variant` 参数 |
| ✨ | `TLoadingSize` | `small` · `medium` · `large` | `defaultSize` 参数 |
| ✨ | `TLoadingThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `color` / `backgroundColor` / `textColor` / `fontSize` / `width` / `height` | `TLoadingThemeData` |
| 🗑️ | `size` | `TLoadingThemeData.defaultSize` |
| 🗑️ | `textPadding` | 文字内边距由业务层 `Text` 控制 |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `disabled` | 无 Widget 级禁用 | 纯展示组件 |
| `color` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `backgroundColor` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `textColor` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `fontSize` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `width` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `height` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `size` | `TLoadingThemeData` | L4 样式迁入 Theme |
| `textPadding` | 删除 | 文字内边距由业务层控制 |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TLoadingThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `color` | `color` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `fontSize` | `fontSize` | 见 §3 末列 |
| `width` | `width` | 见 §3 末列 |
| `height` | `height` | 见 §3 末列 |
| `size` | `defaultSize` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `TLoadingVariant` | 形态枚举 |
| `TLoadingThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 `variant`（尺寸经 `TLoadingThemeData.defaultSize`） |
| 子树 | `Theme.of(context).mergeExtension(TLoadingThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TLoadingThemeData` |

### 3.2 TLoadingThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `defaultSize` | `TLoadingSize` | 默认尺寸 | `size` |
| `color` | `Color` | 圆环颜色 | `color` |
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `textColor` | `Color` | 文字颜色 | `textColor` |
| `fontSize` | `double` | 字体大小 | `fontSize` |
| `width` | `double` | 宽度（linear） | `width` |
| `height` | `double` | 高度（linear） | `height` |

> 注：`textPadding` 删除。文字内边距由业务层 `Text` 控制，组件不越界。

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_loading.dart` | TLoading Widget |
| `t_loading_theme_data.dart` | TLoadingThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础渲染 | 默认参数正常渲染（circular 形态） |
| linear 形态 | `variant: TLoadingVariant.linear` |
| Theme 覆盖 | `mergeExtension(TLoadingThemeData(...))` 生效 |

### Example 契约

- 覆盖 `variant`（`circular` / `linear`）组合
- 覆盖 Theme 覆盖

### export

- **保留**：`TLoading`、`TLoadingVariant`、`TLoadingThemeData`
- **移出**：内部 `*Style`、绘制 helper

## Material vs TDesign

| 项目 | 说明 |
|------|------|
| `color` / `strokeWidth` / `backgroundColor` / `valueColor` | Material **`CircularProgressIndicator`** |
| `backgroundColor` / `valueColor` / `animationDuration` | Material **`LinearProgressIndicator`** |
| `color` / `textColor` / `fontSize` / `width` / `height` / `textPadding` | TDesign **`TLoadingThemeData`** |
