import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TStepsThemeData? stepsTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (stepsTheme != null) stepsTheme,
    ];
    return TTheme(
      data: TThemeData.defaultData(),
      child: MaterialApp(
        theme: ThemeData(extensions: themeExtensions),
        home: Scaffold(body: child),
      ),
    );
  }

  List<TStepsItemData> buildSteps(int count) {
    return List.generate(
        count, (i) => TStepsItemData(title: '步骤${i + 1}', content: '内容${i + 1}'));
  }

  group('TStepsItemData', () {
    test('带参数构造', () {
      final data = TStepsItemData(title: '标题', content: '内容');
      expect(data.title, '标题');
      expect(data.content, '内容');
    });

    test('至少需要一个非空值断言', () {
      expect(() => TStepsItemData(), throwsA(isA<AssertionError>()));
    });

    test('自定义内容构造', () {
      const custom = Text('自定义');
      final data = TStepsItemData(customContent: custom);
      expect(data.customContent, custom);
    });
  });

  group('枚举', () {
    test('TStepsDirection 枚举值', () {
      expect(TStepsDirection.values.length, 2);
      expect(TStepsDirection.values, contains(TStepsDirection.horizontal));
      expect(TStepsDirection.values, contains(TStepsDirection.vertical));
    });

    test('TStepsStatus 枚举值', () {
      expect(TStepsStatus.values.length, 2);
      expect(TStepsStatus.values, contains(TStepsStatus.success));
      expect(TStepsStatus.values, contains(TStepsStatus.error));
    });
  });

  group('TStepsThemeData', () {
    test('默认构造', () {
      const data = TStepsThemeData();
      expect(data.status, null);
      expect(data.simple, null);
    });

    test('带参数构造', () {
      const data = TStepsThemeData(
        status: TStepsStatus.error,
        simple: true,
        readOnly: true,
        verticalSelect: true,
      );
      expect(data.status, TStepsStatus.error);
      expect(data.simple, true);
    });

    test('copyWith', () {
      const data = TStepsThemeData(simple: false);
      final copied = data.copyWith(simple: true, readOnly: true);
      expect(copied.simple, true);
      expect(copied.readOnly, true);
    });

    test('lerp', () {
      const data1 = TStepsThemeData(simple: false);
      const data2 = TStepsThemeData(simple: true);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.simple, true);
    });

    test('lerp 非 TStepsThemeData 返回自身', () {
      const data = TStepsThemeData(simple: false);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TSteps 基础渲染', () {
    testWidgets('horizontal 默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TSteps(steps: buildSteps(3))));
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.text('步骤1'), findsOneWidget);
    });

    testWidgets('vertical 方向渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), direction: TStepsDirection.vertical),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('使用 value 指定激活索引', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: 1),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('使用 activeIndex 指定激活索引（向后兼容）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), activeIndex: 2),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('value 优先级高于 activeIndex', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: 1, activeIndex: 2),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });

  group('TSteps 状态', () {
    testWidgets('success 状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), status: TStepsStatus.success),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('error 状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), status: TStepsStatus.error),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('simple 模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), simple: true),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('readOnly 模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), readOnly: true),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('verticalSelect 模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: buildSteps(3),
          direction: TStepsDirection.vertical,
          verticalSelect: true,
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });

  group('TSteps 边界', () {
    testWidgets('activeIndex 超出上限自动 clamp', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), activeIndex: 10),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('activeIndex 为负数自动 clamp', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), activeIndex: -1),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('使用 themeData 参数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: buildSteps(3),
          themeData: const TStepsThemeData(simple: true),
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });
}
