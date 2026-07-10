import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSwitch V1.0 Widget 测试
///
/// B 类控制：`value` + `onChanged` 受控；`enabled: false` = 禁用。
/// 覆盖 variant 矩阵、size 三档、Theme 子树注入。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TSwitchThemeData? switchTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (switchTheme != null) switchTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // B 类控制：value 受控 + enabled 禁用
  // ============================================================
  group('TSwitch B 类控制（value + enabled）', () {
    testWidgets('value=false 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('value=true 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('enabled=false 时不响应点击（IgnorePointer）', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrapWithTheme(
        TSwitch(
          value: false,
          enabled: false,
          onChanged: (v) => changed = v,
        ),
      ));

      // 禁用时应包裹 ignoring=true 的 IgnorePointer，点击不触发回调
      expect(
        find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring),
        findsOneWidget,
      );
      await tester.tap(find.byType(TSwitch), warnIfMissed: false);
      await tester.pump();
      expect(changed, isFalse);
    });

    testWidgets('enabled=true + onChanged 非 null 时切换触发回调', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrapWithTheme(
        TSwitch(
          value: false,
          onChanged: (v) => changed = v,
        ),
      ));

      await tester.tap(find.byType(TSwitch));
      await tester.pump();
      expect(changed, isTrue);
    });

    testWidgets('enabled=true 但 onChanged=null 时仍可点击但无回调', (tester) async {
      // enabled=true 且 onChanged=null：底层 onChanged 传 null，但不禁用手势
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false, enabled: true),
      ));
      // 不应存在 ignoring=true 的 IgnorePointer
      expect(
        find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring),
        findsNothing,
      );
    });
  });

  // ============================================================
  // variant 四档
  // ============================================================
  group('TSwitch variant 形态', () {
    testWidgets('fill（默认）正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.fill),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('text 形态显示开/关文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.text,
          openText: '开',
          closeText: '关',
        ),
      ));
      expect(find.text('开'), findsOneWidget);
    });

    testWidgets('text 形态 value=false 显示关文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: false,
          variant: TSwitchVariant.text,
          openText: '开',
          closeText: '关',
        ),
      ));
      expect(find.text('关'), findsOneWidget);
    });

    testWidgets('loading 形态渲染加载指示器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.loading),
      ));
      // loading variant 应渲染 TCircleIndicator
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('loading 形态自动禁用（IgnorePointer）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.loading),
      ));
      // loading 时 switchEnabled = false，应存在 ignoring=true 的 IgnorePointer
      expect(
        find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring),
        findsOneWidget,
      );
    });

    testWidgets('icon 形态显示 check/close 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.icon),
      ));
      // value=true 时显示 check 图标
      expect(find.byIcon(TIcons.check), findsOneWidget);
    });

    testWidgets('icon 形态 value=false 显示 close 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false, variant: TSwitchVariant.icon),
      ));
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });
  });

  // ============================================================
  // size 三档
  // ============================================================
  group('TSwitch size 尺寸', () {
    testWidgets('large 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, size: TSwitchSize.large),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('medium 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, size: TSwitchSize.medium),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('small 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, size: TSwitchSize.small),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义颜色
  // ============================================================
  group('TSwitch 自定义颜色', () {
    testWidgets('trackOnColor / trackOffColor 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          trackOnColor: Colors.red,
          trackOffColor: Colors.grey,
        ),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('thumbContentOnColor 自定义（text 形态）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.text,
          thumbContentOnColor: Colors.blue,
        ),
      ));
      expect(find.text('开'), findsOneWidget);
    });
  });

  // ============================================================
  // Theme 子树注入
  // ============================================================
  group('TSwitch Theme 子树', () {
    testWidgets('mergeExtension 覆盖 defaultVariant', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true),
        switchTheme: const TSwitchThemeData(
          defaultVariant: TSwitchVariant.text,
          openText: '主题开',
        ),
      ));
      // Theme 注入的 openText 应生效
      expect(find.text('主题开'), findsOneWidget);
    });

    testWidgets('构造器 variant 覆盖 Theme defaultVariant', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.icon,
        ),
        switchTheme: const TSwitchThemeData(
          defaultVariant: TSwitchVariant.text,
        ),
      ));
      // 构造器 icon 优先，不应显示 text 形态的文案
      expect(find.byIcon(TIcons.check), findsOneWidget);
    });

    testWidgets('mergeExtension 覆盖 defaultSize', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true),
        switchTheme: const TSwitchThemeData(
          defaultSize: TSwitchSize.small,
        ),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });
  });

  // ============================================================
  // TSwitchThemeData copyWith / lerp
  // ============================================================
  group('TSwitchThemeData copyWith / lerp', () {
    test('copyWith 全字段覆盖', () {
      const data = TSwitchThemeData();
      final copied = data.copyWith(
        defaultSize: TSwitchSize.large,
        defaultVariant: TSwitchVariant.text,
        trackOnColor: Colors.red,
        trackOffColor: Colors.grey,
        thumbContentOnColor: Colors.blue,
        thumbContentOffColor: Colors.green,
        thumbContentOnFont: const TextStyle(fontSize: 16),
        thumbContentOffFont: const TextStyle(fontSize: 12),
        openText: '开',
        closeText: '关',
      );
      expect(copied.defaultSize, TSwitchSize.large);
      expect(copied.defaultVariant, TSwitchVariant.text);
      expect(copied.trackOnColor, Colors.red);
      expect(copied.trackOffColor, Colors.grey);
      expect(copied.thumbContentOnColor, Colors.blue);
      expect(copied.thumbContentOffColor, Colors.green);
      expect(copied.thumbContentOnFont, isNotNull);
      expect(copied.thumbContentOffFont, isNotNull);
      expect(copied.openText, '开');
      expect(copied.closeText, '关');
    });

    test('lerp 正常插值', () {
      const data1 = TSwitchThemeData(
        defaultSize: TSwitchSize.small,
        defaultVariant: TSwitchVariant.fill,
        trackOnColor: Colors.red,
        trackOffColor: Colors.grey,
        thumbContentOnColor: Colors.blue,
        thumbContentOffColor: Colors.green,
        openText: '开1',
        closeText: '关1',
      );
      const data2 = TSwitchThemeData(
        defaultSize: TSwitchSize.large,
        defaultVariant: TSwitchVariant.text,
        trackOnColor: Colors.blue,
        trackOffColor: Colors.green,
        thumbContentOnColor: Colors.red,
        thumbContentOffColor: Colors.yellow,
        openText: '开2',
        closeText: '关2',
      );
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.defaultSize, TSwitchSize.small); // t < 0.5 取 data1
      expect(lerped.defaultVariant, TSwitchVariant.fill);
      expect(lerped.openText, '开1');
    });

    test('lerp t >= 0.5 取 other', () {
      const data1 = TSwitchThemeData(
        defaultSize: TSwitchSize.small,
        defaultVariant: TSwitchVariant.fill,
        openText: '开1',
      );
      const data2 = TSwitchThemeData(
        defaultSize: TSwitchSize.large,
        defaultVariant: TSwitchVariant.text,
        openText: '开2',
      );
      final lerped = data1.lerp(data2, 0.6);
      expect(lerped.defaultSize, TSwitchSize.large);
      expect(lerped.defaultVariant, TSwitchVariant.text);
      expect(lerped.openText, '开2');
    });

    test('lerp 非 TSwitchThemeData 返回自身', () {
      const data = TSwitchThemeData(defaultSize: TSwitchSize.small);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  // ============================================================
  // TSwitchResolve 解析器
  // ============================================================
  group('TSwitchResolve 解析器', () {
    testWidgets('getWidth 各尺寸返回正确值', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(TSwitchResolve.getWidth(TSwitchSize.large), 52);
      expect(TSwitchResolve.getWidth(TSwitchSize.medium), 45);
      expect(TSwitchResolve.getWidth(TSwitchSize.small), 39);
    });

    testWidgets('getHeight 各尺寸返回正确值', (tester) async {
      expect(TSwitchResolve.getHeight(TSwitchSize.large), 32);
      expect(TSwitchResolve.getHeight(TSwitchSize.medium), 28);
      expect(TSwitchResolve.getHeight(TSwitchSize.small), 24);
    });

    testWidgets('resolveTrackOnColor 实例颜色优先', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ));

      // 实例颜色优先
      expect(
        TSwitchResolve.resolveTrackOnColor(
          context: capturedContext,
          theme: null,
          instanceColor: Colors.red,
        ),
        Colors.red,
      );

      // Theme 颜色次之
      expect(
        TSwitchResolve.resolveTrackOnColor(
          context: capturedContext,
          theme: const TSwitchThemeData(trackOnColor: Colors.blue),
          instanceColor: null,
        ),
        Colors.blue,
      );
    });

    testWidgets('resolveTrackOffColor 实例颜色优先', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ));

      expect(
        TSwitchResolve.resolveTrackOffColor(
          context: capturedContext,
          theme: null,
          instanceColor: Colors.grey,
        ),
        Colors.grey,
      );

      expect(
        TSwitchResolve.resolveTrackOffColor(
          context: capturedContext,
          theme: const TSwitchThemeData(trackOffColor: Colors.green),
          instanceColor: null,
        ),
        Colors.green,
      );
    });

    testWidgets('resolveThumbOnColor 实例颜色优先', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ));

      expect(
        TSwitchResolve.resolveThumbOnColor(
          context: capturedContext,
          theme: null,
          instanceColor: Colors.red,
        ),
        Colors.red,
      );

      expect(
        TSwitchResolve.resolveThumbOnColor(
          context: capturedContext,
          theme: const TSwitchThemeData(thumbContentOnColor: Colors.blue),
          instanceColor: null,
        ),
        Colors.blue,
      );
    });

    testWidgets('resolveThumbOffColor 实例颜色优先', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ));

      expect(
        TSwitchResolve.resolveThumbOffColor(
          context: capturedContext,
          theme: null,
          instanceColor: Colors.grey,
        ),
        Colors.grey,
      );

      expect(
        TSwitchResolve.resolveThumbOffColor(
          context: capturedContext,
          theme: const TSwitchThemeData(thumbContentOffColor: Colors.green),
          instanceColor: null,
        ),
        Colors.green,
      );
    });

    test('resolveThumbOnFont 实例字体优先', () {
      const instanceFont = TextStyle(fontSize: 18);
      expect(
        TSwitchResolve.resolveThumbOnFont(
          theme: null,
          instanceFont: instanceFont,
        ),
        instanceFont,
      );

      expect(
        TSwitchResolve.resolveThumbOnFont(
          theme: const TSwitchThemeData(thumbContentOnFont: TextStyle(fontSize: 16)),
          instanceFont: null,
        ).fontSize,
        16,
      );

      expect(
        TSwitchResolve.resolveThumbOnFont(
          theme: null,
          instanceFont: null,
        ).fontSize,
        14,
      );
    });

    test('resolveThumbOffFont 实例字体优先', () {
      const instanceFont = TextStyle(fontSize: 18);
      expect(
        TSwitchResolve.resolveThumbOffFont(
          theme: null,
          instanceFont: instanceFont,
        ),
        instanceFont,
      );

      expect(
        TSwitchResolve.resolveThumbOffFont(
          theme: const TSwitchThemeData(thumbContentOffFont: TextStyle(fontSize: 12)),
          instanceFont: null,
        ).fontSize,
        12,
      );

      expect(
        TSwitchResolve.resolveThumbOffFont(
          theme: null,
          instanceFont: null,
        ).fontSize,
        14,
      );
    });
  });

  // ============================================================
  // 枚举值验证
  // ============================================================
  group('TSwitch 枚举', () {
    test('TSwitchSize 枚举值', () {
      expect(TSwitchSize.values.length, 3);
      expect(TSwitchSize.values, contains(TSwitchSize.large));
      expect(TSwitchSize.values, contains(TSwitchSize.medium));
      expect(TSwitchSize.values, contains(TSwitchSize.small));
    });

    test('TSwitchVariant 枚举值', () {
      expect(TSwitchVariant.values.length, 4);
      expect(TSwitchVariant.values, contains(TSwitchVariant.fill));
      expect(TSwitchVariant.values, contains(TSwitchVariant.text));
      expect(TSwitchVariant.values, contains(TSwitchVariant.loading));
      expect(TSwitchVariant.values, contains(TSwitchVariant.icon));
    });
  });

  // ============================================================
  // text 形态默认文案
  // ============================================================
  group('TSwitch text 形态默认文案', () {
    testWidgets('未设置 openText/closeText 时使用默认"开"/"关"', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.text),
      ));
      expect(find.text('开'), findsOneWidget);
    });

    testWidgets('未设置 closeText 时使用默认"关"', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false, variant: TSwitchVariant.text),
      ));
      expect(find.text('关'), findsOneWidget);
    });
  });

  // ============================================================
  // Theme 颜色注入
  // ============================================================
  group('TSwitch Theme 颜色注入', () {
    testWidgets('Theme 注入 trackOnColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true),
        switchTheme: const TSwitchThemeData(
          trackOnColor: Colors.green,
        ),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('Theme 注入 trackOffColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false),
        switchTheme: const TSwitchThemeData(
          trackOffColor: Colors.orange,
        ),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
    });

    testWidgets('Theme 注入 thumbContentOnColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.icon),
        switchTheme: const TSwitchThemeData(
          thumbContentOnColor: Colors.purple,
        ),
      ));
      expect(find.byIcon(TIcons.check), findsOneWidget);
    });

    testWidgets('Theme 注入 thumbContentOffColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false, variant: TSwitchVariant.icon),
        switchTheme: const TSwitchThemeData(
          thumbContentOffColor: Colors.teal,
        ),
      ));
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('Theme 注入 openText/closeText', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.text),
        switchTheme: const TSwitchThemeData(
          openText: '主题开',
          closeText: '主题关',
        ),
      ));
      expect(find.text('主题开'), findsOneWidget);
    });

    testWidgets('构造器 openText 覆盖 Theme openText', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.text,
          openText: '实例开',
        ),
        switchTheme: const TSwitchThemeData(
          openText: '主题开',
        ),
      ));
      expect(find.text('实例开'), findsOneWidget);
      expect(find.text('主题开'), findsNothing);
    });

    testWidgets('Theme 注入 thumbContentOnFont', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: true, variant: TSwitchVariant.text),
        switchTheme: const TSwitchThemeData(
          thumbContentOnFont: TextStyle(fontSize: 16),
        ),
      ));
      expect(find.text('开'), findsOneWidget);
    });

    testWidgets('Theme 注入 thumbContentOffFont', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false, variant: TSwitchVariant.text),
        switchTheme: const TSwitchThemeData(
          thumbContentOffFont: TextStyle(fontSize: 12),
        ),
      ));
      expect(find.text('关'), findsOneWidget);
    });
  });

  // ============================================================
  // thumbContentOffColor 实例颜色
  // ============================================================
  group('TSwitch 实例颜色', () {
    testWidgets('thumbContentOffColor 自定义（text 形态）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: false,
          variant: TSwitchVariant.text,
          thumbContentOffColor: Colors.green,
        ),
      ));
      expect(find.text('关'), findsOneWidget);
    });

    testWidgets('thumbContentOnFont 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.text,
          thumbContentOnFont: TextStyle(fontSize: 18),
        ),
      ));
      expect(find.text('开'), findsOneWidget);
    });

    testWidgets('thumbContentOffFont 自定义', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: false,
          variant: TSwitchVariant.text,
          thumbContentOffFont: TextStyle(fontSize: 10),
        ),
      ));
      expect(find.text('关'), findsOneWidget);
    });

    testWidgets('loading 形态 value=false 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(value: false, variant: TSwitchVariant.loading),
      ));
      expect(find.byType(TSwitch), findsOneWidget);
      // loading 时应禁用
      expect(
        find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring),
        findsOneWidget,
      );
    });

    testWidgets('icon 形态 + large size', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          variant: TSwitchVariant.icon,
          size: TSwitchSize.large,
        ),
      ));
      expect(find.byIcon(TIcons.check), findsOneWidget);
    });

    testWidgets('icon 形态 + small size + value=false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: false,
          variant: TSwitchVariant.icon,
          size: TSwitchSize.small,
        ),
      ));
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('enabled=false + loading variant 时禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwitch(
          value: true,
          enabled: false,
          variant: TSwitchVariant.loading,
        ),
      ));
      // loading 本身就会禁用
      expect(
        find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring),
        findsOneWidget,
      );
    });
  });

  // ============================================================
  // 受控切换回调
  // ============================================================
  group('TSwitch 受控切换', () {
    testWidgets('value=true 点击切换到 false 触发回调', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSwitch(
          value: true,
          onChanged: (v) => changedValue = v,
        ),
      ));
      await tester.tap(find.byType(TSwitch));
      await tester.pump();
      expect(changedValue, false);
    });

    testWidgets('size=large + onChanged 切换', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrapWithTheme(
        TSwitch(
          value: false,
          size: TSwitchSize.large,
          onChanged: (v) => changed = v,
        ),
      ));
      await tester.tap(find.byType(TSwitch));
      await tester.pump();
      expect(changed, true);
    });

    testWidgets('size=small + onChanged 切换', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrapWithTheme(
        TSwitch(
          value: false,
          size: TSwitchSize.small,
          onChanged: (v) => changed = v,
        ),
      ));
      await tester.tap(find.byType(TSwitch));
      await tester.pump();
      expect(changed, true);
    });
  });
}
