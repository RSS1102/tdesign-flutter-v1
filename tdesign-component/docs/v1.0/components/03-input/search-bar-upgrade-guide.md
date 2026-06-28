# TSearchBar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `placeHolder` → `hintText` |
| Rename | `onTextChanged` → `onChanged` |
| Rename | `TSearchStyle` → `TSearchBarStyle` |
| Rename | `TSearchAlignment` → `TSearchBarAlignment` |
| Rename | `style` → 保留（但枚举改名） |
| Delete | 删除 `onInputClick` 参数 |
| Delete | 删除 `TSearchBarEvent` / `TSearchBarCallBack` typedef |
| New | 新增 `TSearchBarThemeData` ThemeExtension |
| Migrate | L4 样式字段迁入 `TSearchBarThemeData` |

## 迁移清单

### 1. 参数重命名

**0.2.x:**
```dart
TSearchBar(
  placeHolder: '请输入关键词',
  onTextChanged: (text) {},
  style: TSearchStyle.square,
  alignment: TSearchAlignment.center,
);
```

**v1.0:**
```dart
TSearchBar(
  hintText: '请输入关键词',
  onChanged: (text) {},
  style: TSearchBarStyle.square,
  alignment: TSearchBarAlignment.center,
);
```

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `placeHolder` | `hintText` | 对齐 Material / TInput |
| `onTextChanged` | `onChanged` | D 类文本通知 |
| `TSearchStyle` | `TSearchBarStyle` | 枚举重命名 |
| `TSearchAlignment` | `TSearchBarAlignment` | 枚举重命名 |

### 2. 删除参数

删除 `onInputClick`：只读场景用 `readOnly` + `onTap`，不单独暴露。

### 3. 删除 typedef

删除 `TSearchBarEvent` / `TSearchBarCallBack`，改用 Flutter 内置 `ValueChanged<String>` / `VoidCallback`。

### 4. L4 样式字段迁入 `TSearchBarThemeData`

`padding` / `backgroundColor` / `cursorHeight` / `mediumStyle` / `autoHeight`

> **注意**：`TSearchBarStyle` / `TSearchBarAlignment` 枚举原在 `t_search_bar.dart` 中定义，v1.0 迁入 `t_search_bar_theme_data.dart`，旧定义已删除以避免类型冲突。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/search/t_search_bar_theme_data.dart` | 新增（TSearchBarThemeData + TSearchBarStyle/TSearchBarAlignment） |
| `lib/src/components/search/t_search_bar.dart` | 参数重命名 + 删除旧枚举 + 删除 typedef + L4 迁入 Theme |
| `lib/tdesign_flutter.dart` | 新增 export |
