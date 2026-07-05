import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/switch/t_switch_theme_data.dart';

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
      home: Scaffold(body: Center(child: child)),
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
      bool changed = false;
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
      bool changed = false;
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
}
