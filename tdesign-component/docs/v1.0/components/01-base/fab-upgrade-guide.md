# TFab 0.2.x → V1.0 升级指南

> 基于 [fab.md V1.0 定稿](./fab.md) · [button.md](./button.md) · [theme.md](../../foundation/theme.md)

---

## 1. 变更总览

| 维度 | 0.2.x | V1.0 |
|------|-------|------|
| **内核** | 自绘 InkWell + Container | 内嵌 TButton |
| **回调** | `onClick` | `onPressed` |
| **主题色** | `theme` / `TFabTheme` | `buttonProps.colorScheme` |
| **形状** | `shape` / `TFabShape` | text 推导（纯图标=circle，有text=round） |
| **尺寸** | `size` / `TFabSize` | `buttonProps.size` |
| **定位** | 无（需外层包裹） | `right` / `bottom` + `draggable` / `magnet` |
| **子内容** | text + icon | text + icon 或 `child` 完全自定义 |
| **移除** | `TFabTheme` / `TFabShape` / `TFabSize` 枚举 | → buttonProps |
| **新增** | — | buttonProps / child / tooltip / 拖拽系统 / TFabThemeData |

---

## 2. 逐项代码替换

### 2.1 参数对照

| 0.2.x | V1.0 | 说明 |
|-------|------|------|
| `theme: TFabTheme.primary` | 删除（默认 primary） | — |
| `theme: TFabTheme.defaultTheme` | `buttonProps: TButtonProps(colorScheme: TButtonColorScheme.defaultTheme)` | 迁入 buttonProps |
| `theme: TFabTheme.light` | `buttonProps: TButtonProps(colorScheme: TButtonColorScheme.light)` | 迁入 buttonProps |
| `theme: TFabTheme.danger` | `buttonProps: TButtonProps(colorScheme: TButtonColorScheme.danger)` | 迁入 buttonProps |
| `shape: TFabShape.circle` | 删除（纯图标默认 circle） | 自动推导 |
| `shape: TFabShape.square` | 删除（有 text 自动 round） | 自动推导 |
| `size: TFabSize.large` | `buttonProps: TButtonProps(size: TButtonSize.large)` | 迁入 buttonProps |
| `size: TFabSize.medium` | `buttonProps: TButtonProps(size: TButtonSize.medium)` | 迁入 buttonProps |
| `size: TFabSize.small` | `buttonProps: TButtonProps(size: TButtonSize.small)` | 迁入 buttonProps |
| `size: TFabSize.extraSmall` | `buttonProps: TButtonProps(size: TButtonSize.extraSmall)` | 迁入 buttonProps |
| `onClick: () {}` | `onPressed: () {}` | 直接改名 |

### 2.2 完整示例

```dart
// === 0.2.x ===
TFab(
  theme: TFabTheme.danger,
  shape: TFabShape.circle,
  size: TFabSize.large,
  text: '发布',
  onClick: _handleTap,
),

// === V1.0 ===
TFab(
  text: '发布',
  buttonProps: TButtonProps(
    colorScheme: TButtonColorScheme.danger,
    size: TButtonSize.large,
  ),
  onPressed: _handleTap,
),
```

### 2.3 定位（新增）

```dart
// V1.0 新增：自带定位，放在 Stack 中即可
Stack(
  fit: StackFit.expand,
  children: [
    // 页面内容 ...
    TFab(
      right: 16,
      bottom: 32,
      draggable: true,
      magnet: true,
      onPressed: () {},
    ),
  ],
)
```

### 2.4 child 模式

```dart
// V1.0：完全自定义内容
TFab(
  child: Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.edit, color: Colors.white),
  ),
  onPressed: () {},
)
```

---

## 3. Theme 注入

```dart
// TFabThemeData — 定位层默认值
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      TFabThemeData(
        defaultRight: 24,
        defaultBottom: 48,
        dragTapSlop: 10,
      ),
    ],
  ),
  child: TFab(),
)

// 按钮外观 — TButtonThemeData
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      TButtonThemeData(defaultColorScheme: TButtonColorScheme.danger),
    ],
  ),
  child: TFab(),
)
```

---

## 4. 升级检查清单

- [ ] `onClick` → `onPressed`
- [ ] `theme: TFabTheme.xxx` → `buttonProps: TButtonProps(colorScheme: ...)`
- [ ] `shape: TFabShape.xxx` → 删除（自动推导）
- [ ] `size: TFabSize.xxx` → `buttonProps: TButtonProps(size: ...)`
- [ ] 如需定位：外层 Stack + Fab 自带 right/bottom
- [ ] 无 `TFabTheme` / `TFabShape` / `TFabSize` 枚举引用
