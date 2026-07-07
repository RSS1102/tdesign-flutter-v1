# TAvatar v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 CircleAvatar** · 控制类 **A**
> 基于 [avatar.md](./avatar.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **形态** | `TAvatarType` / `TAvatarShape` | ✏️ `variant` / `TAvatarVariant`（circle / square） |
| **尺寸** | `avatarSize` | ✏️ `size` / `TAvatarSize`（large / medium / small） |
| **L4 样式** | 构造器 `shape` / `radius` / `avatarSize` / `avatarDisplayBorder` / `backgroundColor` | 📦 迁入 `TAvatarThemeData` |
| **移除** | `fit` / `onLongPress` | 🗑️ 删除 |
| **ThemeExtension** | — | ✨ 新增 `TAvatarThemeData` |

---

## 2. 逐项代码替换

### 2.1 枚举改名

| 删（0.2.x） | 增（v1.0） |
|----|----|
| `enum TAvatarType { circle, square }` | `enum TAvatarVariant { circle, square }` |
| `enum TAvatarShape { ... }` | 合并入 `TAvatarVariant` |
| — | `enum TAvatarSize { large, medium, small }` |

### 2.2 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `TAvatarType.circle` | ✏️ `variant: TAvatarVariant.circle` | 枚举改名 |
| `TAvatarShape.xxx` | ✏️ `variant: TAvatarVariant.xxx` | 合并 |
| `avatarSize: xxx` | ✏️ `size: TAvatarSize.xxx` | 改名 |
| `shape` | 📦 `TAvatarThemeData.shape` | 迁入 Theme |
| `radius` | 📦 `TAvatarThemeData.radius` | 迁入 Theme |
| `avatarDisplayBorder` | 📦 `TAvatarThemeData.border` | 迁入 Theme |
| `backgroundColor` | 📦 `TAvatarThemeData.backgroundColor` | 迁入 Theme |
| `fit` | 🗑️ 删除 | 内部 Image 自动处理 |
| `onLongPress` | 🗑️ 删除 | A 类不需要 |
| `src` | 不变 | — |
| `child` | 不变 | — |
| `text` | 不变 | — |
| `icon` | 不变 | — |
| `onTap` | 不变 | — |

### 2.3 完整示例

```dart
// === 0.2.x ===
TAvatar(
  src: 'https://example.com/avatar.png',
  avatarSize: TAvatarSize.large,
  shape: TAvatarShape.circle,
  radius: 40,
  backgroundColor: Colors.grey,
  avatarDisplayBorder: Border.all(color: Colors.white, width: 2),
  fit: BoxFit.cover,
  onTap: () { ... },
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TAvatarThemeData(
      radius: 40,
      backgroundColor: Colors.grey,
      border: BorderSide(color: Colors.white, width: 2),
    ),
  ),
  child: TAvatar(
    src: 'https://example.com/avatar.png',
    size: TAvatarSize.large,
    variant: TAvatarVariant.circle,
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
    const TAvatarThemeData(radius: 40, backgroundColor: Colors.grey),
  ),
  child: const TAvatar(text: 'A'),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TAvatarThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（src / child / text / icon / size / variant / onTap）
  > TAvatarThemeData（shape / radius / defaultSize / border / backgroundColor）
    > Material CircleAvatar 默认
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TAvatar` | ✅ 保留 | Widget |
| `TAvatarSize` | ✅ 保留 | 尺寸枚举 |
| `TAvatarVariant` | ✅ 保留 | 形态枚举 |
| `TAvatarThemeData` | ✅ 保留 | ThemeExtension |
| `TAvatarType` / `TAvatarShape` | 🚫 移出 | 已合并入 `TAvatarVariant` |

---

## 5. 升级检查清单

- [ ] `TAvatarType` / `TAvatarShape` → `TAvatarVariant`
- [ ] `avatarSize` → `size: TAvatarSize.xxx`
- [ ] `shape` / `radius` / `avatarDisplayBorder` / `backgroundColor` → `TAvatarThemeData`
- [ ] 删除 `fit` / `onLongPress` 引用
- [ ] `TAvatarType` / `TAvatarShape` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
