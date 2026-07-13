# TFooter v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T3 自绘** · 控制类 **A**
> 基于 [footer.md](./footer.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TFooterType` | ✏️ `variant` / `TFooterVariant`（text / link / brand） |
| **L4 样式** | `width` / `height` | 📦 迁入 `TFooterThemeData` |
| **移除** | `width`（构造器） | 🗑️ 迁入 Theme |
| **ThemeExtension** | — | ✨ 新增 `TFooterThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `enum TFooterType { text, link, brand }` | `enum TFooterVariant { text, link, brand }` |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TFooterType.xxx` | ✏️ `variant: TFooterVariant.xxx` | 枚举改名 |
| `type: TFooterType.xxx` | ✏️ `variant: TFooterVariant.xxx` | 参数改名 |
| `width` | 📦 `TFooterThemeData.logoWidth` | 迁入 Theme |
| `height` | 📦 `TFooterThemeData.height` | 迁入 Theme |
| `logo` | 不变 | — |
| `text` | 不变 | — |
| `links` | 不变 | — |
| `onTap` | 不变 | — |

### 2.3 完整示例

```dart
// === 0.2.x ===
TFooter(
  text: 'Copyright © 2024 TDesign',
  type: TFooterType.text,
  height: 60,
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TFooterThemeData(height: 60),
  ),
  child: TFooter(
    text: 'Copyright © 2024 TDesign',
    variant: TFooterVariant.text,
  ),
);

// === v1.0（品牌形态） ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TFooterThemeData(logoWidth: 100, height: 80),
  ),
  child: TFooter(
    variant: TFooterVariant.brand,
    logo: Image.asset('assets/logo.png'),
    text: 'Copyright © 2024',
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TFooterThemeData(logoWidth: 100, height: 80, textColor: Colors.grey),
  ),
  child: const TFooter(text: 'Copyright'),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TFooterThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（logo / text / links / variant / onTap）
  > TFooterThemeData（logoWidth / height / textColor / linkColor）
    > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TFooter` | ✅ 保留 | Widget |
| `TFooterVariant` | ✅ 保留 | 形态枚举 |
| `TFooterLink` | ✅ 保留 | 链接数据模型 |
| `TFooterThemeData` | ✅ 保留 | ThemeExtension |
| `TFooterType` | 🚫 移出 | 已改名 `TFooterVariant` |

---

## 5. 升级检查清单

- [ ] `TFooterType` → `TFooterVariant`
- [ ] `type` → `variant`
- [ ] `width` → `TFooterThemeData.logoWidth`
- [ ] `height` → `TFooterThemeData.height`
- [ ] `TFooterType` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
