# TImageViewer v1.0 升级指南

> 从 0.2.x 迁移到 v1.0 · **showDialog + 全屏 PageView** · 控制类 **E**
> 基于 [image-viewer.md](./image-viewer.md) · [theme.md](../../foundation/theme.md) · [api.md](../../foundation/api.md)

---

## 1. 变更总览

| 维度 | 0.2.x | v1.0 |
|------|-------|------|
| **背景色** | `bgColor` | 📦 `TImageViewerThemeData.backgroundColor` |
| **导航栏背景** | `navBarBgColor` | 📦 `TImageViewerThemeData.appBarBackgroundColor` |
| **图标色** | `iconColor` | 📦 `TImageViewerThemeData.iconColor` |
| **标签样式** | `labelStyle` | 📦 `TImageViewerThemeData.labelStyle` |
| **页码样式** | `indexStyle` | 📦 `TImageViewerThemeData.indexStyle` |
| **宽高** | `width` / `height` | 📦 `TImageViewerThemeData.viewerWidth` / `viewerHeight` |
| **遮罩色** | `modalBarrierColor` | 📦 `TImageViewerThemeData.barrierColor` |
| **ThemeExtension** | — | ✨ 新增 `TImageViewerThemeData` |
| **P1 读取** | 未读取 ThemeExtension | ✨ `showImageViewer` 中 `??=` theme 回退 |

---

## 2. 逐项代码替换

### 2.1 show API 参数对照

| 0.2.x 参数 | v1.0 参数 | 迁移方式 |
|------------|----------|---------|
| `bgColor` | 📦 `TImageViewerThemeData.backgroundColor` | L4 → Theme |
| `navBarBgColor` | 📦 `TImageViewerThemeData.appBarBackgroundColor` | L4 → Theme |
| `iconColor` | 📦 `TImageViewerThemeData.iconColor` | L4 → Theme |
| `labelStyle` | 📦 `TImageViewerThemeData.labelStyle` | L4 → Theme |
| `indexStyle` | 📦 `TImageViewerThemeData.indexStyle` | L4 → Theme |
| `width` | 📦 `TImageViewerThemeData.viewerWidth` | L4 → Theme |
| `height` | 📦 `TImageViewerThemeData.viewerHeight` | L4 → Theme |
| `modalBarrierColor` | 📦 `TImageViewerThemeData.barrierColor` | L4 → Theme |
| `images` | 不变 | — |
| `labels` | 不变 | — |
| `defaultIndex` | 不变 | — |
| `closeBtn` / `deleteBtn` / `showIndex` | 不变 | — |
| `loop` / `autoplay` | 不变 | — |
| `onClose` / `onDelete` / `onIndexChange` | 不变 | — |
| `onTap` / `onLongPress` | 不变 | — |
| `barrierDismissible` | 不变 | — |

### 2.2 完整示例

```dart
// === 0.2.x ===
TImageViewer.showImageViewer(
  context: context,
  images: ['url1', 'url2'],
  bgColor: Colors.black,
  navBarBgColor: Colors.black87,
  iconColor: Colors.white,
  labelStyle: TextStyle(color: Colors.white),
  indexStyle: TextStyle(color: Colors.white70),
  width: 200,
  height: 200,
  modalBarrierColor: Colors.black54,
);

// === v1.0（L4 参数迁入 Theme 子树注入） ===
Theme(
  data: Theme.of(context).mergeExtension(
    const TImageViewerThemeData(
      backgroundColor: Colors.black,
      appBarBackgroundColor: Colors.black87,
      iconColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white),
      indexStyle: TextStyle(color: Colors.white70),
      viewerWidth: 200,
      viewerHeight: 200,
      barrierColor: Colors.black54,
    ),
  ),
  child: Builder(
    builder: (context) {
      TImageViewer.showImageViewer(
        context: context,
        images: ['url1', 'url2'],
      );
      return SizedBox.shrink();
    },
  ),
);
```

---

## 3. Theme 注入方式

```dart
// 子树注入
Theme(
  data: Theme.of(context).mergeExtension(
    const TImageViewerThemeData(
      backgroundColor: Colors.black,
      iconColor: Colors.white,
    ),
  ),
  child: ...,
);

// 全局注入
MaterialApp(
  theme: ThemeData(
    extensions: [
      const TImageViewerThemeData(iconColor: Colors.white),
    ],
  ),
  ...
)
```

### P1 优先级链

```
showImageViewer() 参数
  > TImageViewerThemeData（theme?.field）
    > Token（context.tTheme）
```

`showImageViewer` 中实现 P1 回退：
```dart
final theme = Theme.of(context).extension<TImageViewerThemeData>();
bgColor ??= theme?.backgroundColor;
navBarBgColor ??= theme?.appBarBackgroundColor;
iconColor ??= theme?.iconColor;
labelStyle ??= theme?.labelStyle;
indexStyle ??= theme?.indexStyle;
modalBarrierColor ??= theme?.barrierColor ?? context.tTheme.fontGyColor1;
width ??= theme?.viewerWidth;
height ??= theme?.viewerHeight;
```

---

## 4. Export 变更

| 符号 | v1.0 是否 export | 说明 |
|------|-----------------|------|
| `TImageViewer` | ✅ 保留 | 工具类 |
| `showImageViewer` | ✅ 保留 | 命令式入口 |
| `TImageViewerThemeData` | ✅ 保留 | ThemeExtension |
| `TImageViewerWidget` | 🚫 移出 | 内部 Widget，不 export |

---

## 5. 后续修复（2026-07-05）

### P1 ThemeExtension 读取补全

**问题**：`TImageViewerThemeData` 已定义但 `showImageViewer` 中未读取，L4 参数无回退链。

**修复**：在 `showImageViewer` 方法开头新增 P1 回退，8 个 L4 字段通过 `??=` 从 `Theme.of(context).extension<TImageViewerThemeData>()` 读取：
- `backgroundColor` / `appBarBackgroundColor` / `iconColor`
- `labelStyle` / `indexStyle`
- `viewerWidth` / `viewerHeight`
- `barrierColor`（回退到 `context.tTheme.fontGyColor1`）

---

## 6. 升级检查清单

- [ ] `bgColor` → `TImageViewerThemeData.backgroundColor`
- [ ] `navBarBgColor` → `TImageViewerThemeData.appBarBackgroundColor`
- [ ] `iconColor` → `TImageViewerThemeData.iconColor`
- [ ] `labelStyle` → `TImageViewerThemeData.labelStyle`
- [ ] `indexStyle` → `TImageViewerThemeData.indexStyle`
- [ ] `width` → `TImageViewerThemeData.viewerWidth`
- [ ] `height` → `TImageViewerThemeData.viewerHeight`
- [ ] `modalBarrierColor` → `TImageViewerThemeData.barrierColor`
- [ ] `showImageViewer` 中 P1 读取 `TImageViewerThemeData`
- [ ] `TImageViewerWidget` 不在 export 中
- [ ] 更新 Example 页面 + API 文档
