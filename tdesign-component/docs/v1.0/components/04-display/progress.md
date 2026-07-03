# TProgress — v1.0 定稿

> Sprint **S2** | 控制类 **—**（纯展示） | Material: ProgressIndicator
> 源码：`lib/src/components/progress` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material 进度指示器薄包装（**不可交互**） |
| Material | `LinearProgressIndicator` / `CircularProgressIndicator` |
| Theme | `TProgressThemeData` |
| 禁用 | 无 Widget 级禁用；纯展示 |
| L4 | 构造器 L4 → `TProgressThemeData` |

## 控制方案

控制类 **`—`**（纯展示）：`value` 表示进度 `0.0–1.0`（或 `null` 为 indeterminate），父 State 传入渲染；**无** `onChanged`（对齐 Material `ProgressIndicator`，**非** C 类 Slider）。无 `defaultValue`。

→ [controlled.md](../../foundation/controlled.md)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| TProgressLabelPosition | 尺寸/位置枚举保留 |
| value | 进度值 `0.0–1.0` 或 `null`（indeterminate）；父 State 传入，KEEP |
| label | 进度文案（ KEEP） |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| TProgressType | variant | 命名对齐 v1.0 |
| variant | variant | v1.0 语义形态 |
| progressStatus | TProgressThemeData | L4 → Theme |
| progressLabelPosition | TProgressThemeData | L4 → Theme |
| strokeWidth | TProgressThemeData | L4 → Theme |
| color | TProgressThemeData | L4 → Theme |
| backgroundColor | TProgressThemeData | L4 → Theme |
| linearBorderRadius | TProgressThemeData | L4 → Theme |
| circleRadius | TProgressThemeData | L4 → Theme |
| showLabel | TProgressThemeData | L4 → Theme |
| customProgressLabel | TProgressThemeData | L4 → Theme |
| labelWidgetWidth | TProgressThemeData | L4 → Theme |
| labelWidgetAlignment | TProgressThemeData | L4 → Theme |
| animationDuration | TProgressThemeData | L4 → Theme |

### 🗑️ 移除

| 0.2.x | 原因 |
| --- | --- |
| onTap | 纯展示组件（控制类 —）不应有交互回调 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| TProgressStatus | 内部状态枚举，v1.0 不公开 |
| onLongPress | REMOVE：非设计稿关键态；与 Button 一致删除 |
| onTap | 纯展示组件（控制类 —）不应有交互回调 |

### 新增

_无_

### export

- **保留**：`TProgress`、`TProgressLabelPosition`、`TProgressThemeData`
- **移出**：`TProgressStatus` 内部状态 enum（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）


---

## 2. Theme

`TProgressThemeData` · Material: **ProgressIndicator** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `color` / `linearTrackColor` / `circularTrackColor` / `strokeWidth` | Material **`ProgressIndicatorTheme`** | 线型/环形轨道 |
| `variant` | TDesign **`TProgressThemeData`** | 原 `type` / `TProgressType` |
| `linearBorderRadius` / `circleRadius` / `showLabel` / `customProgressLabel` | TDesign 扩展 | 标签位置与圆角 |
| `progressLabelPosition` | TDesign 扩展 | 原 `TProgressLabelPosition` 默认 |
