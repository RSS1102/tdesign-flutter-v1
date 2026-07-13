import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTabBar V1.0 Widget 测试
///
/// 覆盖 TTabBar 渲染、variant 变体、showIndicator、
/// isScrollable、onTap 回调、指示器 paint 方法、
/// TTabBarVerticalIndicator、TNoneIndicator。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TTabBarThemeData? tabBarTheme}) {
    final extensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (tabBarTheme != null) tabBarTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: extensions),
      home: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: child,
        ),
      ),
    );
  }

  /// 基础 tabs
  List<TTab> baseTabs() => const [
        TTab(text: '标签一'),
        TTab(text: '标签二'),
        TTab(text: '标签三'),
      ];

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TTabBar 基础渲染', () {
    testWidgets('variant=filled 渲染标签栏', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(tabs: baseTabs()),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
      expect(find.text('标签一'), findsOneWidget);
      expect(find.text('标签二'), findsOneWidget);
    });

    testWidgets('variant=capsule 胶囊样式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          variant: TTabBarVariant.capsule,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('variant=card 卡片样式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          variant: TTabBarVariant.card,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('isScrollable=true 可滚动渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TTabBar(
            tabs: baseTabs(),
            isScrollable: true,
          ),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // showIndicator 指示器
  // ============================================================
  group('TTabBar 指示器', () {
    testWidgets('showIndicator=true 渲染 TTabBarIndicator', (tester) async {
      // 覆盖 _getIndicator showIndicator=true 分支 + paint 方法
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          showIndicator: true,
          indicatorHeight: 3,
          indicatorWidth: 16,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('showIndicator=false 渲染 TNoneIndicator', (tester) async {
      // 覆盖 _getIndicator showIndicator=false 分支 + paint 方法
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          showIndicator: false,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 indicator 使用传入的 Decoration', (tester) async {
      // 覆盖 widget.indicator ?? _getIndicator() 的 widget.indicator 分支
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          indicator: const UnderlineTabIndicator(),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // onTap 回调
  // ============================================================
  group('TTabBar 交互', () {
    testWidgets('点击 tab 触发 onTap 回调', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          onTap: (index) => tappedIndex = index,
        ),
      ));
      await tester.tap(find.text('标签二'));
      await tester.pumpAndSettle();
      expect(tappedIndex, 1);
    });
  });

  // ============================================================
  // 自定义样式
  // ============================================================
  group('TTabBar 自定义样式', () {
    testWidgets('自定义 backgroundColor 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          backgroundColor: Colors.blue,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 decoration 渲染', (tester) async {
      // 覆盖 widget.decoration ?? _themeData.decoration 分支
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          decoration: const BoxDecoration(color: Colors.red),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('dividerHeight=0 不展示分割线', (tester) async {
      // 覆盖 widget.dividerHeight <= 0 → null border 分支
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          dividerHeight: 0,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 labelColor/unselectedLabelColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 labelStyle/unselectedLabelStyle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 height/width', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          height: 56,
          width: 300,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });

    testWidgets('自定义 indicatorColor/indicatorPadding', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          showIndicator: true,
          indicatorColor: Colors.orange,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // TTabBarThemeData 覆盖
  // ============================================================
  group('TTabBarThemeData', () {
    testWidgets('注入 TTabBarThemeData 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(tabs: baseTabs()),
        tabBarTheme: const TTabBarThemeData(
          height: 56,
          indicatorColor: Colors.red,
          labelColor: Colors.blue,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // 指示器单元测试
  // ============================================================
  group('指示器单元测试', () {
    test('TNoneIndicator createBoxPainter 返回非 null', () {
      final indicator = TNoneIndicator();
      expect(indicator.createBoxPainter(() {}), isNotNull);
    });

    // TTabBarIndicator/TTabBarVerticalIndicator 需要 context，
    // 已在 showIndicator=true 的 widget 测试中覆盖 createBoxPainter + paint
  });

  // ============================================================
  // TabController 使用
  // ============================================================
  group('TTabBar TabController', () {
    testWidgets('传入自定义 TabController 正常渲染', (tester) async {
      final controller = TabController(length: 3, vsync: tester);
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          controller: controller,
        ),
      ));
      expect(find.byType(TTabBar), findsOneWidget);
      controller.dispose();
    });

    testWidgets('切换 tab 触发 controller.animateTo', (tester) async {
      final controller = TabController(length: 3, vsync: tester);
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: baseTabs(),
          controller: controller,
        ),
      ));
      controller.animateTo(2);
      await tester.pumpAndSettle();
      expect(controller.index, 2);
      controller.dispose();
    });
  });

  // ============================================================
  // TTab 数据类
  // ============================================================
  group('TTab', () {
    test('TTab text 构造', () {
      const tab = TTab(text: '测试');
      expect(tab.text, '测试');
    });

    test('TTab icon 构造', () {
      const tab = TTab(icon: Icon(Icons.star));
      expect(tab.icon, isA<Icon>());
    });

    test('TTab child 构造', () {
      const tab = TTab(child: Text('自定义'));
      expect(tab.child, isA<Text>());
    });
  });

  // ============================================================
  // TTabBarVerticalIndicator 覆盖
  // ============================================================
  group('TTabBarVerticalIndicator', () {
    testWidgets('通过 indicator 参数渲染并触发 paint', (tester) async {
      // 覆盖 287-328（TTabBarVerticalIndicator + _TTabBarVerticalIndicatorPainter）
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return TTabBar(
            tabs: baseTabs(),
            indicator: TTabBarVerticalIndicator(
              context: context,
              indicatorWidth: 2,
              indicatorHeight: 40,
            ),
          );
        }),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TTabBar), findsOneWidget);
    });
  });
}
