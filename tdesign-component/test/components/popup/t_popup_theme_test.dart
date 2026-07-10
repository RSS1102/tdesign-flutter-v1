import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_theme_data.dart';

/// TPopupThemeData 纯函数覆盖（merge / copyWith / lerp），用于提升覆盖率。
void main() {
  group('TPopupThemeData 纯函数', () {
    const theme = TPopupThemeData(
      barrierColor: Colors.black54,
      barrierOpacity: 0.5,
      transitionDuration: Duration(milliseconds: 300),
      panelRadius: 8,
      panelBackgroundColor: Colors.white,
      useSafeArea: true,
      cancelText: '取消',
      confirmText: '确认',
    );

    test('merge other 优先', () {
      const other = TPopupThemeData(barrierColor: Colors.black38, confirmText: 'OK');
      final merged = theme.merge(other);
      expect(merged, isA<TPopupThemeData>());
      expect(merged.barrierColor, Colors.black38);
      expect(merged.confirmText, 'OK');
      // 未提供字段沿用 this
      expect(merged.cancelText, '取消');
    });

    test('merge null 返回 this', () {
      expect(theme.merge(null), theme);
    });

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(barrierOpacity: 0.8, useSafeArea: false);
      expect(copied, isA<TPopupThemeData>());
      expect(copied.barrierOpacity, 0.8);
      expect(copied.useSafeArea, false);
      expect(copied.cancelText, '取消');
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TPopupThemeData', () {
      const other = TPopupThemeData(
        barrierColor: Colors.black12,
        barrierOpacity: 0.2,
        panelRadius: 16,
        useSafeArea: false,
        cancelText: 'Close',
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TPopupThemeData>());
      expect(atHalf, isA<TPopupThemeData>());
      expect(at1, isA<TPopupThemeData>());
      expect(atHalf.useSafeArea, false); // t<0.5 取 this（t=0.5 边界归属 other 侧）
      expect(at1.useSafeArea, false); // t>=0.5 取 other
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });

    test('lerpDouble 静态方法', () {
      expect(TPopupThemeData.lerpDouble(0, 10, 0.5), 5);
      expect(TPopupThemeData.lerpDouble(null, null, 0.5), isNull);
      expect(TPopupThemeData.lerpDouble(10, null, 0.5), 5);
    });
  });
}
