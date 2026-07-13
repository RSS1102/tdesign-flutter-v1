# TTable v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T3 自绘** · 控制类 **—**（纯展示/布局）
> 基于 [table.md](./table.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **表尾** | `footerWidget` | ✏️ `footer` |
| **L4 样式** | `bordered` / `stripe` / `rowHeight` / `height` / `width` / `backgroundColor` | 📦 迁入 `TTableThemeData` |
| **保留构造器** | `loading` / `loadingWidget` / `empty` / `footer` / `columns` / `data` / 回调 | 实例 KEEP（业务态/数据/槽位） |
| **ThemeExtension** | — | ✨ 新增 `TTableThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `footerWidget: xxx` | ✏️ `footer: Widget?` | 改名 |
| `bordered: true` | 📦 `TTableThemeData.bordered` | 迁入 Theme |
| `stripe: true` | 📦 `TTableThemeData.stripe` | 迁入 Theme |
| `rowHeight: 48` | 📦 `TTableThemeData.rowHeight` | 迁入 Theme |
| `height: 400` | 📦 `TTableThemeData.height` | 迁入 Theme |
| `width: 300` | 📦 `TTableThemeData.width` | 迁入 Theme |
| `backgroundColor: Colors.white` | 📦 `TTableThemeData.backgroundColor` | 迁入 Theme |
| `columns` | 不变 | 实例 KEEP |
| `data` | 不变 | 实例 KEEP |
| `loading` / `loadingWidget` | 不变 | 业务态 KEEP（**不进 Theme**） |
| `empty` | 不变 | Widget 槽位 KEEP |
| `onCellTap` / `onScroll` / `onSelect` / `onRowSelect` | 不变 | L3 KEEP |

### 2.2 完整示例

```dart
// === 0.2.x ===
TTable(
  columns: [
    TTableCol(title: '姓名', dataIndex: 'name'),
    TTableCol(title: '年龄', dataIndex: 'age'),
  ],
  data: [
    {'name': '张三', 'age': 20},
    {'name': '李四', 'age': 22},
  ],
  bordered: true,
  stripe: true,
  rowHeight: 48,
  footerWidget: Text('共 2 条'),
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TTableThemeData(
      bordered: true,
      stripe: true,
      rowHeight: 48,
    ),
  ),
  child: TTable(
    columns: [
      TTableCol(title: '姓名', dataIndex: 'name'),
      TTableCol(title: '年龄', dataIndex: 'age'),
    ],
    data: [
      {'name': '张三', 'age': 20},
      {'name': '李四', 'age': 22},
    ],
    footer: Text('共 2 条'),
  ),
);
```

### 2.3 保留在构造器的字段（不进 Theme）

| 字段 | 原因 |
|------|------|
| `loading` / `loadingWidget` | bool 业务态 / Widget 槽位 |
| `empty` / `footer` | Widget 槽位 |
| `columns` / `data` | 实例数据 |
| `onCellTap` / `onScroll` / `onSelect` / `onRowSelect` | L3 回调 |

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TTableThemeData(
      bordered: true,
      stripe: true,
      rowHeight: 48,
      height: 400,
      backgroundColor: Colors.white,
    ),
  ),
  child: TTable(columns: [...], data: [...]),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TTableThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（columns / data / loading / loadingWidget / empty / footer / onCellTap / onScroll / onSelect / onRowSelect）
  > TTableThemeData（bordered / stripe / rowHeight / height / width / backgroundColor）
    > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TTable` | ✅ 保留 | Widget |
| `TTableCol` | ✅ 保留 | 列定义数据模型 |
| `TTableAlign` | ✅ 保留 | 对齐枚举 |
| `TTableFixed` | ✅ 保留 | 固定位置枚举 |
| `TTableThemeData` | ✅ 保留 | ThemeExtension |
| 内部 `*Style` / 渲染 helper | 🚫 移出 | 内部实现 |

---

## 5. 升级检查清单

- [ ] `footerWidget` → `footer`
- [ ] `bordered` / `stripe` / `rowHeight` / `height` / `width` / `backgroundColor` → `TTableThemeData`
- [ ] `loading` / `loadingWidget` 保留在构造器（**不进 Theme**）
- [ ] `empty` / `footer` 保留在构造器
- [ ] 内部 `*Style` / 渲染 helper 不在 export 中
- [ ] 更新 Example 页面 + API 文档
