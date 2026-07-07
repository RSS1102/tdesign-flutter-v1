# TTag v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 Chip** · 控制类 **A**
> 基于 [tag.md](./tag.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **配色** | `theme` | ✏️ `colorScheme` |
| **禁用** | `disable: true` | 🗑️ `onTap: null`（A 类禁用） |
| **L4 样式** | `style` / `iconWidget` / `textColor` / `backgroundColor` / `font` / `fontWeight` / `padding` / `forceVerticalCenter` / `isOutline` / `shape` / `isLight` / `overflow` / `fixedWidth` / `size` | 📦 迁入 `TTagThemeData` |
| **移除** | `disable` / `disabled` | 🗑️ 统一用 `onTap: null` |
| **ThemeExtension** | — | ✨ 新增 `TTagThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `theme: TTagTheme.primary` | ✏️ `colorScheme: TTagColorScheme.primary` | 改名 |
| `disable: true` | 🗑️ `onTap: null` | A 类禁用 |
| `style` | 📦 `TTagThemeData.colorScheme` | 迁入 Theme |
| `iconWidget` | 📦 `TTagThemeData.iconStyle` | 迁入 Theme |
| `textColor` | 📦 `TTagThemeData.textColor` | 迁入 Theme |
| `backgroundColor` | 📦 `TTagThemeData.backgroundColor` | 迁入 Theme |
| `font` | 📦 `TTagThemeData.font` | 迁入 Theme |
| `fontWeight` | 📦 `TTagThemeData.fontWeight` | 迁入 Theme |
| `padding` | 📦 `TTagThemeData.padding` | 迁入 Theme |
| `forceVerticalCenter` | 📦 `TTagThemeData.forceVerticalCenter` | 迁入 Theme |
| `isOutline` | 📦 `TTagThemeData.isOutline` | 迁入 Theme |
| `shape` | 📦 `TTagThemeData.shape` | 迁入 Theme |
| `isLight` | 📦 `TTagThemeData.isLight` | 迁入 Theme |
| `overflow` | 📦 `TTagThemeData.overflow` | 迁入 Theme |
| `fixedWidth` | 📦 `TTagThemeData.fixedWidth` | 迁入 Theme |
| `size` | 📦 `TTagThemeData.defaultSize` | 迁入 Theme |
| `text` | 不变 | — |
| `icon` | 不变 | — |
| `needCloseIcon` | 不变 | — |
| `onTap` | 不变 | — |
| `onCloseTap` | 不变 | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TTag(
  text: '标签',
  theme: TTagTheme.primary,
  size: TTagSize.medium,
  textColor: Colors.white,
  backgroundColor: Colors.blue,
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  isOutline: false,
  shape: TTagShape.round,
  disable: true,
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(
      defaultSize: TTagSize.medium,
      textColor: Colors.white,
      backgroundColor: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      isOutline: false,
      shape: TTagShape.round,
    ),
  ),
  child: const TTag(
    text: '标签',
    colorScheme: TTagColorScheme.primary,
    onTap: null, // 禁用
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(
      defaultSize: TTagSize.medium,
      textColor: Colors.white,
      backgroundColor: Colors.blue,
    ),
  ),
  child: const TTag(text: '标签'),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TTagThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（text / icon / needCloseIcon / onTap / onCloseTap）
  > TTagThemeData（colorScheme / textColor / backgroundColor / font / fontWeight / padding / forceVerticalCenter / isOutline / shape / isLight / overflow / fixedWidth / defaultSize）
    > Material ChipTheme
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TTag` | ✅ 保留 | Widget |
| `TTagSize` | ✅ 保留 | 尺寸枚举 |
| `TTagThemeData` | ✅ 保留 | ThemeExtension |
| `TTagStyles` / `t_tag_styles.dart` | 🚫 移出 | 旧 Style 类 |

---

## 5. 升级检查清单

- [ ] `theme` → `colorScheme`
- [ ] `disable` / `disabled` → `onTap: null`
- [ ] `style` / `iconWidget` / `textColor` / `backgroundColor` / `font` / `fontWeight` / `padding` 等 L4 → `TTagThemeData`
- [ ] `size` → `TTagThemeData.defaultSize`
- [ ] `isOutline` / `shape` / `isLight` / `overflow` / `fixedWidth` / `forceVerticalCenter` → `TTagThemeData`
- [ ] `TTagStyles` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
