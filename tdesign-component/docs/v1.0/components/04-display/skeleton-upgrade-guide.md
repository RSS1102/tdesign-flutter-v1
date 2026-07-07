# TSkeleton v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T3 自绘** · 控制类 **A**
> 基于 [skeleton.md](./skeleton.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TSkeletonTheme` | ✏️ `variant` / `TSkeletonVariant`（avatar / image / text / paragraph） |
| **参数** | `theme` | ✏️ `variant` |
| **L4 样式** | `animation` / `delay` | 📦 迁入 `TSkeletonThemeData`（animation 同时保留构造器 L1） |
| **新增** | — | ✨ `TSkeleton.fromRowCol()` 工厂 / `TSkeletonAnimation` 枚举 |
| **移除** | `TSkeletonTheme` | 🗑️ 改名 `TSkeletonVariant` |
| **ThemeExtension** | — | ✨ 新增 `TSkeletonThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `enum TSkeletonTheme { ... }` | `enum TSkeletonVariant { avatar, image, text, paragraph }` |
| — | `enum TSkeletonAnimation { none, gradient, flashed }` |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TSkeletonTheme.xxx` | ✏️ `variant: TSkeletonVariant.xxx` | 枚举改名 |
| `theme: TSkeletonTheme.xxx` | ✏️ `variant: TSkeletonVariant.xxx` | 参数改名 |
| `animation` (0.2.x) | 📦 `TSkeletonThemeData.animation` + 构造器 L1 保留 | 迁入 Theme（同时保留 L1） |
| `delay` | 📦 `TSkeletonThemeData.delay` | 迁入 Theme |
| `rowCol` | 不变 | — |
| `onTap` | 不变 | — |

### 2.3 完整示例

```dart
// === 0.2.x ===
TSkeleton(
  theme: TSkeletonTheme.avatar,
  animation: TSkeletonAnimation.gradient,
  rowCol: [[1.0], [0.3, 0.3, 0.3]],
);

// === v1.0（预设形态） ===
TSkeleton(
  variant: TSkeletonVariant.avatar,
  animation: TSkeletonAnimation.gradient,
);

// === v1.0（自定义布局工厂） ===
TSkeleton.fromRowCol(
  rowCol: [
    [1.0],           // 第一行：1 个全宽块
    [0.3, 0.3, 0.3], // 第二行：3 个等宽块
  ],
  animation: TSkeletonAnimation.gradient,
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TSkeletonThemeData(
      blockColor: Color(0xFFE7E7E7),
      gradientColors: [Color(0xFFE7E7E7), Color(0xFFF5F5F5), Color(0xFFE7E7E7)],
      borderRadius: 4,
      animation: TSkeletonAnimation.gradient,
      delay: Duration(milliseconds: 500),
    ),
  ),
  child: const TSkeleton(variant: TSkeletonVariant.paragraph),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TSkeletonThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（rowCol / variant / animation / onTap）
  > TSkeletonThemeData（blockColor / gradientColors / borderRadius / animation / delay）
    > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TSkeleton` | ✅ 保留 | Widget |
| `TSkeletonVariant` | ✅ 保留 | 形态枚举 |
| `TSkeletonAnimation` | ✅ 保留 | 动画枚举 |
| `TSkeletonThemeData` | ✅ 保留 | ThemeExtension |
| `TSkeletonTheme` | 🚫 移出 | 已改名 `TSkeletonVariant` |
| `t_skeleton_rowcol.dart` | 🚫 移出 | 内部文件 |

---

## 5. 升级检查清单

- [ ] `TSkeletonTheme` → `TSkeletonVariant`
- [ ] `theme` → `variant`
- [ ] `animation` / `delay` → `TSkeletonThemeData`（animation 同时保留构造器）
- [ ] 新增 `TSkeleton.fromRowCol()` 工厂方法
- [ ] `TSkeletonTheme` / `t_skeleton_rowcol.dart` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
