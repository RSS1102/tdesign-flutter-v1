# TSwiper — v1.0 定稿

> **状态**：规划中 | **控制类**：B | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/swiper`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | PageView |
| Theme | `TSwiperThemeData` |
| 禁用 | 容器/展示无统一 bool。 |
| L4 | 构造器 L4 → **`TSwiperThemeData`** |

## 控制方案

控制类 **B**：`value`（当前页 index）+ `onChanged`；初值父 State。禁用：`onChanged: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `children` | `List<Widget>` | L2 | — | 子页内容（与 `itemBuilder` 二选一） |
| | `itemBuilder` | `Widget Function(BuildContext, int)` | L2 | — | 子页构建器（与 `children` 二选一） |
| | `itemCount` | `int` | L2 | — | 配合 `itemBuilder` 使用 |
| | `value` | `int` | L1 | `0` | 受控当前页 index |
| ✨ | `onChanged` | `ValueChanged<int>?` | L3 | — | 页切换回调 |
| ✨ | `loop` | `bool` | L1 | `false` | 无限循环 |
| ✨ | `autoplay` | `bool` | L1 | `false` | 自动播放 |
| ✨ | `pagination` | `TSwiperPaginationVariant` | L1 | `dots` | 指示器形态 |
| ✨ | `paginationAlignment` | `AlignmentGeometry` | L1 | `bottomCenter` | 指示器对齐 |
| ✨ | `pageEffect` | `TSwiperPageEffect` | L1 | `none` | 切换效果 |
| | `physics` | `ScrollPhysics?` | L1 | — | 滚动物理（Material `PageView.physics`） |
| | `pageSnapping` | `bool` | L1 | `true` | 页面吸附（Material `PageView.pageSnapping`） |
| | `padEnds` | `bool` | L1 | `true` | 边缘填充（Material `PageView.padEnds`） |
| | `clipBehavior` | `Clip` | L1 | `hardEdge` | 裁剪行为（Material `PageView.clipBehavior`） |
| | `reverse` | `bool` | L1 | `false` | 反向滚动（Material `PageView.reverse`） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TSwiperPaginationVariant` | `none` · `dots` · `dotsBar` · `fraction` · `controls` | `pagination` 参数 |
| ✨ | `TSwiperPageEffect` | `none` · `cardMargin` · `scaleAndFade` | `pageEffect` 参数 |
| ✨ | `TSwiperThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TSwiperController` | `value` + `onChanged`（单轨） |
| 🚫 | `Swiper`（flutter_swiper） | `TSwiper`（内部 `PageView`） |
| 📦 | `TSwiperPagination` / `TSwiperDotsPagination` / `TFractionPagination` / `TSwiperArrowPagination` | `TSwiperPaginationVariant` |
| 📦 | `TPageTransformer` | `TSwiperPageEffect` |
| 📦 | `pagination.margin` / `dotsColor` / `dotsActiveColor` 等 | `TSwiperThemeData` |
| 📦 | `autoplayDelay` | `TSwiperThemeData.autoplayInterval` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `SwiperPagination` | `pagination` | L4 → Theme |
| `onIndexChanged` | `onChanged` | 命名对齐 v1.0 |
| `index` / 当前页 | `value` | 命名对齐 v1.0 |
| `transformer` / `TPageTransformer` | `pageEffect` | 命名对齐 v1.0 |
| `scale`（Swiper 构造器） | `pageEffect: scaleAndFade` | 并入效果 |
| `pagination.builder` | `pagination` | L4 → Theme |
| `pagination.alignment` | `paginationAlignment` | 命名对齐 v1.0 |
| `TSwiperPagination.margin` | `TSwiperThemeData.paginationMargin` | L4 → Theme |
| `TSwiperDotsPagination.*` 色/尺寸 | `TSwiperThemeData` | L4 → Theme |
| `autoplayDelay` | `TSwiperThemeData.autoplayInterval` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TSwiperController` | `value` + `onChanged` | 单轨控制 |
| `flutter_swiper_null_safety` | 内部 `PageView` | 移除依赖 |
| `TPageTransformer` | `TSwiperPageEffect` | 枚举化 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TSwiperThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `pagination.margin` | `paginationMargin` | 见 §3 末列 |
| `TSwiperDotsPagination.activeColor` | `dotsActiveColor` | 见 §3 末列 |
| `TSwiperDotsPagination.inactiveColor` | `dotsInactiveColor` | 见 §3 末列 |
| `TSwiperDotsPagination.size` | `dotsSize` | 见 §3 末列 |
| `TFractionPagination.*` | `fractionStyle` | 见 §3 末列 |
| `autoplayDelay` | `autoplayInterval` | 见 §3 末列 |

> 注：Material `PageView` 的 `scrollDirection`/`reverse`/`physics`/`pageSnapping`/`padEnds`/`clipBehavior`/`dragStartBehavior`/`allowImplicitScrolling` 与 Flutter 同名，**KEEP** 构造器。

> 子组件内部使用的 `TSwiper` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TSwiperThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TSwiperThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TSwiperThemeData 字段

> TDesign 扩展字段（Material `PageView` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `paginationMargin` | 指示器边距 | `pagination.margin` |
| 📦 | `dotsActiveColor` | 指示点激活色 | `TSwiperDotsPagination.activeColor` |
| 📦 | `dotsInactiveColor` | 指示点未激活色 | `TSwiperDotsPagination.inactiveColor` |
| 📦 | `dotsSize` | 指示点尺寸 | `TSwiperDotsPagination.size` |
| 📦 | `fractionStyle` | 分页器样式 | `TFractionPagination.*` |
| 📦 | `autoplayInterval` | 自动播放间隔 | `autoplayDelay` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_swiper.dart` — Widget 本体（基于 `PageView`）
  - `t_swiper_theme_data.dart` — `TSwiperThemeData` ThemeExtension

- **底层实现**：基于 Material `PageView`（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 页切换 | ✅ | `value` + `onChanged` |
| 指示器形态 | ✅ | `pagination` 参数 |
| 自动播放 | ✅ | `autoplay` + `onChanged` |

### 4.3 Example 契约

- 覆盖 `children` / `itemBuilder` 子页内容
- 覆盖 `pagination` 指示器形态
- 覆盖 `autoplay` 自动播放

---

### export

- **保留**：`TSwiper`、`TSwiperPaginationVariant`、`TSwiperPageEffect`、`TSwiperThemeData`
- **移出**：`TSwiperController`、`TSwiperPagination` 旧 API、`TPageTransformer`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSwiperThemeData` · Material: **PageView** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `children` / `itemBuilder` / `itemCount` | Material **`PageView`** | 页面内容 |
| `value` / `onChanged` | TDesign 统一命名 | 对应 `onPageChanged` + 父 State 持页码 |
| `scrollDirection` / `reverse` | Material **`PageView`** | 轴向与方向 |
| `physics` / `pageSnapping` / `padEnds` | Material **`PageView`** | 滚动与吸附 |
| `viewportFraction` / `clipBehavior` / `reverse` | Material **`PageView`** | 视口与裁剪 |
| `loop` / `autoplay` / `autoplayInterval` | **TDesign 扩展** | 自动轮播；Material 无内置 |
| `pagination` / `paginationAlignment` | **TDesign 扩展** | 指示器布局与形态 |
| `pageEffect` | **TDesign 扩展** | 卡片 margin / scale+fade |
| dots / fraction 色、尺寸、间距 | TDesign **`TSwiperThemeData`** | L4 默认 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
