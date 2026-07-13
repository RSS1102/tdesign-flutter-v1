# TTextarea 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TTextareaLayout` 枚举 |
| New | 共用 `TInputThemeData` + `TInputResolve` |
| New | 新增 `inputDecoration` 字段 |
| Migrate | L4 样式字段迁入 `TInputThemeData` |

## 迁移清单

### 1. 共用 TInput 主题

TTextarea 不再独立维护样式字段，与 TInput 共用 `TInputThemeData`。

### 2. L4 样式字段迁入 `TInputThemeData`

以下字段从构造器参数迁移到 `TInputThemeData`：

`textStyle` / `hintTextStyle` / `labelStyle` / `backgroundColor` / `textInputBackgroundColor` / `cursorColor` / `additionInfoColor` / `labelWidth` / `margin` / `padding` / `bordered`

### 3. 新增 `TTextareaLayout` 枚举

```dart
enum TTextareaLayout { vertical, horizontal }
```

**v1.0:**
```dart
TTextarea(
  layout: TTextareaLayout.vertical,
  hintText: '请输入个人简介',
  maxLength: 500,
);
```

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/textarea/t_textarea.dart` | 共用 TInputThemeData+Resolve，新增 TTextareaLayout 枚举，新增 inputDecoration 字段 |
| `lib/tdesign_flutter.dart` | export 更新 |
