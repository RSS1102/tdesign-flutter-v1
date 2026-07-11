import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TResult V1.0 Widget 测试
///
/// 覆盖 variant 四档、title/subtitle 渲染、自定义 icon、
/// Theme 各字段、copyWith/lerp、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TResultThemeData? resultTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (resultTheme != null) resultTheme,
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

  group('TResult 基础渲染', () {
    testWidgets('默认 variant 渲染 - info 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult()));
      expect(find.byType(TResult), findsOneWidget);
      // 默认 variant 使用 info_circle 图标
      expect(find.byIcon(TIcons.info_circle), findsOneWidget);
    });

    testWidgets('带 title 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '操作成功')));
      expect(find.text('操作成功'), findsOneWidget);
    });

    testWidgets('带 subtitle 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '标题', subtitle: '副标题描述'),
      ));
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题描述'), findsOneWidget);
    });

    testWidgets('title 为空时不渲染标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult()));
      // 默认 title='' 不应渲染 Text（title.isEmpty 跳过）
      expect(find.byType(TText), findsNothing);
    });

    testWidgets('subtitle 为 null 时不渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TResult(title: '仅有标题')));
      expect(find.text('仅有标题'), findsOneWidget);
      expect(find.byType(TText), findsOneWidget);
    });
  });

  group('TResult variant 四档', () {
    testWidgets('variant: success 显示 check_circle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.success, title: '成功'),
      ));
      expect(find.byIcon(TIcons.check_circle), findsOneWidget);
      expect(find.text('成功'), findsOneWidget);
    });

    testWidgets('variant: warning 显示 error_circle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.warning, title: '警告'),
      ));
      expect(find.byIcon(TIcons.error_circle), findsOneWidget);
    });

    testWidgets('variant: error 显示 close_circle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.error, title: '失败'),
      ));
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
    });

    testWidgets('variant: defaultTheme 显示 info_circle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(variant: TResultVariant.defaultTheme, title: '默认'),
      ));
      expect(find.byIcon(TIcons.info_circle), findsOneWidget);
    });
  });

  group('TResult 自定义 icon', () {
    testWidgets('自定义 icon 覆盖默认图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(
          icon: Icon(Icons.star, size: 70),
          title: '自定义',
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
      // 不应显示默认图标
      expect(find.byIcon(TIcons.info_circle), findsNothing);
    });
  });

  group('TResult Theme', () {
    testWidgets('Theme.titleStyle 应用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '主题样式'),
        resultTheme: const TResultThemeData(
          titleStyle: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ));
      expect(find.text('主题样式'), findsOneWidget);
    });

    testWidgets('Theme 无 titleStyle 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '无主题样式'),
      ));
      expect(find.text('无主题样式'), findsOneWidget);
    });
  });

  group('TResultThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TResultThemeData(
        variant: TResultVariant.success,
        titleStyle: TextStyle(fontSize: 16),
      );
      final copied = theme.copyWith(
        titleStyle: const TextStyle(fontSize: 24),
      );
      expect(copied.variant, TResultVariant.success);
      expect(copied.titleStyle?.fontSize, 24);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TResultThemeData(
        variant: TResultVariant.error,
        titleStyle: TextStyle(color: Colors.blue),
      );
      final copied = theme.copyWith();
      expect(copied.variant, TResultVariant.error);
      expect(copied.titleStyle?.color, Colors.blue);
    });

    test('lerp 前半段取 a 的 variant', () {
      const a = TResultThemeData(variant: TResultVariant.success);
      const b = TResultThemeData(variant: TResultVariant.error);
      final result = a.lerp(b, 0.3);
      expect(result.variant, TResultVariant.success);
    });

    test('lerp 后半段取 b 的 variant', () {
      const a = TResultThemeData(variant: TResultVariant.success);
      const b = TResultThemeData(variant: TResultVariant.error);
      final result = a.lerp(b, 0.7);
      expect(result.variant, TResultVariant.error);
    });

    test('lerp 非 TResultThemeData 返回自身', () {
      const theme = TResultThemeData(variant: TResultVariant.warning);
      final result = theme.lerp(null, 0.5);
      expect(result.variant, TResultVariant.warning);
    });

    test('lerp titleStyle 插值', () {
      const a = TResultThemeData(titleStyle: TextStyle(fontSize: 10));
      const b = TResultThemeData(titleStyle: TextStyle(fontSize: 20));
      final result = a.lerp(b, 0.5);
      expect(result.titleStyle?.fontSize, closeTo(15, 0.01));
    });
  });

  group('TResult 边界情况', () {
    testWidgets('subtitle 为空字符串时不渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TResult(title: '标题', subtitle: ''),
      ));
      expect(find.text('标题'), findsOneWidget);
      // 空字符串 subtitle 不应渲染额外的 TText
      expect(find.byType(TText), findsOneWidget);
    });

    testWidgets('所有参数默认值', (tester) async {
      const result = TResult();
      expect(result.variant, TResultVariant.defaultTheme);
      expect(result.title, '');
      expect(result.subtitle, isNull);
      expect(result.icon, isNull);
    });

    testWidgets('构造器全部参数传入渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TResult(
          title: '标题',
          subtitle: '副标题',
          variant: TResultVariant.success,
          icon: const Icon(Icons.check),
        ),
      ));
      expect(find.byType(TResult), findsOneWidget);
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });
  });
}
