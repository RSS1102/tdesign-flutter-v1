import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('低覆盖组件 ThemeData copyWith / lerp / merge', () {
    test('TEmptyThemeData 覆盖 copyWith 与 lerp', () {
      final baseFont = Font(size: 14, lineHeight: 22);
      final nextFont = Font(size: 16, lineHeight: 24);
      final base = TEmptyThemeData(
        variant: TEmptyVariant.plain,
        emptyTextColor: Colors.black,
        emptyTextFont: baseFont,
        operationTheme: TButtonColorScheme.primary,
      );
      final other = TEmptyThemeData(
        variant: TEmptyVariant.operation,
        emptyTextColor: Colors.white,
        emptyTextFont: nextFont,
        operationTheme: TButtonColorScheme.danger,
      );

      expect(base.copyWith(variant: TEmptyVariant.operation).variant,
          TEmptyVariant.operation);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).variant, TEmptyVariant.plain);
      expect(base.lerp(other, 0.75).variant, TEmptyVariant.operation);
      expect(base.lerp(other, 0.75).emptyTextFont, same(nextFont));
      expect(base.lerp(other, 0.5).emptyTextColor,
          Color.lerp(Colors.black, Colors.white, 0.5));
    });

    test('TToastThemeData 覆盖 merge / copyWith / lerp', () {
      const base = TToastThemeData(
        backgroundColor: Colors.black,
        textStyle: TextStyle(fontSize: 12),
        iconSize: 16,
        iconColor: Colors.white,
        preventTap: true,
        defaultDuration: Duration(seconds: 1),
        borderRadius: 4,
        padding: EdgeInsets.all(8),
        maxWidth: 200,
      );
      const other = TToastThemeData(
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 20),
        iconSize: 24,
        iconColor: Colors.red,
        preventTap: false,
        defaultDuration: Duration(seconds: 2),
        borderRadius: 12,
        padding: EdgeInsets.all(16),
        maxWidth: 320,
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).backgroundColor, Colors.white);
      expect(base.copyWith(iconSize: 18).iconSize, 18);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).preventTap, isTrue);
      expect(base.lerp(other, 0.75).preventTap, isFalse);
      expect(base.lerp(other, 0.5).iconSize, 20);
      expect(TToastThemeData.lerpDouble(null, null, 0.5), isNull);
    });

    test('TDialogThemeData 覆盖 merge / copyWith / lerp', () {
      final baseShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      );
      final nextShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      );
      final base = TDialogThemeData(
        backgroundColor: Colors.white,
        shape: baseShape,
        elevation: 2,
        barrierColor: Colors.black26,
        titleTextStyle: const TextStyle(fontSize: 16),
        contentTextStyle: const TextStyle(fontSize: 14),
        contentPadding: const EdgeInsets.all(12),
        contentMaxHeight: 120,
        actionButtonStyle: TextButton.styleFrom(foregroundColor: Colors.blue),
        width: 280,
      );
      final other = TDialogThemeData(
        backgroundColor: Colors.black,
        shape: nextShape,
        elevation: 8,
        barrierColor: Colors.red,
        titleTextStyle: const TextStyle(fontSize: 20),
        contentTextStyle: const TextStyle(fontSize: 18),
        contentPadding: const EdgeInsets.all(20),
        contentMaxHeight: 240,
        actionButtonStyle: TextButton.styleFrom(foregroundColor: Colors.green),
        width: 360,
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).width, 360);
      expect(base.copyWith(elevation: 4).elevation, 4);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.5).width, 320);
      expect(TDialogThemeData.lerpDouble(null, null, 0.5), isNull);
    });

    test('TRadioThemeData 覆盖 copyWith 与 lerp', () {
      const base = TRadioThemeData(
        selectColor: Colors.blue,
        disableColor: Colors.grey,
        titleColor: Colors.black,
        subTitleColor: Colors.black54,
        backgroundColor: Colors.white,
        spacing: 8,
        insetSpacing: 16,
      );
      const other = TRadioThemeData(
        selectColor: Colors.red,
        disableColor: Colors.black12,
        titleColor: Colors.white,
        subTitleColor: Colors.white70,
        backgroundColor: Colors.black,
        spacing: 16,
        insetSpacing: 24,
      );

      expect(
          base.copyWith(selectColor: Colors.green).selectColor, Colors.green);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.5).spacing, 12);
      expect(base.lerp(other, 0.5).insetSpacing, 20);
    });

    test('TImageViewerThemeData 覆盖 copyWith 与 lerp', () {
      const base = TImageViewerThemeData(
        backgroundColor: Colors.black,
        appBarBackgroundColor: Colors.blue,
        iconColor: Colors.white,
        labelStyle: TextStyle(fontSize: 12),
        indexStyle: TextStyle(fontSize: 14),
        barrierColor: Colors.black54,
        viewerWidth: 200,
        viewerHeight: 300,
      );
      const other = TImageViewerThemeData(
        backgroundColor: Colors.white,
        appBarBackgroundColor: Colors.red,
        iconColor: Colors.black,
        labelStyle: TextStyle(fontSize: 20),
        indexStyle: TextStyle(fontSize: 22),
        barrierColor: Colors.white54,
        viewerWidth: 300,
        viewerHeight: 500,
      );

      expect(base.copyWith(viewerWidth: 240).viewerWidth, 240);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.5).viewerWidth, 250);
      expect(base.lerp(other, 0.5).viewerHeight, 400);
    });

    test('TSearchBarThemeData 覆盖 copyWith 与 lerp', () {
      const base = TSearchBarThemeData(
        variant: TSearchBarVariant.square,
        textAlignment: TSearchBarAlignment.left,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(8),
        cursorHeight: 18,
        autoHeight: false,
      );
      const other = TSearchBarThemeData(
        variant: TSearchBarVariant.round,
        textAlignment: TSearchBarAlignment.center,
        backgroundColor: Colors.black,
        padding: EdgeInsets.all(16),
        cursorHeight: 28,
        autoHeight: true,
      );

      expect(base.copyWith(variant: TSearchBarVariant.round).variant,
          TSearchBarVariant.round);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).textAlignment, TSearchBarAlignment.left);
      expect(base.lerp(other, 0.75).textAlignment, TSearchBarAlignment.center);
      expect(base.lerp(other, 0.5).cursorHeight, 23);
    });

    test('TUploadThemeData 覆盖 copyWith 与 lerp', () {
      const base = TUploadThemeData(
        variant: TUploadVariant.square,
        itemSize: 80,
        spacing: 8,
        runSpacing: 10,
        alignment: WrapAlignment.start,
      );
      const other = TUploadThemeData(
        variant: TUploadVariant.circle,
        itemSize: 120,
        spacing: 16,
        runSpacing: 20,
        alignment: WrapAlignment.end,
      );

      expect(base.copyWith(itemSize: 96).itemSize, 96);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).variant, TUploadVariant.square);
      expect(base.lerp(other, 0.75).variant, TUploadVariant.circle);
      expect(base.lerp(other, 0.5).itemSize, 100);
    });

    test('TLoadingThemeData 覆盖 merge / copyWith / lerp', () {
      const baseIcon = Icon(Icons.refresh);
      const nextIcon = Icon(Icons.close);
      const base = TLoadingThemeData(
        iconColor: Colors.blue,
        textColor: Colors.black,
        axis: Axis.vertical,
        customIcon: baseIcon,
        duration: 800,
        refreshWidget: Text('retry'),
      );
      const other = TLoadingThemeData(
        iconColor: Colors.red,
        textColor: Colors.white,
        axis: Axis.horizontal,
        customIcon: nextIcon,
        duration: 1200,
        refreshWidget: Text('again'),
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).duration, 1200);
      expect(base.copyWith(axis: Axis.horizontal).axis, Axis.horizontal);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).axis, Axis.vertical);
      expect(base.lerp(other, 0.75).axis, Axis.horizontal);
    });

    test('TStepperThemeData 覆盖 copyWith 与 lerp', () {
      const base = TStepperThemeData(
        variant: TStepperVariant.normal,
        inputWidth: 80,
      );
      const other = TStepperThemeData(
        variant: TStepperVariant.filled,
        inputWidth: 120,
      );

      expect(base.copyWith(inputWidth: 100).inputWidth, 100);
      expect(base.copyWith(variant: TStepperVariant.filled).variant,
          TStepperVariant.filled);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).variant, TStepperVariant.normal);
      expect(base.lerp(other, 0.75).variant, TStepperVariant.filled);
      expect(base.lerp(other, 0.5).inputWidth, 100);
    });

    test('TTableThemeData 覆盖 copyWith 与 lerp', () {
      const loading = Text('loading');
      const base = TTableThemeData(
        bordered: true,
        stripe: false,
        rowHeight: 40,
        height: 200,
        width: 300,
        backgroundColor: Colors.white,
        defaultSort: 'name',
        loadingWidget: loading,
        loading: true,
      );
      const other = TTableThemeData(
        bordered: false,
        stripe: true,
        rowHeight: 60,
        height: 400,
        width: 500,
        backgroundColor: Colors.black,
        defaultSort: 'age',
        loadingWidget: SizedBox(),
        loading: false,
      );

      expect(base.copyWith(width: 360).width, 360);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).bordered, isTrue);
      expect(base.lerp(other, 0.75).bordered, isFalse);
      expect(base.lerp(other, 0.5).rowHeight, 50);
    });

    test('TCascaderThemeData 覆盖 copyWith 与 lerp', () {
      const base = TCascaderThemeData(
        height: 280,
        backgroundColor: Colors.white,
        borderRadius: 8,
      );
      const other = TCascaderThemeData(
        height: 320,
        backgroundColor: Colors.black,
        borderRadius: 16,
      );

      expect(base.copyWith(height: 300).height, 300);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.5).height, 300);
    });

    test('TTimeCounterThemeData 覆盖 copyWith 与 lerp', () {
      const base = TTimeCounterThemeData(
        theme: TTimeCounterVariant.defaultTheme,
        size: TTimeCounterSize.small,
        millisecond: false,
        splitWithUnit: false,
      );
      const other = TTimeCounterThemeData(
        theme: TTimeCounterVariant.round,
        size: TTimeCounterSize.large,
        millisecond: true,
        splitWithUnit: true,
      );

      expect(base.copyWith(millisecond: true).millisecond, isTrue);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).theme, TTimeCounterVariant.defaultTheme);
      expect(base.lerp(other, 0.75).theme, TTimeCounterVariant.round);
    });

    test('TTreeSelectThemeData 覆盖 copyWith 与 lerp', () {
      const base = TTreeSelectThemeData(
        height: 320,
        rootColumnWidth: 100,
        columnWidth: 180,
      );
      const other = TTreeSelectThemeData(
        height: 400,
        rootColumnWidth: 140,
        columnWidth: 220,
      );

      expect(base.copyWith(height: 360).height, 360);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.5).rootColumnWidth, 120);
      expect(base.lerp(other, 0.5).columnWidth, 200);
    });

    test('TDropdownThemeData 覆盖 merge / copyWith / lerp', () {
      const base = TDropdownThemeData(
        width: 120,
        height: 44,
        decoration: BoxDecoration(color: Colors.white),
        arrowIcon: Icon(Icons.keyboard_arrow_down),
        arrowColor: Colors.black,
        tabBarAlign: TextAlign.left,
        duration: Duration(milliseconds: 200),
        isScrollable: false,
      );
      const other = TDropdownThemeData(
        width: 240,
        height: 60,
        decoration: BoxDecoration(color: Colors.black),
        arrowIcon: Icon(Icons.close),
        arrowColor: Colors.red,
        tabBarAlign: TextAlign.center,
        duration: Duration(milliseconds: 400),
        isScrollable: true,
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).width, 240);
      expect(base.copyWith(height: 48).height, 48);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).tabBarAlign, TextAlign.left);
      expect(base.lerp(other, 0.75).tabBarAlign, TextAlign.center);
      expect(base.lerp(other, 0.5).width, 180);
      expect(TDropdownThemeData.lerpDouble(null, null, 0.5), isNull);
    });

    test('TFormThemeData 覆盖 copyWith 与 lerp', () {
      const base = TFormThemeData(
        showColon: true,
        labelWidth: 80,
        layout: TFormLayout.horizontal,
        labelAlign: TextAlign.left,
        backgroundColor: Colors.white,
      );
      const other = TFormThemeData(
        showColon: false,
        labelWidth: 120,
        layout: TFormLayout.vertical,
        labelAlign: TextAlign.center,
        backgroundColor: Colors.black,
      );

      expect(base.copyWith(labelWidth: 96).labelWidth, 96);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).showColon, isTrue);
      expect(base.lerp(other, 0.75).showColon, isFalse);
      expect(base.lerp(other, 0.5).labelWidth, 100);
    });

    test('TMessageThemeData 覆盖 merge / copyWith / lerp', () {
      const base = TMessageThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(),
        elevation: 2,
        defaultOffset: Offset(10, 20),
        defaultMarquee: false,
      );
      const other = TMessageThemeData(
        backgroundColor: Colors.black,
        shape: StadiumBorder(),
        elevation: 6,
        defaultOffset: Offset(30, 40),
        defaultMarquee: true,
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).elevation, 6);
      expect(base.copyWith(defaultMarquee: true).defaultMarquee, isTrue);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).shape, isA<RoundedRectangleBorder>());
      expect(base.lerp(other, 0.75).shape, isA<StadiumBorder>());
      expect(base.lerp(other, 0.5).elevation, 4);
      expect(TMessageThemeData.lerpDouble(null, null, 0.5), isNull);
    });

    test('TPopoverThemeData 覆盖 merge / copyWith / lerp', () {
      const base = TPopoverThemeData(
        colorScheme: TPopoverColorScheme.dark,
        backgroundColor: Colors.black,
        padding: EdgeInsets.all(8),
        minWidth: 80,
        maxHeight: 160,
        borderRadius: 4,
        barrierColor: Colors.black26,
        arrowSize: 8,
      );
      const other = TPopoverThemeData(
        colorScheme: TPopoverColorScheme.warning,
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.all(16),
        minWidth: 120,
        maxHeight: 240,
        borderRadius: 12,
        barrierColor: Colors.black54,
        arrowSize: 12,
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).colorScheme, TPopoverColorScheme.warning);
      expect(base.copyWith(arrowSize: 10).arrowSize, 10);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).colorScheme, TPopoverColorScheme.dark);
      expect(base.lerp(other, 0.75).colorScheme, TPopoverColorScheme.warning);
      expect(base.lerp(other, 0.5).minWidth, 100);
      expect(TPopoverThemeData.lerpDouble(null, null, 0.5), isNull);
    });

    test('TActionSheetThemeData 覆盖 merge / copyWith / lerp', () {
      const base = TActionSheetThemeData(
        cancelText: 'cancel',
        showCancelButton: true,
        defaultAlign: TActionSheetAlign.center,
        itemHeight: 48,
        itemMinWidth: 100,
        count: 4,
        rows: 2,
        showPagination: false,
        scrollable: false,
        barrierDismissible: true,
        barrierColor: Colors.black26,
        panelRadius: 8,
        useSafeArea: true,
      );
      const other = TActionSheetThemeData(
        cancelText: 'close',
        showCancelButton: false,
        defaultAlign: TActionSheetAlign.left,
        itemHeight: 64,
        itemMinWidth: 140,
        count: 5,
        rows: 3,
        showPagination: true,
        scrollable: true,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        panelRadius: 16,
        useSafeArea: false,
      );

      expect(base.merge(null), same(base));
      expect(base.merge(other).cancelText, 'close');
      expect(base.copyWith(count: 6).count, 6);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).cancelText, 'cancel');
      expect(base.lerp(other, 0.75).cancelText, 'close');
      expect(base.lerp(other, 0.5).itemHeight, 56);
      expect(TActionSheetThemeData.lerpDouble(null, null, 0.5), isNull);
    });
  });
}
