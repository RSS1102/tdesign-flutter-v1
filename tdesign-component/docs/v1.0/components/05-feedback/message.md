# TMessage

> Sprint **S3** | 控制类 **E** | Material: 自绘

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 命令式组件（非 Widget） |
| Material | 自绘 Overlay |
| Theme | `TMessageThemeData` |
| 禁用 | 无 Widget 级禁用（命令式组件） |
| L4 | 构造器 L4 → **`TMessageThemeData`** |

## 控制方案

控制类 **E**：命令式调用 `showMessage()` / `hideMessage()` 控制显隐；**不提供**声明式 `value` / `onChanged`。禁用：不调 `showMessage`。

## §1 v1.0 定稿 API

### 1.1 构造器参数

> Message 是命令式组件，通过 `showMessage()` 函数调用，无构造器参数。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TMessageThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `backgroundColor` / `textColor` / `fontSize` / `maxLines` / `padding` / `borderRadius` | `TMessageThemeData` |

### §2 0.2.x → v1.0

#### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |

#### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `backgroundColor` | `TMessageThemeData` | L4 样式迁入 Theme |
| `textColor` | `TMessageThemeData` | L4 样式迁入 Theme |
| `fontSize` | `TMessageThemeData` | L4 样式迁入 Theme |
| `maxLines` | 删除 | 文字截断由业务层实现 |
| `padding` | `TMessageThemeData` | L4 样式迁入 Theme |
| `borderRadius` | `TMessageThemeData` | L4 样式迁入 Theme |

#### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TMessageThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `fontSize` | `fontSize` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `borderRadius` | `borderRadius` | 见 §3 末列 |

### ✨ 新增

| 新增符号 | 用途 |
|---------|------|
| `showMessage()` | 命令式显示 Message |
| `hideMessage()` | 命令式隐藏 Message |
| `TMessageThemeData` | ThemeExtension |

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | `showMessage()` 参数 |
| 子树 | `Theme.of(context).mergeExtension(TMessageThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TMessageThemeData` |

### 3.2 TMessageThemeData 字段

| 字段 | 类型 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| `backgroundColor` | `Color` | 背景色 | `backgroundColor` |
| `textColor` | `Color` | 文字颜色 | `textColor` |
| `fontSize` | `double` | 字体大小 | `fontSize` |
| `padding` | `EdgeInsets` | 内边距 | `padding` |
| `borderRadius` | `double` | 圆角 | `borderRadius` |

> 注：`maxLines` 删除。文字截断策略由业务层实现（如 `Text.overflow` / `Text.maxLines`），组件不越界。

## §4 实现约定 · 测试与 Example 契约

### 4.1 文件划分

| 文件 | 职责 |
|------|------|
| `t_message.dart` | 命令式 API（showMessage / hideMessage） |
| `t_message_theme_data.dart` | TMessageThemeData ThemeExtension |

### 4.2 必测场景

| 场景 | 预期 |
|------|------|
| 基础显示 | `showMessage(context, '提示')` 正常显示 |
| 隐藏 | `hideMessage(context)` 正常隐藏 |
| Theme 覆盖 | `mergeExtension(TMessageThemeData(...))` 生效 |

### Example 契约

- 覆盖 `showMessage` / `hideMessage` 基本用法
- 覆盖 Theme 覆盖

### export

- **保留**：`showMessage`、`hideMessage`、`TMessageThemeData`
- **移出**：内部 `*Style`、绘制 helper
