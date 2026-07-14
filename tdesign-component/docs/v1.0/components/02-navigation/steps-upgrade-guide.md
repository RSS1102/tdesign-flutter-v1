# TSteps 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Changed | 使用 `value` 作为唯一当前步索引参数，移除旧 `activeIndex` |
| New | 新增 `TStepsThemeData` ThemeExtension |
| Removed | 移除 `themeData` 构造器参数（改用 `mergeExtension` 子树覆盖） |

## 迁移清单

### 1. 使用 `value` 控制当前步

**0.2.x:**
```dart
TSteps(steps: [...], activeIndex: 1);
```

**v1.0:**
```dart
TSteps(steps: [...], value: 1);
```

### 2. `themeData` 参数已移除 — 改用 `mergeExtension`

`themeData` 构造器参数已移除（对齐 theme.md §2.1）。样式定制通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。

**❌ 已移除:**
```dart
TSteps(
  steps: [...],
  themeData: TStepsThemeData(simple: true),  // 已删除
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TStepsThemeData(simple: true),
  ),
  child: TSteps(steps: [...]),
);
```

### 3. 优先级规则

构造器参数 > `Theme.of(context).extension<TStepsThemeData>()` > 内置默认值

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/steps/t_steps_theme_data.dart` | 新增 |
| `lib/src/components/steps/t_steps.dart` | 新增 `value`；移除 `themeData`；P1 读取 |
| `lib/tdesign_flutter.dart` | 新增 export |
| `test/components/steps/t_steps_test.dart` | 新增测试 |

## 验证命令

```bash
cd tdesign-component
flutter test test/components/steps/t_steps_test.dart --no-color
```
