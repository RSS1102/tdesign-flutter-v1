import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TTabBarThemeData? tabBarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (tabBarTheme != null) tabBarTheme,
    ];
    return Theme(
      data: ThemeData(extensions: [TThemeData.defaultData()]),
      child: MaterialApp(
        theme: ThemeData(extensions: themeExtensions),
        home: Scaffold(body: child),
      ),
    );
  }

  List<TTab> buildTabs(int count) {
    return List.generate(count, (i) => TTab(text: '选项${i + 1}'));
  }

  group('TTabBarVariant', () {
    test('枚举值', () {
      expect(TTabBarVariant.values.length, 3);
      expect(TTabBarVariant.values, contains(TTabBarVariant.filled));
      expect(TTabBarVariant.values, contains(TTabBarVariant.capsule));
      expect(TTabBarVariant.values, contains(TTabBarVariant.card));
    });
  });

  group('TTabSize', () {
    test('枚举值', () {
      expect(TTabSize.values.length, 2);
      expect(TTabSize.values, contains(TTabSize.large));
      expect(TTabSize.values, contains(TTabSize.small));
    });
  });

  group('TTabBarThemeData', () {
    test('默认构造', () {
      const data = TTabBarThemeData();
      expect(data.backgroundColor, null);
      expect(data.variant, null);
      expect(data.height, null);
      expect(data.physics, null);
    });

    test('带参数构造', () {
      const data = TTabBarThemeData(
        backgroundColor: Colors.red,
        variant: TTabBarVariant.capsule,
        height: 56,
      );
      expect(data.backgroundColor, Colors.red);
      expect(data.variant, TTabBarVariant.capsule);
      expect(data.height, 56);
    });

    test('copyWith', () {
      const data = TTabBarThemeData(height: 48);
      final copied = data.copyWith(height: 56, variant: TTabBarVariant.card);
      expect(copied.height, 56);
      expect(copied.variant, TTabBarVariant.card);
    });

    test('lerp', () {
      const data1 = TTabBarThemeData(height: 48);
      const data2 = TTabBarThemeData(height: 56);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.height, 52);
    });

    test('lerp 非 TTabBarThemeData 返回自身', () {
      const data = TTabBarThemeData(height: 48);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TTab', () {
    testWidgets('text 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(text: '标签'),
      ));
      expect(find.text('标签'), findsOneWidget);
    });

    testWidgets('child 渲染', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(wrapWithTheme(
        const TTab(child: Text('自定义', key: childKey)),
      ));
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('icon 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(icon: Icon(Icons.home), text: '首页'),
      ));
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('首页'), findsOneWidget);
    });

    testWidgets('enabled: false 禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(text: '禁用', enabled: false),
      ));
      final ignorePointers = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );
      expect(ignorePointers.any((p) => p.ignoring), true);
    });

    testWidgets('enabled: true 可用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(text: '可用', enabled: true),
      ));
      final ignorePointers = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );
      expect(ignorePointers.every((p) => !p.ignoring), true);
    });

    testWidgets('size: large', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(text: '大尺寸', size: TTabSize.large),
      ));
      expect(find.text('大尺寸'), findsOneWidget);
    });

    testWidgets('badge 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTab(text: '徽标', badge: const TBadge(TBadgeVariant.redPoint)),
      ));
      expect(find.text('徽标'), findsOneWidget);
    });

    testWidgets('自定义 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(text: '高度', height: 60),
      ));
      expect(find.text('高度'), findsOneWidget);
    });
  });

  group('TTabBar', () {
    testWidgets('默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
      expect(find.text('选项1'), findsOneWidget);
    });

    testWidgets('variant: capsule', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          variant: TTabBarVariant.capsule,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('variant: card', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          variant: TTabBarVariant.card,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('showIndicator: true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          showIndicator: true,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('isScrollable: true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(5),
          isScrollable: true,
          controller: TabController(length: 5, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('onTap 回调', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          onTap: (index) => tappedIndex = index,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      await tester.tap(find.text('选项2'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 1);
    });

    testWidgets('ThemeData 注入 variant', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(variant: TTabBarVariant.capsule),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('backgroundColor 和 decoration 互斥断言', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TTabBar(
            tabs: buildTabs(3),
            backgroundColor: Colors.red,
            decoration: const BoxDecoration(color: Colors.blue),
            controller: TabController(length: 3, vsync: const TestVSync()),
          ),
        )),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('TTabBarView', () {
    testWidgets('默认渲染（不可滑动）', (tester) async {
      final controller = TabController(length: 3, vsync: const TestVSync());
      await tester.pumpWidget(wrapWithTheme(
        TTabBarView(
          controller: controller,
          children: const [
            Center(child: Text('页面1')),
            Center(child: Text('页面2')),
            Center(child: Text('页面3')),
          ],
        ),
      ));
      expect(find.byType(TTabBarView), findsOneWidget);
      expect(find.text('页面1'), findsOneWidget);
    });

    testWidgets('physics 自定义滑动', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      await tester.pumpWidget(wrapWithTheme(
        TTabBarView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          children: const [
            Center(child: Text('A')),
            Center(child: Text('B')),
          ],
        ),
      ));
      expect(find.byType(TTabBarView), findsOneWidget);
    });

    testWidgets('ThemeData 注入 defaultPhysics', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      await tester.pumpWidget(wrapWithTheme(
        TTabBarView(
          controller: controller,
          children: const [
            Center(child: Text('A')),
            Center(child: Text('B')),
          ],
        ),
        tabBarTheme: const TTabBarThemeData(
          defaultPhysics: BouncingScrollPhysics(),
        ),
      ));
      expect(find.byType(TTabBarView), findsOneWidget);
    });
  });
}
