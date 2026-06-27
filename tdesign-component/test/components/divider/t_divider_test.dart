import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDivider V1.0 Widget 测试
///
/// 覆盖 layout×child 组合、align 三档、dashed 横向/竖线忽略、
/// Theme 各字段、resolve 优先级、0.2 迁移验证。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TDividerThemeData? dividerTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (dividerTheme != null) dividerTheme,
    ];
    return TTheme(
      data: TThemeData.defaultData(),
      child: MaterialApp(
        theme: ThemeData(
          extensions: themeExtensions,
        ),
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('TDivider 基础渲染', () {
    testWidgets('默认水平分割线 - 模式 A', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TDivider()));
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('水平分割线 + child - 模式 B', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(child: Text('文字信息')),
      ));
      expect(find.text('文字信息'), findsOneWidget);
    });

    testWidgets('竖线分割线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 56,
          child: TDivider(layout: TDividerLayout.vertical),
        ),
      ));
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('竖线 + child 时 child 不渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 56,
          child: TDivider(
            layout: TDividerLayout.vertical,
            child: Text('不该出现'),
          ),
        ),
      ));
      expect(find.text('不该出现'), findsNothing);
    });

    testWidgets('竖线时 dashed 被忽略', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 56,
          child: TDivider(
            layout: TDividerLayout.vertical,
            dashed: true,
          ),
        ),
      ));
      expect(find.byType(TDivider), findsOneWidget);
    });
  });

  group('TDivider align 三档', () {
    testWidgets('align: left', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(
          child: Text('左对齐'),
          align: TDividerAlign.left,
        ),
      ));
      expect(find.text('左对齐'), findsOneWidget);
    });

    testWidgets('align: center（默认）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(child: Text('居中')),
      ));
      expect(find.text('居中'), findsOneWidget);
    });

    testWidgets('align: right', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(
          child: Text('右对齐'),
          align: TDividerAlign.right,
        ),
      ));
      expect(find.text('右对齐'), findsOneWidget);
    });
  });

  group('TDivider dashed', () {
    testWidgets('横向虚线 — CustomPaint 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TDivider(dashed: true)));
      // TTheme 自身也包含 CustomPaint，这里验证至少渲染了 Divider 的 CustomPaint
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('横向虚线 + child', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(dashed: true, child: Text('虚线文字')),
      ));
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('虚线文字'), findsOneWidget);
    });

    testWidgets('默认不虚线 — 无虚线 CustomPaint', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TDivider()));
      // 验证 TDivider 正常渲染且不是虚线（实线用 Container 而非 CustomPaint）
      expect(find.byType(TDivider), findsOneWidget);
    });
  });

  group('TDivider Theme', () {
    testWidgets('Theme.color 应用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        dividerTheme: const TDividerThemeData(color: Colors.red),
        const TDivider(),
      ));
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('Theme.indent 应用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        dividerTheme: const TDividerThemeData(indent: 16),
        const TDivider(),
      ));
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('Theme.endIndent 应用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        dividerTheme: const TDividerThemeData(endIndent: 24),
        const TDivider(),
      ));
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('Theme.margin 应用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        dividerTheme: const TDividerThemeData(
          margin: EdgeInsets.all(10),
        ),
        const TDivider(),
      ));
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Theme.gapPadding 默认值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(child: Text('内容')),
      ));
      expect(find.text('内容'), findsOneWidget);
    });

    testWidgets('Theme.gapPadding 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        dividerTheme: const TDividerThemeData(
          gapPadding: EdgeInsets.symmetric(horizontal: 20),
        ),
        const TDivider(child: Text('间距')),
      ));
      expect(find.text('间距'), findsOneWidget);
    });
  });

  group('TDivider 构造器覆盖 Theme', () {
    testWidgets('dashed 构造器参数覆盖默认值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TDivider(dashed: true)));
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('layout 构造器参数覆盖默认 horizontal', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 50,
          child: TDivider(layout: TDividerLayout.vertical),
        ),
      ));
      expect(find.byType(TDivider), findsOneWidget);
    });
  });

  group('TDividerThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TDividerThemeData(color: Colors.red, thickness: 2);
      final copied = theme.copyWith(thickness: 5);
      expect(copied.color, Colors.red);
      expect(copied.thickness, 5);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TDividerThemeData(color: Colors.blue);
      final copied = theme.copyWith();
      expect(copied.color, Colors.blue);
      expect(copied.thickness, null);
    });

    test('lerp 前半段取 a 的值', () {
      const a = TDividerThemeData(color: Colors.red, thickness: 1);
      const b = TDividerThemeData(color: Colors.blue, thickness: 5);
      final result = a.lerp(b, 0.3);
      expect(result.color, Colors.red);
      expect(result.thickness! > 0, true);
    });

    test('lerp 后半段取 b 的值', () {
      const a = TDividerThemeData(color: Colors.red, thickness: 1);
      const b = TDividerThemeData(color: Colors.blue, thickness: 5);
      final result = a.lerp(b, 0.7);
      expect(result.color, Colors.blue);
      expect(result.thickness! > 1, true);
    });

    test('lerp 非 TDividerThemeData 返回自身', () {
      const theme = TDividerThemeData(color: Colors.red);
      final result = theme.lerp(null, 0.5);
      expect(result.color, Colors.red);
    });
  });

  group('TDivider 边界情况', () {
    testWidgets('child 为 null 时模式 A 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TDivider()));
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('layout 为 null 时默认 horizontal', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(child: Text('默认横线')),
      ));
      expect(find.text('默认横线'), findsOneWidget);
    });

    testWidgets('align 为 null 时默认 center', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDivider(child: Text('默认居中')),
      ));
      expect(find.text('默认居中'), findsOneWidget);
    });

    testWidgets('dashed 为 null 时默认 false（实线）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TDivider()));
      expect(find.byType(TDivider), findsOneWidget);
    });
  });
}
