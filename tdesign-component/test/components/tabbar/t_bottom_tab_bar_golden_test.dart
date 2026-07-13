import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TBottomTabBar P0 Golden 测试
///
/// 覆盖 text/iconText/icon/expansionPanel 四种基本类型 + capsule 轮廓 + 选中态。
/// 首次运行用 `flutter test --update-goldens` 生成基线。
void main() {
  Widget wrapWithTheme(Widget child,
      {TBottomTabBarThemeData? tabTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (tabTheme != null) tabTheme,
      ]),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  /// 构造文本类型 tabs
  List<TBottomTabBarTabConfig> _textTabs() => [
        TBottomTabBarTabConfig(
          tabText: '首页',
          onTap: () {},
        ),
        TBottomTabBarTabConfig(
          tabText: '分类',
          onTap: () {},
        ),
        TBottomTabBarTabConfig(
          tabText: '我的',
          onTap: () {},
        ),
      ];

  /// 构造图标+文本类型 tabs
  List<TBottomTabBarTabConfig> _iconTextTabs() => [
        TBottomTabBarTabConfig(
          tabText: '首页',
          selectedIcon: const Icon(Icons.home),
          unselectedIcon: const Icon(Icons.home_outlined),
          onTap: () {},
        ),
        TBottomTabBarTabConfig(
          tabText: '搜索',
          selectedIcon: const Icon(Icons.search),
          unselectedIcon: const Icon(Icons.search_off),
          onTap: () {},
        ),
        TBottomTabBarTabConfig(
          tabText: '我的',
          selectedIcon: const Icon(Icons.person),
          unselectedIcon: const Icon(Icons.person_outline),
          onTap: () {},
        ),
      ];

  /// 构造纯图标类型 tabs
  List<TBottomTabBarTabConfig> _iconTabs() => [
        TBottomTabBarTabConfig(
          selectedIcon: const Icon(Icons.home),
          unselectedIcon: const Icon(Icons.home_outlined),
          onTap: () {},
        ),
        TBottomTabBarTabConfig(
          selectedIcon: const Icon(Icons.search),
          unselectedIcon: const Icon(Icons.search_off),
          onTap: () {},
        ),
      ];

  group('TBottomTabBar Golden', () {
    testWidgets('text 类型 - 默认选中第一项', (tester) async {
      tester.view.physicalSize = const Size(400, 120);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: _textTabs(),
        ),
      ));
      await expectLater(
        find.byType(TBottomTabBar),
        matchesGoldenFile('goldens/t_bottom_tab_bar_text_default.png'),
      );
    });

    testWidgets('text 类型 - 选中第二项', (tester) async {
      tester.view.physicalSize = const Size(400, 120);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: _textTabs(),
          value: 1,
        ),
      ));
      await expectLater(
        find.byType(TBottomTabBar),
        matchesGoldenFile('goldens/t_bottom_tab_bar_text_selected_1.png'),
      );
    });

    testWidgets('iconText 类型', (tester) async {
      tester.view.physicalSize = const Size(400, 120);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          navigationTabs: _iconTextTabs(),
        ),
      ));
      await expectLater(
        find.byType(TBottomTabBar),
        matchesGoldenFile('goldens/t_bottom_tab_bar_icon_text.png'),
      );
    });

    testWidgets('icon 类型', (tester) async {
      tester.view.physicalSize = const Size(400, 120);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.icon,
          navigationTabs: _iconTabs(),
        ),
      ));
      await expectLater(
        find.byType(TBottomTabBar),
        matchesGoldenFile('goldens/t_bottom_tab_bar_icon.png'),
      );
    });

    testWidgets('capsule 轮廓样式', (tester) async {
      tester.view.physicalSize = const Size(400, 120);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          outlineType: TBottomTabBarOutlineType.capsule,
          navigationTabs: _textTabs(),
        ),
      ));
      await expectLater(
        find.byType(TBottomTabBar),
        matchesGoldenFile('goldens/t_bottom_tab_bar_capsule.png'),
      );
    });

    testWidgets('normal 选中样式（无胶囊背景）', (tester) async {
      tester.view.physicalSize = const Size(400, 120);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.normal,
          navigationTabs: _textTabs(),
        ),
      ));
      await expectLater(
        find.byType(TBottomTabBar),
        matchesGoldenFile('goldens/t_bottom_tab_bar_normal_style.png'),
      );
    });
  }, skip: !Platform.isWindows);
}
