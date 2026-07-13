# TText — v1.0 升级指南

> T2 薄包装层升级 | S2 交付 | 2026-06-27

---

## 1. 变更概览

| 类别 | 0.2.x | v1.0 | 影响 |
|------|--------|------|------|
| 全局变量 | `kTextForceVerticalCenterEnable`<br>`kTextNeedGlobalFontFamily` | **删除**，行为由 Theme / Configuration 控制 | 编译错误 → 需迁移 |
| 样式解析 | `TText.getTextStyle` + `TTextSpan._getTextStyle` 双份独立逻辑 | **`TTextResolve.resolve` / `resolveSpan`** 唯一样式入口 | 透明（内部改） |
| Theme | 无组件级 ThemeExtension | **`TTextThemeData`** 承载 11 个默认字段 | 新增能力 |
| 缓存 key | `(fontSize, height)` 两字段 | **`(fontSize, height, fontFamily, fontWeightIndex, textScale, paddingConfigHash)`** 六字段 | 透明（缓存命中率不变） |
| 版本分支 | `VersionUtil.isAfterThen('3.2.0')` Dart SDK 代理 | **移除**，固定使用当前系数 | 透明（行为不变） |
| height 语义 | `showHeight = min(heightRate, height)` 与 `Container.height` 不一致 | **统一**为 `height`（构造器或 Token 原始因子） | 视觉可能有微小变化 |
| `TTextConfiguration.updateShouldNotify` | 仅监听 `paddingConfig` | 同时监听 **`globalFontFamily`** | 透明（BugFix） |
| 构造器 API | 不变 | **不变**（软收敛） | 零破坏 |

---

## 2. 迁移清单

### 2.1 删除全局变量引用

```dart
// ❌ 0.2.x
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  kTextForceVerticalCenterEnable = true;  // 编译错误！
  kTextNeedGlobalFontFamily = false;      // 编译错误！
}
```

```dart
// ✅ v1.0
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // 使用 TTextThemeData 子树注入
  runApp(
    Theme(
      data: ThemeData(
        extensions: [
          const TTextThemeData(forceVerticalCenter: true),
        ],
      ),
      child: MyApp(),
    ),
  );
}
```

### 2.2 子树级默认样式

```dart
// ✅ 旧方式：逐个组件设置
TText('文本', forceVerticalCenter: true)
TText('另一段', forceVerticalCenter: true)
// ... 每一处都要设置

// ✅ 新方式：Theme 子树统一控制
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      TTextThemeData(
        defaultTextColor: myBrandColor,
        forceVerticalCenter: true,
        defaultFont: Font(size: 18, lineHeight: 26),
      ),
    ],
  ),
  child: Column(children: [
    TText('文本'),          // 自动继承默认颜色 + 居中
    TText('另一段'),        // 同上
    TText('特殊', textColor: Colors.red), // 实例覆盖优先
  ]),
)
```

### 2.3 TTextThemeData 完整字段

| 字段 | 类型 | 默认值 | 对应 0.2.x |
|------|------|--------|-----------|
| `defaultFont` | `Font?` | — | `font` |
| `defaultTextColor` | `Color?` | — | `textColor` |
| `defaultBackgroundColor` | `Color?` | — | `backgroundColor` |
| `forceVerticalCenter` | `bool` | `false` | `kTextForceVerticalCenterEnable` |
| `isTextThrough` | `bool` | `false` | `isTextThrough` |
| `lineThroughColor` | `Color?` | — | `lineThroughColor` |
| `isInFontLoader` | `bool` | `false` | `isInFontLoader` |
| `strutStyle` | `StrutStyle?` | — | `strutStyle` |
| `textWidthBasis` | `TextWidthBasis?` | — | `textWidthBasis` |
| `textHeightBehavior` | `TextHeightBehavior?` | — | `textHeightBehavior` |
| `textScaleFactor` | `double?` | — | `textScaleFactor` |

---

## 3. 内部架构变更（开发者透明）

### 3.1 样式解析单路径

```
0.2.x                                v1.0
─────────────────────────────────    ─────────────────────────────────
TText.getTextStyle()                 TTextResolve.resolve()
  ├─ Token 直读                        ├─ P0 style 实例
  ├─ globalFontFamily 注入             ├─ 构造器糖
  ├─ iOS PingFang 补丁                 ├─ TTextConfiguration
  └─ isInFontLoader 分支               ├─ TTextThemeData (⚠ 新增)
                                       ├─ TextTheme / Token
TTextSpan._getTextStyle()              └─ iOS PingFang 补丁
  ├─ Token 直读                      TTextResolve.resolveSpan()
  ├─ ❌ 无 globalFontFamily            ├─ 同上（不含 TTextConfiguration）
  ├─ ❌ 无 iOS PingFang                └─ iOS PingFang 补丁 (⚠ 新增)
  └─ ❌ 无 isInFontLoader
```

**关键修复**：TTextSpan 现在也享受 iOS PingFang 回退，解决了富文本中字体不一致问题。

### 3.2 缓存 key 扩容

```dart
// ❌ 0.2.x：仅 fontSize + height
static final Map<double, Map<double, EdgeInsetsGeometry>> _cacheMap = {};

// ✅ v1.0：fontFamily + fontWeight + textScale + paddingConfig 也参与
static final Map<(double, double, String?, int?, double, int), EdgeInsetsGeometry> _cacheMap = {};
```

- 切换字体后不再命中过期缓存
- accessibility 大字体模式正确区分

### 3.3 版本分支删除

```dart
// ❌ 0.2.x
if (VersionUtil.isAfterThen('3.2.0')) {
  return -20 / 128;
} else {
  return -7 / 128;
}

// ✅ v1.0（Flutter ≥3.41，固定使用新路径）
return -20 / 128;
```

### 3.4 height 语义统一

```dart
// ❌ 0.2.x
var showHeight = min(paddingConfig.heightRate, height);
Container(height: fontSize * height,         // 使用原始 height
  child: Text(style: TextStyle(height: showHeight)));  // 使用截断 showHeight

// ✅ v1.0
Container(height: fontSize * height,
  child: Text(style: TextStyle(height: height)));  // 统一 height
```

---

## 4. 文件清单

| 文件 | 操作 |
|------|------|
| `lib/src/components/text/t_text.dart` | ✏️ 修改（删除全局变量、委托 Resolve、修复缓存/height） |
| `lib/src/components/text/t_text_theme_data.dart` | 🆕 新建（ThemeExtension） |
| `lib/src/components/text/t_text_resolve.dart` | 🆕 新建（单路径样式解析） |
| `lib/src/components/text/t_font_loader.dart` | ✅ 不变 |
| `lib/tdesign_flutter.dart` | ✏️ 新增 `TTextThemeData` export |
| `example/lib/page/t_text_page.dart` | ✏️ 新增 Theme Demo + 修复签名 |
| `example/assets/api/text_api.md` | ✏️ 新增 TTextThemeData / TTextResolve 说明 |
| `test/components/text/t_text_test.dart` | 🆕 新建（27 个测试） |

---

## 5. 快速验证

```bash
flutter test test/components/text/t_text_test.dart
```

预期：**27 tests passed**。
