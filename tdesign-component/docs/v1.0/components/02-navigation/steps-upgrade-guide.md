# TSteps 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `value` 参数（替代 `activeIndex`，优先级更高） |
| New | 新增 `TStepsThemeData` ThemeExtension |
| New | 新增 `themeData` 参数 |
| Compatible | `activeIndex` 保留向后兼容 |

## 迁移清单

### 1. 新增 `value` 参数（推荐）

**0.2.x:**
```dart
TSteps(steps: [...], activeIndex: 1);
```

**v1.0:**
```dart
TSteps(steps: [...], value: 1);
```

### 2. 新增 `TStepsThemeData`

**v1.0:**
```dart
TSteps(
  steps: [...],
  themeData: TStepsThemeData(
    status: TStepsStatus.error,
    simple: true,
  ),
);
```

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/steps/t_steps_theme_data.dart` | 新增 |
| `lib/src/components/steps/t_steps.dart` | 新增 `value`/`themeData` |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/steps/t_steps_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/steps/t_steps_test.dart --no-color
```
