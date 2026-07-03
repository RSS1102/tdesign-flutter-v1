# TTag — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/tag`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | Chip |
| Theme | `TTagThemeData` |
| 禁用 | `onTap: null`（交互禁用） |
| L4 | 构造器 L4 → **`TTagThemeData`** |

## 控制方案

控制类 **A**：`onTap`；无 `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `text` | `String?` | L2 | — | 标签文案 |
| | `icon` | `Icon?` | L2 | — | 图标 |
| | `size` | `TTagSize` | L1 | `medium` | 标签大小 |
| ✨ | `needCloseIcon` | `bool` | L1 | `false` | 是否显示关闭图标 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |
| ✨ | `onCloseTap` | `VoidCallback?` | L3 | — | 关闭图标点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TTagSize` | `large` · `medium` · `small` | `size` 参数 |
| ✨ | `TTagThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `disable` (0.2.x) / `style` / `iconWidget` / `textColor` / `backgroundColor` / `font` / `fontWeight` / `padding` / `forceVerticalCenter` / `isOutline` / `shape` / `isLight` / `needCloseIcon` / `overflow` / `fixedWidth` | `TTagThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |
| `disable` | 🗑️ 删除 | 交互禁用统一使用 `onTap: null` |
| `style` | `TTagThemeData` | L4 → Theme |
| `iconWidget` | `TTagThemeData` | L4 → Theme |
| `textColor` | `TTagThemeData` | L4 → Theme |
| `backgroundColor` | `TTagThemeData` | L4 → Theme |
| `font` | `TTagThemeData` | L4 → Theme |
| `fontWeight` | `TTagThemeData` | L4 → Theme |
| `padding` | `TTagThemeData` | L4 → Theme |
| `forceVerticalCenter` | `TTagThemeData` | L4 → Theme |
| `isOutline` | `TTagThemeData` | L4 → Theme |
| `shape` | `TTagThemeData` | L4 → Theme |
| `isLight` | `TTagThemeData` | L4 → Theme |
| `needCloseIcon` (0.2.x) | `needCloseIcon` | 参数保留 |
| `overflow` | `TTagThemeData` | L4 → Theme |
| `fixedWidth` | `TTagThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 0.2.x | 原因 |
| --- | --- |
| `disable` / `disabled` | 交互禁用统一使用 `onTap: null` |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TTagThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `style` | `colorScheme` | 见 §3 末列 |
| `textColor` | `textColor` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |
| `font` | `font` | 见 §3 末列 |
| `fontWeight` | `fontWeight` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `forceVerticalCenter` | `forceVerticalCenter` | 见 §3 末列 |
| `isOutline` | `isOutline` | 见 §3 末列 |
| `shape` | `shape` | 见 §3 末列 |
| `isLight` | `isLight` | 见 §3 末列 |
| `overflow` | `overflow` | 见 §3 末列 |
| `fixedWidth` | `fixedWidth` | 见 §3 末列 |

> 注：Material `ChipTheme` 的 `backgroundColor`/`labelStyle`/`side`/`padding` 由 Material 子主题处理，TDesign 扩展字段在 `TTagThemeData` 中。

> 子组件内部使用的 `TTag` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TTagThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TTagThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TTagThemeData 字段

> TDesign 扩展字段（Material `ChipTheme` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `colorScheme` | 颜色方案 | `style` / `theme` |
| 📦 | `textColor` | 文字颜色 | `textColor` |
| 📦 | `backgroundColor` | 背景色 | `backgroundColor` |
| 📦 | `font` | 字体 | `font` |
| 📦 | `fontWeight` | 字重 | `fontWeight` |
| 📦 | `padding` | 内边距 | `padding` |
| 📦 | `forceVerticalCenter` | 强制垂直居中 | `forceVerticalCenter` |
| 📦 | `isOutline` | 是否描边样式 | `isOutline` |
| 📦 | `shape` | 形态 | `shape` |
| 📦 | `isLight` | 是否轻量样式 | `isLight` |
| 📦 | `overflow` | 溢出处理 | `overflow` |
| 📦 | `fixedWidth` | 固定宽度 | `fixedWidth` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_tag.dart` — Widget 本体
  - `t_tag_resolve.dart` — **唯一**样式合并入口
  - `t_tag_theme_data.dart` — `TTagThemeData` ThemeExtension

- **底层实现**：包装 Material `Chip`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 关闭图标 | ✅ | `needCloseIcon: true` |
| 点击交互 | ✅ | `onTap` 回调 |
| 关闭交互 | ✅ | `onCloseTap` 回调 |

### 4.3 Example 契约

- 覆盖 `text` / `icon` 内容
- 覆盖 `needCloseIcon` 关闭图标
- 覆盖 `onTap` / `onCloseTap` 交互

---

### export

- **保留**：`TTag`、`TTagSize`、`TTagThemeData`
- **移出**：`TTagStyles`、`t_tag_styles.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TTagThemeData` · Material: **Chip** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundColor` / `labelStyle` / `side` / `padding` | Material **`ChipTheme`** | 标签/芯片 |
| `textColor` / `font` / `fixedWidth` / `colorScheme` | TDesign **`TTagThemeData`** | 0.2.x L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
