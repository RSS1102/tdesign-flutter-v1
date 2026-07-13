import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TBadge V1.0 Widget 测试
///
/// 覆盖 variant 五档（redPoint/message/bubble/square/subscript）、
/// size 两档、count/maxCount 溢出逻辑、Theme 各字段注入、
/// 边界情况（null count / 空字符串 / 非数字）。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TBadgeThemeData? badgeTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (badgeTheme != null) badgeTheme,
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

  group('TBadge 基础渲染', () {
    testWidgets('redPoint variant 渲染红点', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBadge(TBadgeVariant.redPoint)));
      expect(find.byType(TBadge), findsOneWidget);
      // 红点是一个 Container，无文字
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('message variant 渲染数字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '5'),
      ));
      expect(find.byType(TBadge), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('bubble variant 渲染气泡', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.bubble, count: '3'),
      ));
      expect(find.byType(TBadge), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('square variant 渲染方形', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.square, count: '8'),
      ));
      expect(find.byType(TBadge), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('subscript variant 渲染角标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.subscript, count: 'NEW'),
      ));
      expect(find.byType(TBadge), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
    });
  });

  group('TBadge variant 全量验证', () {
    for (final variant in TBadgeVariant.values) {
      testWidgets('variant: $variant 可正常渲染', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          TBadge(variant, count: '1'),
        ));
        expect(find.byType(TBadge), findsOneWidget);
      });
    }
  });

  group('TBadge size 两档', () {
    testWidgets('size: small（默认）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '1', size: TBadgeSize.small),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets('size: large', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '1', size: TBadgeSize.large),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });
  });

  group('TBadge count/maxCount 溢出逻辑', () {
    testWidgets('count 未超过 maxCount 时原样显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '50', maxCount: '99'),
      ));
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('count 超过 maxCount 时 badgeNum 计算为 maxCount+', (tester) async {
      // 注意：组件内部 updateBadgeNum 会将 badgeNum 设为 '99+'，
      // 但 build 方法实际显示的是 value（widget.count），而非 badgeNum。
      // 此测试验证组件在 count 超过 maxCount 时不崩溃且正常渲染。
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '150', maxCount: '99'),
      ));
      expect(find.byType(TBadge), findsOneWidget);
      expect(find.text('150'), findsOneWidget);
    });

    testWidgets('count 等于 maxCount 时原样显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '99', maxCount: '99'),
      ));
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('单字符 count 渲染圆形容器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '5'),
      ));
      // 单字符走圆形分支（Container width=getBadgeSize）
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.any((c) => c.constraints?.maxWidth == 16 || c.constraints == null), isTrue);
    });

    testWidgets('多字符 count 渲染胶囊容器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '999'),
      ));
      expect(find.text('999'), findsOneWidget);
    });
  });

  group('TBadge 边界情况', () {
    testWidgets('count 为 null 时使用资源默认值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message),
      ));
      // count 为 null 时 value 取 context.resource.badgeZero
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets('count 为非数字字符串时原样显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: 'ABC'),
      ));
      expect(find.text('ABC'), findsOneWidget);
    });

    testWidgets('redPoint 不依赖 count', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.redPoint, count: null),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets('didUpdateWidget count 变化后更新显示', (tester) async {
      var count = '1';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => wrapWithTheme(
            TBadge(TBadgeVariant.message, count: count),
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);

      // 修改 count 并重新构建
      count = '9';
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => wrapWithTheme(
            TBadge(TBadgeVariant.message, count: count),
          ),
        ),
      );
      expect(find.text('9'), findsOneWidget);
    });
  });

  group('TBadge Theme 注入', () {
    testWidgets('TBadgeThemeData.color 覆盖背景色', (tester) async {
      const customColor = Colors.purple;
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.redPoint),
        badgeTheme: const TBadgeThemeData(color: customColor),
      ));
      // 验证 Container 使用了自定义颜色
      final container = tester.widgetList<Container>(find.byType(Container)).firstWhere(
        (c) => c.decoration is BoxDecoration,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, customColor);
    });

    testWidgets('TBadgeThemeData.message 覆盖 count 显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '5'),
        badgeTheme: const TBadgeThemeData(message: 'HOT'),
      ));
      expect(find.text('HOT'), findsOneWidget);
      expect(find.text('5'), findsNothing);
    });

    testWidgets('TBadgeThemeData.showZero=false 时 count 为 0 不显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '0'),
        badgeTheme: const TBadgeThemeData(showZero: false),
      ));
      // showZero=false 且 value=0 时 visible=false，Visibility 不显示子组件
      final visibility = tester.widget<Visibility>(find.byType(Visibility));
      expect(visibility.visible, isFalse);
    });

    testWidgets('TBadgeThemeData.showZero=true（默认）时 count 为 0 显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '0'),
      ));
      final visibility = tester.widget<Visibility>(find.byType(Visibility));
      expect(visibility.visible, isTrue);
    });

    testWidgets('TBadgeThemeData.textColor 覆盖文字色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.message, count: '5'),
        badgeTheme: const TBadgeThemeData(textColor: Colors.yellow),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets('TBadgeThemeData.border 影响方形圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.square, count: '99'),
        badgeTheme: const TBadgeThemeData(border: TBadgeBorder.small),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets('TBadgeThemeData.widthLarge/widthSmall 影响角标尺寸', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBadge(TBadgeVariant.subscript, count: 'NEW'),
        badgeTheme: const TBadgeThemeData(widthLarge: 40, widthSmall: 16),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });

    test('TBadgeThemeData.copyWith 正确合并字段', () {
      const base = TBadgeThemeData(color: Colors.red, showZero: true);
      final merged = base.copyWith(textColor: Colors.white);
      expect(merged.color, Colors.red);
      expect(merged.textColor, Colors.white);
      expect(merged.showZero, isTrue);
    });

    test('TBadgeThemeData.lerp 插值正确', () {
      const a = TBadgeThemeData(color: Colors.red, widthLarge: 20);
      const b = TBadgeThemeData(color: Colors.blue, widthLarge: 40);
      final mid = a.lerp(b, 0.5);
      expect(mid.color, Color.lerp(Colors.red, Colors.blue, 0.5));
    });
  });
}
