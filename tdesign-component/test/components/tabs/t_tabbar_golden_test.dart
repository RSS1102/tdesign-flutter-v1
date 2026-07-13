import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTabBar P0 Golden 测试
///
/// 覆盖 filled / capsule / card 等 outlineType 关键组合。
/// 首次运行用 `flutter test --update-goldens` 生成基线。
void main() {
  Widget wrapWithTheme(Widget child, {TTabBarThemeData? tabBarTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (tabBarTheme != null) tabBarTheme,
      ]),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  List<TTab> buildTabs(int count) {
    return List.generate(count, (i) => TTab(text: '选项${i + 1}'));
  }

  group('TTabBar Golden', () {
    testWidgets('filled 变体（默认）', (tester) async {
      tester.view.physicalSize = const Size(800, 100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(4),
          controller: TabController(length: 4, vsync: const _TestVSync()),
        ),
      ));
      await expectLater(
        find.byType(TTabBar),
        matchesGoldenFile('goldens/t_tabbar_filled.png'),
      );
    });

    testWidgets('capsule 变体', (tester) async {
      tester.view.physicalSize = const Size(800, 100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(4),
          controller: TabController(length: 4, vsync: const _TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(variant: TTabBarVariant.capsule),
      ));
      await expectLater(
        find.byType(TTabBar),
        matchesGoldenFile('goldens/t_tabbar_capsule.png'),
      );
    });

    testWidgets('card 变体', (tester) async {
      tester.view.physicalSize = const Size(800, 100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(4),
          controller: TabController(length: 4, vsync: const _TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(variant: TTabBarVariant.card),
      ));
      await expectLater(
        find.byType(TTabBar),
        matchesGoldenFile('goldens/t_tabbar_card.png'),
      );
    });

    testWidgets('filled 等分态', (tester) async {
      tester.view.physicalSize = const Size(800, 100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(2),
          controller: TabController(length: 2, vsync: const _TestVSync()),
        ),
      ));
      await expectLater(
        find.byType(TTabBar),
        matchesGoldenFile('goldens/t_tabbar_filled_2tabs.png'),
      );
    });

    testWidgets('capsule 多标签', (tester) async {
      tester.view.physicalSize = const Size(800, 100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          tabs: buildTabs(6),
          controller: TabController(length: 6, vsync: const _TestVSync()),
        ),
        tabBarTheme: const TTabBarThemeData(
          variant: TTabBarVariant.capsule,
        ),
      ));
      await expectLater(
        find.byType(TTabBar),
        matchesGoldenFile('goldens/t_tabbar_capsule_small.png'),
      );
    });
  }, skip: !Platform.isWindows);
}

/// 测试用 VSync
class _TestVSync extends TickerProvider {
  const _TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
