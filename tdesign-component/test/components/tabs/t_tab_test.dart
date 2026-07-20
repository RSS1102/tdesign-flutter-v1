import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TTabsBarThemeData? tabsBarTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (tabsBarTheme != null) tabsBarTheme,
      ]),
      home: Scaffold(body: child),
    );
  }

  group('TTab', () {
    test('constructors keep current v1 fields', () {
      const textTab = TTab(text: '文本');
      expect(textTab.text, '文本');
      expect(textTab.enabled, isTrue);

      const childTab = TTab(child: Text('自定义'), enabled: false);
      expect(childTab.child, isA<Text>());
      expect(childTab.enabled, isFalse);

      const iconTab = TTab(icon: Icon(Icons.star), size: TTabSize.large);
      expect(iconTab.icon, isA<Icon>());
      expect(iconTab.size, TTabSize.large);
    });

    testWidgets('renders text, icon+text, badge and disabled states',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DefaultTabController(
          length: 4,
          child: TTabsBar(
            tabs: [
              TTab(text: '文本'),
              TTab(text: '图文', icon: Icon(Icons.home)),
              TTab(text: '徽标', badge: TBadge(TBadgeVariant.redPoint)),
              TTab(text: '禁用', enabled: false),
            ],
          ),
        ),
      ));

      expect(find.text('文本'), findsOneWidget);
      expect(find.text('图文'), findsOneWidget);
      expect(find.text('徽标'), findsOneWidget);
      expect(find.text('禁用'), findsOneWidget);
    });

    testWidgets('renders icon only and child branch', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DefaultTabController(
          length: 2,
          child: TTabsBar(
            tabs: [
              TTab(icon: Icon(Icons.star)),
              TTab(child: Text('子内容')),
            ],
          ),
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('子内容'), findsOneWidget);
    });

    testWidgets('uses DefaultTextStyle fontSize fallback', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DefaultTabController(
          length: 1,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 20),
            child: TTabsBar(
              tabs: [TTab(text: '字号')],
            ),
          ),
        ),
      ));

      expect(find.text('字号'), findsOneWidget);
    });
  });

  group('TTabsBarThemeData', () {
    test('copyWith and lerp preserve v1 fields', () {
      const data = TTabsBarThemeData(height: 48);
      final copied = data.copyWith(
        height: 56,
        variant: TTabsBarVariant.card,
        defaultPhysics: const BouncingScrollPhysics(),
      );

      expect(copied.height, 56);
      expect(copied.variant, TTabsBarVariant.card);
      expect(copied.defaultPhysics, isA<BouncingScrollPhysics>());

      const start = TTabsBarThemeData(height: 48);
      const end = TTabsBarThemeData(height: 56);
      expect(start.lerp(end, 0.5).height, 52);
      expect(start.lerp(null, 0.5), same(start));
    });
  });

  group('TTabsBarView', () {
    testWidgets('renders children with default and explicit physics',
        (tester) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrapWithTheme(
        TTabsBarView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          children: const [Text('第一页'), Text('第二页')],
        ),
      ));

      expect(find.byType(TTabsBarView), findsOneWidget);
      expect(find.text('第一页'), findsOneWidget);
    });

    testWidgets('uses theme defaultPhysics when physics is omitted',
        (tester) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrapWithTheme(
        TTabsBarView(
          controller: controller,
          children: const [Text('第一页'), Text('第二页')],
        ),
        tabsBarTheme: const TTabsBarThemeData(
          defaultPhysics: BouncingScrollPhysics(),
        ),
      ));

      expect(find.byType(TTabsBarView), findsOneWidget);
    });
  });
}
