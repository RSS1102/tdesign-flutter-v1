# TFooter — v1.0 定稿

> **状态**：规划中 | **控制类**：A | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/footer`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘页脚组件 |
| Material | 自绘（无 Material 同名控件） |
| Theme | `TFooterThemeData` |
| 禁用 | 纯展示组件无 Widget 级禁用开关。 |
| L4 | 构造器 L4 → **`TFooterThemeData`** |

## 控制方案

控制类 **A**：`onTap`；无 `value`。禁用：`onTap: null`。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `logo` | `Widget?` | L2 | — | 品牌 Logo |
| | `text` | `String?` | L2 | — | 底部文字 |
| | `links` | `List<TFooterLink>?` | L2 | — | 链接列表 |
| ✨ | `variant` | `TFooterVariant` | L1 | `text` | 形态（text / link / brand） |
| | `onTap` | `GestureTapCallback?` | L3 | — | 点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`width`（Logo 宽度）为 L4 样式，迁入 `TFooterThemeData`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TFooterVariant` | `text` · `link` · `brand` | `variant` 参数 |
| ✨ | `TFooterLink` | `text` · `url` · `onTap` | `links` 数据模型 |
| ✨ | `TFooterThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `TFooterType` | `variant` 参数 |
| 🗑️ | `width` | `TFooterThemeData` |
| 📦 | `height` | `TFooterThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `TFooterType` | `variant` | 枚举化 |
| `type` | `variant` | 命名对齐 v1.0 |
| `height` | `TFooterThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `width` | `TFooterThemeData` | L4 样式迁入 Theme |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TFooterThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `width` | `logoWidth` | 见 §3 末列 |
| `height` | `height` | 见 §3 末列 |

> 注：Material `Footer` 无对应控件，样式由 TDesign 自绘。

> 子组件内部使用的 `TFooter` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TFooterThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TFooterThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TFooterThemeData 字段

> TDesign 扩展字段（无 Material 同名控件，全部为 TDesign 自定义）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `logoWidth` | Logo 宽度 | `width` |
| 📦 | `height` | 默认高度 | `height` |
| 📦 | `textColor` | 文字颜色 | — |
| 📦 | `linkColor` | 链接颜色 | — |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_footer.dart` — Widget 本体
  - `t_footer_resolve.dart` — **唯一**样式合并入口
  - `t_footer_theme_data.dart` — `TFooterThemeData` ThemeExtension

- **底层实现**：自绘页脚组件（无 Material 同名控件）

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 形态切换 | ✅ | `variant: TFooterVariant.brand` |
| 链接列表 | ✅ | `links` 参数 |

### 4.3 Example 契约

- 覆盖 `variant` 形态切换
- 覆盖 `links` 链接列表
- 覆盖 `logo` 品牌 Logo

---

### export

- **保留**：`TFooter`、`TFooterVariant`、`TFooterLink`、`TFooterThemeData`
- **移出**：内部 `*Style`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TFooterThemeData` · Material: **—（自绘）** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `logo` / `text` / `links` | **实例 KEEP** | 页脚内容 |
| `variant` | **实例** | `text` / `link` / `brand` |
| `logoWidth` / 默认 `height` | TDesign **`TFooterThemeData`** | 尺寸 L4 |
| 文案色/链接色 | TDesign **`TFooterThemeData`** | 颜色 L4 |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
