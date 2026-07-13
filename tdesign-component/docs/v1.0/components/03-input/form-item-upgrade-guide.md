# TFormItem 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `formItemNotifier` → `itemNotifier` |
| Rename | `formContentAlign` → `contentAlign` |
| Rename | `formLabelAlign` → `labelAlign` |
| Rename | `hintchild` → `hintText`（Flutter InputDecoration 标准字段） |
| Keep | 保留 `TFormItemType` 枚举 |
| Keep | 保留 `select` / `selectFn` 参数 |

> **关键决策**：与 TForm 一致，保留 InheritedWidget 架构，仅做参数重命名。

## 迁移清单

### 1. 参数重命名

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `formItemNotifier` | `itemNotifier` | 表单项通知器 |
| `formContentAlign` | `contentAlign` | 内容对齐 |
| `formLabelAlign` | `labelAlign` | 标签对齐 |
| `hintchild: Widget` | `hintText: String` | Flutter InputDecoration 标准字段 |

### 2. hintText 类型变化

**0.2.x:**
```dart
TFormItem(
  hintchild: Text('请输入内容'),
);
```

**v1.0:**
```dart
TFormItem(
  hintText: '请输入内容',
);
```

### 3. 保留项

- `TFormItemType` 枚举保留（input/radios/dateTimePicker/cascader/stepper/rate/textarea/upLoadImg）
- `select` / `selectFn` 参数保留
- `type` 参数保留

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/form/t_form_item.dart` | 参数重命名 |
| `lib/src/components/form/t_form_inherited.dart` | 同步重命名 |
