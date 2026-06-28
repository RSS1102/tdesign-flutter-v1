# TSlider 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `leftLabel` → `label` |
| Rename | `onChange` → `onChanged` |
| Keep | 保留内部 `TSliderThemeData` class（73KB 伪 ThemeData 不拆分） |
| Keep | 保留 `onTap` / `onThumbTextTap` 参数 |

> **关键决策**：TSlider 内部有 73KB 的伪 ThemeData class 与 Widget 深度耦合，不拆分为 ThemeExtension，仅做命名修正。

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TSlider(
  leftLabel: '亮度',
  onChange: (val) {},
);
```

**v1.0:**
```dart
TSlider(
  label: '亮度',
  onChanged: (val) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `leftLabel` | `label` | 标签文案 |
| `onChange` | `onChanged` | 回调命名对齐 v1.0 |

### 2. 保留项

- 内部 `TSliderThemeData` class 保留不动（非 ThemeExtension）
- `onTap` / `onThumbTextTap` 参数保留

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/slider/t_slider.dart` | `leftLabel`→`label`, `onChange`→`onChanged` |
| `example/lib/page/t_slider_page.dart` | 15 处 `leftLabel`→`label` |
