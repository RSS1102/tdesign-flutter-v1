# TResult v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T3 自绘** · 控制类 **A**
> 基于 [result.md](./result.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TResultTheme` | ✏️ `variant` / `TResultVariant`（default / success / warning / error） |
| **副标题** | `description` | ✏️ `subtitle` |
| **L4 样式** | `titleStyle` | 📦 迁入 `TResultThemeData` |
| **移除** | `TResultTheme` | 🗑️ 改名 `TResultVariant` |
| **ThemeExtension** | — | ✨ 新增 `TResultThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `enum TResultTheme { defaultTheme, success, warning, error }` | `enum TResultVariant { default, success, warning, error }` |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TResultTheme.success` | ✏️ `variant: TResultVariant.success` | 枚举改名 |
| `theme: TResultTheme.xxx` | ✏️ `variant: TResultVariant.xxx` | 参数改名 |
| `description: 'xxx'` | ✏️ `subtitle: 'xxx'` | 改名 |
| `titleStyle: TextStyle(...)` | 📦 `TResultThemeData.titleStyle` | 迁入 Theme |
| `icon` | 不变 | — |
| `title` | 不变 | — |
| `onTap` | 不变 | — |

### 2.3 完整示例

```dart
// === 0.2.x ===
TResult(
  theme: TResultTheme.success,
  title: '操作成功',
  description: '您的操作已完成',
  titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TResultThemeData(
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
  child: const TResult(
    variant: TResultVariant.success,
    title: '操作成功',
    subtitle: '您的操作已完成',
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TResultThemeData(
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      iconColor: Colors.green,
    ),
  ),
  child: const TResult(variant: TResultVariant.success, title: '成功'),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TResultThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（icon / title / subtitle / variant / onTap）
  > TResultThemeData（titleStyle / iconColor / backgroundColor）
    > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TResult` | ✅ 保留 | Widget |
| `TResultVariant` | ✅ 保留 | 形态枚举 |
| `TResultThemeData` | ✅ 保留 | ThemeExtension |
| `TResultTheme` | 🚫 移出 | 已改名 `TResultVariant` |

---

## 5. 升级检查清单

- [ ] `TResultTheme` → `TResultVariant`
- [ ] `theme` → `variant`
- [ ] `description` → `subtitle`
- [ ] `titleStyle` → `TResultThemeData.titleStyle`
- [ ] `TResultTheme` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
