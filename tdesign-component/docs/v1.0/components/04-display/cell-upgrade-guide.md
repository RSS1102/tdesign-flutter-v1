# TCell v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 ListTile** · 控制类 **A**
> 基于 [cell.md](./cell.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **标题** | `title`(String) + `titleWidget` | 🔀 `title: Widget?`（单槽） |
| **副标题** | `description` / `descriptionWidget` / `subtitleWidget` | 🔀 `subtitle: Widget?`（单槽） |
| **左侧** | `leftIcon` / `leftIconWidget` | ✏️ `prefix: Widget?` |
| **右侧图标** | `rightIcon` / `rightIconWidget` | ✏️ `trailing: Widget?` |
| **图片** | `image` / `imageWidget` | 🔀 `image: Widget?`（单槽） |
| **note** | `note`(String) / `noteWidget` | 🔀 `note: Widget?`（单槽） |
| **回调** | `onClick` | ✏️ `onTap` |
| **禁用** | `disabled: true` | 🗑️ `onTap: null` |
| **对齐** | 构造器 `align` | ✨ `align: TCellAlign`（L1） |
| **箭头** | — | ✨ `arrow: bool` |
| **L4 样式** | `style` / `align`(L4) / `hover` / `showBottomBorder` / `height` / `bordered` | 📦 迁入 `TCellThemeData` |
| **移除** | `TCellStyle` / `TCellClick` / `bordered` / `disabled` | 🗑️ 移除或替代 |
| **ThemeExtension** | — | ✨ 新增 `TCellThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `title: 'xxx'` / `titleWidget: xxx` | 🔀 `title: Text('xxx')` | String → Widget 单槽 |
| `description: 'xxx'` / `descriptionWidget` / `subtitleWidget` | 🔀 `subtitle: Text('xxx')` | 改名 + 单槽 |
| `leftIcon` / `leftIconWidget` | ✏️ `prefix: Widget?` | 改名 + 单槽 |
| `rightIcon` / `rightIconWidget` | ✏️ `trailing: Widget?` | 改名 + 单槽 |
| `image: 'url'` / `imageWidget` | 🔀 `image: Widget?` | 单槽 |
| `note: 'xxx'` / `noteWidget` | 🔀 `note: Widget?` | 单槽 |
| `onClick` | ✏️ `onTap` | 改名 |
| `disabled: true` | 🗑️ `onTap: null` | A 类禁用 |
| `bordered: true` | 📦 `TCellThemeData.showBottomBorder` | 迁入 Theme |
| `style` | 📦 `TCellThemeData.style` | 迁入 Theme |
| `align` | ✨ `align: TCellAlign`（L1 构造器保留） | 升为 L1 |
| `hover` | 📦 `TCellThemeData.hoverColor` | 迁入 Theme |
| `height` | 📦 `TCellThemeData.height` | 迁入 Theme |
| `arrow` | ✨ `arrow: bool`（新增） | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TCell(
  title: '标题',
  description: '描述',
  leftIcon: Icons.person,
  rightIcon: Icons.chevron_right,
  onClick: () { ... },
  disabled: true,
  bordered: true,
);

// === v1.0 ===
TCell(
  title: Text('标题'),
  subtitle: Text('描述'),
  prefix: Icon(Icons.person),
  trailing: Icon(Icons.chevron_right),
  arrow: true,
  onTap: null, // 禁用
  // bordered → TCellThemeData.showBottomBorder
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TCellThemeData(
      showBottomBorder: true,
      height: 56,
      hoverColor: Color(0xFFEEEEEE),
    ),
  ),
  child: const TCell(title: Text('标题')),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TCellThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（title / subtitle / prefix / image / note / trailing / arrow / align / onTap / onLongPress）
  > TCellThemeData（showBottomBorder / style / defaultAlign / hoverColor / height）
    > Material ListTileTheme
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TCell` | ✅ 保留 | Widget |
| `TCellAlign` | ✅ 保留 | 对齐枚举 |
| `TCellThemeData` | ✅ 保留 | ThemeExtension |
| `TCellStyle` | 🚫 移出 | 旧 Style 类 |
| `TCellClick` | 🚫 移出 | 废弃 typedef |

---

## 5. 升级检查清单

- [ ] `title`(String) / `titleWidget` → `title: Text('...')`
- [ ] `description` / `descriptionWidget` → `subtitle: Text('...')`
- [ ] `leftIcon` / `leftIconWidget` → `prefix`
- [ ] `rightIcon` / `rightIconWidget` → `trailing`
- [ ] `image` / `imageWidget` → `image: Widget?`
- [ ] `note`(String) / `noteWidget` → `note: Widget?`
- [ ] `onClick` → `onTap`
- [ ] `disabled: true` → `onTap: null`
- [ ] `bordered` → `TCellThemeData.showBottomBorder`
- [ ] `style` / `hover` / `height` → `TCellThemeData`
- [ ] `TCellStyle` / `TCellClick` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
