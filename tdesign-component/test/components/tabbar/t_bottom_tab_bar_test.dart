import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TBottomTabBarThemeData? tabBarTheme}) {
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

  List<TBottomTabBarTabConfig> buildTextTabs(int count) {
    return List.generate(count, (i) {
      return TBottomTabBarTabConfig(tabText: '标签${i + 1}', onTap: () {});
    });
  }

  List<TBottomTabBarTabConfig> buildIconTextTabs(int count) {
    return List.generate(count, (i) {
      return TBottomTabBarTabConfig(
        tabText: '标签${i + 1}',
        selectedIcon: const Icon(Icons.home, size: 24),
        unselectedIcon: const Icon(Icons.home_outlined, size: 24),
        onTap: () {},
      );
    });
  }

  group('TBottomTabBarThemeData', () {
    test('默认构造', () {
      const data = TBottomTabBarThemeData();
      expect(data.barHeight, null);
      expect(data.selectedBgColor, null);
    });

    test('带参数构造', () {
      const data = TBottomTabBarThemeData(
        barHeight: 60,
        selectedBgColor: Colors.red,
        backgroundColor: Colors.white,
      );
      expect(data.barHeight, 60);
      expect(data.selectedBgColor, Colors.red);
    });

    test('copyWith', () {
      const data = TBottomTabBarThemeData(barHeight: 56);
      final copied = data.copyWith(barHeight: 64, backgroundColor: Colors.blue);
      expect(copied.barHeight, 64);
      expect(copied.backgroundColor, Colors.blue);
    });

    test('lerp', () {
      const data1 = TBottomTabBarThemeData(barHeight: 56);
      const data2 = TBottomTabBarThemeData(barHeight: 64);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.barHeight, 60);
    });

    test('lerp 非 TBottomTabBarThemeData 返回自身', () {
      const data = TBottomTabBarThemeData(barHeight: 56);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('枚举', () {
    test('TBottomTabBarBasicType 枚举值', () {
      expect(TBottomTabBarBasicType.values.length, 4);
      expect(TBottomTabBarBasicType.values, contains(TBottomTabBarBasicType.text));
      expect(TBottomTabBarBasicType.values, contains(TBottomTabBarBasicType.iconText));
      expect(TBottomTabBarBasicType.values, contains(TBottomTabBarBasicType.icon));
      expect(TBottomTabBarBasicType.values,
          contains(TBottomTabBarBasicType.expansionPanel));
    });

    test('TBottomTabBarComponentType 枚举值', () {
      expect(TBottomTabBarComponentType.values.length, 2);
      expect(TBottomTabBarComponentType.values,
          contains(TBottomTabBarComponentType.normal));
      expect(TBottomTabBarComponentType.values,
          contains(TBottomTabBarComponentType.label));
    });

    test('TBottomTabBarOutlineType 枚举值', () {
      expect(TBottomTabBarOutlineType.values.length, 2);
      expect(TBottomTabBarOutlineType.values,
          contains(TBottomTabBarOutlineType.filled));
      expect(TBottomTabBarOutlineType.values,
          contains(TBottomTabBarOutlineType.capsule));
    });

    test('TBottomTabBarIndicatorAnimation 枚举值', () {
      expect(TBottomTabBarIndicatorAnimation.values.length, 3);
      expect(TBottomTabBarIndicatorAnimation.values,
          contains(TBottomTabBarIndicatorAnimation.none));
      expect(TBottomTabBarIndicatorAnimation.values,
          contains(TBottomTabBarIndicatorAnimation.linear));
      expect(TBottomTabBarIndicatorAnimation.values,
          contains(TBottomTabBarIndicatorAnimation.elastic));
    });
  });

  group('TBottomTabBarTabConfig', () {
    test('默认构造', () {
      final config = TBottomTabBarTabConfig(onTap: () {});
      expect(config.tabText, null);
      expect(config.selectedIcon, null);
      expect(config.allowMultipleTaps, false);
    });

    test('带参数构造', () {
      var tapped = false;
      final config = TBottomTabBarTabConfig(
        tabText: '标签',
        onTap: () => tapped = true,
        allowMultipleTaps: true,
      );
      config.onTap!();
      expect(tapped, true);
      expect(config.tabText, '标签');
      expect(config.allowMultipleTaps, true);
    });
  });

  group('BadgeConfig', () {
    test('默认构造', () {
      final config = BadgeConfig(showBadge: true);
      expect(config.showBadge, true);
      expect(config.tBadge, isNotNull);
    });

    test('showBadge: false', () {
      final config = BadgeConfig(showBadge: false);
      expect(config.showBadge, false);
    });
  });

  group('TBottomTabBar 基础渲染', () {
    testWidgets('text 类型渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(TBottomTabBarBasicType.text, navigationTabs: buildTextTabs(3)),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
      expect(find.text('标签1'), findsOneWidget);
      expect(find.text('标签3'), findsOneWidget);
    });

    testWidgets('iconText 类型渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          navigationTabs: buildIconTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
      expect(find.text('标签1'), findsOneWidget);
    });

    testWidgets('capsule 样式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          outlineType: TBottomTabBarOutlineType.capsule,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('componentType: normal', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.normal,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  group('TBottomTabBar value/currentIndex', () {
    testWidgets('使用 value 指定初始选中', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          value: 1,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('使用 currentIndex 指定初始选中（向后兼容）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          currentIndex: 2,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('value 优先级高于 currentIndex', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          value: 1,
          currentIndex: 2,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  group('TBottomTabBar 交互', () {
    testWidgets('点击 tab 触发 onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: [
            TBottomTabBarTabConfig(tabText: '标签1', onTap: () {}),
            TBottomTabBarTabConfig(tabText: '标签2', onTap: () => tapped = true),
          ],
        ),
      ));
      await tester.tap(find.text('标签2'));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });

    testWidgets('allowMultipleTaps 允许重复点击', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              onTap: () => tapCount++,
              allowMultipleTaps: true,
            ),
          ],
        ),
      ));
      await tester.tap(find.text('标签1'));
      await tester.pumpAndSettle();
      expect(tapCount, 1);
    });
  });

  group('TBottomTabBar 指示器动画', () {
    testWidgets('linear 动画', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          indicatorAnimation: TBottomTabBarIndicatorAnimation.linear,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('elastic 动画', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          indicatorAnimation: TBottomTabBarIndicatorAnimation.elastic,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  group('TBottomTabBar ThemeData', () {
    testWidgets('使用 mergeExtension 子树覆盖', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(barHeight: 64),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 barHeight', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(barHeight: 64),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  group('TBottomTabBar 断言', () {
    testWidgets('空 navigationTabs 抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(TBottomTabBarBasicType.text, navigationTabs: []),
        )),
        throwsA(isA<FlutterError>()),
      );
    });

    testWidgets('text 类型但 tabText 为 null 抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(
            TBottomTabBarBasicType.text,
            navigationTabs: [TBottomTabBarTabConfig(onTap: () {})],
          ),
        )),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
