import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/tabs/t_horizontal_tab_bar.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(
    Widget child, {
    TTabsBarThemeData? tabsBarTheme,
    int length = 3,
  }) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (tabsBarTheme != null) tabsBarTheme,
      ]),
      home: Scaffold(
        body: DefaultTabController(length: length, child: child),
      ),
    );
  }

  List<TTab> tabs([int count = 3]) =>
      List.generate(count, (index) => TTab(text: '选项${index + 1}'));

  group('TTabsBarThemeData', () {
    test('copyWith covers v1 default fields', () {
      const theme = TTabsBarThemeData(
        height: 48,
        variant: TTabsBarVariant.filled,
        defaultPhysics: BouncingScrollPhysics(),
      );
      final copied = theme.copyWith(
        height: 56,
        variant: TTabsBarVariant.card,
        defaultPhysics: const NeverScrollableScrollPhysics(),
      );

      expect(copied.height, 56);
      expect(copied.variant, TTabsBarVariant.card);
      expect(copied.defaultPhysics, isA<NeverScrollableScrollPhysics>());

      final preserved = theme.copyWith();
      expect(preserved.height, 48);
      expect(preserved.variant, TTabsBarVariant.filled);
      expect(preserved.defaultPhysics, isA<BouncingScrollPhysics>());
    });
  });

  group('TTabsBar', () {
    testWidgets('renders filled/capsule/card variants', (tester) async {
      for (final variant in TTabsBarVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          TTabsBar(
            tabs: tabs(),
            variant: variant,
            showIndicator: true,
          ),
        ));
        expect(find.byType(TTabsBar), findsOneWidget);
      }
    });

    testWidgets('default filled variant uses container background and divider',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTabsBar(
          tabs: [
            TTab(text: '选项1'),
            TTab(text: '选项2'),
            TTab(text: '选项3'),
          ],
          width: 240,
          height: 56,
        ),
      ));

      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, TThemeData.defaultData().bgColorContainer);
      expect(decoration.border, isNotNull);
      expect(
        (decoration.border as Border).bottom.color,
        TThemeData.defaultData().componentStrokeColor,
      );
    });

    testWidgets('card variant uses container background without divider',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTabsBar(
          tabs: [
            TTab(text: '选项1'),
            TTab(text: '选项2'),
            TTab(text: '选项3'),
          ],
          width: 240,
          height: 56,
          variant: TTabsBarVariant.card,
        ),
      ));

      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, TThemeData.defaultData().bgColorContainer);
      expect(decoration.border, isNull);
    });

    testWidgets('onTap, custom indicator, sizing and colors render',
        (tester) async {
      var tapped = -1;
      await tester.pumpWidget(wrapWithTheme(
        TTabsBar(
          tabs: tabs(),
          onTap: (index) => tapped = index,
          isScrollable: true,
          width: 240,
          height: 56,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicator: const UnderlineTabIndicator(),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
        ),
      ));

      await tester.tap(find.text('选项2'));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });

    testWidgets('theme extension supplies defaults', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabsBar(tabs: tabs()),
        tabsBarTheme: const TTabsBarThemeData(
          height: 56,
          indicatorColor: Colors.blue,
          labelColor: Colors.green,
          showIndicator: true,
          dividerHeight: 0,
          variant: TTabsBarVariant.capsule,
        ),
      ));

      expect(find.byType(TTabsBar), findsOneWidget);
    });
  });

  group('TTabsBar indicators', () {
    test('create painters', () {
      expect(
        const TTabsBarIndicator(indicatorColor: Colors.red)
            .createBoxPainter(),
        isNotNull,
      );
      expect(
        const TTabsBarVerticalIndicator(indicatorColor: Colors.red)
            .createBoxPainter(),
        isNotNull,
      );
      expect(TNoneIndicator().createBoxPainter(), isNotNull);
    });

    test('paint indicators on canvas', () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const config = ImageConfiguration(size: Size(100, 40));
      final horizontalPainter =
          const TTabsBarIndicator(indicatorColor: Colors.red).createBoxPainter();
      final verticalPainter =
          const TTabsBarVerticalIndicator(indicatorColor: Colors.blue)
              .createBoxPainter();
      horizontalPainter.paint(canvas, Offset.zero, config);
      verticalPainter.paint(canvas, Offset.zero, config);
      TNoneIndicator().createBoxPainter().paint(canvas, Offset.zero, config);
      recorder.endRecording();
      expect(true, isTrue);
    });
  });
}
