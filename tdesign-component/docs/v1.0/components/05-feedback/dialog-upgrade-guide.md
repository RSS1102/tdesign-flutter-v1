# TDialog 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `TDialogButtonOptions.action`→`onPressed` |
| Compatible | `showAlert`/`showConfirm`/`showInput` 命令式 show 保留 |
| Compatible | `TAlertDialog`/`TConfirmDialog`/`TInputDialog` 声明式 Widget 保留 |
| Compatible | `title`/`content`/`contentWidget`/`leftBtn`/`rightBtn`/`buttons`/`barrierDismissible` 保留 |
| Deprecated | `TDialogButtonOptions.style`/`type`/`theme` 标记为废弃（后续迁入 `TDialogThemeData`） |

## 迁移清单

### 1. `TDialogButtonOptions.action` → `onPressed`

**0.2.x:**
```dart
TDialogButtonOptions(
  title: '确认',
  action: () { Navigator.pop(context); },
);
```

**v1.0:**
```dart
TDialogButtonOptions(
  title: '确认',
  onPressed: () { Navigator.pop(context); },
);
```

### 2. 声明式 Widget 中的 `action` → `onPressed`

`TConfirmDialog` 的 `action` 参数同样改名为 `onPressed`。

**0.2.x:**
```dart
TConfirmDialog(
  title: '标题',
  action: () { ... },
);
```

**v1.0:**
```dart
TConfirmDialog(
  title: '标题',
  onPressed: () { ... },
);
```

## 保留的 API

| 符号 | 说明 |
|------|------|
| `showAlert`/`showConfirm`/`showInput` | 命令式 show 三族 |
| `TAlertDialog`/`TConfirmDialog`/`TInputDialog` | 声明式 Widget |
| `TDialogButtonOptions` | 按钮配置（`title`/`onPressed`/`titleColor`/`titleSize`/`height`/`fontWeight`） |
| `title`/`content`/`contentWidget` | 文案与自定义内容 |
| `leftBtn`/`rightBtn`/`buttons` | 按钮区 |
| `barrierDismissible` | 点击蒙层关闭 |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/dialog/t_dialog.dart` | `TDialogButtonOptions.action`→`onPressed` |
| `lib/src/components/dialog/t_confirm_dialog.dart` | `action` 字段→`onPressed` |
| `lib/src/components/dialog/t_dialog_widget.dart` | `.action` 属性访问→`.onPressed` |
| `lib/src/components/dialog/t_alert_dialog.dart` | `action:`→`onPressed:` |
| `lib/src/components/dialog/t_input_dialog.dart` | `action:`→`onPressed:` |
| `lib/src/components/dialog/t_image_dialog.dart` | `action:`→`onPressed:` |
| `example/lib/page/t_dialog_page.dart` | 全部改为新 API |
| `example/assets/api/dialog_api.md` | API 文档同步 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/dialog
flutter build web --release --no-web-resources-cdn
```
