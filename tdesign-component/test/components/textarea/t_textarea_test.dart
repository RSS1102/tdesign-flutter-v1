import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTextarea V1.0 Widget 测试
///
/// D 类控制：`controller` 主路径；`readOnly: true` = 禁用输入。
/// 覆盖 layout、maxLength + indicator、onChanged、bordered。
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
  group('TTextarea D 类控制（controller + readOnly）', () {
    testWidgets('controller 预设文本正常显示', (tester) async {
      final controller = TextEditingController(text: '初始内容');
      await tester.pumpWidget(wrapWithTheme(
        TTextarea(controller: controller),
      ));
      expect(find.text('初始内容'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('输入文本时 controller.text 更新', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(wrapWithTheme(
        TTextarea(controller: controller),
      ));

      await tester.enterText(find.byType(TTextarea), 'multiline');
      await tester.pump();
      expect(controller.text, 'multiline');
      controller.dispose();
    });

    testWidgets('readOnly=true 时 TextField 为只读', (tester) async {
      final controller = TextEditingController(text: '只读');
      await tester.pumpWidget(wrapWithTheme(
        TTextarea(controller: controller, readOnly: true),
      ));
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
      controller.dispose();
    });

    testWidgets('onChanged 回调触发', (tester) async {
      String? changedText;
      final controller = TextEditingController();
      await tester.pumpWidget(wrapWithTheme(
        TTextarea(
          controller: controller,
          onChanged: (text) => changedText = text,
        ),
      ));

      await tester.enterText(find.byType(TTextarea), 'changed');
      await tester.pump();
      expect(changedText, 'changed');
      controller.dispose();
    });
  });

  // ============================================================
  // layout 布局
  // ============================================================
  group('TTextarea layout 布局', () {
    testWidgets('horizontal（默认）正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(layout: TTextareaLayout.horizontal, hintText: '水平'),
      ));
      expect(find.byType(TTextarea), findsOneWidget);
    });

    testWidgets('vertical 垂直布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(layout: TTextareaLayout.vertical, hintText: '垂直'),
      ));
      expect(find.byType(TTextarea), findsOneWidget);
    });

    testWidgets('label + horizontal 布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(label: '描述', layout: TTextareaLayout.horizontal),
      ));
      expect(find.text('描述'), findsOneWidget);
    });

    testWidgets('label + vertical 布局', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(label: '备注', layout: TTextareaLayout.vertical),
      ));
      expect(find.text('备注'), findsOneWidget);
    });
  });

  // ============================================================
  // maxLength + indicator 计数器
  // ============================================================
  group('TTextarea 计数器', () {
    testWidgets('indicator=true + maxLength 显示计数器', (tester) async {
      final controller = TextEditingController(text: 'ab');
      await tester.pumpWidget(wrapWithTheme(
        TTextarea(
          controller: controller,
          maxLength: 500,
          indicator: true,
        ),
      ));
      expect(find.text('2/500'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('indicator=false 不显示计数器', (tester) async {
      final controller = TextEditingController(text: 'abc');
      await tester.pumpWidget(wrapWithTheme(
        TTextarea(
          controller: controller,
          maxLength: 500,
          indicator: false,
        ),
      ));
      expect(find.textContaining('/500'), findsNothing);
      controller.dispose();
    });

    testWidgets('无 maxLength 时不显示计数器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(indicator: true),
      ));
      expect(find.textContaining('/'), findsNothing);
    });
  });

  // ============================================================
  // bordered 边框
  // ============================================================
  group('TTextarea 边框', () {
    testWidgets('bordered=true 显示边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(bordered: true, hintText: '有边框'),
      ));
      expect(find.byType(TTextarea), findsOneWidget);
    });

    testWidgets('bordered=false 无边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(bordered: false, hintText: '无边框'),
      ));
      expect(find.byType(TTextarea), findsOneWidget);
    });

    testWidgets('showBottomDivider=true 显示底部分割线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(showBottomDivider: true, hintText: '分割线'),
      ));
      expect(find.byType(TTextarea), findsOneWidget);
    });
  });

  // ============================================================
  // 内容属性
  // ============================================================
  group('TTextarea 内容属性', () {
    testWidgets('hintText 显示提示文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(hintText: '请输入描述'),
      ));
      expect(find.text('请输入描述'), findsOneWidget);
    });

    testWidgets('required=true 正常渲染必填标志', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(
          label: '必填字段',
          required: true,
          labelWidth: 100,
          hintText: '请输入',
        ),
      ));
      expect(find.byType(TTextarea), findsOneWidget);
    });

    testWidgets('additionInfo 显示错误提示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(additionInfo: '不能为空'),
      ));
      expect(find.text('不能为空'), findsOneWidget);
    });

    testWidgets('labelIcon 显示标签图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTextarea(label: '标签', labelIcon: Icon(Icons.info)),
      ));
      expect(find.byIcon(Icons.info), findsOneWidget);
    });
  });
}
