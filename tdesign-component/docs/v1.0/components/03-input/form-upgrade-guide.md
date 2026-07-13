# TForm 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `isHorizontal` → `layout` |
| Rename | `formController` → `controller` |
| Rename | `formShowErrorMessage` → `showErrorMessage` |
| New | 新增 `TFormThemeData` ThemeExtension |
| Keep | 保留 `items` / `data` / `rules` / `btnGroup` / `onSubmit` 架构 |
| Keep | 保留 InheritedWidget 架构（700 行 switch 不重写） |
| Keep | 保留 `TFormItemType` 枚举 |

> **关键决策**：TForm 有 700 行 switch + FormItemNotifier 深度耦合，保留 InheritedWidget 架构，仅做参数字段重命名和 ThemeData 注入。定稿文档中"废弃 items/data"的计划未执行。

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TForm(
  formController: controller,
  formShowErrorMessage: true,
  isHorizontal: true,
  data: formData,
  rules: validationRules,
  items: [...],
);
```

**v1.0:**
```dart
TForm(
  controller: controller,
  showErrorMessage: true,
  layout: true,  // true=水平, false=垂直
  data: formData,
  rules: validationRules,
  items: [...],
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `isHorizontal` | `layout` | 布局方向（bool） |
| `formController` | `controller` | 表单控制器 |
| `formShowErrorMessage` | `showErrorMessage` | 是否显示错误信息 |

### 2. FormController API

`FormController` 仅提供 `submit()` 和 `reset(Map<String, dynamic> data)` 方法，**无** `add()` / `[]` 操作符。

### 3. L4 样式字段迁入 `TFormThemeData`

`colon` / `labelWidth` / `layout` / `contentAlign` 等

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/form/t_form_theme_data.dart` | 新增（TFormThemeData） |
| `lib/src/components/form/t_form.dart` | 参数重命名 |
| `lib/src/components/form/t_form_inherited.dart` | 同步重命名 |
| `lib/tdesign_flutter.dart` | 新增 export |
