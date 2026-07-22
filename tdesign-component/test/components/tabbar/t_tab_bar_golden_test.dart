import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Visual regression coverage for the current v1 TTabBar API.
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(backgroundColor: Colors.white, body: Center(child: child)),
    );
  }

  List<TTabBarItemConfig> textTabs() => List.generate(
        3,
        (index) => TTabBarItemConfig(
          tabText: ['首页', '分类', '我的'][index],
          onTap: () {},
        ),
      );

  List<TTabBarItemConfig> iconTextTabs() => [
        TTabBarItemConfig(
          tabText: '首页',
          selectedIcon: const Icon(Icons.home),
          unselectedIcon: const Icon(Icons.home_outlined),
          onTap: () {},
        ),
        TTabBarItemConfig(
          tabText: '搜索',
          selectedIcon: const Icon(Icons.search),
          unselectedIcon: const Icon(Icons.search_outlined),
          onTap: () {},
        ),
        TTabBarItemConfig(
          tabText: '我的',
          selectedIcon: const Icon(Icons.person),
          unselectedIcon: const Icon(Icons.person_outline),
          onTap: () {},
        ),
      ];

  List<TTabBarItemConfig> iconTabs() => [
        TTabBarItemConfig(
          selectedIcon: const Icon(Icons.home),
          unselectedIcon: const Icon(Icons.home_outlined),
          onTap: () {},
        ),
        TTabBarItemConfig(
          selectedIcon: const Icon(Icons.search),
          unselectedIcon: const Icon(Icons.search_outlined),
          onTap: () {},
        ),
      ];

  Future<void> expectTabBarGolden(
    WidgetTester tester, {
    required TTabBarVariant variant,
    required List<TTabBarItemConfig> tabs,
    required String golden,
    int value = 0,
  }) async {
    tester.view.physicalSize = const Size(400, 120);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(wrapWithTheme(
      TTabBar(
        variant: variant,
        value: value,
        navigationTabs: tabs,
        onChanged: (_) {},
      ),
    ));

    await expectLater(find.byType(TTabBar), matchesGoldenFile(golden));
  }

  group('TTabBar visual regression', () {
    testWidgets('text defaults to the first selected item', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.text,
        tabs: textTabs(),
        golden: 'goldens/t_tab_bar_text_default.png',
      );
    });

    testWidgets('text renders a non-first selected item', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.text,
        tabs: textTabs(),
        value: 1,
        golden: 'goldens/t_tab_bar_text_selected_1.png',
      );
    });

    testWidgets('icon text renders selected and unselected icons',
        (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.iconText,
        tabs: iconTextTabs(),
        golden: 'goldens/t_tab_bar_icon_text.png',
      );
    });

    testWidgets('icon renders selected and unselected icons', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.icon,
        tabs: iconTabs(),
        golden: 'goldens/t_tab_bar_icon.png',
      );
    });

    testWidgets('weak text has no selected capsule background', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.weakText,
        tabs: textTabs(),
        golden: 'goldens/t_tab_bar_normal_style.png',
      );
    });

    testWidgets('capsule renders icon text within the rounded bar',
        (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.capsule,
        tabs: iconTextTabs(),
        golden: 'goldens/t_tab_bar_capsule.png',
      );
    });
  });
}
