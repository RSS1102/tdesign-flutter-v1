import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TStepperThemeData? stepperTheme}) {
    final extensions = <ThemeExtension<dynamic>>[TThemeData.defaultData()];
    if (stepperTheme != null) {
      extensions.add(stepperTheme);
    }
    return MaterialApp(
      theme: ThemeData(extensions: extensions),
      home: Scaffold(body: Center(child: child)),
    );
  }

  TextField textField(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  Finder inputContainerFinder() => find
      .ancestor(
        of: find.byType(TextField),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration != null,
        ),
      )
      .first;

  Container inputContainer(WidgetTester tester) => tester.widget<Container>(
        inputContainerFinder(),
      );

  BoxDecoration iconButtonDecoration(WidgetTester tester, String key) => tester
      .widget<DecoratedBox>(
        find.descendant(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(DecoratedBox),
        ),
      )
      .decoration as BoxDecoration;

  group('TStepper v1 controlled behavior', () {
    testWidgets('renders controlled value and icons', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 5, onChanged: (_) {})));

      expect(find.byType(TStepper), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(textField(tester).controller?.text, '5');
      expect(tester.getSize(find.byKey(const ValueKey('stepper-decrease'))),
          const Size(32, 32));
      expect(tester.getSize(inputContainerFinder()), const Size(48, 32));
    });

    testWidgets('add increments by step', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        step: 2,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, 7);
      expect(textField(tester).controller?.text, '7');
    });

    testWidgets('remove decrements by step', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        step: 2,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(changed, 3);
      expect(textField(tester).controller?.text, '3');
    });

    testWidgets('buttons clamp at min and max without duplicate callback',
        (tester) async {
      var calls = 0;
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 10,
        min: 0,
        max: 10,
        step: 5,
        onChanged: (value) {
          calls += 1;
          changed = value;
        },
      )));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(calls, 0);
      expect(changed, isNull);

      await tester.pumpWidget(wrap(TStepper(
        value: 2,
        min: 0,
        max: 10,
        step: 5,
        onChanged: (value) {
          calls += 1;
          changed = value;
        },
      )));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(calls, 1);
      expect(changed, 0);
      expect(textField(tester).controller?.text, '0');
    });

    testWidgets('onChanged null disables buttons and input', (tester) async {
      await tester.pumpWidget(wrap(const TStepper(value: 5)));

      expect(textField(tester).enabled, isFalse);
      final addButton = tester.widget<GestureDetector>(
          find.byKey(const ValueKey('stepper-increase')));
      final removeButton = tester.widget<GestureDetector>(
          find.byKey(const ValueKey('stepper-decrease')));
      expect(addButton.onTap, isNull);
      expect(removeButton.onTap, isNull);
    });

    testWidgets('limit state only disables reached-side action',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(
        TStepper(value: 0, min: 0, max: 10, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(variant: TStepperVariant.filled),
      ));

      expect(
        iconButtonDecoration(tester, 'stepper-decrease').color,
        token.bgColorSecondaryContainer,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.remove)).color,
        token.textDisabledColor,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.add)).color,
        token.textColorPrimary,
      );

      await tester.pumpWidget(wrap(
        TStepper(value: 10, min: 0, max: 10, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(variant: TStepperVariant.filled),
      ));
      expect(
        tester.widget<Icon>(find.byIcon(Icons.remove)).color,
        token.textColorPrimary,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.add)).color,
        token.textDisabledColor,
      );
    });

    testWidgets('submitted input parses and clamps', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        min: 0,
        max: 10,
        onChanged: (value) => changed = value,
      )));

      await tester.enterText(find.byType(TextField), '8');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(changed, 8);

      await tester.enterText(find.byType(TextField), '99');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(changed, 10);
      expect(textField(tester).controller?.text, '10');
    });

    testWidgets('invalid input restores current value', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        onChanged: (value) => changed = value,
      )));

      await tester.enterText(find.byType(TextField), '-');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changed, isNull);
      expect(textField(tester).controller?.text, '5');
    });

    testWidgets('decimal values are supported and formatted', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 1.5,
        step: 0.25,
        min: 0,
        max: 2,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(changed, 1.75);
      expect(textField(tester).controller?.text, '1.75');

      await tester.pumpWidget(wrap(TStepper(
        value: 2.0,
        onChanged: (_) {},
      )));
      expect(textField(tester).controller?.text, '2');
    });

    testWidgets('didUpdateWidget syncs external value changes', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 1, onChanged: (_) {})));
      expect(textField(tester).controller?.text, '1');

      await tester.pumpWidget(wrap(TStepper(value: 9, onChanged: (_) {})));
      expect(textField(tester).controller?.text, '9');
    });
  });

  group('TStepper theme', () {
    testWidgets('filled variant and inputWidth come from theme',
        (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(
          variant: TStepperVariant.filled,
          inputWidth: 88,
        ),
      ));

      final inputBox = tester.getSize(inputContainerFinder());
      expect(inputBox.width, 88);
      expect(inputBox.height, 32);
      expect(textField(tester).decoration?.filled, isFalse);
      final token = TThemeData.defaultData();
      expect(
        (inputContainer(tester).decoration as BoxDecoration).color,
        token.bgColorSecondaryContainer,
      );
    });

    testWidgets('filled disabled uses disabled background for whole control',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(
        const TStepper(value: 1),
        stepperTheme: const TStepperThemeData(variant: TStepperVariant.filled),
      ));

      expect(
        (inputContainer(tester).decoration as BoxDecoration).color,
        token.bgColorComponentDisabled,
      );
      expect(
        iconButtonDecoration(tester, 'stepper-decrease').color,
        token.bgColorComponentDisabled,
      );
      expect(
        iconButtonDecoration(tester, 'stepper-increase').color,
        token.bgColorComponentDisabled,
      );
    });

    testWidgets('normal variant keeps transparent input and segment borders',
        (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(variant: TStepperVariant.normal),
      ));

      expect(textField(tester).decoration?.filled, isFalse);
      final inputDecoration =
          inputContainer(tester).decoration as BoxDecoration;
      expect(inputDecoration.border, isA<Border>());
      expect(
        iconButtonDecoration(tester, 'stepper-decrease').border,
        isA<Border>(),
      );
      expect(
        iconButtonDecoration(tester, 'stepper-increase').border,
        isA<Border>(),
      );
    });

    test('TStepperThemeData copyWith and lerp', () {
      const base = TStepperThemeData(
        variant: TStepperVariant.normal,
        inputWidth: 60,
      );
      const other = TStepperThemeData(
        variant: TStepperVariant.filled,
        inputWidth: 100,
      );

      expect(base.copyWith(variant: TStepperVariant.filled).variant,
          TStepperVariant.filled);
      expect(base.copyWith(inputWidth: 72).inputWidth, 72);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).variant, TStepperVariant.normal);
      expect(base.lerp(other, 0.75).variant, TStepperVariant.filled);
      expect(base.lerp(other, 0.5).inputWidth, 80);
    });
  });
}
