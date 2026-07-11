import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';

/// TCircleIndicator 组件测试
/// AnimationController.repeat() 无限循环，不能用 pumpAndSettle
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  group('TCircleIndicator', () {
    testWidgets('基础渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCircleIndicator(size: 30, color: Colors.blue, lineWidth: 4),
      ));
      await tester.pump();
      expect(find.byType(TCircleIndicator), findsOneWidget);
      // 替换空 widget 以 dispose（避免 repeat 无限循环）
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TCircleIndicator), findsNothing);
    });

    testWidgets('默认颜色（从 Theme 获取）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCircleIndicator(),
      ));
      await tester.pump();
      expect(find.byType(TCircleIndicator), findsOneWidget);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
    });

    testWidgets('didUpdateWidget duration 变化', (tester) async {
      var duration = 1000;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(builder: (context, setter) {
          setState = setter;
          return TCircleIndicator(duration: duration);
        }),
      ));
      await tester.pump();
      setState(() => duration = 2000);
      await tester.pump();
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TCircleIndicator), findsNothing);
    });

    testWidgets('shouldRepaint 返回 true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCircleIndicator(size: 40),
      ));
      await tester.pump();
      // 再次 pump 触发 shouldRepaint
      await tester.pumpWidget(wrapWithTheme(
        const TCircleIndicator(size: 40, color: Colors.red),
      ));
      await tester.pump();
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
    });
  });
}
