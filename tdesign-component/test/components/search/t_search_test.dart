import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSearchBar V1.0 Widget 测试
///
/// D 类控制：controller 主路径。
/// 覆盖：构造器、square/round 样式、left/center 对齐、disabled、readOnly、
/// onChanged/onSubmitted 回调、清除按钮、取消按钮、action 按钮、
/// mediumStyle、autoFocus、Theme 覆盖、cursorHeight。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TSearchBar 基础渲染', () {
    testWidgets('TSearchBar 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(hintText: '搜索'),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
      expect(find.text('搜索'), findsOneWidget);
    });

    testWidgets('TSearchBar 带 controller 预设文本', (tester) async {
      final controller = TextEditingController(text: '初始文本');
      await tester.pumpWidget(wrapWithTheme(
        TSearchBar(controller: controller),
      ));
      expect(find.text('初始文本'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('TSearchBar 带 hintText 提示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(hintText: '请输入关键词'),
      ));
      expect(find.text('请输入关键词'), findsOneWidget);
    });
  });

  // ============================================================
  // style 枚举变体
  // ============================================================
  group('TSearchBar style 枚举变体', () {
    testWidgets('style=square（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          style: TSearchBarVariant.square,
          hintText: '方形',
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
    });

    testWidgets('style=round 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          style: TSearchBarVariant.round,
          hintText: '圆形',
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
    });
  });

  // ============================================================
  // alignment 枚举变体
  // ============================================================
  group('TSearchBar alignment 枚举变体', () {
    testWidgets('alignment=left（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          alignment: TSearchBarAlignment.left,
          hintText: '左对齐',
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
    });

    testWidgets('alignment=center 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          alignment: TSearchBarAlignment.center,
          hintText: '居中',
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
    });
  });

  // ============================================================
  // disabled / readOnly
  // ============================================================
  group('TSearchBar 禁用与只读', () {
    testWidgets('enabled=false 时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '禁用',
          enabled: false,
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('readOnly=true 时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '只读',
          readOnly: true,
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });
  });

  // ============================================================
  // Theme 覆盖（TSearchBarThemeData）
  // ============================================================
  group('TSearchBar Theme 覆盖', () {
    testWidgets('TSearchBarThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            const TSearchBarThemeData(
              defaultStyle: TSearchBarVariant.round,
              defaultAlignment: TSearchBarAlignment.center,
              backgroundColor: Color(0xFFFF0000),
              cursorHeight: 20,
            ),
          ]),
          home: const Scaffold(
            body: Center(
              child: TSearchBar(hintText: '主题覆盖'),
            ),
          ),
        ),
      );
      expect(find.byType(TSearchBar), findsOneWidget);
      expect(find.text('主题覆盖'), findsOneWidget);
    });
  });

  // ============================================================
  // onChanged 回调
  // ============================================================
  group('TSearchBar onChanged 回调', () {
    testWidgets('输入文本时触发 onChanged', (tester) async {
      String? changedText;
      await tester.pumpWidget(wrapWithTheme(
        TSearchBar(
          hintText: '搜索',
          onChanged: (text) => changedText = text,
        ),
      ));

      await tester.enterText(find.byType(TSearchBar), 'hello');
      await tester.pump();
      expect(changedText, 'hello');
    });
  });

  // ============================================================
  // 清除按钮
  // ============================================================
  group('TSearchBar 清除按钮', () {
    testWidgets('输入文本后显示清除按钮', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(wrapWithTheme(
        TSearchBar(controller: controller),
      ));
      // 输入文本触发 controller listener，更新 clearBtnHide
      await tester.enterText(find.byType(TSearchBar), '有内容');
      await tester.pump();
      expect(find.byIcon(TIcons.close_circle_filled), findsOneWidget);
      controller.dispose();
    });

    testWidgets('点击清除按钮清空文本并触发 onChanged', (tester) async {
      final controller = TextEditingController();
      String? changedText;
      await tester.pumpWidget(wrapWithTheme(
        TSearchBar(
          controller: controller,
          onChanged: (text) => changedText = text,
        ),
      ));
      // 先输入文本让清除按钮出现
      await tester.enterText(find.byType(TSearchBar), '待清除');
      await tester.pump();

      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();
      expect(controller.text, '');
      expect(changedText, '');
      controller.dispose();
    });

    testWidgets('无文本时不显示清除按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(hintText: '空'),
      ));
      await tester.pump();
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
    });
  });

  // ============================================================
  // 取消按钮
  // ============================================================
  group('TSearchBar 取消按钮', () {
    testWidgets('needCancel=true 聚焦后显示取消按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '搜索',
          needCancel: true,
          autoFocus: true,
        ),
      ));
      await tester.pumpAndSettle();
      // autoFocus 后取消按钮应可见
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('needCancel=false（默认）不显示取消按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(hintText: '搜索'),
      ));
      await tester.pump();
      expect(find.text('取消'), findsNothing);
    });
  });

  // ============================================================
  // action 按钮
  // ============================================================
  group('TSearchBar action 按钮', () {
    testWidgets('action 非空时显示操作文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '搜索',
          action: '搜索',
        ),
      ));
      // action 文字会渲染两次（actionBtn 中 Text + 可能的重复）
      expect(find.text('搜索'), findsAtLeast(1));
    });

    testWidgets('点击 action 触发 onActionClick', (tester) async {
      String? actionText;
      await tester.pumpWidget(wrapWithTheme(
        TSearchBar(
          hintText: '搜索',
          action: '搜索',
          onActionClick: (text) => actionText = text,
        ),
      ));
      // 找到 action 对应的 Text 并点击
      final actionFinder = find.text('搜索').last;
      await tester.tap(actionFinder, warnIfMissed: false);
      await tester.pump();
      // onActionClick 应被调用
      expect(actionText, isNotNull);
    });
  });

  // ============================================================
  // mediumStyle / autoFocus / cursorHeight
  // ============================================================
  group('TSearchBar 其他属性', () {
    testWidgets('mediumStyle=true 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '中型',
          mediumStyle: true,
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
    });

    testWidgets('autoFocus=true 时 TextField 自动聚焦', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '自动聚焦',
          autoFocus: true,
        ),
      ));
      await tester.pump();
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('cursorHeight 设置光标高度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSearchBar(
          hintText: '光标',
          cursorHeight: 24,
        ),
      ));
      expect(find.byType(TSearchBar), findsOneWidget);
    });
  });

  // ============================================================
  // onClearClick 回调
  // ============================================================
  group('TSearchBar onClearClick 回调', () {
    testWidgets('onClearClick 返回 true 时不执行默认清除', (tester) async {
      final controller = TextEditingController();
      var clearClicked = false;
      await tester.pumpWidget(wrapWithTheme(
        TSearchBar(
          controller: controller,
          onClearClick: (value) {
            clearClicked = true;
            return true; // 返回 true 表示外部处理，不执行默认清除
          },
        ),
      ));
      // 先输入文本让清除按钮出现
      await tester.enterText(find.byType(TSearchBar), '内容');
      await tester.pump();

      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();
      expect(clearClicked, isTrue);
      // 返回 true 时默认清除不执行，文本仍保留
      expect(controller.text, '内容');
      controller.dispose();
    });
  });
}
