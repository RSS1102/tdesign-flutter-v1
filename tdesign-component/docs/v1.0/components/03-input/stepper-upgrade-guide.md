# TStepper 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChange` → `onChanged` |
| Rename | `TStepperTheme` → `TStepperColorScheme` |
| Rename | `theme` → 保留（但枚举改名） |
| Delete | 删除 `defaultValue` 字段 |
| Delete | 删除重复 `TStepperColorScheme` 定义 |
| New | 新增 `TStepperThemeData` ThemeExtension |
| Fix | 修复 `flutter/services.dart` show 导入冲突 |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TStepper(
  defaultValue: 5,
  theme: TStepperTheme.filled,
  onChange: (val) {},
);
```

**v1.0:**
```dart
TStepper(
  value: 5,
  theme: TStepperColorScheme.filled,
  onChanged: (val) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `onChange` | `onChanged` | C 类受控 |
| `TStepperTheme` | `TStepperColorScheme` | 枚举重命名 |
| `defaultValue` | 删除 | 改用 `value` 受控 |

### 2. 删除 `defaultValue`

初值由父 State 持有，不用 Widget 级 `defaultValue`。`value` 为必填受控参数。

### 3. 禁用方式

保留 `disabled: true` 参数（C 类组件）。

### 4. L4 样式字段

`inputWidth` 等迁入 `TStepperThemeData`。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/stepper/t_stepper_theme_data.dart` | 新增（TStepperThemeData + TStepperColorScheme） |
| `lib/src/components/stepper/t_stepper.dart` | 参数重命名 + 删除 defaultValue + 移除重复枚举 + 修复 import |
| `lib/tdesign_flutter.dart` | 新增 export |

## 后续修复（2026-07-06）

### 1. `_getIcon` dynamic context 修复

`TStepperIconButton._getIcon(context)` 的 `context` 参数缺少 `BuildContext` 类型注解（默认 `dynamic`），导致 `context.tTheme` 扩展方法运行时抛 `NoSuchMethodError`。修复为 `Icon _getIcon(BuildContext context)`。

### 2. M3 InputDecoration 下划线泄漏修复

`InputDecoration(border: InputBorder.none)` 未设 `enabledBorder`/`focusedBorder`/`disabledBorder`，M3 默认下划线可见。补全 3 个 border 属性为 `InputBorder.none`。
