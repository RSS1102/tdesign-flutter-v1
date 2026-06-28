# TPopup 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TPopupThemeData` ThemeExtension |
| Compatible | TPopup/TPopupOptions/TPopupHandle 等 API 保留不变 |
| Compatible | TPopupOptions 的 L4 字段保留为实例参数（优先于 Theme） |

## 说明

TPopup 在 v1.0 升级前已基本对齐设计规范。本次仅新增 `TPopupThemeData` 作为 L4 默认值来源。

| TPopupOptions 字段 | TPopupThemeData 字段 | 说明 |
|---|---|---|
| `overlayColor` | `barrierColor` | 蒙层颜色 |
| `overlayOpacity` | `barrierOpacity` | 蒙层透明度 |
| `animationDuration` | `transitionDuration` | 动画时长 |
| `radius` | `panelRadius` | 圆角 |
| `backgroundColor` | `panelBackgroundColor` | 背景色 |
| `useSafeArea` | `useSafeArea` | 安全区 |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/popup/t_popup_theme_data.dart` | 新增 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `example/assets/api/popup_api.md` | API 文档同步 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/popup
flutter build web --release --no-web-resources-cdn
```
