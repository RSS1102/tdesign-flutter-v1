# TImageViewer — v1.0 定稿

> **状态**：规划中 | **控制类**：E | **Sprint**：S4

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/image-viewer`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Overlay / Route；命令式 `show` 为主 |
| Material | `showDialog` + 全屏 PageView |
| Theme | `TImageViewerThemeData` |
| 禁用 | 浮层无 Widget 级禁用；命令式由调用方控制 |
| L4 | show 色/字号/尺寸 → **`TImageViewerThemeData`** |

## 控制方案

控制类 **E**：命令式 `showImageViewer()` 为主；当前页由 `defaultIndex` + `onIndexChange` 通知。无 Widget 级 `disabled`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 show API（`showImageViewer`）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `context` | `BuildContext` | E 首参 | — | BuildContext |
| | `images` | `List<String>` | L2 | — | 图片列表（URL / asset / File） |
| | `labels` | `List<String>?` | L2 | — | 与 images 对齐的标签 |
| | `defaultIndex` | `int` | L1 | `0` | 初始页索引 |
| | `closeBtn` | `bool` | L1 | `true` | 是否显示关闭按钮 |
| | `deleteBtn` | `bool` | L1 | `false` | 是否显示删除按钮 |
| | `showIndex` | `bool` | L1 | `true` | 是否显示页码 |
| | `loop` | `bool` | L3 | `false` | 无限循环 |
| | `autoplay` | `bool` | L3 | `false` | 自动播放 |
| | `onClose` | `VoidCallback?` | L3 | — | 关闭回调 |
| | `onDelete` | `ValueChanged<int>?` | L3 | — | 删除回调 |
| | `onIndexChange` | `ValueChanged<int>?` | L3 | — | 页切换回调 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 图片点击回调 |
| | `onLongPress` | `GestureLongPressCallback?` | L3 | — | 图片长按回调 |
| | `leftItemBuilder` | `Widget Function()?` | L2 | — | 导航栏左侧槽位 |
| | `rightItemBuilder` | `Widget Function()?` | L2 | — | 导航栏右侧槽位 |
| | `barrierDismissible` | `bool` | L3 | `true` | 对齐 Material |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TImageViewerThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TImageViewerWidget` | `showImageViewer()` |
| 📦 | `bgColor` / `navBarBgColor` / `iconColor` | `TImageViewerThemeData` |
| 📦 | `labelStyle` / `indexStyle` | `TImageViewerThemeData` |
| 📦 | `width` / `height` | `TImageViewerThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `bgColor` | `TImageViewerThemeData.backgroundColor` | L4 → Theme |
| `navBarBgColor` | `TImageViewerThemeData.appBarBackgroundColor` | L4 → Theme |
| `iconColor` | `TImageViewerThemeData.iconColor` | L4 → Theme |
| `labelStyle` | `TImageViewerThemeData.labelStyle` | L4 → Theme |
| `indexStyle` | `TImageViewerThemeData.indexStyle` | L4 → Theme |
| `width` | `TImageViewerThemeData.viewerWidth` | L4 → Theme |
| `height` | `TImageViewerThemeData.viewerHeight` | L4 → Theme |
| `modalBarrierColor` | `TImageViewerThemeData.barrierColor` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TImageViewerThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `bgColor` | `backgroundColor` | 见 §3 末列 |
| `navBarBgColor` | `appBarBackgroundColor` | 见 §3 末列 |
| `iconColor` | `iconColor` | 见 §3 末列 |
| `labelStyle` | `labelStyle` | 见 §3 末列 |
| `indexStyle` | `indexStyle` | 见 §3 末列 |
| `width` | `viewerWidth` | 见 §3 末列 |
| `height` | `viewerHeight` | 见 §3 末列 |
| `modalBarrierColor` | `barrierColor` | 见 §3 末列 |

> 注：Material `DialogTheme` 的 `barrierColor`/`barrierDismissible` 由 Material 参数处理，TDesign 扩展字段在 `TImageViewerThemeData` 中。

> 子组件内部使用的 `TImageViewer` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单次调用 | `showImageViewer()` 参数 |
| 子树 | `Theme.of(context).mergeExtension(TImageViewerThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TImageViewerThemeData` |

### 3.2 覆盖顺序

`showImageViewer()` 参数 **>** `resolve（全量合并）` **>** Token

### 3.3 TImageViewerThemeData 字段

> TDesign 扩展字段（Material `DialogTheme` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `backgroundColor` | 全屏背景色 | `bgColor` |
| 📦 | `appBarBackgroundColor` | 导航栏背景色 | `navBarBgColor` |
| 📦 | `iconColor` | 图标颜色 | `iconColor` |
| 📦 | `labelStyle` | 标签样式 | `labelStyle` |
| 📦 | `indexStyle` | 页码样式 | `indexStyle` |
| 📦 | `viewerWidth` | 预览区宽度 | `width` |
| 📦 | `viewerHeight` | 预览区高度 | `height` |
| 📦 | `barrierColor` | 遮罩颜色 | `modalBarrierColor` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_image_viewer.dart` — Widget 本体
  - `t_image_viewer_theme_data.dart` — `TImageViewerThemeData` ThemeExtension

- **底层实现**：`showDialog` + 全屏 `PageView`（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 多图切换 | ✅ | `images` + `defaultIndex` |
| 页码显示 | ✅ | `showIndex: true` |
| 关闭交互 | ✅ | `onClose` 回调 |
| 删除交互 | ✅ | `deleteBtn: true` + `onDelete` 回调 |

### 4.3 Example 契约

- 覆盖 `images` 多图切换
- 覆盖 `showIndex` 页码显示
- 覆盖 `onClose` / `onDelete` 交互

---

### export

- **保留**：`TImageViewer`、`showImageViewer`、`TImageViewerThemeData`
- **移出**：`TImageViewerWidget`、`image_viewer_widget.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TImageViewerThemeData` · Material: **Dialog + 全屏预览** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `images` / `labels` / `defaultIndex` | **单次 show L2** | 业务内容与初始页 |
| 工具栏显隐 / 轮播 / 手势回调 | **单次 show L3** | 当次交互行为 |
| `showImageViewer` | **E 类首参** | `showDialog(context, …)` |
| 背景 / 导航栏 / 图标 / 文案色 | **`TImageViewerThemeData`** | L4 默认 |
| `barrierColor` / `barrierDismissible` | Material **`DialogTheme`** | 蒙层可单次覆盖 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
