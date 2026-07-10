import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TBackTop widget 级用例', () {
    testWidgets('默认（circle/light）可构建', (tester) async {
      await tester.pumpWidget(wrap(const TBackTop(onPressed: _noop)));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('halfCircle / dark / tooltip 可构建', (tester) async {
      await tester.pumpWidget(wrap(const TBackTop(
        shape: TBackTopShape.halfCircle,
        colorScheme: TBackTopColorScheme.dark,
        tooltip: '回到顶部',
        onPressed: _noop,
      )));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('绑定 ScrollController（阈值未达，初始可见）可构建', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(wrap(TBackTop(
        controller: controller,
        visibilityOffset: 100,
        onPressed: _noop,
      )));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('dispose 重建（didUpdateWidget colorScheme 变化）', (tester) async {
      await tester.pumpWidget(wrap(const TBackTop(
        colorScheme: TBackTopColorScheme.light,
        onPressed: _noop,
      )));
      await tester.pumpWidget(wrap(const TBackTop(
        colorScheme: TBackTopColorScheme.dark,
        onPressed: _noop,
      )));
      expect(find.byType(TBackTop), findsOneWidget);
    });
  });
}

void _noop() {}
