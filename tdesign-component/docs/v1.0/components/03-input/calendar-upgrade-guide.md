# TCalendar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `CalendarType` → `TCalendarVariant` |
| Rename | `onChange` → `onChanged` |
| New | 新增 `TCalendarThemeData` ThemeExtension（含 13 个样式字段） |
| Removed | 移除 `style` P0 构造器参数（TCalendarStyle 降级为内部类） |
| Migrate | L4 样式字段迁入 `TCalendarThemeData`，通过 `mergeExtension` 子树覆盖 |

## 迁移清单

### 1. 枚举重命名 `CalendarType` → `TCalendarVariant`

**v1.0:**
```dart
TCalendar(
  type: TCalendarVariant.single,
  onChanged: (value) {},
);
```

### 2. `style` 参数已移除 — 改用 `mergeExtension`

`TCalendar.style` P0 构造器参数已移除（对齐 theme.md §2.2 四问判定：Q2=是 → 不要 P0）。原 `TCalendarStyle` 的 13 个样式字段已迁入 `TCalendarThemeData`，通过 `Theme.of(context).mergeExtension(...)` 子树覆盖。`TCalendarStyle` 降级为内部类，不再公开导出。

**❌ 已移除:**
```dart
TCalendar(
  style: TCalendarStyle(cellHeight: 80),  // 已删除
  onChanged: (value) {},
);
```

**✅ v1.0:**
```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TCalendarThemeData(cellHeight: 80),
  ),
  child: TCalendar(
    onChanged: (value) {},
  ),
);
```

### 3. `TCalendarThemeData` 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `defaultVariant` | `TCalendarVariant?` | 默认选择模式 |
| `firstDayOfWeek` | `int?` | 每周第一天 |
| `height` | `double?` | 组件高度 |
| `decoration` | `BoxDecoration?` | 组件容器装饰 |
| `weekdayStyle` | `TextStyle?` | 星期文字样式 |
| `monthTitleStyle` | `TextStyle?` | 月份标题文字样式 |
| `dayStyle` | `TextStyle?` | 日期数字样式 |
| `todayDayStyle` | `TextStyle?` | 今天日期数字样式 |
| `cellDecoration` | `BoxDecoration?` | 日期单元格装饰（选中状态） |
| `subtitleStyle` | `TextStyle?` | 副标题样式 |
| `cellHeight` | `double?` | 日期单元格高度（默认 60） |
| `monthTitleHeight` | `double?` | 月份标题高度（默认 22） |
| `verticalGap` | `double?` | 日期格垂直间距 |
| `bodyPadding` | `double?` | 内边距 |
| `weekdayGap` | `double?` | 星期之间的水平间距 |
| `centreColor` | `Color?` | 区间中间格背景色 |

### 4. 优先级规则

构造器参数 > `Theme.of(context).extension<TCalendarThemeData>()` > token 默认值（`TCalendarStyle.generateStyle(context)`）

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/calendar/t_calendar_theme_data.dart` | 新增 + 扩展（13 样式字段迁入） |
| `lib/src/components/calendar/t_calendar.dart` | 枚举重命名；移除 `style` P0；移除 `export t_calendar_style.dart`；P1 读取 |
| `lib/src/components/calendar/t_calendar_style.dart` | 保留为内部类（不再 export） |
| `lib/src/components/calendar/t_calendar_cell.dart` | 添加直接 import `t_calendar_style.dart` |
| `lib/src/components/calendar/t_calendar_body.dart` | 同步 CalendarType → TCalendarVariant |
| `lib/tdesign_flutter.dart` | export 更新 |
| `example/lib/page/t_calendar_page.dart` | 移除 `style:` 参数 |
| `example/lib/lunar_data_source_example.dart` | 移除 `TCalendarStyle` 引用 |
| `test/t_calendar_test.dart` | 改为 `mergeExtension` 模式 |
