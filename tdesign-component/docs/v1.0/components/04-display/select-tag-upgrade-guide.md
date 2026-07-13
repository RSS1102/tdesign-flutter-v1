# TSelectTag v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 FilterChip** · 控制类 **B**
> 基于 [select-tag.md](./select-tag.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **选中态** | `isSelected` | ✏️ `value: bool`（B 类受控） |
| **回调** | `onSelectChanged` | ✏️ `onChanged: ValueChanged<bool>?` |
| **配色** | `theme` | ✏️ `colorScheme` |
| **禁用** | — | 🗑️ `onChanged: null` |
| **L4 样式** | `selectStyle` / `unSelectStyle` / `disableSelectStyle` / `iconWidget` / `padding` / `forceVerticalCenter` / `isOutline` / `shape` / `isLight` / `fixedWidth` / `size` | 📦 迁入 `TTagThemeData`（与 TTag 共用） |
| **移除** | `onTap` | 🗑️ B 类统一用 `onChanged` |
| **ThemeExtension** | — | ✨ 复用 `TTagThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `isSelected: true` | ✏️ `value: true` | B 类受控 |
| `onSelectChanged: (v) {}` | ✏️ `onChanged: (v) {}` | 改名 |
| `theme: TTagTheme.primary` | ✏️ `colorScheme: TTagColorScheme.primary` | 改名 |
| `selectStyle` | 📦 `TTagThemeData.selectStyle` | 迁入 Theme |
| `unSelectStyle` | 📦 `TTagThemeData.unSelectStyle` | 迁入 Theme |
| `disableSelectStyle` | 📦 `TTagThemeData.disableSelectStyle` | 迁入 Theme |
| `iconWidget` | 📦 `TTagThemeData.iconStyle` | 迁入 Theme |
| `padding` | 📦 `TTagThemeData.padding` | 迁入 Theme |
| `forceVerticalCenter` | 📦 `TTagThemeData.forceVerticalCenter` | 迁入 Theme |
| `isOutline` | 📦 `TTagThemeData.isOutline` | 迁入 Theme |
| `shape` | 📦 `TTagThemeData.shape` | 迁入 Theme |
| `isLight` | 📦 `TTagThemeData.isLight` | 迁入 Theme |
| `fixedWidth` | 📦 `TTagThemeData.fixedWidth` | 迁入 Theme |
| `size` | 📦 `TTagThemeData.defaultSize` | 迁入 Theme |
| `onTap` | 🗑️ 删除 | B 类用 `onChanged` |
| `text` | 不变 | — |
| `icon` | 不变 | — |
| `needCloseIcon` | 不变 | — |
| `onCloseTap` | 不变 | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TSelectTag(
  text: '标签',
  isSelected: _selected,
  onSelectChanged: (v) {
    setState(() => _selected = v);
  },
  theme: TTagTheme.primary,
  size: TTagSize.medium,
  shape: TTagShape.round,
);

// === v1.0 ===
TSelectTag(
  text: '标签',
  value: _selected,
  onChanged: (v) {
    setState(() => _selected = v);
  },
  // theme → colorScheme, size/shape → TTagThemeData
);

// 禁用态
TSelectTag(
  text: '标签',
  value: true,
  onChanged: null, // 禁用
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入（与 TTag 共用 TTagThemeData）
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(
      defaultSize: TTagSize.medium,
      shape: TTagShape.round,
      isOutline: true,
    ),
  ),
  child: TSelectTag(text: '标签', value: true, onChanged: (v) {}),
);
```

### 优先级链

```
构造器参数（value / onChanged / text / icon / needCloseIcon / onCloseTap）
  > TTagThemeData（defaultSize / selectStyle / unSelectStyle / disableSelectStyle / iconStyle / padding / forceVerticalCenter / isOutline / shape / isLight / fixedWidth）
    > Material ChipTheme
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TSelectTag` | ✅ 保留 | Widget |
| `TTagThemeData` | ✅ 保留 | 与 TTag 共用 |
| `selectStyle` / `unSelectStyle` / `disableSelectStyle` | 🚫 移出 | 迁入 `TTagThemeData` |

---

## 5. 升级检查清单

- [ ] `isSelected` → `value: bool`
- [ ] `onSelectChanged` → `onChanged`
- [ ] `theme` → `colorScheme`
- [ ] `size` / `selectStyle` / `unSelectStyle` / `disableSelectStyle` 等 L4 → `TTagThemeData`
- [ ] 删除 `onTap` 引用
- [ ] `selectStyle` 等 Style 类不在 export 中
- [ ] 更新 Example 页面 + API 文档
