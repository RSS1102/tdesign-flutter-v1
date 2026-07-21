import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_theme_data.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('TPopup coverage supplements', () {
    testWidgets('PopupHeader renders custom header and close callback',
        (tester) async {
      TPopupTrigger? trigger;

      await tester.pumpWidget(wrap(
        PopupHeader(
          options: TPopupOptions.bottom(
            child: const Text('body'),
            headerBuilder: (context, close) => TextButton(
              onPressed: close,
              child: const Text('custom header'),
            ),
          ),
          onCloseWithTrigger: (value) => trigger = value,
        ),
      ));

      expect(find.text('custom header'), findsOneWidget);
      await tester.tap(find.text('custom header'));
      expect(trigger, TPopupTrigger.custom);
    });

    testWidgets('PopupShell renders default bottom header actions',
        (tester) async {
      final triggers = <TPopupTrigger>[];

      await tester.pumpWidget(wrap(
        PopupShell(
          options: TPopupOptions.bottom(
            child: const SizedBox(height: 24, child: Text('bottom body')),
            titleWidget: const Text('标题'),
          ),
          onCloseWithTrigger: triggers.add,
        ),
      ));

      expect(find.text('标题'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确定'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await tester.tap(find.text('确定'));

      expect(
          triggers,
          containsAll(<TPopupTrigger>[
            TPopupTrigger.cancel,
            TPopupTrigger.confirm,
          ]));
    });

    testWidgets('PopupShell renders custom bottom slots', (tester) async {
      final triggers = <TPopupTrigger>[];

      await tester.pumpWidget(wrap(
        PopupShell(
          options: TPopupOptions.bottom(
            child: const Text('custom body'),
            titleWidget: const Text('custom title'),
            cancelBuilder: (context, close) => TextButton(
              onPressed: close,
              child: const Text('custom cancel'),
            ),
            confirmBuilder: (context, close) => TextButton(
              onPressed: close,
              child: const Text('custom confirm'),
            ),
          ),
          onCloseWithTrigger: triggers.add,
        ),
      ));

      await tester.tap(find.text('custom cancel'));
      await tester.tap(find.text('custom confirm'));

      expect(triggers, <TPopupTrigger>[
        TPopupTrigger.cancel,
        TPopupTrigger.confirm,
      ]);
    });

    testWidgets('center shell covers default and custom close controls',
        (tester) async {
      final triggers = <TPopupTrigger>[];

      await tester.pumpWidget(wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupShell(
              options: TPopupOptions.center(
                child: const Text('center default'),
                width: 120,
                height: 80,
              ),
              onCloseWithTrigger: triggers.add,
            ),
            PopupShell(
              options: TPopupOptions.center(
                child: const Text('center custom'),
                width: 120,
                height: 80,
                closeBuilder: (context, close) => TextButton(
                  onPressed: close,
                  child: const Text('custom close'),
                ),
              ),
              onCloseWithTrigger: triggers.add,
            ),
            PopupShell(
              options: TPopupOptions.center(
                child: const Text('center no close'),
                width: 120,
                height: 80,
                closeBuilder: null,
              ),
              onCloseWithTrigger: triggers.add,
            ),
          ],
        ),
      ));

      await tester.tap(find.byType(IconButton).first);
      await tester.tap(find.text('custom close'));

      expect(find.text('center no close'), findsOneWidget);
      expect(triggers, <TPopupTrigger>[
        TPopupTrigger.close,
        TPopupTrigger.close,
      ]);
    });

    test('TPopupOptions explicit nulls, slots and validation errors', () {
      const child = SizedBox();

      final copied = TPopupOptions.bottom(
        child: child,
        titleWidget: const Text('title'),
      ).copyWith(
        radius: 12,
        overlayOpacity: 0.4,
      );
      expect(copied.radius, 12);
      expect(copied.overlayOpacity, 0.4);

      final cleared = copied.copyWith(
        radius: null,
        overlayOpacity: null,
        titleWidget: null,
        cancelBuilder: null,
        confirmBuilder: null,
        closeBuilder: null,
      );

      expect(cleared.radius, isNull);
      expect(cleared.overlayOpacity, isNull);
      expect(cleared.titleWidget, isNull);
      expect(cleared.cancelBuilder, isNull);
      expect(cleared.confirmBuilder, isNull);
      expect(cleared.closeBuilder, isNull);
      expect(cleared.usesDefaultCancel, isFalse);
      expect(cleared.usesDefaultConfirm, isFalse);
      expect(cleared.hasBuiltInHeader, isFalse);

      expect(const TPopupBottomInset(left: 1, right: 2).left, 1);
      expect(const TPopupTopInset(left: 3, right: 4).right, 4);
      expect(const TPopupLeftInset(top: 5, bottom: 6).bottom, 6);
      expect(const TPopupRightInset(top: 7, bottom: 8).top, 7);

      final invalid = <TPopupOptions>[
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.top,
          width: 10,
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.top,
          inset: TPopupBottomInset(),
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.bottom,
          width: 10,
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.left,
          inset: TPopupBottomInset(),
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.right,
          inset: TPopupBottomInset(),
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.left,
          height: 10,
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.right,
          height: 10,
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.center,
          inset: TPopupBottomInset(),
        ),
        const TPopupOptions(
          child: child,
          placement: TPopupPlacement.top,
          titleWidget: Text('invalid'),
        ),
        TPopupOptions(
          child: child,
          placement: TPopupPlacement.bottom,
          closeBuilder: (context, close) => const SizedBox(),
        ),
        TPopupOptions.bottom(
          child: child,
          showOverlay: true,
          modal: false,
        ),
        TPopupOptions.bottom(
          child: child,
          showOverlay: false,
          closeOnOverlayClick: true,
        ),
      ];

      for (final option in invalid) {
        expect(option.assertPlacementParams, throwsFlutterError);
      }
    });

    test('PopupLayout covers typed insets', () {
      const safePadding = EdgeInsets.fromLTRB(1, 2, 3, 4);
      final layouts = <PopupLayout>[
        PopupLayout(
          placement: TPopupPlacement.bottom,
          inset: const TPopupBottomInset(left: 8, right: 9),
        ),
        PopupLayout(
          placement: TPopupPlacement.left,
          inset: const TPopupLeftInset(top: 10, bottom: 11),
        ),
        PopupLayout(
          placement: TPopupPlacement.right,
          inset: const TPopupRightInset(top: 12, bottom: 13),
        ),
      ];

      for (final layout in layouts) {
        expect(
          layout.wrapPositioned(
            child: const SizedBox(),
            safePadding: safePadding,
          ),
          isA<Positioned>(),
        );
      }
    });

    testWidgets('PopupShell edge placements render expanded bodies',
        (tester) async {
      await tester.pumpWidget(wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 80,
              child: PopupShell(
                options: TPopupOptions.top(
                  child: const Text('top shell'),
                  height: 80,
                ),
                onCloseWithTrigger: (_) {},
              ),
            ),
            SizedBox(
              width: 160,
              height: 80,
              child: PopupShell(
                options: TPopupOptions.left(
                  child: const Text('left shell'),
                  width: 80,
                ),
                onCloseWithTrigger: (_) {},
              ),
            ),
            SizedBox(
              width: 160,
              height: 80,
              child: PopupShell(
                options: TPopupOptions.right(
                  child: const Text('right shell'),
                  width: 80,
                ),
                onCloseWithTrigger: (_) {},
              ),
            ),
          ],
        ),
      ));

      expect(find.text('top shell'), findsOneWidget);
      expect(find.text('left shell'), findsOneWidget);
      expect(find.text('right shell'), findsOneWidget);
    });

    testWidgets('TPopup.show uses theme transition and overlay tap',
        (tester) async {
      var overlayClicks = 0;
      TPopupTrigger? visibleTrigger;

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          extensions: const [
            TPopupThemeData(
              transitionDuration: Duration(milliseconds: 120),
              barrierColor: Colors.red,
              barrierOpacity: 0.5,
            ),
          ],
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                TPopup.show(
                  context,
                  options: TPopupOptions.bottom(
                    child: const SizedBox(height: 80, child: Text('overlay')),
                    closeOnOverlayClick: true,
                    onOverlayClick: () => overlayClicks++,
                    onVisibleChange: (visible, trigger) {
                      if (!visible) {
                        visibleTrigger = trigger;
                      }
                    },
                  ),
                );
              },
              child: const Text('open overlay'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('open overlay'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(overlayClicks, 1);
      expect(visibleTrigger, TPopupTrigger.overlay);
    });

    testWidgets('TPopupHandle close and reopen paths', (tester) async {
      late TPopupHandle handle;
      var closed = 0;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                handle = TPopup.show(
                  context,
                  options: TPopupOptions.bottom(
                    child: const Text('handle popup'),
                    onClosed: () => closed++,
                  ),
                );
              },
              child: const Text('open popup'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('open popup'));
      await tester.pumpAndSettle();
      expect(handle.isShowing, isTrue);

      handle.open();
      expect(handle.isShowing, isTrue);

      handle.close();
      await tester.pumpAndSettle();
      expect(handle.isShowing, isFalse);
      expect(closed, 1);

      handle.open();
      await tester.pumpAndSettle();
      expect(handle.isShowing, isTrue);
      handle.close();
      await tester.pumpAndSettle();
    });
  });
}
