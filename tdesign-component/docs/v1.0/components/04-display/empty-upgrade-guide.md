# TEmpty v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T3 自绘** · 控制类 **A**
> 基于 [empty.md](./empty.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TEmptyType` | ✏️ `variant` / `TEmptyVariant`（plain / operation） |
| **插图** | `icon` | 🔀 `image`（统一 Widget 槽位） |
| **操作区** | `operationText` / `customOperationWidget` | 🔀 `operation`（单槽） |
| **回调** | `onTapEvent` | ✏️ `onTap` |
| **L4 样式** | `emptyTextColor` / `emptyTextFont` / `operationTheme` | 📦 迁入 `TEmptyThemeData` |
| **移除** | `TEmptyType` / `TTapEvent` | 🗑️ 移除 |
| **ThemeExtension** | — | ✨ 新增 `TEmptyThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `enum TEmptyType { ... }` | `enum TEmptyVariant { plain, operation }` |
| `typedef TTapEvent = ...` | 🗑️ 移除（改用 `GestureTapCallback?`） |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TEmptyType.xxx` | ✏️ `variant: TEmptyVariant.xxx` | 枚举改名 |
| `type: TEmptyType.xxx` | ✏️ `variant: TEmptyVariant.xxx` | 参数改名 |
| `icon` | 🔀 `image: Widget?` | 统一 Widget 槽位 |
| `operationText: 'xxx'` | 🔀 `operation: Widget?` | 合并单槽 |
| `customOperationWidget: xxx` | 🔀 `operation: Widget?` | 合并单槽 |
| `onTapEvent` | ✏️ `onTap` | 改名 |
| `emptyTextColor` | 📦 `TEmptyThemeData.textColor` | 迁入 Theme |
| `emptyTextFont` | 📦 `TEmptyThemeData.textFont` | 迁入 Theme |
| `operationTheme` | 📦 `TEmptyThemeData.operationTheme` | 迁入 Theme |
| `title`（emptyText） | 不变 | — |

### 2.3 完整示例

```dart
// === 0.2.x ===
TEmpty(
  type: TEmptyType.operation,
  icon: Icon(Icons.inbox),
  emptyText: '暂无数据',
  operationText: '刷新',
  onTapEvent: () { ... },
  emptyTextColor: Colors.grey,
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TEmptyThemeData(textColor: Colors.grey),
  ),
  child: TEmpty(
    variant: TEmptyVariant.operation,
    image: Icon(Icons.inbox),
    title: '暂无数据',
    operation: TextButton(
      child: Text('刷新'),
      onPressed: () { ... },
    ),
    onTap: () { ... },
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TEmptyThemeData(textColor: Colors.grey, textFont: TextStyle(fontSize: 14)),
  ),
  child: const TEmpty(title: '暂无数据'),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TEmptyThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（image / title / variant / operation / onTap）
  > TEmptyThemeData（textColor / textFont / operationTheme）
    > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TEmpty` | ✅ 保留 | Widget |
| `TEmptyVariant` | ✅ 保留 | 形态枚举 |
| `TEmptyThemeData` | ✅ 保留 | ThemeExtension |
| `TEmptyType` | 🚫 移出 | 已改名 `TEmptyVariant` |
| `TTapEvent` | 🚫 移出 | 废弃 typedef |

---

## 5. 升级检查清单

- [ ] `TEmptyType` → `TEmptyVariant`
- [ ] `type` → `variant`
- [ ] `icon` → `image: Widget?`
- [ ] `operationText` / `customOperationWidget` → `operation: Widget?`
- [ ] `onTapEvent` → `onTap`
- [ ] `emptyTextColor` / `emptyTextFont` / `operationTheme` → `TEmptyThemeData`
- [ ] `TEmptyType` / `TTapEvent` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
