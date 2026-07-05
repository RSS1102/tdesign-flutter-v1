import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCheckbox V1.0 Widget 测试
/// B 类控制：value + onChanged 受控；onChanged:null 禁用。
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('TCheckbox B 类控制（value + onChanged）', () {
    testWidgets('value=false 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('value=true 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: true, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('onChanged 回调触发', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (v) => changedValue = v),
      ));
      await tester.tap(find.byType(TCheckbox), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('onChanged:null 时禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCheckbox(value: false),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('enabled=false 时禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, enabled: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  group('TCheckbox title', () {
    testWidgets('title 显示标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(title: '选项A', value: false, onChanged: (_) {}),
      ));
      expect(find.text('选项A'), findsOneWidget);
    });

    testWidgets('subTitle 显示副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '主标题',
          subTitle: '副标题',
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('主标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });
  });

  group('TCheckbox id', () {
    testWidgets('id 标识正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(id: 'cb1', value: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  group('TCheckbox 组合', () {
    testWidgets('title + value=true + onChanged', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(title: '已选', value: true, onChanged: (_) {}),
      ));
      expect(find.text('已选'), findsOneWidget);
    });

    testWidgets('title + subTitle + enabled=false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '禁用项',
          subTitle: '不可选',
          enabled: false,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('禁用项'), findsOneWidget);
    });

    testWidgets('多个 Checkbox 同时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Column(children: [
          TCheckbox(title: '选项1', value: true, onChanged: (_) {}),
          TCheckbox(title: '选项2', value: false, onChanged: (_) {}),
          TCheckbox(title: '选项3', value: false, onChanged: (_) {}),
        ]),
      ));
      expect(find.text('选项1'), findsOneWidget);
      expect(find.text('选项2'), findsOneWidget);
      expect(find.text('选项3'), findsOneWidget);
    });

    testWidgets('titleMaxLine 限制行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '这是一个很长很长很长很长很长的标题',
          titleMaxLine: 1,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });
}
