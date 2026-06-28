# TCalendar 组件 v1.0 升级指南

## 变更概览

| 变更类型 | 说明 |
|---------|------|
| Rename | `CalendarType` → `TCalendarVariant` |
| Rename | `onChange` → `onChanged` |
| Delete | 删除旧 `TCalendarVariant` 枚举（迁入 Theme） |
| New | 新增 `TCalendarThemeData` ThemeExtension |
| Migrate | L4 样式字段迁入 `TCalendarThemeData` |

## 迁移清单

### 1. 枚举重命名 `CalendarType` → `TCalendarVariant`

**0.2.x:**
```dart
TCalendar(
  type: CalendarType.single,
  onChange: (value) {},
);
```

**v1.0:**
```dart
TCalendar(
  type: TCalendarVariant.single,
  onChanged: (value) {},
);
```

### 2. 参数重命名

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `CalendarType` | `TCalendarVariant` | 枚举重命名 |
| `onChange` | `onChanged` | 命名对齐 v1.0 |

### 3. L4 样式字段迁入 `TCalendarThemeData`

`style` / `firstDayOfWeek` / `height` / `onMonthChanged` / `monthTitleBuilder` / `cellBuilder` / `subtitleBuilder` / `animateTo` / `anchorDate`

> **注意**：`TCalendarVariant` 枚举原在 `t_calendar.dart` 中定义，v1.0 迁入 `t_calendar_theme_data.dart`，旧定义已删除以避免类型冲突。

### 4. 内部文件同步

`t_calendar_body.dart` 中的 `CalendarType` 引用也需同步改为 `TCalendarVariant`。

## 文件清单

| 文件 | 变更 |
|------|------|
| `lib/src/components/calendar/t_calendar_theme_data.dart` | 新增（TCalendarThemeData + TCalendarVariant） |
| `lib/src/components/calendar/t_calendar.dart` | 枚举重命名 + 删除旧 TCalendarVariant + 参数重命名 |
| `lib/src/components/calendar/t_calendar_body.dart` | 同步 CalendarType → TCalendarVariant |
| `lib/tdesign_flutter.dart` | 新增 export |
