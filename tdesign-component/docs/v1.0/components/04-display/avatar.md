# TAvatar — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/avatar`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | CircleAvatar |
| Theme | `TAvatarThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TAvatarThemeData`** |

## 控制方案

控制类 **A**：`onTap`；**不提供** `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `src` | `String?` | L2 | — | 图片 URL / asset / file path |
| | `child` | `Widget?` | L2 | — | 自定义内容（替代图片） |
| | `text` | `String?` | L2 | — | 文字头像 |
| | `icon` | `Icon?` | L2 | — | 图标头像 |
| ✨ | `size` | `TAvatarSize` | L1 | `medium` | 尺寸 |
| ✨ | `variant` | `TAvatarVariant` | L1 | `circle` | 形态（circle / square） |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`fit`（图片适配）由内部 `Image` 自动处理；`onLongPress` 不提供（A 类组件一般不需要长按）。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TAvatarSize` | `large` · `medium` · `small` | `size` 参数 |
| ✨ | `TAvatarVariant` | `circle` · `square` | `variant` 参数 |
| ✨ | `TAvatarThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TAvatarType` | `variant` 参数 |
| 📦 | `TAvatarShape` | `variant` 参数 |
| 📦 | `onTap` (0.2.x) | `onTap`（命名对齐） |
| 📦 | `shape` / `radius` / `avatarSize` / `avatarDisplayBorder` / `backgroundColor` | `TAvatarThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TAvatarType` | `variant` | 枚举化 |
| `TAvatarShape` | `variant` | 枚举化 |
| `onTap` | `onTap` | 命名对齐 |
| `shape` | `TAvatarThemeData` | L4 → Theme |
| `radius` | `TAvatarThemeData` | L4 → Theme |
| `avatarSize` | `TAvatarThemeData` | L4 → Theme |
| `avatarDisplayBorder` | `TAvatarThemeData` | L4 → Theme |
| `backgroundColor` | `TAvatarThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 原因 |
|------------|------|
| `fit` | 图片适配由内部 `Image` 自动处理 |
| `onLongPress` | A 类组件一般不需要长按 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TAvatarThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `shape` | `shape` | 见 §3 末列 |
| `radius` | `radius` | 见 §3 末列 |
| `avatarSize` | `defaultSize` | 见 §3 末列 |
| `avatarDisplayBorder` | `border` | 见 §3 末列 |
| `backgroundColor` | `backgroundColor` | 见 §3 末列 |

> 注：Material `CircleAvatar` 的 `backgroundImage`/`foregroundImage`/`child`/`radius`/`backgroundColor`/`foregroundColor` 由 Material 参数处理，TDesign 扩展字段在 `TAvatarThemeData` 中。图片 `fit` 由内部 `Image` 自动处理。

> 子组件内部使用的 `TAvatar` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TAvatarThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TAvatarThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TAvatarThemeData 字段

> TDesign 扩展字段（Material `CircleAvatar` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `shape` | 头像形态（circle/square） | `TAvatarShape` |
| 📦 | `radius` | 圆角半径 | `radius` |
| 📦 | `defaultSize` | 默认尺寸 | `avatarSize` |
| 📦 | `border` | 边框样式 | `avatarDisplayBorder` |
| 📦 | `backgroundColor` | 背景色 | `backgroundColor` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_avatar.dart` — Widget 本体
  - `t_avatar_resolve.dart` — **唯一**样式合并入口
  - `t_avatar_theme_data.dart` — `TAvatarThemeData` ThemeExtension

- **底层实现**：包装 Material `CircleAvatar`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 图片头像 | ✅ | `src` 加载 |
| 文字头像 | ✅ | `text` 参数 |
| 形态切换 | ✅ | `variant: TAvatarVariant.square` |
| 尺寸切换 | ✅ | `size: TAvatarSize.large` |
| 点击交互 | ✅ | `onTap` 回调 |

### 4.3 Example 契约

- 覆盖 `src` / `text` / `icon` 三种内容形式
- 覆盖 `variant` 形态切换
- 覆盖 `size` 尺寸切换

---

### export

- **保留**：`TAvatar`、`TAvatarSize`、`TAvatarVariant`、`TAvatarThemeData`
- **移出**：内部绘制 helper、未公开 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TAvatarThemeData` · Material: **CircleAvatar** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundImage` / `foregroundImage` | Material **`CircleAvatar`** | 实例 `src` / `child` |
| `child` | Material **`CircleAvatar`** | 实例 `text` / `icon` |
| `radius` / `backgroundColor` / `foregroundColor` | Material **`CircleAvatar`** | 默认 → **`TAvatarThemeData`** |
| `avatarDisplayList` / 组叠 | TDesign 扩展 | 头像组业务槽位 **KEEP** |
| `shape` / `radius` / `defaultSize` / `border` | TDesign **`TAvatarThemeData`** | L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
