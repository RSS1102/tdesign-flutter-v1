import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TProgress V1.0 Widget 测试
///
/// 覆盖 variant 四档（linear/circular/micro/button）、value 边界、
/// label 位置、onPressed 回调、Theme 各字段、copyWith/lerp、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TProgressThemeData? progressTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (progressTheme != null) progressTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TProgress 基础渲染', () {
    testWidgets('linear variant 默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.linear, value: 0.5),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('value 为 null 时默认 0', (tester) async {
      final progress = TProgress(variant: TProgressVariant.linear);
      expect(progress.value, 0);
    });

    testWidgets('value 被 clamp 到 0-1 范围', (tester) async {
      final progress = TProgress(variant: TProgressVariant.linear, value: 1.5);
      expect(progress.value, 1.0);

      final progress2 = TProgress(variant: TProgressVariant.linear, value: -0.5);
      expect(progress2.value, 0.0);
    });
  });

  group('TProgress variant 四档', () {
    testWidgets('variant: linear 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: circular 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular, value: 0.6),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: micro 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.micro, value: 0.3),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: button 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.button, value: 0.7),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });

  group('TProgress label 显示', () {
    testWidgets('linear value=0.5 显示 50%', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('50%'), findsWidgets);
    });

    testWidgets('linear value=0.0 不显示百分比文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.0,
          ),
        ),
      ));
      await tester.pump();
      // value 不为 null 时（即使是 0.0）getAutoText 仍渲染 "0%" 文本
      expect(find.text('0%'), findsWidgets);
    });

    testWidgets('labelPosition: left 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
        progressTheme: const TProgressThemeData(
          progressLabelPosition: TProgressLabelPosition.left,
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('labelPosition: right 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
        progressTheme: const TProgressThemeData(
          progressLabelPosition: TProgressLabelPosition.right,
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('showLabel: false 隐藏标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
        progressTheme: const TProgressThemeData(showLabel: false),
      ));
      await tester.pump();
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('自定义 TTextLabel 标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
            label: const TTextLabel('自定义'),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('自定义'), findsWidgets);
    });

    testWidgets('TIconLabel 标签渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(
          variant: TProgressVariant.circular,
          value: 0.5,
          label: const TIconLabel(Icons.star),
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.star), findsWidgets);
    });
  });

  group('TProgress onPressed 回调', () {
    testWidgets('micro variant 点击触发 onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TProgress(
          variant: TProgressVariant.micro,
          value: 0.5,
          onPressed: () => tapped = true,
        ),
      ));
      await tester.pump();
      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('button variant 点击触发 onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(
            variant: TProgressVariant.button,
            value: 0.5,
            onPressed: () => tapped = true,
          ),
        ),
      ));
      await tester.pump();
      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('onPressed 为 null 时不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(
          variant: TProgressVariant.micro,
          value: 0.5,
          onPressed: null,
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });

  group('TProgress Theme', () {
    testWidgets('Theme.color 覆盖进度条颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(color: Colors.red),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.strokeWidth 覆盖粗细', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(strokeWidth: 10),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.backgroundColor 覆盖背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(backgroundColor: Colors.grey),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.circleRadius 覆盖环形半径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular, value: 0.5),
        progressTheme: const TProgressThemeData(circleRadius: 150),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.customProgressLabel 渲染自定义标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(
          customProgressLabel: Text('加载中'),
          progressLabelPosition: TProgressLabelPosition.left,
        ),
      ));
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
    });

    testWidgets('Theme.animationDuration 覆盖动画时长', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(
          animationDuration: Duration(milliseconds: 500),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });

  group('TProgressThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TProgressThemeData(
        strokeWidth: 5,
        color: Colors.red,
        circleRadius: 100,
      );
      final copied = theme.copyWith(strokeWidth: 10);
      expect(copied.strokeWidth, 10);
      expect(copied.color, Colors.red);
      expect(copied.circleRadius, 100);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TProgressThemeData(
        strokeWidth: 5,
        backgroundColor: Colors.blue,
      );
      final copied = theme.copyWith();
      expect(copied.strokeWidth, 5);
      expect(copied.backgroundColor, Colors.blue);
    });

    test('lerp 前半段取 a 的 variant', () {
      const a = TProgressThemeData(variant: TProgressVariant.linear);
      const b = TProgressThemeData(variant: TProgressVariant.circular);
      final result = a.lerp(b, 0.3);
      expect(result.variant, TProgressVariant.linear);
    });

    test('lerp 后半段取 b 的 variant', () {
      const a = TProgressThemeData(variant: TProgressVariant.linear);
      const b = TProgressThemeData(variant: TProgressVariant.circular);
      final result = a.lerp(b, 0.7);
      expect(result.variant, TProgressVariant.circular);
    });

    test('lerp 非 TProgressThemeData 返回自身', () {
      const theme = TProgressThemeData(strokeWidth: 5);
      final result = theme.lerp(null, 0.5);
      expect(result.strokeWidth, 5);
    });

    test('lerp strokeWidth 插值', () {
      const a = TProgressThemeData(strokeWidth: 10);
      const b = TProgressThemeData(strokeWidth: 30);
      final result = a.lerp(b, 0.5);
      expect(result.strokeWidth, 20);
    });

    test('lerp animationDuration 插值', () {
      const a = TProgressThemeData(animationDuration: Duration(milliseconds: 100));
      const b = TProgressThemeData(animationDuration: Duration(milliseconds: 300));
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 200);
    });

    test('lerp 两端 animationDuration 均为 null 返回 null', () {
      const a = TProgressThemeData();
      const b = TProgressThemeData();
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration, isNull);
    });

    test('lerp a animationDuration 为 null 返回 b 值', () {
      const a = TProgressThemeData();
      const b = TProgressThemeData(animationDuration: Duration(milliseconds: 200));
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 200);
    });

    test('lerp b animationDuration 为 null 返回 a 值', () {
      const a = TProgressThemeData(animationDuration: Duration(milliseconds: 100));
      const b = TProgressThemeData();
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 100);
    });
  });

  group('TProgress 边界情况', () {
    testWidgets('value=1.0 满进度渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 1.0),
        ),
      ));
      await tester.pump();
      expect(find.text('100%'), findsWidgets);
    });

    testWidgets('value=0.05 小进度走 outside label 路径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(variant: TProgressVariant.linear, value: 0.05),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('micro variant 不显示百分比文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.micro, value: 0.5),
      ));
      await tester.pump();
      // micro 类型不显示自动文字
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('circular variant 中心显示标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular, value: 0.5),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });
}
