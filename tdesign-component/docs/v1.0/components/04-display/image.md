# TImage — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S2

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/image`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 动作控件薄包装 |
| Material | Image |
| Theme | `TImageThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TImageThemeData`** |

## 控制方案

控制类 **A**：`onTap`；**不提供** `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `src` | `String?` | L2 | — | 图片 URL / asset / file path |
| | `fit` | `BoxFit?` | L1 | `cover` | 图片适配方式 |
| | `frameBuilder` | `ImageFrameBuilder?` | L2 | — | 帧构建器（动画图片） |
| | `loadingBuilder` | `ImageLoadingBuilder?` | L2 | — | 加载中构建器 |
| | `errorBuilder` | `ImageErrorWidgetBuilder?` | L2 | — | 加载失败构建器 |
| | `filterQuality` | `FilterQuality?` | L1 | `low` | 滤镜质量 |
| | `alignment` | `AlignmentGeometry?` | L1 | `center` | 对齐方式 |
| | `repeat` | `ImageRepeat?` | L1 | `noRepeat` | 重复方式 |
| | `semanticLabel` | `String?` | L2 | — | 无障碍标签 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

_无（复用 Material 类型）_

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TImageType` | `variant` 参数 |
| 📦 | `height` / `color` / `opacity` / `filterQuality` / `alignment` / `repeat` / `centerSlice` / `matchTextDirection` / `gaplessPlayback` / `excludeFromSemantics` / `isAntiAlias` / `cacheHeight` / `cacheWidth` | `TImageThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TImageType` | `variant` | 枚举化 |
| `imgUrl` / `assetUrl` | `src` | 统一参数名 |
| `height` | `TImageThemeData` | L4 → Theme |
| `color` | `TImageThemeData` | L4 → Theme |
| `opacity` | `TImageThemeData` | L4 → Theme |
| `filterQuality` | `filterQuality` | 参数保留 |
| `alignment` | `alignment` | 参数保留 |
| `repeat` | `repeat` | 参数保留 |
| `centerSlice` | `TImageThemeData` | L4 → Theme |
| `matchTextDirection` | `TImageThemeData` | L4 → Theme |
| `gaplessPlayback` | `TImageThemeData` | L4 → Theme |
| `excludeFromSemantics` | `TImageThemeData` | L4 → Theme |
| `isAntiAlias` | `TImageThemeData` | L4 → Theme |
| `cacheHeight` | `TImageThemeData` | L4 → Theme |
| `cacheWidth` | `TImageThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

_无_

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TImageThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `height` | `height` | 见 §3 末列 |
| `color` | `color` | 见 §3 末列 |
| `opacity` | `opacity` | 见 §3 末列 |
| `centerSlice` | `centerSlice` | 见 §3 末列 |
| `matchTextDirection` | `matchTextDirection` | 见 §3 末列 |
| `gaplessPlayback` | `gaplessPlayback` | 见 §3 末列 |
| `excludeFromSemantics` | `excludeFromSemantics` | 见 §3 末列 |
| `isAntiAlias` | `isAntiAlias` | 见 §3 末列 |
| `cacheHeight` | `cacheHeight` | 见 §3 末列 |
| `cacheWidth` | `cacheWidth` | 见 §3 末列 |

> 注：Material `Image` 的 `width`/`height`/`fit`/`filterQuality`/`alignment`/`frameBuilder`/`loadingBuilder`/`errorBuilder` 与 Flutter 同名，**KEEP** 构造器。

> 子组件内部使用的 `TImage` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TImageThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TImageThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TImageThemeData 字段

> TDesign 扩展字段（Material `Image` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `height` | 默认高度 | `height` |
| 📦 | `color` | 着色 | `color` |
| 📦 | `opacity` | 透明度 | `opacity` |
| 📦 | `centerSlice` | 九宫格切片 | `centerSlice` |
| 📦 | `matchTextDirection` | 是否跟随文字方向 | `matchTextDirection` |
| 📦 | `gaplessPlayback` | 无缝播放 | `gaplessPlayback` |
| 📦 | `excludeFromSemantics` | 排除语义 | `excludeFromSemantics` |
| 📦 | `isAntiAlias` | 抗锯齿 | `isAntiAlias` |
| 📦 | `cacheHeight` | 缓存高度 | `cacheHeight` |
| 📦 | `cacheWidth` | 缓存宽度 | `cacheWidth` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_image.dart` — Widget 本体
  - `t_image_resolve.dart` — **唯一**样式合并入口
  - `t_image_theme_data.dart` — `TImageThemeData` ThemeExtension

- **底层实现**：包装 Material `Image`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 网络图片 | ✅ | `src` URL 加载 |
| Asset 图片 | ✅ | `src` asset 加载 |
| 加载中 | ✅ | `loadingBuilder` |
| 加载失败 | ✅ | `errorBuilder` |
| 点击交互 | ✅ | `onTap` 回调 |

### 4.3 Example 契约

- 覆盖 `src` 网络图片
- 覆盖 `src` Asset 图片
- 覆盖 `fit` 适配方式
- 覆盖 `frameBuilder` 动画图片

---

### export

- **保留**：`TImage`、`TImageThemeData`
- **移出**：`image_widget.dart` 内部 Widget（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TImageThemeData` · Material: **Image** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `width` / `height` / `fit` / `filterQuality` / `alignment` / `repeat` / `semanticLabel` | Material **`Image`** | 与 Flutter 同名，**KEEP** 构造器 |
| `frameBuilder` / `loadingBuilder` / `errorBuilder` | Material **`Image`** | 加载/错误构建器 |
| `cacheWidth` / `cacheHeight` | Material **`Image`** | 解码缓存尺寸 |
| `color` / `opacity` / `centerSlice` / `matchTextDirection` / `gaplessPlayback` / `isAntiAlias` | TDesign **`TImageThemeData`** | L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
