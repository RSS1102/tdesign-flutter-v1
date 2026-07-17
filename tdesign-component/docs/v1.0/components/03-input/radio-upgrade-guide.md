# TRadio v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Refactor | `TRadio<T>` 改为严格受控的独立组件，不再继承 `TCheckbox` |
| Refactor | `TRadioGroup<T>` 使用外部 `value + onChanged`，删除 Controller |
| Delete | 删除 `TRadioVariant`、`radioStyle`、`radioCheckStyle` |
| Delete | 删除 `enabled`，统一使用 `onChanged: null` 禁用 |
| Visual | 标准指示器固定为圆环加实心圆点 |
| Theme | 颜色、文案和间距由 `TRadioThemeData` 管理 |

## 迁移方式

### 单颗 Radio

```dart
TRadio<String>(
  value: 'a',
  groupValue: selected,
  onChanged: (value) => setState(() => selected = value),
  title: '选项 A',
)
```

`onChanged: null` 同时表达行为禁用和视觉禁用。

### Radio Group

```dart
TRadioGroup<String>(
  value: selected,
  options: const [
    TRadioOption(value: 'a', label: '选项 A'),
    TRadioOption(value: 'b', label: '选项 B', disabled: true),
  ],
  onChanged: (value) => setState(() => selected = value),
)
```

### 自定义指示器

v1.0 不再提供方形、勾选、check-circle 或 hollowCircle 变体。确有非标准视觉需求时使用 `customIconBuilder`：

```dart
TRadio<String>(
  value: 'a',
  groupValue: selected,
  onChanged: onChanged,
  customIconBuilder: (context, selected, disabled) {
    return MyRadioIndicator(selected: selected, disabled: disabled);
  },
)
```

## 删除项

- `TRadioVariant`
- `TRadioStyle`
- `radioStyle`
- `radioCheckStyle`
- `TRadioGroupController`
- `OnRadioGroupChange`
- `enabled`

不提供兼容别名。
