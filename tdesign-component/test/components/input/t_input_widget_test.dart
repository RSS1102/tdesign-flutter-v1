import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TInput widget 级用例', () {
    testWidgets('普通布局可构建', (tester) async {
      await tester.pumpWidget(wrap(const TInput(
        label: '姓名',
        hintText: '请输入',
        onChanged: null,
      )));
      expect(find.byType(TInput), findsOneWidget);
    });

    testWidgets('双行/长文本/卡片布局可构建', (tester) async {
      await tester.pumpWidget(wrap(const Column(
        children: [
          TInput(layout: TInputLayout.twoLine, label: '双行', hintText: 'h'),
          TInput(layout: TInputLayout.longText, label: '长文本', hintText: 'h'),
          TInput(
            layout: TInputLayout.cardStyle,
            cardStyleTopText: '顶部',
            cardStyleBottomText: '底部',
            hintText: 'h',
          ),
        ],
      )));
      expect(find.byType(TInput, skipOffstage: false), findsNWidgets(3));
    });

    testWidgets('前后缀/清除/必填/错误提示可构建', (tester) async {
      final controller = TextEditingController(text: 'abc');
      addTearDown(controller.dispose);
      await tester.pumpWidget(wrap(TInput(
        controller: controller,
        prefix: const Icon(Icons.person),
        suffix: const Icon(Icons.check),
        required: true,
        additionInfo: '错误信息',
        showClearButton: true,
        onClearTap: () {},
      )));
      expect(find.byType(TInput), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('obscureText / readOnly 可构建', (tester) async {
      await tester.pumpWidget(wrap(const Column(
        children: [
          TInput(obscureText: true, hintText: '密码'),
          TInput(readOnly: true, hintText: '只读'),
        ],
      )));
      expect(find.byType(TInput, skipOffstage: false), findsNWidgets(2));
    });

    testWidgets('sizes / rightBtn / onBtnTap 可构建', (tester) async {
      await tester.pumpWidget(wrap(const TInput(
        size: TInputSize.small,
        rightBtn: Text('发送'),
        onBtnTap: null,
        hintText: '验证码',
      )));
      expect(find.text('发送'), findsOneWidget);
    });
  });
}
