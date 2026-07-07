# TProgress v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 ProgressIndicator** · 控制类 **—**（纯展示）
> 基于 [progress.md](./progress.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TProgressType` | ✏️ `variant` |
| **L4 样式** | `progressStatus` / `progressLabelPosition` / `strokeWidth` / `color` / `backgroundColor` / `linearBorderRadius` / `circleRadius` / `showLabel` / `customProgressLabel` / `labelWidgetWidth` / `labelWidgetAlignment` / `animationDuration` | 📦 迁入 `TProgressThemeData` |
| **移除** | `onTap` / `onLongPress` | 🗑️ 纯展示组件不应有交互回调 |
| **废弃** | `TProgressStatus` | 🗑️ 内部状态 enum，不公开 |
| **ThemeExtension** | — | ✨ 新增 `TProgressThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TProgressType.xxx` | ✏️ `variant` | 枚举改名 |
| `progressStatus` | 📦 `TProgressThemeData` | 迁入 Theme |
| `progressLabelPosition` | 📦 `TProgressThemeData.progressLabelPosition` | 迁入 Theme |
| `strokeWidth` | 📦 `TProgressThemeData.strokeWidth` | 迁入 Theme |
| `color` | 📦 `TProgressThemeData.color` | 迁入 Theme |
| `backgroundColor` | 📦 `TProgressThemeData.backgroundColor` | 迁入 Theme |
| `linearBorderRadius` | 📦 `TProgressThemeData.linearBorderRadius` | 迁入 Theme |
| `circleRadius` | 📦 `TProgressThemeData.circleRadius` | 迁入 Theme |
| `showLabel` | 📦 `TProgressThemeData.showLabel` | 迁入 Theme |
| `customProgressLabel` | 📦 `TProgressThemeData.customProgressLabel` | 迁入 Theme |
| `labelWidgetWidth` | 📦 `TProgressThemeData.labelWidgetWidth` | 迁入 Theme |
| `labelWidgetAlignment` | 📦 `TProgressThemeData.labelWidgetAlignment` | 迁入 Theme |
| `animationDuration` | 📦 `TProgressThemeData.animationDuration` | 迁入 Theme |
| `onTap` | 🗑️ 删除 | 纯展示组件不应有交互 |
| `onLongPress` | 🗑️ 删除 | 非设计稿关键态 |
| `value` | 不变 | 0.0–1.0 或 null（indeterminate） |
| `label` | 不变 | 进度文案 |
| `TProgressLabelPosition` | 不变 | 枚举保留 |

### 2.2 完整示例

```dart
// === 0.2.x ===
TProgress(
  value: 0.5,
  TProgressType: TProgressType.linear,
  color: Colors.blue,
  strokeWidth: 4,
  linearBorderRadius: 8,
  showLabel: true,
  label: '50%',
  onTap: () { ... },
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TProgressThemeData(
      color: Colors.blue,
      strokeWidth: 4,
      linearBorderRadius: 8,
      showLabel: true,
    ),
  ),
  child: const TProgress(
    value: 0.5,
    variant: TProgressVariant.linear,
    label: '50%',
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TProgressThemeData(color: Colors.blue, strokeWidth: 4),
  ),
  child: const TProgress(value: 0.5),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TProgressThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（value / label / variant）
  > TProgressThemeData（color / strokeWidth / linearBorderRadius / circleRadius / showLabel / customProgressLabel / progressLabelPosition / labelWidgetWidth / labelWidgetAlignment / animationDuration）
    > Material ProgressIndicatorTheme
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TProgress` | ✅ 保留 | Widget |
| `TProgressLabelPosition` | ✅ 保留 | 位置枚举 |
| `TProgressThemeData` | ✅ 保留 | ThemeExtension |
| `TProgressStatus` | 🚫 移出 | 内部状态 enum |
| `TProgressType` | 🚫 移出 | 已改名 `variant` |

---

## 5. 升级检查清单

- [ ] `TProgressType` → `variant`
- [ ] 删除 `onTap` / `onLongPress` 引用
- [ ] `color` / `strokeWidth` / `linearBorderRadius` / `circleRadius` / `showLabel` 等 L4 → `TProgressThemeData`
- [ ] `TProgressStatus` / `TProgressType` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
