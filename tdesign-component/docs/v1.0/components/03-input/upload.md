# TUpload — v1.0 定稿

> **状态**：规划中 | **控制类**：— | **Sprint**：S3

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/upload`

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 展示/布局组件；样式进 Theme |
| Material | image_picker |
| Theme | `TUploadThemeData` |
| 禁用 | 废弃 Widget 级 `disabled`。触发区按 A 类 `onPressed: null` 禁用 |
| L4 | 构造器 L4 → **`TUploadThemeData`** |

## 控制方案

控制类 **—**：无受控 value；按子交互控件控制类处理。

- 选图/拍图触发区 → 控制类 A（`onPressed` / `onPressed: null`）
- 文件列表展示 → 纯展示
- 删除/预览子动作 → `onCancel` / `onPreview`（置 null 禁用）

Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)：`TFormField<List<TUploadFile>>`

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。无图例项 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `files` | `List<TUploadFile>?` | L2 | — | 已选文件列表（展示） |
| | `onChanged` | `ValueChanged<List<TUploadFile>>?` | L3 | — | 文件列表变更 |
| ✨ | `max` | `int?` | L1 | — | 最大文件数 |
| ✨ | `mediaType` | `TUploadMediaType` | L1 | `image` | 媒体类型（image/video/mixed） |
| ✨ | `sizeLimit` | `int?` | L1 | — | 单文件大小限制（bytes） |
| ✨ | `multiple` | `bool` | L1 | `false` | 是否多选 |
| ✨ | `onPressed` | `VoidCallback?` | L3 | — | 选图/拍图点击 |
| ✨ | `onCancel` | `ValueChanged<TUploadFile>?` | L3 | — | 删除文件回调 |
| ✨ | `onPreview` | `ValueChanged<TUploadFile>?` | L3 | — | 预览文件回调 |
| ✨ | `onError` | `ValueChanged<TUploadValidatorError>?` | L3 | — | 错误回调 |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `TUploadMediaType` | `image` · `video` · `mixed` | `mediaType` 参数 |
| ✨ | `TUploadFile` | `uri` · `name` · `size` · `status` | `files` 数据模型 |
| ✨ | `TUploadValidatorError` | `max` · `size` · `type` | `onError` 回调参数 |
| ✨ | `TUploadThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `TUploadMediaType`（旧） | `TUploadMediaType`（重命名） |
| 🚫 | `TUploadType` | `TUploadMediaType` |
| 🚫 | `TUploadBoxType` | `TUploadThemeData.variant` |
| 🗑️ | `onClick` | `onPressed` |
| 🗑️ | `onChange` | `onChanged` |
| 🗑️ | `disabled` | `onUploadTap: null` |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `onClick` | `onPressed` | 命名对齐 v1.0 |
| `onChange` | `onChanged` | 命名对齐 v1.0 |
| `TUploadMediaType` | `TUploadMediaType` | 重命名（避免与旧 enum 冲突） |
| `TUploadType` | `TUploadMediaType` | 合并枚举 |
| `TUploadBoxType` | `TUploadThemeData.variant` | 枚举化 |
| `disabled` | `onPressed: null` | Material 禁用 |

### ✨ 新增

_无_

### 🔀 合并

_无_

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `TUploadFileStatus` | 删除 | 内部状态枚举，v1.0 不公开 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（TUploadThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| `width` | `thumbWidth` | 见 §3 末列 |
| `height` | `thumbHeight` | 见 §3 末列 |
| `wrapSpacing` | `wrapSpacing` | 见 §3 末列 |
| `wrapRunSpacing` | `wrapRunSpacing` | 见 §3 末列 |
| `wrapAlignment` | `wrapAlignment` | 见 §3 末列 |
| `type` / `TUploadBoxType` | `variant` | 见 §3 末列 |

> 注：选图/拍图能力由 `image_picker` 平台能力提供，非 Material Widget。

> 子组件内部使用的 `TUpload` 也需同步升级，**不借用构造器参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 L1 参数 |
| 子树 | `Theme.of(context).mergeExtension(TUploadThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `TUploadThemeData` |

### 3.2 覆盖顺序

`resolve（全量合并）` **>** Token

### 3.3 TUploadThemeData 字段

> TDesign 扩展字段（`image_picker` 无对应项）：

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| 📦 | `thumbWidth` | 缩略图宽度 | `width` |
| 📦 | `thumbHeight` | 缩略图高度 | `height` |
| 📦 | `wrapSpacing` | 缩略图水平间距 | `wrapSpacing` |
| 📦 | `wrapRunSpacing` | 缩略图垂直间距 | `wrapRunSpacing` |
| 📦 | `wrapAlignment` | 缩略图对齐 | `wrapAlignment` |
| 📦 | `variant` | 展示形态枚举（卡片/网格等） | `type` / `TUploadBoxType` |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_upload.dart` — Widget 本体
  - `t_upload_resolve.dart` — **唯一**样式合并入口
  - `t_upload_theme_data.dart` — `TUploadThemeData` ThemeExtension

- **底层实现**：包装 `image_picker` 平台能力

### 4.2 必测场景

> 控制类通用必测见 [testing.md](../guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 文件列表展示 | ✅ | `files` 正确渲染 |
| 选图/拍图 | ✅ | `onPressed` 触发 |
| 删除文件 | ✅ | `onCancel` 回调 |
| 预览文件 | ✅ | `onPreview` 回调 |
| 错误处理 | ✅ | `onError` 回调 |

### 4.3 Example 契约

- 覆盖 `mediaType`（image/video/mixed）
- 覆盖 `multiple` 多选
- 提供 Form 桥接示例

---

### export

- **保留**：`TUpload`、`TUploadThemeData`、`TUploadValidatorError`、`TUploadMediaType`、`TUploadFile`
- **移出**：`TUploadFileStatus` 内部状态 enum、`TUploadType`、`TUploadBoxType`（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TUploadThemeData` · Material: **image_picker** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `files` / `onChanged` | **— 类 Widget API** | 文件列表展示与受控；Form → `TFormField` |
| `max` / `mediaType` / `sizeLimit` / `multiple` | **构造器 L1** | 上传业务约束（语义级） |
| `onPressed` / `onCancel` / `onPreview` / `onError` | **构造器 L3** | 生命周期回调 |
| 选图/拍图 | **`image_picker`** | 平台能力；非 Material Widget |
| `thumbWidth` / `thumbHeight` / `wrapSpacing` / `wrapRunSpacing` / `wrapAlignment` | **`TUploadThemeData`** | 缩略图网格 L4 |
| `variant` | **`TUploadThemeData`** | 展示形态（卡片/网格） |

---

> **文档参考**：[api.md](../foundation/api.md) · [controlled.md](../foundation/controlled.md) · [theme.md](../foundation/theme.md) · [disabled-evolution.md](../foundation/disabled-evolution.md)
