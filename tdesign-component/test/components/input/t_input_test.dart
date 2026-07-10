import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TInput V1.0 Widget 测试
///
/// D 类控制：`controller` 主路径；`readOnly: true` = 禁用输入。
/// 覆盖 layout 六种、size 两档、hintText、onChanged、清除按钮。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // D 类控制：controller 主路径 + readOnly 禁用
  // ============================================================
  group('TInput D 类控制（controller + readOnly）', () {
    testWidgets('controller 预设文本正常显示', (tester) async {
      final controller = TextEditingController(text: '初始文本');
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller),
      ));
      expect(find.text('初始文本'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('输入文本时 controller.text 更新', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller),
      ));

      await tester.enterText(find.byType(TInput), 'hello');
      await tester.pump();
      expect(controller.text, 'hello');
      controller.dispose();
    });

    testWidgets('readOnly=true 时无法输入', (tester) async {
      final controller = TextEditingController(text: '只读');
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller, readOnly: true),
      ));

      // readOnly 时 TextField.readOnly = true
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
      controller.dispose();
    });

    testWidgets('onChanged 回调触发', (tester) async {
      String? changedText;
      final controller = TextEditingController();
      await tester.pumpWidget(wrapWithTheme(
        TInput(
          controller: controller,
          onChanged: (text) => changedText = text,
        ),
      ));

      await tester.enterText(find.byType(TInput), 'abc');
      await tester.pump();
      expect(changedText, 'abc');
      controller.dispose();
    });

    testWidgets('readOnly=true 时 onChanged 仍可设置但无输入', (tester) async {
      final controller = TextEditingController(text: '固定');
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller, readOnly: true),
      ));
      // readOnly 状态下 TextField 仍渲染
      expect(find.byType(TextField), findsOneWidget);
      controller.dispose();
    });
  });

  // ============================================================
  // layout 六种布局
  // ============================================================
  group('TInput layout 布局形态', () {
    testWidgets('normal（默认）正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(hintText: '提示'),
      ));
      expect(find.byType(TInput), findsOneWidget);
      expect(find.text('提示'), findsOneWidget);
    });

    testWidgets('twoLine 两行布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(layout: TInputLayout.twoLine, hintText: '两行'),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('special 特殊布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(layout: TInputLayout.special, hintText: '特殊'),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('longText 长文本布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(layout: TInputLayout.longText, hintText: '长文本'),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('normalMaxTwoLine 布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(layout: TInputLayout.normalMaxTwoLine, hintText: '最多两行'),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('cardStyle 卡片布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(
          layout: TInputLayout.cardStyle,
          cardStyleTopText: '卡片标题',
          hintText: '卡片输入',
        ),
      ));
      expect(find.text('卡片标题'), findsOneWidget);
    });
  });

  // ============================================================
  // size 两档
  // ============================================================
  group('TInput size 尺寸', () {
    testWidgets('large（默认）正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(size: TInputSize.large, hintText: '大'),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('small 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(size: TInputSize.small, hintText: '小'),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });
  });

  // ============================================================
  // 内容属性
  // ============================================================
  group('TInput 内容属性', () {
    testWidgets('label 显示左侧标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(label: '标签', hintText: '请输入'),
      ));
      expect(find.text('标签'), findsOneWidget);
    });

    testWidgets('prefix 显示左侧图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(prefix: Icon(Icons.search), hintText: '搜索'),
      ));
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('suffix 显示右侧组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(suffix: Icon(Icons.clear), hintText: '后缀'),
      ));
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('required=true 正常渲染必填标志', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(
          label: '必填字段',
          required: true,
          hintText: '请输入',
          leftInfoWidth: 80,
        ),
      ));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('additionInfo 显示错误提示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TInput(additionInfo: '错误信息'),
      ));
      expect(find.text('错误信息'), findsOneWidget);
    });
  });

  // ============================================================
  // 清除按钮
  // ============================================================
  group('TInput 清除按钮', () {
    testWidgets('controller 有文本时显示清除按钮', (tester) async {
      final controller = TextEditingController(text: '有内容');
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller),
      ));
      expect(find.byIcon(TIcons.close_circle_filled), findsOneWidget);
      controller.dispose();
    });

    testWidgets('点击清除按钮清空文本', (tester) async {
      final controller = TextEditingController(text: '待清除');
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller),
      ));

      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();
      expect(controller.text, '');
      controller.dispose();
    });

    testWidgets('showClearButton=false 时不显示清除按钮', (tester) async {
      final controller = TextEditingController(text: '内容');
      await tester.pumpWidget(wrapWithTheme(
        TInput(controller: controller, showClearButton: false),
      ));
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
      controller.dispose();
    });
  });
}
