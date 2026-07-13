# TBadge v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 Badge M3** · 控制类 **A**
> 基于 [badge.md](./badge.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TBadgeType` | ✏️ `variant` / `TBadgeVariant`（normal / small / dot） |
| **尺寸** | `TBadgeSize` | 🗑️ 移除（`variant` 同时控制形态和尺寸） |
| **L4 样式** | 构造器 `color` / `textColor` / `message` / `widthLarge` / `widthSmall` / `padding` | 📦 迁入 `TBadgeThemeData` |
| **ThemeExtension** | — | ✨ 新增 `TBadgeThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `enum TBadgeType { ... }` | `enum TBadgeVariant { normal, small, dot }` |
| `enum TBadgeSize { ... }` | 🗑️ 移除 |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TBadgeType.xxx` | ✏️ `variant: TBadgeVariant.xxx` | 枚举改名 |
| `size: TBadgeSize.xxx` | 🗑️ 删除 | 用 `variant` 控制形态和尺寸 |
| `color` | 📦 `TBadgeThemeData.backgroundColor` | 迁入 Theme |
| `textColor` | 📦 `TBadgeThemeData.textColor` | 迁入 Theme |
| `message` | 📦 `TBadgeThemeData.message` | 迁入 Theme |
| `widthLarge` | 📦 `TBadgeThemeData.largeWidth` | 迁入 Theme |
| `widthSmall` | 📦 `TBadgeThemeData.smallWidth` | 迁入 Theme |
| `padding` | 📦 `TBadgeThemeData.padding` | 迁入 Theme |
| `count` | 不变 | — |
| `maxCount` | 不变 | — |
| `border` | 不变 | — |
| `showZero` | 不变 | — |
| `child` | 不变 | — |
| `onTap` | 不变 | — |

### 2.3 完整示例

```dart
// === 0.2.x ===
TBadge(
  count: 8,
  maxCount: 99,
  TBadgeType: TBadgeType.normal,
  color: Colors.red,
  textColor: Colors.white,
  widthLarge: 20,
  padding: EdgeInsets.symmetric(horizontal: 4),
  child: Icon(Icons.message),
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TBadgeThemeData(
      backgroundColor: Colors.red,
      textColor: Colors.white,
      largeWidth: 20,
      padding: EdgeInsets.symmetric(horizontal: 4),
    ),
  ),
  child: TBadge(
    count: 8,
    maxCount: 99,
    variant: TBadgeVariant.normal,
    child: Icon(Icons.message),
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TBadgeThemeData(backgroundColor: Colors.red, textColor: Colors.white),
  ),
  child: const TBadge(count: 8, child: Icon(Icons.message)),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TBadgeThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（count / maxCount / variant / border / showZero / child / onTap）
  > TBadgeThemeData（backgroundColor / textColor / message / largeWidth / smallWidth / padding / showZero）
    > Material BadgeTheme
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TBadge` | ✅ 保留 | Widget |
| `TBadgeVariant` | ✅ 保留 | 形态枚举 |
| `TBadgeThemeData` | ✅ 保留 | ThemeExtension |
| `TBadgeType` / `TBadgeSize` | 🚫 移出 | 已移除/合并 |

---

## 5. 升级检查清单

- [ ] `TBadgeType` → `TBadgeVariant`
- [ ] 删除 `size` / `TBadgeSize` 引用（用 `variant` 控制）
- [ ] `color` → `TBadgeThemeData.backgroundColor`
- [ ] `textColor` / `message` / `widthLarge` / `widthSmall` / `padding` → `TBadgeThemeData`
- [ ] `TBadgeType` / `TBadgeSize` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
