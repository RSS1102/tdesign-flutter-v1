# TInput 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `TInputType` → `TInputLayout` |
| Rename | `TCardStyle` → `TInputCardStyle`（迁入 Theme） |
| Rename | `leftLabel` → `label` |
| Rename | `leftIcon` → `prefix` |
| Rename | `rightWidget` → `suffix` |
| Rename | `needClear` → `showClearButton` |
| Rename | `type` → `layout` |
| New | 新增 `TInputThemeData` ThemeExtension |
| New | 新增 `TInputResolve` 静态解析器 |
| Migrate | L4 样式字段迁入 `TInputThemeData` |

## 迁移清单

### 1. 枚举重命名 `TInputType` → `TInputLayout`

**0.2.x:**
```dart
TInput(
  type: TInputType.normal,
  leftLabel: '标签',
);
```

**v1.0:**
```dart
TInput(
  layout: TInputLayout.normal,
  label: '标签',
);
```

### 2. 参数重命名

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `leftLabel` | `label` | 标签文案 |
| `leftIcon` | `prefix` | 前缀图标 |
| `rightWidget` | `suffix` | 后缀组件 |
| `needClear` | `showClearButton` | 是否显示清除按钮 |
| `type` | `layout` | 布局形态 |
| `leftLabelStyle` | `labelStyle`（保留在构造器） | 标签样式 |

### 3. L4 样式字段迁入 `TInputThemeData`

以下字段从构造器参数迁移到 `TInputThemeData`：

`backgroundColor` / `textInputBackgroundColor` / `textStyle` / `hintTextStyle` / `cursorColor` / `clearBtnColor` / `contentPadding` / `cardStyleTopText` / `cardStyleBottomText` / `additionInfoColor` / `leftInfoWidth` / `showBottomDivider` / `TCardStyle`（枚举）

**v1.0 用法:**
```dart
TInputThemeData(
  backgroundColor: Colors.white,
  cursorColor: Colors.blue,
  showBottomDivider: false,
);

TInput(
  layout: TInputLayout.normal,
  label: '标签',
  hintText: '请输入',
);
```

### 4. 禁用方式

D 类组件用 `enabled: false` 或 `readOnly: true`，不用 `onChanged: null`。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/input/t_input_theme_data.dart` | 新增（TInputThemeData + TInputLayout/TInputSize/TInputCardStyle/TInputSpacer） |
| `lib/src/components/input/t_input_resolve.dart` | 新增（静态解析器 + Chinese2Formatter） |
| `lib/src/components/input/t_input.dart` | 枚举重命名 + 参数重命名 + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 替换旧 export |

## 后续修复（2026-07-06）

### M3 InputDecoration 下划线泄漏修复

`input_view.dart` 中 `InputDecoration` 已设 `enabledBorder`/`focusedBorder` 为透明，但未设 `disabledBorder`/`errorBorder`/`focusedErrorBorder`，禁用/错误态显示 M3 灰色/红色下划线。补全 3 个 border 属性为透明 `UnderlineInputBorder`。TTextarea 复用 TInputView，自动生效。
