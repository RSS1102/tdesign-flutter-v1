# TNavBar — v1.0 升级指南

> A 类组件升级 | S3 交付 | 2026-06-27

---

## 1. 变更概览

| 类别 | 0.2.x | v1.0 | 影响 |
|------|--------|------|------|
| 左侧操作项 | `leftBarItems` | **`leading`** | 对齐 AppBar 命名 |
| 右侧操作项 | `rightBarItems` | **`actions`** | 对齐 AppBar 命名 |
| 屏幕适配 | `screenAdaptation` | — | **废弃**：外层手动处理安全区域 |
| 边框样式 | `TNavBarItemBorder` | **`TNavBarBorder`** + Theme | 改名；迁入 ThemeData |
| L4 样式 | 构造器全量参数 | **`TNavBarThemeData`** | 13 个样式参数迁入 Theme |
| Theme | 无组件级 Theme | **`TNavBarThemeData`**（ThemeExtension） | 新增能力 |
| 禁用 | 无统一语义 | A 类：`action: null` / `onBack: null` | 语义统一 |

---

## 2. 迁移清单

### 2.1 构造器参数迁移

```dart
// ❌ 0.2.x
TNavBar(
  title: '标题',
  leftBarItems: [TNavBarItem(icon: TIcons.close)],
  rightBarItems: [TNavBarItem(icon: TIcons.home)],
  screenAdaptation: false,
)

// ✅ v1.0
TNavBar(
  title: '标题',
  leading: [TNavBarItem(icon: TIcons.close)],
  actions: [TNavBarItem(icon: TIcons.home)],
  // screenAdaptation 已移除，安全区域由外层 Padding/SafeArea 处理
)
```

### 2.2 L4 样式迁入 Theme

0.2.x 中 13 个样式参数分布在构造器中，v1.0 统一迁入 `TNavBarThemeData`：

| 0.2.x 构造器参数 | TNavBarThemeData 字段 |
|------------------|----------------------|
| `titleColor` | `titleColor` |
| `backIconColor` | `backIconColor` |
| `titleFont` | `titleFont` |
| `titleFontWeight` | `titleFontWeight` |
| `titleFontFamily` | `titleFontFamily` |
| `backgroundColor` | `backgroundColor` |
| `height` | `height` |
| `padding` | `padding` |
| `titleMargin` | `titleMargin` |
| `opacity` | `opacity` |
| `useBorderStyle` | `useBorderStyle` |
| `border` | `border`（`TNavBarBorder`） |
| `boxShadow` | `boxShadow` |

构造器仍保留这些参数用于**实例级覆盖**（优先级高于 Theme）。

```dart
// 全局注入
MaterialApp(
  theme: ThemeData(
    extensions: const [
      TNavBarThemeData(
        height: 56,
        backgroundColor: Colors.white,
        titleFontWeight: FontWeight.w600,
      ),
    ],
  ),
)

// 子树注入
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      TNavBarThemeData(
        titleColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    ],
  ),
  child: TNavBar(title: '页面标题'),
)
```

### 2.3 screenAdaptation 迁移

```dart
// ❌ 0.2.x：组件内处理安全区域
TNavBar(screenAdaptation: true, ...)

// ✅ v1.0：外层 Padding/SafeArea 处理
Padding(
  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
  child: TNavBar(...),
)
```

### 2.4 TNavBarItemBorder → TNavBarBorder

```dart
// ❌ 0.2.x
TNavBar(border: TNavBarItemBorder(width: 1.0, radius: 22.0), ...)

// ✅ v1.0
TNavBar(border: TNavBarBorder(width: 1.0, radius: 22.0), ...)
```

---

## 3. 优先级链

```
构造器参数 (height / titleColor / backgroundColor / ...)
  > TNavBarThemeData (子树 ThemeExtension 注入)
    > 内部默认值 (height: 48 / fontSize: fontBodyLarge / 等)
```

---

## 4. 文件清单

| 文件 | 操作 |
|------|------|
| `lib/src/components/navbar/t_nav_bar.dart` | ✏️ 重构（leftBarItems→leading、rightBarItems→actions、废弃 screenAdaptation/TNavBarItemBorder、L4 参数保留但可选） |
| `lib/src/components/navbar/t_nav_bar_theme_data.dart` | 🆕 新建（TNavBarThemeData + TNavBarBorder） |
| `lib/tdesign_flutter.dart` | ✏️ export 新增 ThemeData/Border |
| `example/lib/page/t_navbar_page.dart` | ✏️ 重写为 v1.0 API |
| `example/assets/api/navbar_api.md` | ✏️ API 文档更新 |
| `test/components/navbar/t_nav_bar_test.dart` | 🆕 新建（28 个测试） |
| `docs/v1.0/components/02-navigation/navbar-upgrade-guide.md` | 🆕 本文档 |

---

## 5. 快速验证

```bash
flutter test test/components/navbar/t_nav_bar_test.dart
dart analyze lib/src/components/navbar/
```
