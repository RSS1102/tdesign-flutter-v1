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
      expect(
          TBottomTabBarBasicType.values, contains(TBottomTabBarBasicType.text));
      expect(TBottomTabBarBasicType.values,
          contains(TBottomTabBarBasicType.iconText));
      expect(
          TBottomTabBarBasicType.values, contains(TBottomTabBarBasicType.icon));
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
        TBottomTabBar(TBottomTabBarBasicType.text,
            navigationTabs: buildTextTabs(3)),
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

  group('TBottomTabBar value', () {
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

    testWidgets('父级更新 value 同步选中态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          value: 0,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          value: 2,
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
          TBottomTabBar(TBottomTabBarBasicType.text, navigationTabs: const []),
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

    testWidgets('icon 类型但未设置 icon 抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(
            TBottomTabBarBasicType.icon,
            navigationTabs: [
              TBottomTabBarTabConfig(tabText: '标签', onTap: () {})
            ],
          ),
        )),
        throwsA(isA<FlutterError>()),
      );
    });

    testWidgets('iconText 类型但未设置 tabText 抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(
            TBottomTabBarBasicType.iconText,
            navigationTabs: [
              TBottomTabBarTabConfig(
                selectedIcon: const Icon(Icons.home),
                unselectedIcon: const Icon(Icons.home_outlined),
                onTap: () {},
              ),
            ],
          ),
        )),
        throwsA(isA<FlutterError>()),
      );
    });

    testWidgets('iconText 类型但未设置 icon 抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(
            TBottomTabBarBasicType.iconText,
            navigationTabs: [
              TBottomTabBarTabConfig(tabText: '标签', onTap: () {}),
            ],
          ),
        )),
        throwsA(isA<FlutterError>()),
      );
    });

    testWidgets('value 越界抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(
            TBottomTabBarBasicType.text,
            value: 5,
            navigationTabs: buildTextTabs(3),
          ),
        )),
        throwsA(isA<FlutterError>()),
      );
    });

    testWidgets('value 为负数抛异常', (tester) async {
      expect(
        () => tester.pumpWidget(wrapWithTheme(
          TBottomTabBar(
            TBottomTabBarBasicType.text,
            value: -1,
            navigationTabs: buildTextTabs(3),
          ),
        )),
        throwsA(isA<FlutterError>()),
      );
    });
  });

  // ============================================================
  // icon 纯图标类型
  // ============================================================
  group('TBottomTabBar icon 纯图标类型', () {
    List<TBottomTabBarTabConfig> buildIconTabs(int count) {
      return List.generate(count, (i) {
        return TBottomTabBarTabConfig(
          selectedIcon: const Icon(Icons.home, size: 24),
          unselectedIcon: const Icon(Icons.home_outlined, size: 24),
          onTap: () {},
        );
      });
    }

    testWidgets('icon 类型正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(TBottomTabBarBasicType.icon,
            navigationTabs: buildIconTabs(3)),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
      // 选中第一个 tab，应显示 selectedIcon
      expect(find.byIcon(Icons.home), findsWidgets);
    });

    testWidgets('icon 类型点击切换', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.icon,
          navigationTabs: [
            TBottomTabBarTabConfig(
              selectedIcon: const Icon(Icons.home),
              unselectedIcon: const Icon(Icons.home_outlined),
              onTap: () {},
            ),
            TBottomTabBarTabConfig(
              selectedIcon: const Icon(Icons.search),
              unselectedIcon: const Icon(Icons.search_off),
              onTap: () => tapped = true,
            ),
          ],
        ),
      ));
      await tester.tap(find.byIcon(Icons.search_off));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });
  });

  // ============================================================
  // expansionPanel 展开面板类型
  // ============================================================
  group('TBottomTabBar expansionPanel 展开面板类型', () {
    testWidgets('expansionPanel 纯文本渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.expansionPanel,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
      expect(find.text('标签1'), findsOneWidget);
    });

    testWidgets('expansionPanel 带 popUpButtonConfig 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.expansionPanel,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              onTap: () {},
              popUpButtonConfig: TBottomTabBarPopUpBtnConfig(
                items: const [
                  PopUpMenuItem(value: '选项1'),
                  PopUpMenuItem(value: '选项2'),
                ],
                onChanged: (value) {},
              ),
            ),
            TBottomTabBarTabConfig(tabText: '标签2', onTap: () {}),
          ],
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
      // 展开面板带 popUpButtonConfig 时应显示 view_list 图标
      expect(find.byIcon(TIcons.view_list), findsOneWidget);
    });

    testWidgets('expansionPanel 点击带 popUpButtonConfig 弹出菜单', (tester) async {
      String? selectedValue;
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.expansionPanel,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              onTap: () {},
              popUpButtonConfig: TBottomTabBarPopUpBtnConfig(
                items: const [
                  PopUpMenuItem(value: '选项1'),
                  PopUpMenuItem(value: '选项2'),
                ],
                onChanged: (value) => selectedValue = value,
              ),
            ),
            TBottomTabBarTabConfig(tabText: '标签2', onTap: () {}),
          ],
        ),
      ));
      // 点击带弹窗的 tab
      await tester.tap(find.text('标签1'));
      await tester.pumpAndSettle();
      // 弹窗应出现
      expect(find.text('选项1'), findsOneWidget);
      expect(find.text('选项2'), findsOneWidget);
      // 点击选项1
      await tester.tap(find.text('选项1'));
      await tester.pumpAndSettle();
      expect(selectedValue, '选项1');
    });
  });

  // ============================================================
  // 分割线与边框
  // ============================================================
  group('TBottomTabBar 分割线与边框', () {
    testWidgets('useVerticalDivider: true 显示竖线分隔', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.normal,
          useVerticalDivider: true,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(VerticalDivider), findsNWidgets(2));
    });

    testWidgets('useVerticalDivider: true 但 label 样式不显示竖线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.label,
          useVerticalDivider: true,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      // label 样式强制不显示竖线
      expect(find.byType(VerticalDivider), findsNothing);
    });

    testWidgets('showTopBorder: false 不显示上边线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          showTopBorder: false,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('自定义 topBorder', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          topBorder: const BorderSide(color: Colors.red, width: 2),
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('自定义 dividerColor 和 dividerThickness', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.normal,
          useVerticalDivider: true,
          dividerColor: Colors.blue,
          dividerThickness: 1.0,
          dividerHeight: 40,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(VerticalDivider), findsNWidgets(2));
    });
  });

  // ============================================================
  // needInkWell 水波纹效果
  // ============================================================
  group('TBottomTabBar needInkWell 水波纹', () {
    testWidgets('needInkWell: true 渲染 Material + InkWell', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          needInkWell: true,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(InkWell), findsWidgets);
      expect(find.byType(Material), findsWidgets);
    });

    testWidgets('needInkWell: false 不渲染 InkWell', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          needInkWell: false,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(InkWell), findsNothing);
    });
  });

  // ============================================================
  // useSafeArea 与 placeholder
  // ============================================================
  group('TBottomTabBar useSafeArea 与 placeholder', () {
    testWidgets('useSafeArea: false 不使用安全区域', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          useSafeArea: false,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('useSafeArea: true + placeholder: false 使用 SafeArea',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          useSafeArea: true,
          placeholder: false,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });

  // ============================================================
  // onLongPress 长按事件
  // ============================================================
  group('TBottomTabBar onLongPress', () {
    testWidgets('长按触发 onLongPress 回调', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              onTap: () {},
              onLongPress: () => longPressed = true,
            ),
            TBottomTabBarTabConfig(tabText: '标签2', onTap: () {}),
          ],
        ),
      ));
      await tester.longPress(find.text('标签1'));
      await tester.pumpAndSettle();
      expect(longPressed, true);
    });
  });

  // ============================================================
  // BadgeConfig 徽标
  // ============================================================
  group('TBottomTabBar BadgeConfig 徽标', () {
    testWidgets('showBadge: true 显示徽标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              onTap: () {},
              badgeConfig: BadgeConfig(
                showBadge: true,
                tBadge: const TBadge(TBadgeVariant.redPoint),
              ),
            ),
            TBottomTabBarTabConfig(tabText: '标签2', onTap: () {}),
          ],
        ),
      ));
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets('BadgeConfig 自定义偏移量', (tester) async {
      final config = BadgeConfig(
        showBadge: true,
        tBadge: const TBadge(TBadgeVariant.redPoint),
        badgeTopOffset: -5,
        badgeRightOffset: -15,
      );
      expect(config.badgeTopOffset, -5);
      expect(config.badgeRightOffset, -15);
    });

    testWidgets('BadgeConfig 默认 tBadge 为 redPoint', (tester) async {
      final config = BadgeConfig(showBadge: true);
      expect(config.tBadge, isNotNull);
    });
  });

  // ============================================================
  // 自定义文本样式与颜色
  // ============================================================
  group('TBottomTabBar 自定义文本样式与颜色', () {
    testWidgets('selectTabTextStyle / unselectTabTextStyle 自定义',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              onTap: () {},
              selectTabTextStyle:
                  const TextStyle(color: Colors.red, fontSize: 16),
              unselectTabTextStyle:
                  const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            TBottomTabBarTabConfig(tabText: '标签2', onTap: () {}),
          ],
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('selectedBgColor / unselectedBgColor 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          selectedBgColor: Colors.yellow,
          unselectedBgColor: Colors.grey,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('backgroundColor 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          backgroundColor: Colors.white,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('centerDistance 自定义（iconText）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          centerDistance: 4,
          navigationTabs: buildIconTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('自定义 barHeight', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          barHeight: 72,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // Theme 全面覆盖
  // ============================================================
  group('TBottomTabBar Theme 全面覆盖', () {
    testWidgets('Theme 注入 useVerticalDivider', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.normal,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(useVerticalDivider: true),
      ));
      expect(find.byType(VerticalDivider), findsNWidgets(2));
    });

    testWidgets('Theme 注入 selectedBgColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(
          selectedBgColor: Colors.green,
          unselectedBgColor: Colors.grey,
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme:
            const TBottomTabBarThemeData(backgroundColor: Colors.white),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 centerDistance', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          navigationTabs: buildIconTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(centerDistance: 6),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 dividerHeight 和 dividerThickness', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          componentType: TBottomTabBarComponentType.normal,
          useVerticalDivider: true,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(
          dividerHeight: 40,
          dividerThickness: 1.0,
          dividerColor: Colors.blue,
        ),
      ));
      expect(find.byType(VerticalDivider), findsNWidgets(2));
    });

    testWidgets('Theme 注入 showTopBorder', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(showTopBorder: false),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('Theme 注入 topBorder', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          navigationTabs: buildTextTabs(3),
        ),
        tabBarTheme: const TBottomTabBarThemeData(
          topBorder: BorderSide(color: Colors.red, width: 1),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    test('Theme lerp 全字段插值', () {
      const data1 = TBottomTabBarThemeData(
        barHeight: 56,
        selectedBgColor: Colors.red,
        unselectedBgColor: Colors.grey,
        backgroundColor: Colors.white,
        centerDistance: 4,
        useVerticalDivider: true,
        dividerHeight: 32,
        dividerThickness: 0.5,
        dividerColor: Colors.black,
        showTopBorder: true,
        topBorder: BorderSide(color: Colors.red, width: 1),
        needInkWell: false,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      );
      const data2 = TBottomTabBarThemeData(
        barHeight: 64,
        selectedBgColor: Colors.blue,
        unselectedBgColor: Colors.green,
        backgroundColor: Colors.black,
        centerDistance: 8,
        useVerticalDivider: false,
        dividerHeight: 40,
        dividerThickness: 1.0,
        dividerColor: Colors.white,
        showTopBorder: false,
        topBorder: BorderSide(color: Colors.blue, width: 2),
        needInkWell: true,
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.linear,
      );
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.barHeight, 60);
      expect(lerped.selectedBgColor, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(lerped.useVerticalDivider, true); // t < 0.5 取 data1
      expect(lerped.showTopBorder, true); // t < 0.5 取 data1
      expect(lerped.needInkWell, false); // t < 0.5 取 data1
    });

    test('Theme lerp t >= 0.5 取 other 的布尔值', () {
      const data1 = TBottomTabBarThemeData(
        useVerticalDivider: true,
        showTopBorder: true,
        needInkWell: false,
      );
      const data2 = TBottomTabBarThemeData(
        useVerticalDivider: false,
        showTopBorder: false,
        needInkWell: true,
      );
      final lerped = data1.lerp(data2, 0.6);
      expect(lerped.useVerticalDivider, false); // t >= 0.5 取 data2
      expect(lerped.showTopBorder, false);
      expect(lerped.needInkWell, true);
    });

    test('copyWith 全字段覆盖', () {
      const data = TBottomTabBarThemeData();
      final copied = data.copyWith(
        barHeight: 56,
        selectedBgColor: Colors.red,
        unselectedBgColor: Colors.grey,
        backgroundColor: Colors.white,
        centerDistance: 4,
        useVerticalDivider: true,
        dividerHeight: 32,
        dividerThickness: 0.5,
        dividerColor: Colors.black,
        showTopBorder: true,
        topBorder: const BorderSide(color: Colors.red),
        needInkWell: true,
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.linear,
      );
      expect(copied.barHeight, 56);
      expect(copied.selectedBgColor, Colors.red);
      expect(copied.unselectedBgColor, Colors.grey);
      expect(copied.backgroundColor, Colors.white);
      expect(copied.centerDistance, 4);
      expect(copied.useVerticalDivider, true);
      expect(copied.dividerHeight, 32);
      expect(copied.dividerThickness, 0.5);
      expect(copied.dividerColor, Colors.black);
      expect(copied.showTopBorder, true);
      expect(copied.needInkWell, true);
      expect(copied.animationDuration, const Duration(milliseconds: 500));
      expect(copied.animationCurve, Curves.linear);
    });
  });

  // ============================================================
  // didUpdateWidget 选中切换动画
  // ============================================================
  group('TBottomTabBar didUpdateWidget', () {
    testWidgets('value 变化触发选中切换', (tester) async {
      var value = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TBottomTabBar(
              TBottomTabBarBasicType.text,
              value: value,
              indicatorAnimation: TBottomTabBarIndicatorAnimation.linear,
              navigationTabs: buildTextTabs(3),
            );
          },
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);

      // 切换到第二个 tab
      setState(() => value = 1);
      await tester.pumpAndSettle();
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('value 变化触发选中切换', (tester) async {
      var value = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TBottomTabBar(
              TBottomTabBarBasicType.text,
              value: value,
              navigationTabs: buildTextTabs(3),
            );
          },
        ),
      ));
      setState(() => value = 2);
      await tester.pumpAndSettle();
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('animationDuration 变化更新控制器', (tester) async {
      var duration = const Duration(milliseconds: 300);
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TBottomTabBar(
              TBottomTabBarBasicType.text,
              animationDuration: duration,
              navigationTabs: buildTextTabs(3),
            );
          },
        ),
      ));
      setState(() => duration = const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // TBottomTabBarPopUpBtnConfig 与 PopUpMenuItem
  // ============================================================
  group('TBottomTabBarPopUpBtnConfig', () {
    test('默认构造', () {
      final config = TBottomTabBarPopUpBtnConfig(
        items: const [PopUpMenuItem(value: 'test')],
        onChanged: (value) {},
      );
      expect(config.items.length, 1);
      expect(config.popUpDialogConfig, null);
    });

    test('带 popUpDialogConfig 构造', () {
      final config = TBottomTabBarPopUpBtnConfig(
        items: const [PopUpMenuItem(value: 'test')],
        onChanged: (value) {},
        popUpDialogConfig: TBottomTabBarPopUpShapeConfig(
          radius: 8,
          arrowWidth: 14,
          arrowHeight: 9,
        ),
      );
      expect(config.popUpDialogConfig, isNotNull);
      expect(config.popUpDialogConfig!.radius, 8);
    });

    test('arrowHeight <= 0 抛异常', () {
      expect(
        () => TBottomTabBarPopUpBtnConfig(
          items: const [PopUpMenuItem(value: 'test')],
          onChanged: (value) {},
          popUpDialogConfig: TBottomTabBarPopUpShapeConfig(
            arrowHeight: 0,
          ),
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('arrowWidth <= 0 抛异常', () {
      expect(
        () => TBottomTabBarPopUpBtnConfig(
          items: const [PopUpMenuItem(value: 'test')],
          onChanged: (value) {},
          popUpDialogConfig: TBottomTabBarPopUpShapeConfig(
            arrowWidth: 0,
          ),
        ),
        throwsA(isA<FlutterError>()),
      );
    });
  });

  group('TBottomTabBarPopUpShapeConfig', () {
    test('默认构造', () {
      final config = TBottomTabBarPopUpShapeConfig();
      expect(config.popUpWidth, null);
      expect(config.popUpItemHeight, 48);
      expect(config.backgroundColor, null);
      expect(config.radius, null);
      expect(config.arrowWidth, null);
      expect(config.arrowHeight, null);
    });

    test('带参数构造', () {
      final config = TBottomTabBarPopUpShapeConfig(
        popUpWidth: 200,
        popUpItemHeight: 56,
        backgroundColor: Colors.white,
        radius: 8,
        arrowWidth: 14,
        arrowHeight: 9,
      );
      expect(config.popUpWidth, 200);
      expect(config.popUpItemHeight, 56);
      expect(config.backgroundColor, Colors.white);
      expect(config.radius, 8);
      expect(config.arrowWidth, 14);
      expect(config.arrowHeight, 9);
    });
  });

  group('PopUpMenuItem', () {
    testWidgets('默认构造显示 value 文本', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PopUpMenuItem(value: '测试值'),
          ),
        ),
      );
      expect(find.text('测试值'), findsOneWidget);
    });

    testWidgets('自定义 itemWidget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PopUpMenuItem(
              value: 'test',
              itemWidget: Text('自定义内容'),
            ),
          ),
        ),
      );
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('自定义 alignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PopUpMenuItem(
              value: 'test',
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      );
      expect(find.text('test'), findsOneWidget);
    });
  });

  // ============================================================
  // 更多 tab 数量场景（>3 和 <=3）
  // ============================================================
  group('TBottomTabBar tab 数量场景', () {
    testWidgets('4 个 tab（>3）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(TBottomTabBarBasicType.text,
            navigationTabs: buildTextTabs(4)),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
      expect(find.text('标签4'), findsOneWidget);
    });

    testWidgets('2 个 tab（<=3）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(TBottomTabBarBasicType.text,
            navigationTabs: buildTextTabs(2)),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('capsule + iconText 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          outlineType: TBottomTabBarOutlineType.capsule,
          navigationTabs: buildIconTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });

    testWidgets('capsule + normal 样式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.text,
          outlineType: TBottomTabBarOutlineType.capsule,
          componentType: TBottomTabBarComponentType.normal,
          navigationTabs: buildTextTabs(3),
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });

  // ============================================================
  // iconText 类型点击切换和交互
  // ============================================================
  group('TBottomTabBar iconText 交互', () {
    testWidgets('iconText 类型点击切换 selectedIcon', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '标签1',
              selectedIcon: const Icon(Icons.home),
              unselectedIcon: const Icon(Icons.home_outlined),
              onTap: () {},
            ),
            TBottomTabBarTabConfig(
              tabText: '标签2',
              selectedIcon: const Icon(Icons.search),
              unselectedIcon: const Icon(Icons.search_off),
              onTap: () => tapped = true,
            ),
          ],
        ),
      ));
      await tester.tap(find.text('标签2'));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });

    testWidgets('iconText 类型空 tabText 渲染（允许空文本）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TBottomTabBar(
          TBottomTabBarBasicType.iconText,
          navigationTabs: [
            TBottomTabBarTabConfig(
              tabText: '',
              selectedIcon: const Icon(Icons.home),
              unselectedIcon: const Icon(Icons.home_outlined),
              onTap: () {},
            ),
            TBottomTabBarTabConfig(
              tabText: '标签2',
              selectedIcon: const Icon(Icons.search),
              unselectedIcon: const Icon(Icons.search_off),
              onTap: () {},
            ),
          ],
        ),
      ));
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });
}
