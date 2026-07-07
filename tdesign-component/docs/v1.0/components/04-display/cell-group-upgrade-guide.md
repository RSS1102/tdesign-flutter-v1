# TCellGroup v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 Column + TCell** · 控制类 **A**
> 基于 [cell-group.md](./cell-group.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **组主题** | `TCellGroupTheme`（default / card） | ✏️ `TCellThemeData.groupVariant` |
| **标题** | `title`(String) + `titleWidget` | 🔀 `title: Widget?`（单槽） |
| **L4 样式** | `theme` / `style` / `bordered` / `isShowLastBordered` | 📦 迁入 `TCellThemeData`（与 TCell 共用） |
| **移除** | `TCellGroupTheme` / `TCellStyle` / `bordered` / `isShowLastBordered` | 🗑️ 移除或迁入 Theme |
| **ThemeExtension** | — | ✨ 复用 `TCellThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `title: 'xxx'` / `titleWidget` | 🔀 `title: Widget?` | String → Widget 单槽 |
| `TCellGroupTheme.defaultTheme` | 📦 `TCellThemeData.groupVariant` | 枚举化迁入 Theme |
| `theme: TCellGroupTheme.xxx` | 📦 `TCellThemeData.groupVariant` | 迁入 Theme |
| `style` | 📦 `TCellThemeData` | 迁入 Theme |
| `bordered: true` | 📦 `TCellThemeData.bordered` | 迁入 Theme |
| `isShowLastBordered: true` | 📦 `TCellThemeData.isShowLastBordered` | 迁入 Theme |
| `cells` | 不变 | — |
| `builder` | ✨ 新增 `CellGroupBuilder` | 自定义 cell 父组件 |
| `onTap` | 不变 | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TCellGroup(
  title: '分组标题',
  theme: TCellGroupTheme.card,
  bordered: true,
  isShowLastBordered: false,
  cells: [
    TCell(title: '单元格1'),
    TCell(title: '单元格2'),
  ],
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TCellThemeData(
      groupVariant: TCellGroupVariant.card,
      bordered: true,
      isShowLastBordered: false,
    ),
  ),
  child: TCellGroup(
    title: Text('分组标题'),
    cells: [
      TCell(title: Text('单元格1')),
      TCell(title: Text('单元格2')),
    ],
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入（与 TCell 共用 TCellThemeData）
Theme(
  data: Theme.of(context).mergeExtension(
    const TCellThemeData(
      groupVariant: TCellGroupVariant.card,
      bordered: true,
    ),
  ),
  child: TCellGroup(cells: [...]),
);
```

### 优先级链

```
构造器参数（title / cells / builder / onTap）
  > TCellThemeData（groupVariant / bordered / isShowLastBordered / showBottomBorder）
    > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TCellGroup` | ✅ 保留 | Widget |
| `TCellThemeData` | ✅ 保留 | 与 TCell 共用 |
| `TCellGroupTheme` | 🚫 移出 | 已迁入 `TCellThemeData.groupVariant` |
| `TCellStyle` | 🚫 移出 | 旧 Style 类 |

---

## 5. 升级检查清单

- [ ] `title`(String) / `titleWidget` → `title: Widget?`
- [ ] `TCellGroupTheme` → `TCellThemeData.groupVariant`
- [ ] `bordered` / `isShowLastBordered` → `TCellThemeData`
- [ ] `TCellGroupTheme` / `TCellStyle` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
