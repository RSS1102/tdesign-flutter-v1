import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TNavBar V1.0 Widget 测试
///
/// 覆盖：默认渲染、title/centerTitle、leading/actions、useDefaultBack/onBack、
/// ThemeData 注入、禁用 callback、TNavBarItem、TNavBarBorder。
void main() {
  Widget wrapWithTheme(Widget child, {TNavBarThemeData? navBarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (navBarTheme != null) navBarTheme,
    ];
    return Theme(
      data: ThemeData(extensions: [TThemeData.defaultData()]),
      child: MaterialApp(
        theme: ThemeData(extensions: themeExtensions),
        home: Scaffold(body: child),
      ),
    );
  }

  group('TNavBar 基础渲染', () {
    testWidgets('默认渲染（标题居中、默认返回）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '页面标题'),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.text('页面标题'), findsOneWidget);
    });

    testWidgets('标题居中', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '居中标题', centerTitle: true),
      ));
      expect(find.text('居中标题'), findsOneWidget);
    });

    testWidgets('标题左对齐', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '左对齐', centerTitle: false),
      ));
      expect(find.text('左对齐'), findsOneWidget);
    });

    testWidgets('titleWidget 替代 title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '忽略', titleWidget: Text('自定义')),
      ));
      expect(find.text('自定义'), findsOneWidget);
      expect(find.text('忽略'), findsNothing);
    });
  });

  group('TNavBar leading / actions', () {
    testWidgets('leading 操作项渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        leading: [TNavBarItem(icon: TIcons.close, iconSize: 24)],
      )));
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('actions 操作项渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        actions: [
          TNavBarItem(icon: TIcons.home, iconSize: 24),
          TNavBarItem(icon: TIcons.ellipsis, iconSize: 24),
        ],
      )));
      expect(find.byIcon(TIcons.home), findsOneWidget);
      expect(find.byIcon(TIcons.ellipsis), findsOneWidget);
    });

    testWidgets('useDefaultBack 为 true 时显示返回图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', useDefaultBack: true),
      ));
      expect(find.byIcon(TIcons.chevron_left), findsOneWidget);
    });

    testWidgets('useDefaultBack 为 false 时不显示返回图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', useDefaultBack: false),
      ));
      expect(find.byIcon(TIcons.chevron_left), findsNothing);
    });
  });

  group('TNavBar onBack', () {
    testWidgets('onBack 回调被触发', (tester) async {
      var called = false;
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '标题',
          useDefaultBack: true,
          onBack: () => called = true,
        ),
      ));
      // 点击返回按钮
      final backFinder = find.byIcon(TIcons.chevron_left);
      await tester.tap(backFinder);
      expect(called, true);
    });

    testWidgets('onBack: null 时点击不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', useDefaultBack: true, onBack: null),
      ));
      final backFinder = find.byIcon(TIcons.chevron_left);
      await tester.tap(backFinder);
      // 无异常即通过
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });

  group('TNavBar L4 样式', () {
    testWidgets('自定义 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', height: 56),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', backgroundColor: Colors.blue),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('自定义 titleColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '彩色标题', titleColor: Colors.red),
      ));
      expect(find.text('彩色标题'), findsOneWidget);
    });

    testWidgets('border 边框模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '边框',
        useDefaultBack: false,
        useBorderStyle: true,
        leading: [TNavBarItem(icon: TIcons.close, iconSize: 24)],
        actions: [
          TNavBarItem(icon: TIcons.home, iconSize: 24),
          TNavBarItem(icon: TIcons.ellipsis, iconSize: 24),
        ],
      )));
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });

  group('TNavBarThemeData', () {
    test('默认构造全 null', () {
      const theme = TNavBarThemeData();
      expect(theme.titleColor, null);
      expect(theme.backgroundColor, null);
      expect(theme.opacity, null);
    });

    test('copyWith 部分覆盖', () {
      const theme = TNavBarThemeData(opacity: 1.0);
      final copied = theme.copyWith(opacity: 0.5);
      expect(copied.opacity, 0.5);
    });

    test('lerp', () {
      const a = TNavBarThemeData(opacity: 1.0);
      const b = TNavBarThemeData(opacity: 0.5);
      final result = a.lerp(b, 0.5);
      expect(result.opacity, 0.75);
    });

    test('lerp 非同类返回自身', () {
      const a = TNavBarThemeData(opacity: 1.0);
      final result = a.lerp(null, 0.5);
      expect(result.opacity, 1.0);
    });

    testWidgets('Theme 不承载 height，构造器 height 同步 preferredSize 与实际高度',
        (tester) async {
      const navBar = TNavBar(title: '标题', height: 64);
      await tester.pumpWidget(wrapWithTheme(navBar));
      expect(navBar.preferredSize.height, 64);
      expect(tester.getSize(find.byType(TNavBar)).height, 64);
    });
  });

  group('TNavBarItem', () {
    test('默认 iconSize 为 24', () {
      final item = TNavBarItem(icon: TIcons.home);
      expect(item.iconSize, 24.0);
      expect(item.icon, TIcons.home);
    });

    test('action: null 禁用', () {
      final item = TNavBarItem(icon: TIcons.home, action: null);
      expect(item.action, null);
    });

    testWidgets('item 点击触发 action', (tester) async {
      var called = false;
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        actions: [
          TNavBarItem(
              icon: TIcons.home, iconSize: 24, action: () => called = true),
        ],
      )));
      await tester.tap(find.byIcon(TIcons.home));
      expect(called, true);
    });
  });

  group('TNavBarBorder', () {
    test('默认值', () {
      const border = TNavBarBorder();
      expect(border.width, 1.0);
      expect(border.radius, 22.0);
      expect(border.color, null);
      expect(border.padding, null);
    });

    test('自定义值', () {
      const border = TNavBarBorder(
        width: 2.0,
        radius: 16.0,
        color: Colors.red,
      );
      expect(border.width, 2.0);
      expect(border.radius, 16.0);
      expect(border.color, Colors.red);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TNavBar 覆盖率补充', () {
    test('preferredSize 自定义 height', () {
      // 覆盖 111-112（preferredSize getter）
      const navBar = TNavBar(title: 'test', height: 60);
      expect(navBar.preferredSize.height, 60);
    });

    testWidgets('belowTitleWidget 渲染', (tester) async {
      // 覆盖 284-286（belowTitleWidget 非空 → Column 渲染）
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: 'below',
          belowTitleWidget: const Text('下方内容'),
        ),
      ));
      expect(find.text('下方内容'), findsOneWidget);
    });

    testWidgets('flexibleSpace 渲染', (tester) async {
      // 覆盖 312-315（flexibleSpace 非空 → Stack 渲染）
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: 'flex',
          flexibleSpace: Container(color: Colors.blue),
        ),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });
}
