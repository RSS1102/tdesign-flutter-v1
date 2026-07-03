# TSkeleton — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/skeleton`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘占位组件 |
| Material | 自绘（无 Material 同名控件） |
| Theme | `TSkeletonThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TSkeletonThemeData`** |

## 控制方案

控制类 **A**：`onTap`；无 `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

#### TSkeleton（基础构造器）

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `rowCol` | `List<List<double>>?` | L2 | — | 自定义行列布局 |
| ✨ | `variant` | `TSkeletonVariant` | L1 | `text` | 预设形态（avatar / image / text / paragraph） |
| ✨ | `animation` | `TSkeletonAnimation` | L1 | `none` | 动画类型 |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

#### TSkeleton.fromRowCol() — 自定义布局工厂

> 用于自定义行列占位块布局。

```dart
TSkeleton.fromRowCol(
  rowCol: [
    [1.0],           // 第一行：1 个全宽块
    [0.3, 0.3, 0.3], // 第二行：3 个等宽块
  ],
  animation: TSkeletonAnimation.gradient,
  onTap: () { ... },
)
```

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TSkeletonVariant` | `avatar` · `image` · `text` · `paragraph` | `variant` 参数 |
| ✨ | `TSkeletonAnimation` | `none` · `gradient` · `flashed` | `animation` 参数 |
| ✨ | `TSkeletonThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TSkeletonTheme` | `variant` 参数 |
| 📦 | `animation` (0.2.x) / `delay` | `TSkeletonThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TSkeletonTheme` | `variant` | 枚举化 |
| `theme` | `variant` | 参数重命名 |
| `animation` (0.2.x) | `TSkeletonThemeData` | L4 → Theme |
| `delay` | `TSkeletonThemeData` | L4 → Theme |

### ✨ 新增

| 到（v1.0） | 说明 |
|-----------|------|
| `TSkeletonVariant` | 预设形态枚举 |
| `TSkeleton.fromRowCol()` | 自定义布局工厂 |
| `variant` | 由 `theme` 迁移 |

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TSkeletonTheme` | `TSkeletonVariant` | 枚举化 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TSkeletonThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `animation` (0.2.x) | `animation` | 见 §3 末列 |
| `delay` | `delay` | 见 §3 末列 |

> 注：`animation` 参数保留在构造器（L1 语义级），Theme 中为默认值。

> 子组件内部使用的 `TSkeleton` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TSkeletonThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TSkeletonThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TSkeletonThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `blockColor` | 占位块颜色 | — |
| 📦 | `gradientColors` | 渐变色列表 | — |
| 📦 | `borderRadius` | 圆角 | — |
| 📦 | `animation` | 动画类型默认值 | `animation` |
| 📦 | `delay` | 动画延迟 | `delay` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_skeleton.dart` — Widget 本体
  - `t_skeleton_resolve.dart` — **唯一**样式合并入口
  - `t_skeleton_theme_data.dart` — `TSkeletonThemeData` ThemeExtension

- **底层实现**：自绘占位块（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 预设形态 | ✅ | `variant` 参数 |
| 自定义布局 | ✅ | `fromRowCol()` 工厂 |
| 动画效果 | ✅ | `animation` 参数 |

### 4.3 Example 契约

- 覆盖 `variant` 各预设形态
- 覆盖 `fromRowCol()` 自定义布局
- 覆盖 `animation` 动画类型

---

### export

- **保留**：`TSkeleton`、`TSkeletonVariant`、`TSkeletonAnimation`、`TSkeletonThemeData`
- **移出**：`TSkeletonTheme`（enum）、`t_skeleton_rowcol.dart`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TSkeletonThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| 占位块布局 | **实例 KEEP** | `rowCol` / `TSkeletonVariant` 预设 |
| `animation` / `delay` | TDesign **`TSkeletonThemeData`** | 动画类型与延迟默认 |
| 块色 / 渐变 / 圆角 | TDesign **`TSkeletonThemeData`** | 自绘 L4 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
