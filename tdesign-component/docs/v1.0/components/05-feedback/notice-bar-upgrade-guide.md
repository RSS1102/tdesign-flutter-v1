# TNoticeBar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TNoticeBarThemeData` ThemeExtension |
| New | 新增 `TNoticeBarVariant` 枚举（原 `TNoticeBarTheme`） |
| New | 新增 `themeData` 参数 |
| Migration | `style`/`marquee`/`speed`/`interval`/`theme`/`prefixIcon`/`suffixIcon`/`height` 从构造器迁入 `TNoticeBarThemeData` |
| Rename | `onTap`→`onPressed` |
| Delete | 删除 `t_notice_bar_style.dart`（`TNoticeBarStyle`/`TNoticeBarTheme`/`TNoticeBarType`） |
| Breaking | 移除 deprecated `context` 参数（统一用 `content`） |
| Compatible | `content`/`direction`/`maxLines`/`left`/`right` 保留为实例参数 |

## 迁移清单

### 1. L4 样式参数迁入 `TNoticeBarThemeData`

**0.2.x:**
```dart
TNoticeBar(
  content: '提示文字',
  marquee: true,
  speed: 50,
  prefixIcon: TIcons.sound,
  suffixIcon: TIcons.close,
  theme: TNoticeBarTheme.info,
  height: 22,
  onTap: (trigger) { ... },
);
```

**v1.0:**
```dart
TNoticeBar(
  content: '提示文字',
  themeData: TNoticeBarThemeData(
    marquee: true,
    speed: 50,
    prefixIcon: TIcons.sound,
    suffixIcon: TIcons.close,
    variant: TNoticeBarVariant.info,
    height: 22,
  ),
  onPressed: (trigger) { ... },
);
```

### 2. `TNoticeBarTheme` → `TNoticeBarVariant`

枚举值不变（info/success/warning/error），仅改名。

### 3. `TNoticeBarStyle` 废弃

原 `TNoticeBarStyle.generateTheme(context, theme: ...)` 改为 `TNoticeBarThemeData(variant: ...).resolve(context)`。

### 4. `context` 参数废弃

0.2.x 的 `context` 参数已废弃，统一用 `content`。

## 保留的实例参数

| 参数 | 类型 | 说明 |
|------|------|------|
| `content` | `dynamic` | 文本内容（String 或 List<String>） |
| `direction` | `Axis?` | 滚动方向 |
| `maxLines` | `int?` | 文本行数（仅静态有效） |
| `left` | `Widget?` | 左侧自定义内容 |
| `right` | `Widget?` | 右侧自定义内容 |
| `onPressed` | `ValueChanged?` | 点击事件 |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/notice_bar/t_notice_bar_theme_data.dart` | 新增 |
| `lib/src/components/notice_bar/t_notice_bar.dart` | 移除 L4 参数，新增 `themeData`，`onTap`→`onPressed` |
| `lib/src/components/notice_bar/t_notice_bar_style.dart` | 删除 |
| `lib/tdesign_flutter.dart` | 移除 style export，新增 theme_data export |
| `example/lib/page/t_notice_bar_page.dart` | 全部改为新 API |
| `example/assets/api/notice-bar_api.md` | API 文档同步 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/notice_bar
flutter build web --release --no-web-resources-cdn
```
