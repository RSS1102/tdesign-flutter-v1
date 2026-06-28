# TCascader 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `onChange` → `onChanged` |
| New | 新增 `TCascaderThemeData` ThemeExtension |
| New | 新增 `TCascaderVariant` 枚举 |
| Migrate | L4 样式字段迁入 `TCascaderThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TCascader.showMultiCascader(
  context,
  title: '选择地址',
  data: data,
  onChange: (selectData) {},
);
```

**v1.0:**
```dart
TCascader.showMultiCascader(
  context,
  title: '选择地址',
  data: data,
  onChanged: (selectData) {},
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `onChange` | `onChanged` | F 类回调，签名 `void Function(List<MultiCascaderListModel>)?` |

### 2. `showMultiCascader` 入口方法

`TCascader.showMultiCascader` 的 `onChange` 参数同步改为 `onChanged`。

### 3. L4 样式字段迁入 `TCascaderThemeData`

`initialIndexes` / `initialData` / `theme`（`step` / `tab`） / `title` / `closeText` / `barrierColor` / `duration` / `cascaderHeight` / `titleStyle` / `backgroundColor` / `topRadius`

### 4. 新增 `TCascaderVariant` 枚举

原 `theme` 字符串参数（`'step'` / `'tab'`）枚举化为 `TCascaderVariant`。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/cascader/t_cascader_theme_data.dart` | 新增（TCascaderThemeData + TCascaderVariant） |
| `lib/src/components/cascader/t_cascader.dart` | `showMultiCascader` 的 onChange → onChanged |
| `lib/src/components/cascader/t_multi_cascader.dart` | onChange → onChanged |
| `lib/tdesign_flutter.dart` | 新增 export |
