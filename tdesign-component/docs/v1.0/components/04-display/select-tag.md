# TSelectTag — v1.0 定稿

> **状态**：规划中 | **控制类**：B | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/select-tag`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 选择控件薄包装 |
| Material | FilterChip |
| Theme | `TTagThemeData`（与 TTag 共用） |
| 禁用 | 交互锁定用 `onChanged: null`（B 类）。 |
| L4 | 构造器 L4 → **`TTagThemeData`** |

## 控制方案

控制类 **B**：`value` + `onChanged`；无 `defaultValue`。禁用：`onChanged: null`（组件自动读取 TDesign Token 的禁用色）。

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `value` | `bool` | L1 | — | 受控选中态 |
| | `onChanged` | `ValueChanged<bool>?` | L3 | — | 选中态变更 |
| | `text` | `String?` | L2 | — | 标签文案 |
| | `icon` | `Icon?` | L2 | — | 图标 |
| ✨ | `needCloseIcon` | `bool` | L1 | `false` | 是否显示关闭图标 |
| ✨ | `onCloseTap` | `VoidCallback?` | L3 | — | 关闭图标点击回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

> 注：`size`（标签大小）为 L4 样式，迁入 `TTagThemeData`。B 类组件交互统一用 `onChanged`，不提供 `onTap`。

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TTagThemeData` | ThemeExtension | §3 主题配置（与 TTag 共用） |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 📦 | `theme` (0.2.x) | `colorScheme` 参数 |
| 📦 | `selectStyle` / `unSelectStyle` / `disableSelectStyle` | `TTagThemeData` |
| 📦 | `onSelectChanged` | `onChanged` |
| 📦 | `isSelected` | `value` |
| 🗑️ | `onTap` | B 类组件统一用 `onChanged` |
| 🗑️ | `size` | `TTagThemeData` |
| 📦 | `iconWidget` / `padding` / `forceVerticalCenter` / `isOutline` / `shape` / `isLight` / `fixedWidth` | `TTagThemeData` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `theme` | `colorScheme` | 命名对齐 v1.0 |
| `selectStyle` | `TTagThemeData` | L4 → Theme |
| `unSelectStyle` | `TTagThemeData` | L4 → Theme |
| `disableSelectStyle` | `TTagThemeData` | L4 → Theme |
| `onSelectChanged` | `onChanged` | 命名对齐 v1.0 |
| `isSelected` | `value` | B 类受控 |
| `iconWidget` | `TTagThemeData` | L4 → Theme |
| `padding` | `TTagThemeData` | L4 → Theme |
| `forceVerticalCenter` | `TTagThemeData` | L4 → Theme |
| `isOutline` | `TTagThemeData` | L4 → Theme |
| `shape` | `TTagThemeData` | L4 → Theme |
| `isLight` | `TTagThemeData` | L4 → Theme |
| `needCloseIcon` | `needCloseIcon` | L1 能力参数保留 |
| `onCloseTap` | `onCloseTap` | L3 回调保留（移出 Theme） |
| `fixedWidth` | `TTagThemeData` | L4 → Theme |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `onTap` | B 类组件统一用 `onChanged` | 删除 |
| `size` | `TTagThemeData` | L4 样式迁入 Theme |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TTagThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `size` | `defaultSize` | 见 §3 末列 |
| `selectStyle` | `selectStyle` | 见 §3 末列 |
| `unSelectStyle` | `unSelectStyle` | 见 §3 末列 |
| `disableSelectStyle` | `disableSelectStyle` | 见 §3 末列 |
| `iconWidget` | `iconStyle` | 见 §3 末列 |
| `padding` | `padding` | 见 §3 末列 |
| `forceVerticalCenter` | `forceVerticalCenter` | 见 §3 末列 |
| `isOutline` | `isOutline` | 见 §3 末列 |
| `shape` | `shape` | 见 §3 末列 |
| `isLight` | `isLight` | 见 §3 末列 |
| `fixedWidth` | `fixedWidth` | 见 §3 末列 |

> 注：Material `ChipTheme` 的 `backgroundColor`/`labelStyle`/`side`/`padding` 由 Material 子主题处理，TDesign 扩展字段在 `TTagThemeData` 中。

> 子组件内部使用的 `TSelectTag` 也需同步升级，**不借用构造器参数**。

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

### 3.3 TTagThemeData 字段（TSelectTag 相关）

> TDesign 扩展字段（复用 TTag 的 `TTagThemeData`）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `defaultSize` | 默认尺寸 | `size` |
| 📦 | `selectStyle` | 选中态样式 | `selectStyle` |
| 📦 | `unSelectStyle` | 未选中态样式 | `unSelectStyle` |
| 📦 | `disableSelectStyle` | 禁用态样式 | `disableSelectStyle` |
| 📦 | `iconStyle` | 图标样式 | `iconWidget` |
| 📦 | `padding` | 内边距 | `padding` |
| 📦 | `forceVerticalCenter` | 强制垂直居中 | `forceVerticalCenter` |
| 📦 | `isOutline` | 是否描边样式 | `isOutline` |
| 📦 | `shape` | 形态 | `shape` |
| 📦 | `isLight` | 是否轻量样式 | `isLight` |
| 📦 | `fixedWidth` | 固定宽度 | `fixedWidth` |

> 完整字段见 [tag.md §3](./tag.md#3-theme-主题配置)

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_select_tag.dart` — Widget 本体
  - 复用 `TTag` 的 resolve 逻辑

- **底层实现**：包装 Material `FilterChip`

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 选中态切换 | ✅ | `value` + `onChanged` |
| 禁用态 | ✅ | `onChanged: null` |

### 4.3 Example 契约

- 覆盖 `value` 选中态切换
- 覆盖 `onChanged` 回调
- 提供 Form 桥接示例

---

### export

- **保留**：`TSelectTag`、`TTagThemeData`（与 TTag 共用）
- **移出**：`selectStyle`/`unSelectStyle`/`disableSelectStyle` 等 Style 类（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TTagThemeData` · Material: **FilterChip** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `backgroundColor` / `labelStyle` / `side` / `padding` | Material **`ChipTheme`** | 标签/芯片 |
| `defaultSize` | TDesign **`TTagThemeData`** | 0.2.x `size` 迁入 |
| `selectStyle` | TDesign **`TTagThemeData`** | 0.2.x L4 迁入（§1 迁移表） |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
