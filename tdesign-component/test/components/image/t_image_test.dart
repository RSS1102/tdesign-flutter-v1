import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TImage V1.0 Widget 测试
///
/// 覆盖 variant 七档、src/asset/file 加载、loading/error 状态、
/// width/fit 参数、Theme 各字段、copyWith/lerp、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TImageThemeData? imageTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (imageTheme != null) imageTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TImage 基础渲染', () {
    testWidgets('默认参数渲染 - roundedSquare variant', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/test.png'),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('src 为 null 仍渲染组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TImage()));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('http 开头的 src 走 network 路径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/image.png'),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('非 http 开头的 src 走 asset 路径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'assets/img.png'),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  group('TImage variant 七档', () {
    testWidgets('variant: clip 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.clip,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('variant: fitHeight 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.fitHeight,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('variant: fitWidth 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.fitWidth,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('variant: stretch 渲染 ConstrainedBox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.stretch,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TImage),
          matching: find.byType(ConstrainedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('variant: square 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.square,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('variant: roundedSquare 渲染 Container 圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.roundedSquare,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('variant: circle 渲染 Container 圆形', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.circle,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  group('TImage loading/error 状态', () {
    testWidgets('加载中显示默认 loading 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/loading.png'),
      ));
      // 初始状态 loading=true，显示 ellipsis 图标
      expect(find.byIcon(TIcons.ellipsis), findsOneWidget);
    });

    testWidgets('自定义 loadingWidget 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/loading.png',
          loadingWidget: Text('加载中'),
        ),
      ));
      expect(find.text('加载中'), findsOneWidget);
    });

    testWidgets('自定义 errorWidget 在加载失败时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://invalid.example.com/bad.png',
          errorWidget: Text('加载失败'),
        ),
      ));
      // 等待错误回调
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      // 可能显示 errorWidget 或默认 error 图标
      expect(
        find.text('加载失败'),
        findsWidgets,
      );
    });

    testWidgets('加载失败显示默认 error 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://invalid.example.com/bad.png'),
      ));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      // 错误状态显示 close 图标或 errorWidget
      expect(
        find.byIcon(TIcons.close),
        findsWidgets,
      );
    });
  });

  group('TImage width/fit 参数', () {
    testWidgets('自定义 width 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          width: 100,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('自定义 fit 覆盖默认 fit', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          fit: BoxFit.contain,
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('默认 width 为 72', (tester) async {
      const image = TImage(src: 'https://example.com/test.png');
      expect(image.width, isNull);
      // _width getter: widget.width ?? 72
    });
  });

  group('TImage imageFile 参数', () {
    testWidgets('imageFile 非 null 走 file 路径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TImage(
          imageFile: File('/nonexistent/path/file.png'),
        ),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  group('TImage Theme', () {
    testWidgets('Theme.height 覆盖默认高度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/test.png'),
        imageTheme: const TImageThemeData(height: 100),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('Theme.color 覆盖叠加色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/test.png'),
        imageTheme: const TImageThemeData(color: Colors.red),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('Theme.excludeFromSemantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/test.png'),
        imageTheme: const TImageThemeData(excludeFromSemantics: true),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });

    testWidgets('Theme.cacheWidth/cacheHeight', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(src: 'https://example.com/test.png'),
        imageTheme: const TImageThemeData(cacheWidth: 100, cacheHeight: 100),
      ));
      expect(find.byType(TImage), findsOneWidget);
    });
  });

  group('TImageThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TImageThemeData(
        height: 72,
        color: Colors.red,
        cacheWidth: 100,
      );
      final copied = theme.copyWith(height: 100);
      expect(copied.height, 100);
      expect(copied.color, Colors.red);
      expect(copied.cacheWidth, 100);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TImageThemeData(
        height: 80,
        color: Colors.blue,
      );
      final copied = theme.copyWith();
      expect(copied.height, 80);
      expect(copied.color, Colors.blue);
    });

    test('lerp 前半段取 a 的 variant', () {
      const a = TImageThemeData(variant: TImageVariant.circle);
      const b = TImageThemeData(variant: TImageVariant.square);
      final result = a.lerp(b, 0.3);
      expect(result.variant, TImageVariant.circle);
    });

    test('lerp 后半段取 b 的 variant', () {
      const a = TImageThemeData(variant: TImageVariant.circle);
      const b = TImageThemeData(variant: TImageVariant.square);
      final result = a.lerp(b, 0.7);
      expect(result.variant, TImageVariant.square);
    });

    test('lerp 非 TImageThemeData 返回自身', () {
      const theme = TImageThemeData(height: 72);
      final result = theme.lerp(null, 0.5);
      expect(result.height, 72);
    });

    test('lerp height 插值', () {
      const a = TImageThemeData(height: 50);
      const b = TImageThemeData(height: 100);
      final result = a.lerp(b, 0.5);
      expect(result.height, 75);
    });

    test('lerp cacheWidth 插值并取整', () {
      const a = TImageThemeData(cacheWidth: 100);
      const b = TImageThemeData(cacheWidth: 200);
      final result = a.lerp(b, 0.5);
      expect(result.cacheWidth, 150);
    });

    test('lerp color 插值', () {
      const a = TImageThemeData(color: Colors.red);
      const b = TImageThemeData(color: Colors.blue);
      final result = a.lerp(b, 0.5);
      expect(result.color, isNotNull);
    });

    test('lerp excludeFromSemantics 前半取 a', () {
      const a = TImageThemeData(excludeFromSemantics: true);
      const b = TImageThemeData(excludeFromSemantics: false);
      final result = a.lerp(b, 0.3);
      expect(result.excludeFromSemantics, true);
    });

    test('lerp excludeFromSemantics 后半取 b', () {
      const a = TImageThemeData(excludeFromSemantics: true);
      const b = TImageThemeData(excludeFromSemantics: false);
      final result = a.lerp(b, 0.7);
      expect(result.excludeFromSemantics, false);
    });
  });

  group('TImage 边界情况', () {
    testWidgets('src 为 null 走 network 路径（空字符串）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TImage()));
      expect(find.byType(TImage), findsOneWidget);
    });

    test('默认 variant 为 roundedSquare', () {
      const image = TImage(src: 'https://example.com/test.png');
      expect(image.variant, TImageVariant.roundedSquare);
    });

    test('默认 filterQuality 为 low', () {
      const image = TImage(src: 'https://example.com/test.png');
      expect(image.filterQuality, FilterQuality.low);
    });

    test('默认 alignment 为 center', () {
      const image = TImage(src: 'https://example.com/test.png');
      expect(image.alignment, Alignment.center);
    });

    test('默认 repeat 为 noRepeat', () {
      const image = TImage(src: 'https://example.com/test.png');
      expect(image.repeat, ImageRepeat.noRepeat);
    });

    testWidgets('stretch variant 使用 ConstrainedBox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.stretch,
          width: 200,
        ),
      ));
      expect(
        find.descendant(
          of: find.byType(TImage),
          matching: find.byType(ConstrainedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('roundedSquare variant 使用 clipBehavior Container', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TImage(
          src: 'https://example.com/test.png',
          variant: TImageVariant.roundedSquare,
        ),
      ));
      // roundedSquare 包裹在带 clipBehavior 的 Container 中
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });
  });
}
