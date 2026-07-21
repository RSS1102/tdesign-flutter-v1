import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_cell.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: SizedBox(width: 320, child: child)),
    );
  }

  testWidgets('selection notifier rebuilds the cell and range bridge',
      (tester) async {
    final startNotifier = DateSelectTypeNotifier(DateSelectType.start);
    final endNotifier = DateSelectTypeNotifier(DateSelectType.end);
    final start = TCalendarCellModel(
      date: DateTime(2024, 1, 1),
      typeNotifier: startNotifier,
      isLastDayOfMonth: false,
    );
    final end = TCalendarCellModel(
      date: DateTime(2024, 1, 2),
      typeNotifier: endNotifier,
      isLastDayOfMonth: false,
    );
    await tester.pumpWidget(wrap(TCalendarCell(
      cell: start,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [start, end],
    )));
    expect(find.text('1'), findsOneWidget);

    startNotifier.setType(DateSelectType.centre);
    await tester.pump();
    await tester.pump();
    expect(start.selectType, DateSelectType.centre);
  });

  testWidgets('today selected cell keeps selected text color', (tester) async {
    final today = DateTime.now();
    final date = DateTime(today.year, today.month, today.day);
    final notifier = DateSelectTypeNotifier(DateSelectType.selected);
    final cell = TCalendarCellModel(
      date: date,
      typeNotifier: notifier,
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: cell,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [cell],
    )));

    final text = tester.widget<Text>(find.text('${date.day}'));
    expect(text.style?.color, TThemeData.defaultData().textColorAnti);
    expect(text.style?.color, isNot(TThemeData.defaultData().brandNormalColor));
  });
}
