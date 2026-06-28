# TSwitch 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `TSwitchType` → `TSwitchVariant` |
| Rename | `isOn` → `value` |
| Rename | `enable` → `enabled` |
| Rename | `type` → `variant` |
| Delete | 删除 `OnSwitchChanged` typedef |
| New | 新增 `TSwitchThemeData` ThemeExtension |
| New | 新增 `TSwitchResolve` 静态解析器 |
| Migrate | L4 样式字段迁入 `TSwitchThemeData` |

## 迁移清单

### 1. 枚举重命名 `TSwitchType` → `TSwitchVariant`

**0.2.x:**
```dart
TSwitch(
  isOn: true,
  type: TSwitchType.text,
  enable: false,
);
```

**v1.0:**
```dart
TSwitch(
  value: true,
  variant: TSwitchVariant.text,
  enabled: false,
);
```

### 2. 参数重命名

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `isOn` | `value` | 受控值统一为 value |
| `enable` | `enabled` | 禁用参数 |
| `type` | `variant` | 变体类型 |

### 3. 禁用方式

B 类组件禁用用 `enabled: false`（保留构造器参数），不用 `onChanged: null`。

### 4. 删除 typedef

删除 `OnSwitchChanged`，改用 Flutter 内置 `ValueChanged<bool>?`。

### 5. L4 样式字段迁入 `TSwitchThemeData`

`trackOnColor` / `trackOffColor` / `thumbContentOnColor` / `thumbContentOffColor` / `thumbContentOnFont` / `thumbContentOffFont` / `openText` / `closeText`

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/switch/t_switch_theme_data.dart` | 新增（TSwitchThemeData + TSwitchSize/TSwitchVariant） |
| `lib/src/components/switch/t_switch_resolve.dart` | 新增（尺寸/颜色解析） |
| `lib/src/components/switch/t_switch.dart` | 参数重命名 + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 新增 export |
