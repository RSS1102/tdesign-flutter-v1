import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TPopover 组件 Widget 测试
///
/// 覆盖 TPopoverColorScheme、TPopoverPlacement、内容渲染、箭头、回调等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TPopoverThemeData? popoverTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (popoverTheme != null) popoverTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 枚举验证
  // ============================================================
  group('枚举', () {
    test('TPopoverColorScheme 有六个值', () {
      expect(TPopoverColorScheme.values.length, 6);
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.dark));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.light));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.info));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.success));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.warning));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.error));
    });

    test('TPopoverPlacement 有十二个值', () {
      expect(TPopoverPlacement.values.length, 12);
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.top));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottom));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.left));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.right));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.topLeft));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.topRight));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottomLeft));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottomRight));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.leftTop));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.leftBottom));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.rightTop));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.rightBottom));
    });
  });

  // ============================================================
  // TPopoverWidget 基础渲染
  // ============================================================
  group('TPopoverWidget 基础渲染', () {
    testWidgets('渲染文本内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '气泡内容',
            ),
          );
        }),
      ));
      await tester.pump();

      expect(find.byType(TPopoverWidget), findsOneWidget);
      expect(find.text('气泡内容'), findsOneWidget);
    });

    testWidgets('contentWidget 自定义内容渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              contentWidget: const Text('自定义Widget'),
              width: 100,
              height: 50,
            ),
          );
        }),
      ));
      await tester.pump();

      expect(find.text('自定义Widget'), findsOneWidget);
    });

    testWidgets('contentWidget 未指定 width/height 抛出断言', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              contentWidget: const Text('无尺寸'),
            ),
          );
        }),
      ));

      // 应抛出 FlutterError
      expect(tester.takeException(), isA<FlutterError>());
    });
  });

  // ============================================================
  // colorScheme 颜色方案
  // ============================================================
  group('TPopoverWidget colorScheme', () {
    for (final scheme in TPopoverColorScheme.values) {
      testWidgets('colorScheme: $scheme 渲染正常', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          Builder(builder: (context) {
            return Center(
              child: TPopoverWidget(
                context: context,
                content: '${scheme.name}气泡',
                colorScheme: scheme,
              ),
            );
          }),
        ));
        await tester.pump();

        expect(find.text('${scheme.name}气泡'), findsOneWidget);
      });
    }
  });

  // ============================================================
  // placement 定位方向
  // ============================================================
  group('TPopoverWidget placement', () {
    for (final placement in TPopoverPlacement.values) {
      testWidgets('placement: $placement 渲染正常', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          Builder(builder: (context) {
            return Center(
              child: TPopoverWidget(
                context: context,
                content: '${placement.name}定位',
                placement: placement,
              ),
            );
          }),
        ));
        await tester.pump();

        expect(find.text('${placement.name}定位'), findsOneWidget);
      });
    }
  });

  // ============================================================
  // showArrow 箭头
  // ============================================================
  group('TPopoverWidget 箭头', () {
    testWidgets('showArrow: true 渲染箭头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '有箭头',
              placement: TPopoverPlacement.bottom,
              showArrow: true,
            ),
          );
        }),
      ));
      await tester.pump();

      // 箭头使用 Container + BoxDecoration(border:)
      expect(find.text('有箭头'), findsOneWidget);
    });

    testWidgets('showArrow: false 不渲染箭头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '无箭头',
              showArrow: false,
            ),
          );
        }),
      ));
      await tester.pump();

      expect(find.text('无箭头'), findsOneWidget);
    });

    testWidgets('自定义 arrowSize', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '大箭头',
              arrowSize: 16,
              placement: TPopoverPlacement.top,
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('大箭头'), findsOneWidget);
    });
  });

  // ============================================================
  // padding / width / height / radius
  // ============================================================
  group('TPopoverWidget 尺寸', () {
    testWidgets('自定义 padding 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '内边距',
              padding: const EdgeInsets.all(20),
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('内边距'), findsOneWidget);
    });

    testWidgets('自定义 width 和 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '固定尺寸',
              width: 200,
              height: 80,
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('固定尺寸'), findsOneWidget);
    });

    testWidgets('自定义 radius 圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '圆角',
              radius: BorderRadius.circular(20),
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('圆角'), findsOneWidget);
    });
  });

  // ============================================================
  // showPopover 静态方法
  // ============================================================
  group('TPopover.showPopover', () {
    testWidgets('showPopover 弹出气泡', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '弹出气泡',
        placement: TPopoverPlacement.bottom,
      ));
      await tester.pumpAndSettle();

      expect(find.text('弹出气泡'), findsOneWidget);
    });

    testWidgets('showPopover 带 colorScheme', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '成功气泡',
        colorScheme: TPopoverColorScheme.success,
      ));
      await tester.pumpAndSettle();

      expect(find.text('成功气泡'), findsOneWidget);
    });

    testWidgets('closeOnClickOutside: true 点击外部关闭', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '可关闭',
        closeOnClickOutside: true,
      ));
      await tester.pumpAndSettle();

      expect(find.text('可关闭'), findsOneWidget);

      // 点击外部关闭
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('可关闭'), findsNothing);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TPopover 主题覆盖', () {
    testWidgets('TPopoverThemeData 注入后正常渲染', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
        popoverTheme: const TPopoverThemeData(
          colorScheme: TPopoverColorScheme.dark,
          backgroundColor: Colors.black,
          borderRadius: 8,
          arrowSize: 10,
          minWidth: 50,
          maxHeight: 200,
        ),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '主题气泡',
      ));
      await tester.pumpAndSettle();

      expect(find.text('主题气泡'), findsOneWidget);
    });

    test('TPopoverThemeData merge 合并', () {
      const base = TPopoverThemeData(
        backgroundColor: Colors.white,
        borderRadius: 4,
      );
      const override = TPopoverThemeData(borderRadius: 8);
      final merged = base.merge(override);
      expect(merged.backgroundColor, Colors.white);
      expect(merged.borderRadius, 8);
    });

    test('TPopoverThemeData copyWith', () {
      const original = TPopoverThemeData(backgroundColor: Colors.white);
      final copied = original.copyWith(backgroundColor: Colors.grey);
      expect(copied.backgroundColor, Colors.grey);
    });
  });
}
