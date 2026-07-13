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
        const TTab(text: '徽标', badge: TBadge(TBadgeVariant.redPoint)),
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

  // ============================================================
  // TTabBarThemeData copyWith 全字段
  // ============================================================
  group('TTabBarThemeData copyWith 全字段', () {
    test('copyWith 覆盖所有字段', () {
      const data = TTabBarThemeData();
      final copied = data.copyWith(
        decoration: const BoxDecoration(color: Colors.red),
        backgroundColor: Colors.blue,
        indicatorColor: Colors.green,
        indicatorHeight: 4,
        indicatorWidth: 20,
        labelColor: Colors.red,
        unselectedLabelColor: Colors.grey,
        isScrollable: true,
        labelStyle: const TextStyle(fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        height: 56,
        indicatorPadding: const EdgeInsets.all(4),
        labelPadding: const EdgeInsets.all(8),
        indicator: const BoxDecoration(),
        showIndicator: true,
        physics: const BouncingScrollPhysics(),
        variant: TTabBarVariant.card,
        dividerColor: Colors.black,
        dividerHeight: 1.0,
        selectedBgColor: Colors.yellow,
        unSelectedBgColor: Colors.orange,
        tabAlignment: TabAlignment.center,
        iconMargin: const EdgeInsets.all(4),
        textMargin: const EdgeInsets.all(2),
        contentHeight: 40,
        defaultPhysics: const BouncingScrollPhysics(),
      );
      expect(copied.backgroundColor, Colors.blue);
      expect(copied.indicatorColor, Colors.green);
      expect(copied.indicatorHeight, 4);
      expect(copied.indicatorWidth, 20);
      expect(copied.labelColor, Colors.red);
      expect(copied.unselectedLabelColor, Colors.grey);
      expect(copied.isScrollable, true);
      expect(copied.height, 56);
      expect(copied.showIndicator, true);
      expect(copied.variant, TTabBarVariant.card);
      expect(copied.dividerColor, Colors.black);
      expect(copied.dividerHeight, 1.0);
      expect(copied.selectedBgColor, Colors.yellow);
      expect(copied.unSelectedBgColor, Colors.orange);
      expect(copied.tabAlignment, TabAlignment.center);
      expect(copied.contentHeight, 40);
    });
  });

  // ============================================================
  // TTabBarThemeData lerp 全字段
  // ============================================================
  group('TTabBarThemeData lerp', () {
    test('lerp 正常插值 t < 0.5', () {
      const data1 = TTabBarThemeData(
        backgroundColor: Colors.red,
        indicatorHeight: 3,
        indicatorWidth: 16,
        height: 48,
        isScrollable: true,
        variant: TTabBarVariant.filled,
        showIndicator: true,
      );
      const data2 = TTabBarThemeData(
        backgroundColor: Colors.blue,
        indicatorHeight: 5,
        indicatorWidth: 20,
        height: 56,
        isScrollable: false,
        variant: TTabBarVariant.card,
        showIndicator: false,
      );
      final lerped = data1.lerp(data2, 0.3);
      // t < 0.5 取 data1 的布尔/枚举值
      expect(lerped.isScrollable, true);
      expect(lerped.variant, TTabBarVariant.filled);
      expect(lerped.showIndicator, true);
    });

    test('lerp 正常插值 t >= 0.5', () {
      const data1 = TTabBarThemeData(
        isScrollable: true,
        variant: TTabBarVariant.filled,
        showIndicator: true,
        tabAlignment: TabAlignment.start,
      );
      const data2 = TTabBarThemeData(
        isScrollable: false,
        variant: TTabBarVariant.card,
        showIndicator: false,
        tabAlignment: TabAlignment.center,
      );
      final lerped = data1.lerp(data2, 0.6);
      expect(lerped.isScrollable, false);
      expect(lerped.variant, TTabBarVariant.card);
      expect(lerped.showIndicator, false);
      expect(lerped.tabAlignment, TabAlignment.center);
    });
  });

  // ============================================================
  // TTab 更多渲染场景
  // ============================================================
  group('TTab 更多渲染场景', () {
    testWidgets('icon + text + badge 组合渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(
          icon: Icon(Icons.home),
          text: '首页',
          badge: TBadge(TBadgeVariant.redPoint),
        ),
      ));
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('首页'), findsOneWidget);
    });

    testWidgets('size: small（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(text: '小尺寸', size: TTabSize.small),
      ));
      expect(find.text('小尺寸'), findsOneWidget);
    });

    testWidgets('icon only（无 text/child）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(icon: Icon(Icons.star)),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('child + icon 组合渲染', (tester) async {
      const childKey = Key('custom_child');
      await tester.pumpWidget(wrapWithTheme(
        const TTab(
          icon: Icon(Icons.home),
          child: Text('自定义', key: childKey),
        ),
      ));
      expect(find.byKey(childKey), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('自定义 iconMargin', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(
          icon: Icon(Icons.home),
          text: '首页',
          iconMargin: EdgeInsets.only(bottom: 8, right: 8),
        ),
      ));
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('首页'), findsOneWidget);
    });

    testWidgets('自定义 textMargin（带 badge）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTab(
          text: '徽标',
          textMargin: EdgeInsets.only(left: 4),
          badge: TBadge(TBadgeVariant.redPoint),
        ),
      ));
      expect(find.text('徽标'), findsOneWidget);
    });
  });

  // ============================================================
  // TTabBar 更多渲染场景
  // ============================================================
  group('TTabBar 更多渲染场景', () {
    testWidgets('variant: filled（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          variant: TTabBarVariant.filled,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('showIndicator: false 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          showIndicator: false,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 indicatorColor 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          showIndicator: true,
          indicatorColor: Colors.red,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 indicatorWidth 和 indicatorHeight', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          showIndicator: true,
          indicatorWidth: 24,
          indicatorHeight: 4,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 labelColor 和 unselectedLabelColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 labelStyle 和 unselectedLabelStyle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          height: 56,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 width', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          width: 300,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 indicatorPadding', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          showIndicator: true,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 labelPadding', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 physics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(5),
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          controller: TabController(length: 5, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          backgroundColor: Colors.white,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 decoration', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          decoration: const BoxDecoration(color: Colors.yellow),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 dividerColor 和 dividerHeight', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          dividerColor: Colors.red,
          dividerHeight: 1.0,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('dividerHeight <= 0 不显示分割线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          dividerHeight: 0,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('capsule + selectedBgColor / unSelectedBgColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          variant: TTabBarVariant.capsule,
          selectedBgColor: Colors.red,
          unSelectedBgColor: Colors.grey,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 tabAlignment', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          tabAlignment: TabAlignment.center,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // TTabBar Tab 切换交互
  // ============================================================
  group('TTabBar Tab 切换交互', () {
    testWidgets('点击第一个 tab 触发 onTap(0)', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          onTap: (index) => tappedIndex = index,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      await tester.tap(find.text('选项1'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 0);
    });

    testWidgets('点击第三个 tab 触发 onTap(2)', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          onTap: (index) => tappedIndex = index,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
      ));
      await tester.tap(find.text('选项3'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 2);
    });

    testWidgets('controller 切换 index', (tester) async {
      final controller = TabController(length: 3, vsync: const TestVSync());
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: controller,
        ),
      ));
      controller.index = 1;
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    });
  });

  // ============================================================
  // TTabBar Theme 注入更多字段
  // ============================================================
  group('TTabBar Theme 注入更多字段', () {
    testWidgets('Theme 注入 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(backgroundColor: Colors.yellow),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(height: 56),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 isScrollable', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(5),
          controller: TabController(length: 5, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(isScrollable: true),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 showIndicator', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(showIndicator: true),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 labelColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(labelColor: Colors.red),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 dividerColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(dividerColor: Colors.blue),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 selectedBgColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          variant: TTabBarVariant.capsule,
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(selectedBgColor: Colors.green),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 tabAlignment', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(tabAlignment: TabAlignment.center),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 physics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(physics: BouncingScrollPhysics()),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 decoration', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(3),
          controller: TabController(length: 3, vsync: const TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(
          decoration: BoxDecoration(color: Colors.purple),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // TTabBarView 更多场景
  // ============================================================
  group('TTabBarView 更多场景', () {
    testWidgets('默认不可滑动', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      await tester.pumpWidget(wrapWithTheme(
        TTabBarView(
          controller: controller,
          children: const [
            Center(child: Text('A')),
            Center(child: Text('B')),
          ],
        ),
      ));
      expect(find.byType(TTabBarView), findsOneWidget);
    });

    testWidgets('无 controller 时使用 DefaultTabController', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: const DefaultTabController(
          length: 2,
          child: Scaffold(
            body: TTabBarView(
              children: [
                Center(child: Text('A')),
                Center(child: Text('B')),
              ],
            ),
          ),
        ),
      ));
      expect(find.byType(TTabBarView), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('自定义 physics 覆盖 Theme', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      await tester.pumpWidget(wrapWithTheme(
        TTabBarView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            Center(child: Text('A')),
            Center(child: Text('B')),
          ],
        ),
        tabBarTheme: const TTabBarThemeData(
          defaultPhysics: NeverScrollableScrollPhysics(),
        ),
      ));
      expect(find.byType(TTabBarView), findsOneWidget);
    });
  });

  // ============================================================
  // TTabBarIndicator / TNoneIndicator
  // ============================================================
  group('TTabBarIndicator / TNoneIndicator', () {
    test('TTabBarIndicator 默认构造', () {
      const indicator = TTabBarIndicator();
      expect(indicator.indicatorWidth, null);
      expect(indicator.indicatorHeight, null);
      expect(indicator.indicatorColor, null);
      expect(indicator.context, null);
    });

    test('TTabBarIndicator 带参数构造', () {
      const indicator = TTabBarIndicator(
        indicatorWidth: 24,
        indicatorHeight: 4,
        indicatorColor: Colors.red,
      );
      expect(indicator.indicatorWidth, 24);
      expect(indicator.indicatorHeight, 4);
      expect(indicator.indicatorColor, Colors.red);
    });

    test('TNoneIndicator createBoxPainter 不抛异常', () {
      final indicator = TNoneIndicator();
      expect(indicator.createBoxPainter, returnsNormally);
    });

    test('TTabBarVerticalIndicator 默认构造', () {
      const indicator = TTabBarVerticalIndicator();
      expect(indicator.indicatorWidth, null);
      expect(indicator.indicatorHeight, null);
    });
  });
}
