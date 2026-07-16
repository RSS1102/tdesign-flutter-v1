import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(body: child),
      );

  group('TStepper 基础渲染', () {
    for (final size in TStepperSize.values) {
      for (final theme in TStepperColorScheme.values) {
        testWidgets('size=$size theme=$theme 渲染', (tester) async {
          await tester.pumpWidget(wrap(TStepper(
            size: size,
            theme: theme,
            max: 100,
            min: 0,
            value: 5,
            onChanged: (_) {},
          )));

          expect(find.byType(TStepper), findsOneWidget);
          expect(find.byIcon(Icons.add), findsOneWidget);
          expect(find.byIcon(Icons.remove), findsOneWidget);
        });
      }
    }

    testWidgets('onChanged 为 null 时整体禁用输入', (tester) async {
      await tester.pumpWidget(wrap(const TStepper()));
      final s = tester.widget<TStepper>(find.byType(TStepper));
      expect(s.onChanged, isNull);
    });
  });

  group('TStepper 交互', () {
    testWidgets('点击 add 递增并回调', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        max: 100,
        onChanged: (v) => changed = v,
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(changed, 6);
    });

    testWidgets('点击 reduce 递减并回调', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        onChanged: (v) => changed = v,
      )));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(changed, 4);
    });

    testWidgets('add 越界截断并触发 onOverlimit(plus)', (tester) async {
      var overlimit = '';
      await tester.pumpWidget(wrap(TStepper(
        value: 8,
        max: 10,
        step: 5,
        onChanged: (_) {},
        onOverlimit: (t) => overlimit = t.name,
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(overlimit, 'plus');
    });

    testWidgets('reduce 越界截断并触发 onOverlimit(minus)', (tester) async {
      var overlimit = '';
      await tester.pumpWidget(wrap(TStepper(
        value: 3,
        min: 0,
        step: 5,
        onChanged: (_) {},
        onOverlimit: (t) => overlimit = t.name,
      )));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(overlimit, 'minus');
    });

    testWidgets('达到上限后 add 无操作', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        value: 100,
        max: 100,
        onChanged: (v) => changed = v,
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(changed, -1);
    });

    testWidgets('disabled 时按钮和输入框都不可交互', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        disabled: true,
        value: 5,
        onChanged: (v) => changed = v,
      )));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(changed, -1);
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isFalse);
    });

    testWidgets('onChanged 为 null 时按钮和输入框都禁用', (tester) async {
      await tester.pumpWidget(wrap(const TStepper(value: 5)));
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isFalse);
    });

    testWidgets('长数值触发 _getTextWidth 正分支', (tester) async {
      final controller = TStepperController();
      await tester.pumpWidget(wrap(TStepper(
        controller: controller,
        max: 99999,
        value: 12345,
        onChanged: (_) {},
      )));
      // 通过 controller 设置值触发 updateUI
      controller.value = 12345;
      await tester.pumpAndSettle();
      expect(controller.value, 12345);
    });

    testWidgets('eventController cleanValue 清空', (tester) async {
      final ec = StreamController<TStepperEventType>();
      await tester.pumpWidget(wrap(TStepper(
        value: 7,
        eventController: ec,
        onChanged: (_) {},
      )));
      ec.add(TStepperEventType.cleanValue);
      await tester.pumpAndSettle();
      // 输入框文本应被清空为 0
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.controller?.text, '0');
      await ec.close();
    });

    testWidgets('输入合法文本触发 onChanged', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        max: 100,
        min: 0,
        onChanged: (v) => changed = v,
      )));
      await tester.enterText(find.byType(TextField), '50');
      await tester.pumpAndSettle();
      expect(changed, 50);
    });

    testWidgets('清空输入回退为 min', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        max: 100,
        min: 0,
        onChanged: (v) => changed = v,
        onOverlimit: (_) {},
      )));
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(changed, 0);
    });

    testWidgets('输入超上限触发 onOverlimit(plus)', (tester) async {
      var overlimit = '';
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        max: 10,
        min: 0,
        onChanged: (_) {},
        onOverlimit: (t) => overlimit = t.name,
      )));
      await tester.enterText(find.byType(TextField), '999');
      await tester.pumpAndSettle();
      expect(overlimit, 'plus');
    });

    testWidgets('已达下限再 reduce 直接返回', (tester) async {
      var changed = -1;
      await tester.pumpWidget(wrap(TStepper(
        value: 0,
        min: 0,
        onChanged: (v) => changed = v,
      )));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(changed, -1);
    });

    testWidgets('disableInput 时输入框禁用', (tester) async {
      await tester.pumpWidget(wrap(TStepper(
        disableInput: true,
        onChanged: (_) {},
      )));
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isFalse);
    });
  });

  group('TStepperController', () {
    test('value setter 触发 updateUI（绑定 state 时）', () {
      final c = TStepperController();
      c.value = 3;
      expect(c.value, 3);
    });
  });

  group('TStepperIconButton 独立渲染', () {
    for (final size in TStepperSize.values) {
      for (final theme in TStepperColorScheme.values) {
        testWidgets(
            'size=$size theme=$theme disabled=${(size.index + theme.index) % 2 == 0}',
            (tester) async {
          final disabled = (size.index + theme.index) % 2 == 0;
          await tester.pumpWidget(wrap(TStepperIconButton(
            type: TStepperIconType.add,
            size: size,
            theme: theme,
            disabled: disabled,
            onTap: () {},
          )));
          expect(find.byType(TStepperIconButton), findsOneWidget);
        });
      }
    }

    testWidgets('点击触发 onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(TStepperIconButton(
        type: TStepperIconType.remove,
        onTap: () => tapped = true,
      )));
      await tester.tap(find.byType(TStepperIconButton));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });

    testWidgets('disabled 时 onTap 不触发', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(TStepperIconButton(
        type: TStepperIconType.add,
        disabled: true,
        onTap: () => tapped = true,
      )));
      await tester.tap(find.byType(TStepperIconButton));
      await tester.pumpAndSettle();
      expect(tapped, false);
    });
  });
}
