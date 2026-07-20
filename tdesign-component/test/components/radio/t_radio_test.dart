import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  const options = [
    TRadioOption(value: 'a', label: '选项 A'),
    TRadioOption(value: 'b', label: '选项 B', subTitle: '说明 B'),
    TRadioOption(value: 'c', label: '选项 C', disabled: true),
  ];

  group('TRadio v1 单项行为', () {
    testWidgets('按 groupValue 渲染选中态并触发 onChanged', (tester) async {
      String? changed;
      await tester.pumpWidget(wrap(TRadio<String>(
        value: 'a',
        groupValue: 'b',
        title: '选项 A',
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 A'));
      await tester.pump();

      expect(changed, 'a');
    });

    testWidgets('onChanged 为 null 时禁用', (tester) async {
      await tester.pumpWidget(wrap(const TRadio<String>(
        value: 'a',
        groupValue: 'a',
        title: '选项 A',
      )));

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('自定义 iconBuilder 生效', (tester) async {
      await tester.pumpWidget(wrap(TRadio<String>(
        value: 'a',
        groupValue: 'a',
        onChanged: (_) {},
        customIconBuilder: (context, selected, disabled) {
          return Text('$selected $disabled');
        },
      )));

      expect(find.text('true false'), findsOneWidget);
    });

    testWidgets('large + contentDirection.left + divider + subTitle 可构建',
        (tester) async {
      await tester.pumpWidget(wrap(TRadio<String>(
        value: 'a',
        groupValue: 'b',
        title: '大尺寸',
        subTitle: '副标题',
        size: TRadioSize.large,
        contentDirection: TContentDirection.left,
        showDivider: true,
        onChanged: (_) {},
      )));

      expect(find.text('大尺寸'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
      expect(find.byType(TDivider), findsOneWidget);
    });
  });

  group('TRadioGroup v1 受控行为', () {
    testWidgets('点击 option 触发互斥选中回调', (tester) async {
      String? changed;
      await tester.pumpWidget(wrap(TRadioGroup<String>(
        value: 'a',
        options: options,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 B'));
      await tester.pump();

      expect(changed, 'b');
      expect(find.text('说明 B'), findsOneWidget);
    });

    testWidgets('onChanged 为 null 时整组禁用', (tester) async {
      await tester.pumpWidget(wrap(const TRadioGroup<String>(
        value: 'a',
        options: options,
      )));

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('禁用 option 不触发回调', (tester) async {
      String? changed;
      await tester.pumpWidget(wrap(TRadioGroup<String>(
        value: 'a',
        options: options,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.text('选项 C'));
      await tester.pump();

      expect(changed, isNull);
    });
  });

  group('TRadioGroup v1 布局与自定义项', () {
    testWidgets('横向多列布局可构建', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 240,
        child: TRadioGroup<String>(
          value: 'a',
          options: options,
          direction: Axis.horizontal,
          columns: 2,
        ),
      )));

      expect(find.byType(TRadioGroup<String>), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('cardMode 使用卡片组布局', (tester) async {
      await tester.pumpWidget(wrap(const TRadioGroup<String>(
        value: 'a',
        options: options,
        cardMode: true,
      )));

      expect(find.text('选项 A'), findsOneWidget);
      expect(find.text('选项 B'), findsOneWidget);
    });

    testWidgets('itemBuilder 由 Group 接管点击和语义', (tester) async {
      String? changed;
      await tester.pumpWidget(wrap(TRadioGroup<String>(
        value: 'a',
        options: options,
        onChanged: (value) => changed = value,
        itemBuilder: (context, option, selected, disabled) {
          return Text('${option.label} $selected $disabled');
        },
      )));

      await tester.tap(find.text('选项 B false false'));
      await tester.pump();

      expect(changed, 'b');
    });

    test('columns 必须大于 0', () {
      expect(
        () => TRadioGroup<String>(
          value: null,
          options: options,
          columns: 0,
        ),
        throwsAssertionError,
      );
    });
  });

  group('TRadioThemeData', () {
    test('copyWith 覆盖字段', () {
      const theme = TRadioThemeData(
        selectColor: Colors.red,
        spacing: 4,
      );
      final copied = theme.copyWith(
        disableColor: Colors.grey,
        titleColor: Colors.green,
        subTitleColor: Colors.yellow,
        backgroundColor: Colors.black,
        spacing: 8,
        insetSpacing: 12,
      );

      expect(copied.selectColor, Colors.red);
      expect(copied.disableColor, Colors.grey);
      expect(copied.titleColor, Colors.green);
      expect(copied.subTitleColor, Colors.yellow);
      expect(copied.backgroundColor, Colors.black);
      expect(copied.spacing, 8);
      expect(copied.insetSpacing, 12);
    });

    test('lerp 支持非同类型和中间值', () {
      const a = TRadioThemeData(
        selectColor: Colors.red,
        spacing: 4,
      );
      const b = TRadioThemeData(
        selectColor: Colors.blue,
        spacing: 8,
      );

      expect(a.lerp(null, 0.5), same(a));
      final mid = a.lerp(b, 0.5);
      expect(mid.selectColor, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(mid.spacing, 6);
    });

    testWidgets('Theme 注入可渲染', (tester) async {
      await tester.pumpWidget(wrap(
        TRadio<String>(
          value: 'a',
          groupValue: 'a',
          title: '主题',
          onChanged: (_) {},
        ),
      ));

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [
          TThemeData.defaultData(),
          const TRadioThemeData(
            selectColor: Colors.red,
            titleColor: Colors.green,
          ),
        ]),
        home: Scaffold(
          body: TRadio<String>(
            value: 'a',
            groupValue: 'a',
            title: '主题',
            onChanged: (_) {},
          ),
        ),
      ));

      expect(find.text('主题'), findsOneWidget);
    });
  });
}
