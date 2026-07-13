# TImage v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **T1 包装 Image** · 控制类 **A**
> 基于 [image.md](./image.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **图片源** | `imgUrl` / `assetUrl` | ✏️ `src`（统一参数名） |
| **形态** | `TImageType` | ✏️ `variant`（如保留） |
| **L4 样式** | `height` / `color` / `opacity` / `centerSlice` / `matchTextDirection` / `gaplessPlayback` / `excludeFromSemantics` / `isAntiAlias` / `cacheHeight` / `cacheWidth` | 📦 迁入 `TImageThemeData` |
| **保留构造器** | `fit` / `filterQuality` / `alignment` / `repeat` | 保留（Material 同名 KEEP） |
| **ThemeExtension** | — | ✨ 新增 `TImageThemeData` |

---

## 2. 逐项代码替换

### 2.1 构造器参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `imgUrl: 'https://...'` | ✏️ `src: 'https://...'` | 统一参数名 |
| `assetUrl: 'assets/...'` | ✏️ `src: 'assets/...'` | 统一参数名 |
| `TImageType.xxx` | ✏️ `variant` | 枚举改名 |
| `height` | 📦 `TImageThemeData.height` | 迁入 Theme |
| `color` | 📦 `TImageThemeData.color` | 迁入 Theme |
| `opacity` | 📦 `TImageThemeData.opacity` | 迁入 Theme |
| `centerSlice` | 📦 `TImageThemeData.centerSlice` | 迁入 Theme |
| `matchTextDirection` | 📦 `TImageThemeData.matchTextDirection` | 迁入 Theme |
| `gaplessPlayback` | 📦 `TImageThemeData.gaplessPlayback` | 迁入 Theme |
| `excludeFromSemantics` | 📦 `TImageThemeData.excludeFromSemantics` | 迁入 Theme |
| `isAntiAlias` | 📦 `TImageThemeData.isAntiAlias` | 迁入 Theme |
| `cacheHeight` | 📦 `TImageThemeData.cacheHeight` | 迁入 Theme |
| `cacheWidth` | 📦 `TImageThemeData.cacheWidth` | 迁入 Theme |
| `fit` | 不变 | Material 同名 KEEP |
| `filterQuality` | 不变 | Material 同名 KEEP |
| `alignment` | 不变 | Material 同名 KEEP |
| `repeat` | 不变 | Material 同名 KEEP |
| `frameBuilder` | 不变 | — |
| `loadingBuilder` | 不变 | — |
| `errorBuilder` | 不变 | — |
| `semanticLabel` | 不变 | — |
| `onTap` | 不变 | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TImage(
  imgUrl: 'https://example.com/image.png',
  height: 200,
  color: Colors.red,
  cacheWidth: 100,
  fit: BoxFit.cover,
);

// === v1.0 ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TImageThemeData(height: 200, color: Colors.red, cacheWidth: 100),
  ),
  child: TImage(
    src: 'https://example.com/image.png',
    fit: BoxFit.cover,
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TImageThemeData(height: 200, color: Colors.red),
  ),
  child: TImage(src: 'https://example.com/image.png'),
);

// 全局注入
MaterialApp(
  theme: ThemeData(extensions: [const TImageThemeData()]),
  ...
)
```

### 优先级链

```
构造器参数（src / fit / filterQuality / alignment / repeat / frameBuilder / loadingBuilder / errorBuilder / semanticLabel / onTap）
  > TImageThemeData（height / color / opacity / centerSlice / matchTextDirection / gaplessPlayback / excludeFromSemantics / isAntiAlias / cacheHeight / cacheWidth）
    > Material Image
      > Token
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TImage` | ✅ 保留 | Widget |
| `TImageThemeData` | ✅ 保留 | ThemeExtension |
| `TImageType` | 🚫 移出 | 已改为 `variant` |
| 内部 `image_widget.dart` | 🚫 移出 | 内部 Widget |

---

## 5. 升级检查清单

- [ ] `imgUrl` / `assetUrl` → `src`
- [ ] `TImageType` → `variant`
- [ ] `height` / `color` / `opacity` / `centerSlice` 等 L4 → `TImageThemeData`
- [ ] `fit` / `filterQuality` / `alignment` / `repeat` 保留在构造器
- [ ] `TImageType` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
