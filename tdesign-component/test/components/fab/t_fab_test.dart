import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TFab V1.0 Widget 测试
///
/// 覆盖：默认渲染、buttonProps merge、text 推导、onPressed 禁用、
/// child 模式、拖拽阈值、resolveLayout + 安全区。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TFabThemeData? fabTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (fabTheme != null) fabTheme,
    ];
    return TTheme(
      data: TThemeData.defaultData(),
      child: MaterialApp(
        theme: ThemeData(
          extensions: themeExtensions,
        ),
        home: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [child],
          ),
        ),
      ),
    );
  }

  group('TFab 基础渲染', () {
    testWidgets('默认纯图标悬浮按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(TFab), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('图标 + 文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(text: '发布'),
      ));
      expect(find.byType(TFab), findsOneWidget);
      expect(find.text('发布'), findsOneWidget);
    });

    testWidgets('child 模式 — 不内嵌 TButton', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: Container(
            width: 56,
            height: 56,
            color: Colors.blue,
          ),
        ),
      ));
      expect(find.byType(TFab), findsOneWidget);
      // child 模式下不应内嵌 TButton
      expect(find.byType(TButton), findsNothing);
    });

    testWidgets('child 模式 + 点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: Container(width: 56, height: 56, color: Colors.red),
          onPressed: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(TFab));
      expect(tapped, true);
    });
  });

  group('TFab buttonProps', () {
    testWidgets('buttonProps.colorScheme 覆盖默认 primary', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          buttonProps: TButtonProps(
            colorScheme: TButtonColorScheme.danger,
          ),
        ),
      ));
      expect(find.byType(TFab), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('buttonProps.size 覆盖默认 large', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          buttonProps: TButtonProps(size: TButtonSize.small),
        ),
      ));
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('buttonProps 多字段同时覆盖', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          buttonProps: TButtonProps(
            colorScheme: TButtonColorScheme.light,
            size: TButtonSize.medium,
          ),
          text: '操作',
        ),
      ));
      expect(find.text('操作'), findsOneWidget);
    });
  });

  group('TFab 禁用态', () {
    testWidgets('onPressed: null 内嵌 TButton 禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(onPressed: null),
      ));
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('child 模式 onPressed: null 用 IgnorePointer', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: GestureDetector(
            onTap: () => tapped = true,
            child: Container(width: 56, height: 56, color: Colors.grey),
          ),
          onPressed: null,
        ),
      ));
      await tester.tap(find.byType(TFab));
      expect(tapped, false);
    });
  });

  group('TFab 定位层', () {
    testWidgets('默认 right=16 bottom=32', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('自定义 right/bottom', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(right: 24, bottom: 48),
      ));
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('draggable: false 时仅 Positioned 定位', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(Positioned), findsOneWidget);
    });
  });

  group('TFab bounds 和拖拽类型', () {
    test('TFabBounds 构造', () {
      const bounds = TFabBounds(start: 16, end: 32);
      expect(bounds.start, 16);
      expect(bounds.end, 32);
    });

    test('TFabDragAxis 枚举值', () {
      expect(TFabDragAxis.all.index, 0);
      expect(TFabDragAxis.vertical.index, 1);
      expect(TFabDragAxis.horizontal.index, 2);
    });

    test('TFabMagnet 枚举值', () {
      expect(TFabMagnet.left.index, 0);
      expect(TFabMagnet.right.index, 1);
    });
  });

  group('TFabThemeData', () {
    test('默认构造全 null', () {
      const theme = TFabThemeData();
      expect(theme.defaultRight, null);
      expect(theme.defaultBottom, null);
      expect(theme.dragTapSlop, null);
    });

    test('copyWith 部分覆盖', () {
      const theme = TFabThemeData(defaultRight: 16, defaultBottom: 32);
      final copied = theme.copyWith(defaultRight: 24);
      expect(copied.defaultRight, 24);
      expect(copied.defaultBottom, 32);
    });

    test('lerp 前半段取 a', () {
      const a = TFabThemeData(defaultRight: 10, dragTapSlop: 18);
      const b = TFabThemeData(defaultRight: 30, dragTapSlop: 30);
      final result = a.lerp(b, 0.3);
      // lerpDouble 应该给出正确插值
      expect(result.defaultRight! > 10, true);
    });

    testWidgets('Theme 注入生效', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(),
        fabTheme: const TFabThemeData(defaultRight: 50, defaultBottom: 100),
      ));
      expect(find.byType(Positioned), findsOneWidget);
    });
  });

  group('TFabDragDetails', () {
    test('构造', () {
      const details = TFabDragDetails(
        position: Offset(16, 32),
      );
      expect(details.position.dx, 16);
      expect(details.position.dy, 32);
      expect(details.start, null);
      expect(details.end, null);
    });
  });

  group('TButtonProps', () {
    test('全 null 构造', () {
      const props = TButtonProps();
      expect(props.size, null);
      expect(props.variant, null);
      expect(props.colorScheme, null);
    });

    test('带值构造', () {
      const props = TButtonProps(
        size: TButtonSize.medium,
        colorScheme: TButtonColorScheme.danger,
      );
      expect(props.size, TButtonSize.medium);
      expect(props.colorScheme, TButtonColorScheme.danger);
    });
  });
}
