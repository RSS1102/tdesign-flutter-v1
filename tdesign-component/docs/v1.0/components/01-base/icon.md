# TIcon — v1.0 定稿

> Sprint **S2** | **—** 纯展示 · **T2** · 源码：`lib/src/components/icon` · 依赖 [tdesign_icons](https://pub.dev/packages/tdesign_icons) `^0.0.4` · **代码待落地**

## 资源剥离 · 使用方案

**0.2.x（现仓库）**：图标资源内嵌在 `tdesign_flutter`（`t_icons.dart` + `t_icons.ttf`）。

**资源包（已完成）**：图标资源已独立发布 [`tdesign_icons`](https://pub.dev/packages/tdesign_icons) **v0.0.4**（[pub.dev](https://pub.dev/packages/tdesign_icons) · [GitHub](https://github.com/Tencent/tdesign-icons/tree/develop/packages/flutter)），含 TTF、`TIcons`、`TIcons.allIconsMap`。要求 Flutter **≥ 3.32.0**。

**组件库接入（v1.0 待落地）**：`pubspec` 增加 `tdesign_icons: ^0.0.4`；删除内嵌 `t_icons.dart` / `t_icons.ttf`；`icon/` 承载 `TIcon` + re-export `TIcons`。

**目标使用方案**（接入后）：

| 层 | 位置 | 做什么 |
| --- | --- | --- |
| 数据 | `tdesign_icons` **v0.0.4** | `TIcons.xxx`（`IconData`） |
| 组件 | `tdesign_flutter` / `icon/` | `TIcon`、`TIconThemeData` |
| 业务 | 一行 import | `import 'package:tdesign_flutter/tdesign_flutter.dart'` |

图标名：[tdesign.tencent.com/icons](https://tdesign.tencent.com/icons)

**使用 Demo**（接入后；Theme 细节见 §3）：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';

TIcon(TIcons.home_filled)
TIcon(TIcons.home_filled, size: 24, color: Colors.blue)
TIcon.fromName('home_filled')   // TIcons.allIconsMap
```

调用链：`TIcons`（数据）→ `TIcon`（组件）→ 内部 `Icon` 渲染字体。

> 子组件（如 TButton）的 `icon:` 参数见各组件 md，可用 `Icon(TIcons.xxx)`，**不强制** `TIcon`。

**读法**：§1 API · §2 升级 · §3 Theme · §4 落地

---

## 架构

Material `Icon` 薄包装 · 纯展示 · 默认 `size` / `color` 走 `TIconThemeData` → `IconTheme`。资源与组件分工见上文 **资源剥离 · 使用方案**。

---

## 1. API

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `icon` | `IconData` | 位置参数 |
| `size` / `color` | `double?` / `Color?` | 默认 Theme |
| `semanticLabel` | `String?` | 可选 |
| `TIcon.fromName` | 工厂 | `allIconsMap[name]` |

**export**：`TIcon` · `TIconThemeData` · `TIcons`（re-export）｜**移出**：`_TIconsData` · 内嵌字体/`t_icons.dart`

---

## 2. 0.2.x → v1.0

| 0.2.x（现仓库） | v1.0（目标） |
| --- | --- |
| 内嵌 `t_icons.dart` + `t_icons.ttf` | 删；`dependencies: tdesign_icons: ^0.0.4` |
| `TIcons.all` / `value.name` | `TIcons.allIconsMap` / map **key** |
| 仅 `TIcons` 常量 | + `TIcon` · `TIconThemeData` · `icon.dart` |
| Flutter ≥ 3.16 | 随 `tdesign_icons` 升至 **≥ 3.32** |

其它组件 `IconData?`→`Widget?` 另文改；`Icon(TIcons.xxx)` 通常不动。码点可能变化，接入后目视回归。

---

## 3. Theme

`TIconThemeData`（`size` · `color`）配子树默认尺寸/颜色。覆盖：构造器 **>** `TIconThemeData` **>** `IconTheme`。

**子树**（`mergeExtension`）：

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TIconThemeData(size: 20, color: Colors.grey),
  ),
  child: Column(
    children: [
      TIcon(TIcons.home),              // 20 · grey
      TIcon(TIcons.setting, size: 24), // 构造器 size 优先
    ],
  ),
)
```

**全局**（`MaterialApp.theme.extensions`）：

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [TIconThemeData(size: 16)],
  ),
  // ...
)
```

> `Icon(TIcons.xxx)` 只走 `IconTheme`，**不读** `TIconThemeData`；要 Theme 统一请用 `TIcon`。

---

## 4. 落地 · 测试

**待实现文件**：`icon.dart` · `t_icon.dart` · `t_icon_theme_data.dart`（禁止本库生成 `TIcons` 或声明字体）

**接入清单**：`pubspec` 加依赖并删字体 · `tdesign_flutter.dart` export 改 `icon.dart` · demo 改 `allIconsMap` · deep import 改 barrel

| 测什么 | 范围 |
| --- | --- |
| Widget | `TIcon` 渲染、`size`/`color` 构造器覆盖 |
| Theme | `TIconThemeData` 子树默认、`IconTheme` 回退 |
| 工厂 | `TIcon.fromName` 合法名 / 非法名 |
| 包拆分 | import 可用 `TIcons`；字体来自 `tdesign_icons` |
| 升级 | example 浏览/搜索 `allIconsMap`；全库图标目视抽样 |
