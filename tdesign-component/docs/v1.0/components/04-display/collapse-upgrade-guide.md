# TCollapse v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 ExpansionPanelList** · 控制类 **B**（手风琴）/ **C**（多开）
> 基于 [collapse.md](./collapse.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **回调** | `expansionCallback` | ✏️ `onExpansionChanged` |
| **初始展开** | `initialOpenPanelValue` | ✏️ `value`（手风琴受控） |
| **展开模式** | — | ✨ `mode: TCollapseMode`（accordion / multiple） |
| **手风琴回调** | — | ✨ `onChanged`（B 类受控） |
| **L4 样式** | `TCollapseStyle` / `style` / `backgroundColor` | 📦 迁入 `TCollapseThemeData` |
| **移除** | `TCollapseStyle` | 🗑️ 迁入 Theme |
| **ThemeExtension** | — | ✨ 新增 `TCollapseThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `expansionCallback` | ✏️ `onExpansionChanged` | 对齐 Material |
| `initialOpenPanelValue` | ✏️ `value` | 命名对齐 v1.0 |
| `TCollapseStyle.block` / `.card` | 📦 `TCollapseThemeData.style` | 迁入 Theme |
| `style` | 📦 `TCollapseThemeData.style` | 迁入 Theme |
| `backgroundColor` | 📦 `TCollapseThemeData.backgroundColor` | 迁入 Theme |
| `children` | 不变（`List<TCollapsePanel>`） | — |
| `mode` | ✨ 新增 | 展开模式 |
| `value` | ✨ 新增 | 手风琴受控 |
| `onChanged` | ✨ 新增 | 手风琴回调 |

### 2.2 TCollapsePanel 参数

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `headerBuilder` | `header: Widget?` | 改为 Widget 槽位 |
| `body` | `body: Widget?` | 不变 |
| `isExpanded` | 不变 | 多开模式展开态 |
| `canTapOnHeader` | 不变 | — |
| — | `value: Object?` | 手风琴模式必填 |
| — | `expandIconTextBuilder` | 展开图标旁文案 |

### 2.3 完整示例

```dart
// === 0.2.x ===
TCollapse(
  initialOpenPanelValue: 0,
  expansionCallback: (index, isExpanded) { ... },
  children: [
    ExpansionPanel(headerBuilder: (ctx, exp) => Text('面板1'), body: Text('内容1')),
  ],
);

// === v1.0（手风琴模式） ===
TCollapse(
  mode: TCollapseMode.accordion,
  value: _currentPanel,
  onChanged: (value) {
    setState(() => _currentPanel = value);
  },
  children: [
    TCollapsePanel(
      value: 0,
      header: Text('面板1'),
      body: Text('内容1'),
    ),
  ],
);

// === v1.0（多开模式） ===
TCollapse(
  mode: TCollapseMode.multiple,
  onExpansionChanged: (index, isExpanded) { ... },
  children: [
    TCollapsePanel(
      header: Text('面板1'),
      body: Text('内容1'),
      isExpanded: true,
    ),
  ],
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TCollapseThemeData(
      style: TCollapsePanelStyle.card,
      backgroundColor: Colors.white,
    ),
  ),
  child: TCollapse(children: [...]),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TCollapseThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（mode / value / children / onExpansionChanged / onChanged）
  > TCollapseThemeData（style / backgroundColor / animationDuration / elevation）
    > Material ExpansionPanelList
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TCollapse` | ✅ 保留 | Widget |
| `TCollapsePanel` | ✅ 保留 | 面板数据模型 |
| `TCollapseMode` | ✅ 保留 | 展开模式枚举 |
| `TCollapseThemeData` | ✅ 保留 | ThemeExtension |
| `TCollapseStyle` | 🚫 移出 | 已迁入 `TCollapseThemeData.style` |

---

## 5. 升级检查清单

- [ ] `expansionCallback` → `onExpansionChanged`
- [ ] `initialOpenPanelValue` → `value`（手风琴模式）
- [ ] 新增 `mode: TCollapseMode.accordion/multiple`
- [ ] `TCollapseStyle` → `TCollapseThemeData.style`
- [ ] `style` / `backgroundColor` → `TCollapseThemeData`
- [ ] `headerBuilder` → `header: Widget?`
- [ ] `TCollapseStyle` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
