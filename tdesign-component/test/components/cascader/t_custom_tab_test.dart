import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/cascader/t_custom_tab.dart';

/// TCustomTab 组件测试
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  group('TCustomTab', () {
    testWidgets('基础渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCustomTab(tabs: ['Tab1', 'Tab2', 'Tab3']),
      ));
      expect(find.text('Tab1'), findsOneWidget);
      expect(find.text('Tab2'), findsOneWidget);
      expect(find.text('Tab3'), findsOneWidget);
    });

    testWidgets('initialIndex=1 高亮第二个', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCustomTab(tabs: ['A', 'B'], initialIndex: 1),
      ));
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('点击 tab 触发 onTap', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(wrapWithTheme(
        TCustomTab(
          tabs: const ['A', 'B'],
          onTap: (index) => tappedIndex = index,
        ),
      ));
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 1);
    });

    testWidgets('didUpdateWidget initialIndex 变化', (tester) async {
      var initialIndex = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TCustomTab(
              tabs: const ['A', 'B'],
              initialIndex: initialIndex,
            );
          },
        ),
      ));
      setState(() => initialIndex = 1);
      await tester.pumpAndSettle();
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('onTap 为 null 时不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCustomTab(tabs: ['A', 'B']),
      ));
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(find.byType(TCustomTab), findsOneWidget);
    });
  });
}
