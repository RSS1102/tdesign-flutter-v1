import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TIcon v1.0 Widget 测试
///
/// 覆盖基础渲染、构造器参数、TIconThemeData 子树注入、
/// IconTheme 回退、TIcon.fromName 工厂构造。
void main() {
  /// 最小化包装，注入 TTheme
  Widget wrapWithTheme(Widget child, {TIconThemeData? iconTheme}) {
    final extensions = <ThemeExtension>[
      if (iconTheme != null) iconTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...extensions],
      ),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // T01 – 基础渲染
  // ============================================================
  testWidgets('T01 - 基础渲染：渲染 TDesign 图标', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TIcon(TIcons.home_filled),
    ));
    expect(find.byType(TIcon), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });

  // ============================================================
  // T02 – 构造器参数覆盖
  // ============================================================
  testWidgets('T02 - 构造器 size 生效', (tester) async {
    const customSize = 48.0;
    await tester.pumpWidget(wrapWithTheme(
      const TIcon(TIcons.setting, size: customSize),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, customSize);
  });

  testWidgets('T02b - 构造器 color 生效', (tester) async {
    const customColor = Colors.red;
    await tester.pumpWidget(wrapWithTheme(
      const TIcon(TIcons.check_circle, color: customColor),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, customColor);
  });

  // ============================================================
  // T03 – TIconThemeData 子树注入
  // ============================================================
  testWidgets('T03 - Theme size 默认生效', (tester) async {
    const themeSize = 32.0;
    await tester.pumpWidget(wrapWithTheme(
      const TIcon(TIcons.home_filled),
      iconTheme: const TIconThemeData(size: themeSize),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, themeSize);
  });

  testWidgets('T03b - Theme color 默认生效', (tester) async {
    const themeColor = Colors.blue;
    await tester.pumpWidget(wrapWithTheme(
      const TIcon(TIcons.star_filled),
      iconTheme: const TIconThemeData(color: themeColor),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, themeColor);
  });

  testWidgets('T03c - 构造器参数优先于 Theme', (tester) async {
    const themeSize = 20.0;
    const constructorSize = 40.0;
    await tester.pumpWidget(wrapWithTheme(
      const TIcon(TIcons.home_filled, size: constructorSize),
      iconTheme: const TIconThemeData(size: themeSize),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, constructorSize);
  });

  // ============================================================
  // T04 – IconTheme 回退
  // ============================================================
  testWidgets('T04 - 无 Theme 时回退 IconTheme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [TThemeData.defaultData()],
          iconTheme: const IconThemeData(size: 28.0, color: Colors.green),
        ),
        home: const Scaffold(
          body: Center(child: TIcon(TIcons.check)),
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, 28.0);
    expect(icon.color, Colors.green);
  });

  // ============================================================
  // T05 – TIcon.fromName 工厂构造
  // ============================================================
  testWidgets('T05 - fromName 合法名渲染图标', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TIcon.fromName('home_filled'),
    ));
    expect(find.byType(TIcon), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('T05b - fromName 带参数', (tester) async {
    const customSize = 36.0;
    await tester.pumpWidget(wrapWithTheme(
      TIcon.fromName('setting', size: customSize),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, customSize);
  });

  test('T05c - fromName 非法名抛出异常', () {
    expect(
      () => TIcon.fromName('__non_existent_icon__'),
      throwsA(isA<ArgumentError>()),
    );
  });

  // ============================================================
  // T06 – TIconThemeData.copyWith / lerp
  // ============================================================
  test('T06 - TIconThemeData.copyWith 正确合并', () {
    const original = TIconThemeData(size: 24.0, color: Colors.black);
    final copied = original.copyWith(size: 32.0);

    expect(copied.size, 32.0);
    expect(copied.color, Colors.black);
  });

  test('T06b - TIconThemeData.lerp 插值', () {
    const a = TIconThemeData(size: 10.0, color: Colors.red);
    const b = TIconThemeData(size: 20.0, color: Colors.blue);

    final mid = a.lerp(b, 0.5);
    expect(mid.size, 15.0);
    expect(mid.color, Color.lerp(Colors.red, Colors.blue, 0.5));
  });

  test('T06c - TIconThemeData.lerp null other 返回自身', () {
    const a = TIconThemeData(size: 10.0);
    final result = a.lerp(null, 0.5);
    expect(result, equals(a));
  });

  // 补充用例至 ≥15
  testWidgets('T07 - mergeExtension 覆盖 defaultSize', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        const TIconThemeData(size: 32.0, color: Colors.green),
      ]),
      home: const Scaffold(body: Center(child: TIcon(TIcons.home))),
    ));
    final icon = tester.widget<Icon>(find.byIcon(TIcons.home));
    expect(icon.size, 32.0);
    expect(icon.color, Colors.green);
  });

  testWidgets('T08 - 多个 TIcon 同时渲染', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: const Scaffold(body: Center(child: Row(children: [
        TIcon(TIcons.home),
        TIcon(TIcons.search),
        TIcon(TIcons.user),
      ]))),
    ));
    expect(find.byIcon(TIcons.home), findsOneWidget);
    expect(find.byIcon(TIcons.search), findsOneWidget);
    expect(find.byIcon(TIcons.user), findsOneWidget);
  });
}
