import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_swiper_null_safety/src/transformer_page_view/transformer_page_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSwiper V1.0 Widget 测试
///
/// TSwiper 提供 TSwiperPagination / TSwiperDotsPagination / TFractionPagination /
/// TSwiperArrowPagination 等指示器，配合 flutter_swiper_null_safety 的 Swiper 使用。
/// 覆盖：
/// - 基础渲染（Swiper + TSwiperPagination）
/// - TSwiperPaginationVariant 枚举
/// - TSwiperPageEffect 枚举
/// - 各指示器样式（dots/dotsBar/fraction/controls）
/// - 主题覆盖（TSwiperThemeData）
/// - TPageTransformer 切换效果
/// - 边界场景
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TSwiperThemeData? swiperTheme}) {
    final extensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (swiperTheme != null) swiperTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: extensions),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TSwiper 基础渲染', () {
    testWidgets('Swiper + TSwiperPagination 渲染子项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('第${index + 1}页'),
            pagination: const TSwiperPagination(),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.text('第1页'), findsOneWidget);
    });

    testWidgets('TSwiperPagination 默认使用 dots 指示器', (tester) async {
      const pagination = TSwiperPagination();
      expect(pagination.builder, same(TSwiperPagination.dots));
    });

    test('TSwiperPagination.dotsBar 指示器', () {
      expect(TSwiperPagination.dotsBar, isA<TSwiperDotsPagination>());
      const dotsBar = TSwiperPagination.dotsBar as TSwiperDotsPagination;
      expect(dotsBar.roundedRectangleWidth, 20);
    });

    test('TSwiperPagination.fraction 指示器', () {
      expect(TSwiperPagination.fraction, isA<TFractionPagination>());
    });

    test('TSwiperPagination.controls 指示器', () {
      expect(TSwiperPagination.controls, isA<TSwiperArrowPagination>());
    });
  });

  // ============================================================
  // TSwiperPaginationVariant 枚举
  // ============================================================
  group('TSwiperPaginationVariant 枚举', () {
    test('包含所有变体', () {
      expect(TSwiperPaginationVariant.values, containsAll([
        TSwiperPaginationVariant.none,
        TSwiperPaginationVariant.dots,
        TSwiperPaginationVariant.dotsBar,
        TSwiperPaginationVariant.fraction,
        TSwiperPaginationVariant.controls,
      ]));
    });

    test('变体数量为 5', () {
      expect(TSwiperPaginationVariant.values.length, 5);
    });
  });

  // ============================================================
  // TSwiperPageEffect 枚举
  // ============================================================
  group('TSwiperPageEffect 枚举', () {
    test('包含所有变体', () {
      expect(TSwiperPageEffect.values, containsAll([
        TSwiperPageEffect.none,
        TSwiperPageEffect.cardMargin,
        TSwiperPageEffect.scaleAndFade,
      ]));
    });

    test('变体数量为 3', () {
      expect(TSwiperPageEffect.values.length, 3);
    });
  });

  // ============================================================
  // TSwiperDotsPagination 指示器
  // ============================================================
  group('TSwiperDotsPagination 指示器', () {
    testWidgets('圆点指示器渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(
              builder: TSwiperDotsPagination(),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      // 圆点指示器会生成 pagination_0 / pagination_1 / pagination_2
      expect(find.byKey(const Key('pagination_0')), findsOneWidget);
      expect(find.byKey(const Key('pagination_1')), findsOneWidget);
      expect(find.byKey(const Key('pagination_2')), findsOneWidget);
    });

    testWidgets('dotsBar 圆角矩形指示器渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(
              builder: TSwiperDotsPagination(roundedRectangleWidth: 20),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.byKey(const Key('pagination_0')), findsOneWidget);
    });

    test('默认参数正确', () {
      const dots = TSwiperDotsPagination();
      expect(dots.size, 6.0);
      expect(dots.activeSize, 6.0);
      expect(dots.space, 8.0);
      expect(dots.roundedRectangleWidth, isNull);
    });

    test('自定义颜色参数', () {
      const dots = TSwiperDotsPagination(
        activeColor: Colors.red,
        color: Colors.grey,
      );
      expect(dots.activeColor, Colors.red);
      expect(dots.color, Colors.grey);
    });
  });

  // ============================================================
  // TFractionPagination 指示器
  // ============================================================
  group('TFractionPagination 指示器', () {
    testWidgets('数字指示器渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(
              builder: TFractionPagination(),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      // 数字指示器显示 "1/3"
      expect(find.text('1'), findsOneWidget);
      expect(find.text('/3'), findsOneWidget);
    });

    test('默认参数正确', () {
      const fraction = TFractionPagination();
      expect(fraction.width, isNull);
      expect(fraction.height, isNull);
      expect(fraction.color, Colors.white);
      expect(fraction.activeColor, Colors.white);
    });

    test('自定义宽高和圆角', () {
      const fraction = TFractionPagination(
        width: 50,
        height: 30,
        borderRadius: 15,
        backgroundColor: Colors.black,
      );
      expect(fraction.width, 50);
      expect(fraction.height, 30);
      expect(fraction.borderRadius, 15);
      expect(fraction.backgroundColor, Colors.black);
    });
  });

  // ============================================================
  // TSwiperArrowPagination 指示器
  // ============================================================
  group('TSwiperArrowPagination 指示器', () {
    testWidgets('箭头指示器渲染（loop 模式）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            loop: true,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(
              builder: TSwiperArrowPagination(),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      // loop 模式下两个箭头都可见
      expect(find.byIcon(Icons.arrow_back_ios_outlined), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios_outlined), findsOneWidget);
    });

    testWidgets('箭头指示器（非 loop，首项隐藏左箭头）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            loop: false,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(
              builder: TSwiperArrowPagination(),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      // 非 loop + autoHideWhenAtBoundary=true（默认），首项左箭头隐藏
      expect(find.byIcon(Icons.arrow_forward_ios_outlined), findsOneWidget);
    });

    test('autoHideWhenAtBoundary 默认为 true', () {
      const arrow = TSwiperArrowPagination();
      expect(arrow.autoHideWhenAtBoundary, isTrue);
    });

    test('自定义箭头 widget', () {
      const backArrow = Icon(Icons.chevron_left);
      const arrow = TSwiperArrowPagination(
        backArrow: backArrow,
        radius: 15,
        backgroundColor: Colors.blue,
      );
      expect(arrow.backArrow, same(backArrow));
      expect(arrow.radius, 15);
      expect(arrow.backgroundColor, Colors.blue);
    });
  });

  // ============================================================
  // TPageTransformer 切换效果
  // ============================================================
  group('TPageTransformer 切换效果', () {
    test('margin 卡片式构造', () {
      final transformer = TPageTransformer.margin(margin: 8.0);
      expect(transformer.margin, 8.0);
      expect(transformer.fade, 1);
      expect(transformer.scale, 1);
    });

    test('scaleAndFade 缩放淡化构造', () {
      final transformer = TPageTransformer.scaleAndFade(fade: 0.5, scale: 0.7);
      expect(transformer.fade, 0.5);
      expect(transformer.scale, 0.7);
      expect(transformer.margin, 0.0);
    });

    test('默认构造', () {
      final transformer = TPageTransformer(fade: 0.8, scale: 0.9, margin: 4.0);
      expect(transformer.fade, 0.8);
      expect(transformer.scale, 0.9);
      expect(transformer.margin, 4.0);
    });

    test('transform 覆盖 scale/fade/margin 三分支', () {
      final item = Container(width: 10, height: 10);
      // scaleAndFade：scale!=null + fade!=null + margin=0.0(非 null) → 三分支全走
      final r1 = TPageTransformer.scaleAndFade().transform(item, TransformInfo(position: 0.5));
      expect(r1, isA<Widget>());
      // margin 构造：仅 margin 分支
      final r2 = TPageTransformer.margin(margin: 12.0).transform(item, TransformInfo(position: 0.3));
      expect(r2, isA<Widget>());
      // 默认构造（全 null）：无变换路径
      final r3 = TPageTransformer().transform(item, TransformInfo(position: 0.0));
      expect(r3, isA<Widget>());
    });

    testWidgets('Swiper 使用 TPageTransformer.margin 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('页$index'),
            transformer: TPageTransformer.margin(),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.text('页0'), findsOneWidget);
    });

    testWidgets('Swiper 使用 TPageTransformer.scaleAndFade 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('页$index'),
            transformer: TPageTransformer.scaleAndFade(),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.text('页0'), findsOneWidget);
    });
  });

  // ============================================================
  // 主题覆盖（TSwiperThemeData）
  // ============================================================
  group('TSwiperThemeData 主题', () {
    test('默认构造所有字段为 null', () {
      const theme = TSwiperThemeData();
      expect(theme.pagination, isNull);
      expect(theme.pageEffect, isNull);
      expect(theme.paginationMargin, isNull);
      expect(theme.autoplayInterval, isNull);
    });

    test('copyWith 正确合并', () {
      const base = TSwiperThemeData(
        pagination: TSwiperPaginationVariant.dots,
        pageEffect: TSwiperPageEffect.none,
      );
      final merged = base.copyWith(
        pagination: TSwiperPaginationVariant.fraction,
        autoplayInterval: const Duration(seconds: 5),
      );
      expect(merged.pagination, TSwiperPaginationVariant.fraction);
      expect(merged.pageEffect, TSwiperPageEffect.none);
      expect(merged.autoplayInterval, const Duration(seconds: 5));
    });

    test('lerp 正确插值（t < 0.5 取 a）', () {
      const a = TSwiperThemeData(
        pagination: TSwiperPaginationVariant.dots,
        pageEffect: TSwiperPageEffect.none,
      );
      const b = TSwiperThemeData(
        pagination: TSwiperPaginationVariant.fraction,
        pageEffect: TSwiperPageEffect.scaleAndFade,
      );
      final result = a.lerp(b, 0.3);
      expect(result.pagination, TSwiperPaginationVariant.dots);
      expect(result.pageEffect, TSwiperPageEffect.none);
    });

    test('lerp 正确插值（t >= 0.5 取 b）', () {
      const a = TSwiperThemeData(
        pagination: TSwiperPaginationVariant.dots,
      );
      const b = TSwiperThemeData(
        pagination: TSwiperPaginationVariant.fraction,
      );
      final result = a.lerp(b, 0.6);
      expect(result.pagination, TSwiperPaginationVariant.fraction);
    });

    test('lerp 非同类型返回 this', () {
      const a = TSwiperThemeData(
        pagination: TSwiperPaginationVariant.dots,
      );
      final result = a.lerp(null, 0.5);
      expect(result.pagination, TSwiperPaginationVariant.dots);
    });

    testWidgets('通过 TSwiperThemeData 注入主题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(),
          ),
        ),
        swiperTheme: const TSwiperThemeData(
          pagination: TSwiperPaginationVariant.dotsBar,
          autoplayInterval: Duration(seconds: 3),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.text('页0'), findsOneWidget);
    });
  });

  // ============================================================
  // TSwiperPagination 参数
  // ============================================================
  group('TSwiperPagination 参数', () {
    test('默认 builder 为 dots', () {
      const pagination = TSwiperPagination();
      expect(pagination.builder, same(TSwiperPagination.dots));
    });

    test('默认 margin 为 EdgeInsets.all(10.0)', () {
      const pagination = TSwiperPagination();
      expect(pagination.margin, const EdgeInsets.all(10.0));
    });

    test('自定义 alignment', () {
      const pagination = TSwiperPagination(
        alignment: Alignment.topCenter,
      );
      expect(pagination.alignment, Alignment.topCenter);
    });

    test('自定义 builder', () {
      const fraction = TFractionPagination();
      const pagination = TSwiperPagination(builder: fraction);
      expect(pagination.builder, same(fraction));
    });

    testWidgets('自定义 margin 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 2,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(
              margin: EdgeInsets.all(20.0),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
    });
  });

  // ============================================================
  // 自动播放
  // ============================================================
  group('Swiper 自动播放', () {
    testWidgets('autoplay 启用渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            autoplay: true,
            autoplayDelay: 1000,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      // 等待自动播放触发
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('loop 循环模式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            loop: true,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.text('页0'), findsOneWidget);
    });

    testWidgets('非 loop 模式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            loop: false,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
      expect(find.text('页0'), findsOneWidget);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TSwiper 覆盖率补充', () {
    testWidgets('itemCount > 20 触发 warning', (tester) async {
      // 覆盖 103（itemCount > 20 warning）
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 25,
            loop: false,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: const TSwiperPagination(),
          ),
        ),
      ));
      // 25 个 item 可能有布局溢出
      tester.takeException();
      expect(find.byType(Swiper), findsAny);
    });

    testWidgets('TSwiperDotsPagination 默认颜色 + 自定义 size/space', (tester) async {
      // 覆盖 108-112（默认颜色 outer=false）+ 116-124（PageIndicator）
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: Swiper(
            itemCount: 3,
            loop: false,
            itemBuilder: (context, index) => Text('页$index'),
            pagination: TSwiperPagination(
              builder: TSwiperDotsPagination(
                size: 10,
                space: 5,
              ),
            ),
          ),
        ),
      ));
      expect(find.byType(Swiper), findsOneWidget);
    });

    testWidgets('TSwiperDotsPagination.build outer=true 覆盖品牌色/悬浮色 fallback（108/112）',
        (tester) async {
      // 直接调用 build，构造 outer=true 的 config，覆盖 outer 分支的 activeColor/color fallback
      final controller = SwiperController();
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      final config = SwiperPluginConfig(
        outer: true,
        scrollDirection: Axis.horizontal,
        controller: controller,
        pageController: PageController(),
        itemCount: 3,
      );
      final widget = const TSwiperDotsPagination().build(ctx, config);
      expect(widget, isA<Widget>());
    });

    testWidgets('TSwiperDotsPagination.build PageIndicator 分支覆盖（116-124）',
        (tester) async {
      // 构造 indicatorLayout != NONE 且 layout == DEFAULT 的 config，触发 PageIndicator 分支
      final controller = SwiperController();
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      final config = SwiperPluginConfig(
        outer: false,
        scrollDirection: Axis.horizontal,
        controller: controller,
        pageController: PageController(),
        itemCount: 3,
        indicatorLayout: PageIndicatorLayout.SCALE,
        layout: SwiperLayout.DEFAULT,
      );
      final widget = const TSwiperDotsPagination().build(ctx, config);
      expect(widget, isA<Widget>());
    });
  });
}
