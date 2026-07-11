import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TInputResolve 样式解析器单元测试
///
/// 覆盖全部静态 resolve* 方法的三段优先级（构造器 > Theme > Token 默认）、
/// 布局/尺寸分支、卡片装饰分支，以及 Chinese2Formatter。
void main() {
  late BuildContext ctx;

  Widget harness() {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Builder(builder: (context) {
        ctx = context;
        return const Placeholder();
      }),
    );
  }

  setUp(() async {
    // ctx 在 pump 后由 Builder 赋值
  });

  Future<void> prepare(WidgetTester tester) async {
    await tester.pumpWidget(harness());
  }

  group('resolveTextStyle 三段优先级', () {
    testWidgets('instanceStyle 优先', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveTextStyle(
        context: ctx,
        instanceStyle: const TextStyle(color: Colors.red),
      );
      expect(style.color, Colors.red);
    });

    testWidgets('theme.textStyle 次之', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveTextStyle(
        context: ctx,
        theme: TInputThemeData(textStyle: const TextStyle(color: Colors.green)),
      );
      expect(style.color, Colors.green);
    });

    testWidgets('均无则用 Token 默认', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveTextStyle(context: ctx);
      expect(style.color, ctx.tTheme.textColorPrimary);
    });
  });

  group('resolveHintTextStyle 三段优先级', () {
    testWidgets('instanceStyle 优先', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveHintTextStyle(
        context: ctx,
        instanceStyle: const TextStyle(color: Colors.red),
      );
      expect(style.color, Colors.red);
    });

    testWidgets('theme.hintTextStyle 次之', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveHintTextStyle(
        context: ctx,
        theme:
            TInputThemeData(hintTextStyle: const TextStyle(color: Colors.green)),
      );
      expect(style.color, Colors.green);
    });

    testWidgets('均无则用 Token 默认', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveHintTextStyle(context: ctx);
      expect(style.color, ctx.tTheme.textColorPlaceholder);
    });
  });

  group('resolveLabelStyle 三段优先级', () {
    testWidgets('instanceStyle 优先', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveLabelStyle(
        context: ctx,
        instanceStyle: const TextStyle(color: Colors.red),
      );
      expect(style.color, Colors.red);
    });

    testWidgets('theme.labelStyle 次之', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveLabelStyle(
        context: ctx,
        theme: TInputThemeData(labelStyle: const TextStyle(color: Colors.green)),
      );
      expect(style.color, Colors.green);
    });

    testWidgets('均无则用 Token 默认', (tester) async {
      await prepare(tester);
      final style = TInputResolve.resolveLabelStyle(context: ctx);
      expect(style.letterSpacing, 0);
    });
  });

  group('resolveBackgroundColor 三段优先级', () {
    testWidgets('instanceColor 优先', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveBackgroundColor(
          context: ctx,
          instanceColor: Colors.red,
        ),
        Colors.red,
      );
    });

    testWidgets('theme.backgroundColor 次之', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveBackgroundColor(
          context: ctx,
          theme: TInputThemeData(backgroundColor: Colors.green),
        ),
        Colors.green,
      );
    });

    testWidgets('均无则返回 null', (tester) async {
      await prepare(tester);
      expect(TInputResolve.resolveBackgroundColor(context: ctx), isNull);
    });
  });

  group('resolveTextInputBackgroundColor 两段优先级', () {
    testWidgets('instanceColor 优先', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveTextInputBackgroundColor(
          theme: TInputThemeData(),
          instanceColor: Colors.red,
        ),
        Colors.red,
      );
    });

    testWidgets('theme.textInputBackgroundColor 次之', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveTextInputBackgroundColor(
          theme: TInputThemeData(textInputBackgroundColor: Colors.green),
        ),
        Colors.green,
      );
    });

    testWidgets('均无则返回 null', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveTextInputBackgroundColor(theme: TInputThemeData()),
        isNull,
      );
    });
  });

  group('颜色类 resolve（cursor/clear/addition）', () {
    testWidgets('resolveCursorColor 三段', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveCursorColor(context: ctx, instanceColor: Colors.red),
        Colors.red,
      );
      expect(
        TInputResolve.resolveCursorColor(
          context: ctx,
          theme: TInputThemeData(cursorColor: Colors.green),
        ),
        Colors.green,
      );
      expect(
        TInputResolve.resolveCursorColor(context: ctx),
        ctx.tTheme.brandNormalColor,
      );
    });

    testWidgets('resolveClearBtnColor 三段', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveClearBtnColor(context: ctx, instanceColor: Colors.red),
        Colors.red,
      );
      expect(
        TInputResolve.resolveClearBtnColor(
          context: ctx,
          theme: TInputThemeData(clearBtnColor: Colors.green),
        ),
        Colors.green,
      );
      expect(
        TInputResolve.resolveClearBtnColor(context: ctx),
        ctx.tTheme.textColorPlaceholder,
      );
    });

    testWidgets('resolveAdditionInfoColor 三段', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveAdditionInfoColor(
            context: ctx, instanceColor: Colors.red),
        Colors.red,
      );
      expect(
        TInputResolve.resolveAdditionInfoColor(
          context: ctx,
          theme: TInputThemeData(additionInfoColor: Colors.green),
        ),
        Colors.green,
      );
      expect(
        TInputResolve.resolveAdditionInfoColor(context: ctx),
        ctx.tTheme.textColorPlaceholder,
      );
    });
  });

  group('resolveContentPadding 布局分支', () {
    const spacer = TInputSpacer.defaultSpacer;

    testWidgets('instancePadding 优先', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.normal,
        size: TInputSize.large,
        instancePadding: const EdgeInsets.all(3),
      );
      expect(p, const EdgeInsets.all(3));
    });

    testWidgets('theme.contentPadding 次之', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.normal,
        size: TInputSize.large,
        theme: TInputThemeData(contentPadding: const EdgeInsets.all(7)),
      );
      expect(p, const EdgeInsets.all(7));
    });

    testWidgets('normal 默认（无 additionInfo）', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.normal,
        size: TInputSize.large,
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('normal 默认（有 additionInfo 用 padding）', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.normal,
        size: TInputSize.large,
        additionInfo: '提示',
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('normalMaxTwoLine 分支', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.normalMaxTwoLine,
        size: TInputSize.small,
        additionInfo: '提示',
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('twoLine 分支', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.twoLine,
        size: TInputSize.small,
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('special 分支', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.special,
        size: TInputSize.small,
        spacer: spacer,
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('longText 分支', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.longText,
        size: TInputSize.small,
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('cardStyle 分支（无 additionInfo）', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.cardStyle,
        size: TInputSize.small,
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });

    testWidgets('cardStyle 分支（有 additionInfo）', (tester) async {
      await prepare(tester);
      final p = TInputResolve.resolveContentPadding(
        context: ctx,
        layout: TInputLayout.cardStyle,
        size: TInputSize.large,
        additionInfo: '提示',
      );
      expect(p, isA<EdgeInsetsGeometry>());
    });
  });

  group('resolveCardStyleDecoration 分支', () {
    testWidgets('instanceDecoration 为 BoxDecoration 直接返回', (tester) async {
      await prepare(tester);
      final deco = BoxDecoration(color: Colors.red);
      expect(
        TInputResolve.resolveCardStyleDecoration(
          context: ctx,
          layout: TInputLayout.cardStyle,
          instanceDecoration: deco,
        ),
        deco,
      );
    });

    testWidgets('非 cardStyle 返回 null', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveCardStyleDecoration(
          context: ctx,
          layout: TInputLayout.normal,
        ),
        isNull,
      );
    });

    testWidgets('cardStyle 但无 cardStyle 返回 null', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveCardStyleDecoration(
          context: ctx,
          layout: TInputLayout.cardStyle,
        ),
        isNull,
      );
    });

    testWidgets('cardStyle + topText', (tester) async {
      await prepare(tester);
      final r = TInputResolve.resolveCardStyleDecoration(
        context: ctx,
        layout: TInputLayout.cardStyle,
        cardStyle: TInputCardStyle.topText,
      );
      expect(r, isA<BoxDecoration>());
    });

    testWidgets('cardStyle + topTextWithBlueBorder', (tester) async {
      await prepare(tester);
      final r = TInputResolve.resolveCardStyleDecoration(
        context: ctx,
        layout: TInputLayout.cardStyle,
        cardStyle: TInputCardStyle.topTextWithBlueBorder,
      );
      expect(r, isA<BoxDecoration>());
    });

    testWidgets('cardStyle + errorStyle', (tester) async {
      await prepare(tester);
      final r = TInputResolve.resolveCardStyleDecoration(
        context: ctx,
        layout: TInputLayout.cardStyle,
        cardStyle: TInputCardStyle.errorStyle,
      );
      expect(r, isA<BoxDecoration>());
    });
  });

  group('resolveSpacer / getInputPadding', () {
    testWidgets('resolveSpacer 三段', (tester) async {
      await prepare(tester);
      expect(
        TInputResolve.resolveSpacer(instanceSpacer: TInputSpacer.defaultSpacer),
        TInputSpacer.defaultSpacer,
      );
      expect(
        TInputResolve.resolveSpacer(
          theme: TInputThemeData(spacer: TInputSpacer.defaultSpacer),
        ),
        TInputSpacer.defaultSpacer,
      );
      expect(TInputResolve.resolveSpacer(), TInputSpacer.defaultSpacer);
    });

    testWidgets('getInputPadding small/large', (tester) async {
      await prepare(tester);
      expect(TInputResolve.getInputPadding(TInputSize.small), 12);
      expect(TInputResolve.getInputPadding(TInputSize.large), 16);
    });
  });

  group('Chinese2Formatter', () {
    test('空字符串直接返回', () {
      final f = Chinese2Formatter(10);
      final v = TextEditingValue.empty;
      expect(f.formatEditUpdate(v, v), v);
    });

    test('英文在长度内保留', () {
      final f = Chinese2Formatter(10);
      final oldV = TextEditingValue.empty;
      final newV = const TextEditingValue(text: 'abc');
      expect(f.formatEditUpdate(oldV, newV).text, 'abc');
    });

    test('中文按 2 计数并截断', () {
      final f = Chinese2Formatter(3);
      final oldV = TextEditingValue.empty;
      final newV = const TextEditingValue(text: '中文文'); // 3 个中文 = 6 > 3
      final r = f.formatEditUpdate(oldV, newV);
      // 超出后截断到 maxLength 之内
      expect(r.text.length, lessThanOrEqualTo(2));
    });

    test('超限英文被截断', () {
      final f = Chinese2Formatter(3);
      final oldV = TextEditingValue.empty;
      final newV = const TextEditingValue(text: 'abcdef');
      final r = f.formatEditUpdate(oldV, newV);
      expect(r.text.length, lessThanOrEqualTo(3));
    });

    test('非法字符被拒绝（回退 oldValue）', () {
      final f = Chinese2Formatter(10);
      final oldV = const TextEditingValue(text: 'ok');
      final newV = const TextEditingValue(text: 'ok@#');
      final r = f.formatEditUpdate(oldV, newV);
      // 不匹配正则则回退
      expect(r.text, oldV.text);
    });
  });
}
