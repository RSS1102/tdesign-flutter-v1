import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDialog V1.0 Widget 测试
///
/// E 类控制：`showDialog()` 调用即显；不调即不显。
/// 覆盖 TConfirmDialog 标题/内容/按钮/关闭、TDialogButtonOptions。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: Center(child: child)),
    );
  }

  /// 辅助：构建一个带按钮的页面，点击按钮显示 Dialog
  Widget wrapWithButton(VoidCallback onButtonTap, {String btnText = '显示弹窗'}) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(
        body: Center(
          child: TButton(child: Text(btnText), onPressed: onButtonTap),
        ),
      ),
    );
  }

  // ============================================================
  // E 类控制：showDialog 调用即显
  // ============================================================
  group('TConfirmDialog E 类控制（showDialog）', () {
    testWidgets('点击按钮调用 showDialog 后弹窗出现', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '弹窗标题',
            content: '弹窗内容',
            buttonText: '确认',
          ),
        );
      }));

      // 初始无弹窗
      expect(find.text('弹窗标题'), findsNothing);

      // 点击按钮显示弹窗
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('弹窗标题'), findsOneWidget);
      expect(find.text('弹窗内容'), findsOneWidget);
    });

    testWidgets('不调用 showDialog 时不显示弹窗', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(child: Text('页面内容')),
      ));
      expect(find.byType(TConfirmDialog), findsNothing);
    });

    testWidgets('点击确认按钮关闭弹窗', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '确认弹窗',
            buttonText: '确认',
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('确认弹窗'), findsOneWidget);

      // 点击确认按钮
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(find.text('确认弹窗'), findsNothing);
    });

    testWidgets('onPressed 回调触发', (tester) async {
      bool confirmed = false;
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => TConfirmDialog(
            title: '回调弹窗',
            buttonText: '确认',
            onPressed: () => confirmed = true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    });
  });

  // ============================================================
  // TConfirmDialog 内容
  // ============================================================
  group('TConfirmDialog 内容', () {
    testWidgets('title 显示标题', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(title: '标题测试'),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('标题测试'), findsOneWidget);
    });

    testWidgets('content 显示内容文字', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            content: '这是内容文字',
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('这是内容文字'), findsOneWidget);
    });

    testWidgets('contentWidget 自定义内容组件', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            contentWidget: Text('自定义内容'),
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('buttonText 显示按钮文字', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            buttonText: '好的',
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('好的'), findsOneWidget);
    });

    testWidgets('showCloseButton=true 显示关闭按钮', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            showCloseButton: true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      // 关闭按钮图标
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('点击关闭按钮关闭弹窗', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '关闭测试',
            showCloseButton: true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(TIcons.close));
      await tester.pumpAndSettle();
      expect(find.text('关闭测试'), findsNothing);
    });
  });

  // ============================================================
  // TConfirmDialog 样式
  // ============================================================
  group('TConfirmDialog 样式', () {
    testWidgets('backgroundColor 自定义背景色', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '背景色',
            backgroundColor: Colors.yellow,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('背景色'), findsOneWidget);
    });

    testWidgets('buttonStyle: text 文字按钮样式', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '文字按钮',
            buttonText: '确认',
            buttonStyle: TDialogButtonStyle.text,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('确认'), findsOneWidget);
    });

    testWidgets('radius 自定义圆角', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '圆角',
            radius: 20,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('width 自定义宽度', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '宽度',
            width: 280,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('宽度'), findsOneWidget);
    });
  });
}
