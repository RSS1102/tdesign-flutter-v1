# TSwipeCell 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| New | 新增 `TSwipeCellThemeData` ThemeExtension |
| Removed | 移除 `themeData` 构造器参数（改用 `mergeExtension` 子树覆盖） |
| Migration | `slidableKey`/`opened`/`groupTag`/`closeWhenOpened`/`closeWhenTapped`/`dragStartBehavior`/`duration` 迁入 `TSwipeCellThemeData` |
| Rename | `onChange`→`onChanged` |
| Rename | `disabled`→`enabled`（默认 `true`，`false` 表示禁用） |
| Compatible | `cell`/`controller`/`direction` 保留为实例参数 |

## 迁移清单

### 1. L4 参数迁入 `TSwipeCellThemeData` + `themeData` 移除

`themeData` 构造器参数已移除（对齐 theme.md §2.1）。样式通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。

**❌ 已移除:**
```dart
TSwipeCell(
  cell: TCell(title: '标题'),
  enabled: true,
  themeData: TSwipeCellThemeData(  // 已删除
    slidableKey: Key('1'),
    groupTag: 'group1',
  ),
  onChanged: (direction, open) { ... },
  right: TSwipeCellPanel(...),
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    TSwipeCellThemeData(
      slidableKey: Key('1'),
      groupTag: 'group1',
      closeWhenOpened: true,
    ),
  ),
  child: TSwipeCell(
    cell: TCell(title: '标题'),
    enabled: true,
    onChanged: (direction, open) { ... },
    right: TSwipeCellPanel(...),
  ),
);
```

### 2. `disabled` → `enabled`

`disabled: true` 等同于 `enabled: false`。默认值从 `disabled: false` 变为 `enabled: true`。

### 3. 优先级规则

构造器参数 > `Theme.of(context).extension<TSwipeCellThemeData>()` > 内置默认值

## 保留的实例参数

| 参数 | 类型 | 说明 |
|------|------|------|
| `cell` | `Widget` | 单元格内容（必填） |
| `enabled` | `bool` | 是否启用滑动（默认 `true`） |
| `right` | `TSwipeCellPanel?` | 右侧操作面板 |
| `left` | `TSwipeCellPanel?` | 左侧操作面板 |
| `onChanged` | `Function(TSwipeDirection, bool)?` | 滑动展开事件 |
| `controller` | `SlidableController?` | 自定义控制 |
| `direction` | `Axis?` | 可拖动方向 |

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/swipe_cell/t_swipe_cell_theme_data.dart` | 新增 |
| `lib/src/components/swipe_cell/t_swipe_cell.dart` | L4 参数迁入 Theme；移除 `themeData`；P1 读取；`onChange`→`onChanged`，`disabled`→`enabled` |
| `lib/tdesign_flutter.dart` | 新增 theme_data export |
| `example/lib/page/t_swipe_cell_page.dart` | 全部改为 `mergeExtension` 模式 |
| `example/assets/api/swipe-cell_api.md` | API 文档同步 |

## 验证命令

```bash
cd tdesign-component
flutter analyze lib/src/components/swipe_cell
flutter test test/components/swipe_cell/
```
