import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/link/t_link_theme_data.dart';
import 'package:tdesign_flutter/src/components/link/t_link_types.dart';

/// TLinkThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TLinkThemeData 纯函数', () {
    const theme = TLinkThemeData(
      defaultVariant: TLinkVariant.underline,
      defaultSize: TLinkSize.small,
      defaultColorScheme: TLinkColorScheme.danger,
      iconSize: 16,
      fontSize: 14,
      leftGapWithIcon: 4,
      rightGapWithIcon: 4,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        defaultColorScheme: TLinkColorScheme.success,
        iconSize: 20,
        fontSize: 16,
      );
      expect(copied, isA<TLinkThemeData>());
      expect(copied.defaultVariant, TLinkVariant.underline);
      expect(copied.defaultSize, TLinkSize.small);
      expect(copied.defaultColorScheme, TLinkColorScheme.success);
      expect(copied.iconSize, 20);
      expect(copied.fontSize, 16);
      expect(copied.leftGapWithIcon, 4);
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TLinkThemeData', () {
      const other = TLinkThemeData(
        defaultVariant: TLinkVariant.basic,
        defaultSize: TLinkSize.large,
        defaultColorScheme: TLinkColorScheme.warning,
        iconSize: 24,
        fontSize: 18,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TLinkThemeData>());
      expect(atHalf, isA<TLinkThemeData>());
      expect(at1, isA<TLinkThemeData>());
      expect(at0.defaultVariant, TLinkVariant.underline);
      expect(atHalf.defaultVariant, TLinkVariant.basic);
      expect(at1.defaultSize, TLinkSize.large);
      expect(atHalf.defaultColorScheme, TLinkColorScheme.warning);
      expect(atHalf.fontSize, 16);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });
  });
}
