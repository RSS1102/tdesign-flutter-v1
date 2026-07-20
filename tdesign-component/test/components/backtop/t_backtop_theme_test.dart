import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/backtop/t_backtop_theme_data.dart';

/// TBackTopThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TBackTopThemeData 纯函数', () {
    const theme = TBackTopThemeData(
      shape: TBackTopShape.circle,
      colorScheme: TBackTopColorScheme.light,
      defaultVisibilityOffset: 200,
      defaultRight: 20,
      defaultBottom: 40,
      halfCircleRightInset: -16,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        shape: TBackTopShape.halfCircle,
        defaultVisibilityOffset: 300,
      );
      expect(copied, isA<TBackTopThemeData>());
      expect(copied.shape, TBackTopShape.halfCircle);
      expect(copied.defaultVisibilityOffset, 300);
      expect(copied.colorScheme, TBackTopColorScheme.light);
    });

    test('copyWith cover remaining fields', () {
      final copied = theme.copyWith(
        colorScheme: TBackTopColorScheme.dark,
        defaultRight: 24,
        defaultBottom: 36,
        halfCircleRightInset: -12,
      );
      expect(copied.colorScheme, TBackTopColorScheme.dark);
      expect(copied.defaultRight, 24);
      expect(copied.defaultBottom, 36);
      expect(copied.halfCircleRightInset, -12);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TBackTopThemeData', () {
      const other = TBackTopThemeData(
        shape: TBackTopShape.halfCircle,
        defaultVisibilityOffset: 400,
        defaultRight: 30,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TBackTopThemeData>());
      expect(atHalf, isA<TBackTopThemeData>());
      expect(at1, isA<TBackTopThemeData>());
      expect(atHalf.shape, TBackTopShape.halfCircle);
      expect(at1.shape, TBackTopShape.halfCircle);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });

    test('lerp cover remaining fields', () {
      const other = TBackTopThemeData(
        shape: TBackTopShape.halfCircle,
        colorScheme: TBackTopColorScheme.dark,
        defaultRight: 40,
        defaultBottom: 50,
        halfCircleRightInset: -8,
      );
      final lerped = theme.lerp(other, 0.5);
      expect(lerped.colorScheme, TBackTopColorScheme.dark);
      expect(lerped.defaultRight, 30);
      expect(lerped.defaultBottom, 45);
      expect(lerped.halfCircleRightInset, -12);
    });
  });
}
