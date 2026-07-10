import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/input/t_input_theme_data.dart';

/// TInputThemeData 纯函数覆盖（copyWith / lerp），用于提升覆盖率。
void main() {
  group('TInputThemeData 纯函数', () {
    const theme = TInputThemeData(
      defaultLayout: TInputLayout.normal,
      defaultSize: TInputSize.large,
      textStyle: TextStyle(fontSize: 14),
      hintTextStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: Colors.white,
      textInputBackgroundColor: Colors.black12,
      cursorColor: Colors.red,
      clearBtnColor: Colors.blue,
      additionInfoColor: Colors.green,
      contentPadding: EdgeInsets.all(8),
      cardStyle: TInputCardStyle.topText,
      cardStyleTopText: '顶部',
      cardStyleBottomText: '底部',
      leftInfoWidth: 40,
      showBottomDivider: true,
      showClearButton: true,
      clearIconSize: 18,
      spacer: TInputSpacer.defaultSpacer,
    );

    test('copyWith 覆盖字段', () {
      final copied = theme.copyWith(
        defaultLayout: TInputLayout.twoLine,
        defaultSize: TInputSize.small,
        showClearButton: false,
      );
      expect(copied, isA<TInputThemeData>());
      expect(copied.defaultLayout, TInputLayout.twoLine);
      expect(copied.defaultSize, TInputSize.small);
      expect(copied.showClearButton, false);
      // 未覆盖字段保持原值
      expect(copied.cursorColor, Colors.red);
      expect(copied.cardStyleTopText, '顶部');
    });

    test('lerp 在 t=0 / 0.5 / 1 返回 TInputThemeData', () {
      const other = TInputThemeData(
        defaultLayout: TInputLayout.cardStyle,
        defaultSize: TInputSize.small,
        textStyle: TextStyle(fontSize: 20),
        backgroundColor: Colors.black,
        cursorColor: Colors.yellow,
        leftInfoWidth: 80,
        showBottomDivider: false,
      );
      final at0 = theme.lerp(other, 0);
      final atHalf = theme.lerp(other, 0.5);
      final at1 = theme.lerp(other, 1);
      expect(at0, isA<TInputThemeData>());
      expect(atHalf, isA<TInputThemeData>());
      expect(at1, isA<TInputThemeData>());
      // t<0.5 取 this 的枚举/布尔字段（t=0.5 边界归属 other 侧）
      expect(atHalf.defaultLayout, TInputLayout.cardStyle);
      // t>=0.5 取 other 的枚举/布尔字段
      expect(at1.defaultLayout, TInputLayout.cardStyle);
    });

    test('lerp other 非同类型时返回 this', () {
      expect(theme.lerp(null, 0.5), theme);
    });
  });
}
