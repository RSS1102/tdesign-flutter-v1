import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TInput;

import 't_input.dart' show TInput;

/// TInput 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
/// 被 TInput 和 TTextarea 共用。
class TInputThemeData extends ThemeExtension<TInputThemeData> {
  /// 未传 [TInput.layout] 时的默认布局
  final TInputLayout? defaultLayout;

  /// 未传 [TInput.size] 时的默认尺寸
  final TInputSize? defaultSize;

  /// 文本样式
  final TextStyle? textStyle;

  /// 提示文本样式
  final TextStyle? hintTextStyle;

  /// 标签文本样式
  final TextStyle? labelStyle;

  /// 输入框背景色
  final Color? backgroundColor;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// 清除按钮颜色
  final Color? clearBtnColor;

  /// 附加信息颜色
  final Color? additionInfoColor;

  /// 内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 卡片布局默认样式
  final TInputCardStyle? cardStyle;

  /// 卡片模式上方文字
  final String? cardStyleTopText;

  /// 卡片模式下方文字
  final String? cardStyleBottomText;

  /// 左侧信息宽度
  final double? leftInfoWidth;

  /// 是否展示底部分割线
  final bool? showBottomDivider;

  /// 是否显示清除按钮
  final bool? showClearButton;

  /// 清除图标大小
  final double? clearIconSize;

  /// 组件各模块间间距
  final TInputSpacer? spacer;

  const TInputThemeData({
    this.defaultLayout,
    this.defaultSize,
    this.textStyle,
    this.hintTextStyle,
    this.labelStyle,
    this.backgroundColor,
    this.textInputBackgroundColor,
    this.cursorColor,
    this.clearBtnColor,
    this.additionInfoColor,
    this.contentPadding,
    this.cardStyle,
    this.cardStyleTopText,
    this.cardStyleBottomText,
    this.leftInfoWidth,
    this.showBottomDivider,
    this.showClearButton,
    this.clearIconSize,
    this.spacer,
  });

  @override
  TInputThemeData copyWith({
    TInputLayout? defaultLayout,
    TInputSize? defaultSize,
    TextStyle? textStyle,
    TextStyle? hintTextStyle,
    TextStyle? labelStyle,
    Color? backgroundColor,
    Color? textInputBackgroundColor,
    Color? cursorColor,
    Color? clearBtnColor,
    Color? additionInfoColor,
    EdgeInsetsGeometry? contentPadding,
    TInputCardStyle? cardStyle,
    String? cardStyleTopText,
    String? cardStyleBottomText,
    double? leftInfoWidth,
    bool? showBottomDivider,
    bool? showClearButton,
    double? clearIconSize,
    TInputSpacer? spacer,
  }) {
    return TInputThemeData(
      defaultLayout: defaultLayout ?? this.defaultLayout,
      defaultSize: defaultSize ?? this.defaultSize,
      textStyle: textStyle ?? this.textStyle,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textInputBackgroundColor:
          textInputBackgroundColor ?? this.textInputBackgroundColor,
      cursorColor: cursorColor ?? this.cursorColor,
      clearBtnColor: clearBtnColor ?? this.clearBtnColor,
      additionInfoColor: additionInfoColor ?? this.additionInfoColor,
      contentPadding: contentPadding ?? this.contentPadding,
      cardStyle: cardStyle ?? this.cardStyle,
      cardStyleTopText: cardStyleTopText ?? this.cardStyleTopText,
      cardStyleBottomText: cardStyleBottomText ?? this.cardStyleBottomText,
      leftInfoWidth: leftInfoWidth ?? this.leftInfoWidth,
      showBottomDivider: showBottomDivider ?? this.showBottomDivider,
      showClearButton: showClearButton ?? this.showClearButton,
      clearIconSize: clearIconSize ?? this.clearIconSize,
      spacer: spacer ?? this.spacer,
    );
  }

  @override
  TInputThemeData lerp(ThemeExtension<TInputThemeData>? other, double t) {
    if (other is! TInputThemeData) {
      return this;
    }
    return TInputThemeData(
      defaultLayout: t < 0.5 ? defaultLayout : other.defaultLayout,
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      hintTextStyle: TextStyle.lerp(hintTextStyle, other.hintTextStyle, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textInputBackgroundColor: Color.lerp(
          textInputBackgroundColor, other.textInputBackgroundColor, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      clearBtnColor: Color.lerp(clearBtnColor, other.clearBtnColor, t),
      additionInfoColor:
          Color.lerp(additionInfoColor, other.additionInfoColor, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t),
      cardStyle: t < 0.5 ? cardStyle : other.cardStyle,
      cardStyleTopText: t < 0.5 ? cardStyleTopText : other.cardStyleTopText,
      cardStyleBottomText:
          t < 0.5 ? cardStyleBottomText : other.cardStyleBottomText,
      leftInfoWidth: lerpDouble(leftInfoWidth, other.leftInfoWidth, t),
      showBottomDivider: t < 0.5 ? showBottomDivider : other.showBottomDivider,
      showClearButton: t < 0.5 ? showClearButton : other.showClearButton,
      clearIconSize: lerpDouble(clearIconSize, other.clearIconSize, t),
    );
  }
}

/// 输入框布局形态
enum TInputLayout {
  /// 普通布局
  normal,

  /// 双行布局
  twoLine,

  /// 长文本布局
  longText,

  /// 特殊布局
  special,

  /// 普通最大双行
  normalMaxTwoLine,

  /// 卡片布局
  cardStyle,
}

/// 输入框尺寸
enum TInputSize { small, large }

/// 卡片默认样式
enum TInputCardStyle { topText, topTextWithBlueBorder, errorStyle }

/// 组件各模块间间距配置
class TInputSpacer {
  /// 图标与标签间距
  final double? iconLabelSpace;

  /// 标签与输入区间距
  final double? labelInputSpace;

  /// 输入区右侧间距
  final double? inputRightSpace;

  /// 右侧间距
  final double? rightSpace;

  /// 附加信息间距
  final double? additionInfoSpace;

  const TInputSpacer({
    this.iconLabelSpace,
    this.labelInputSpace,
    this.inputRightSpace,
    this.rightSpace,
    this.additionInfoSpace,
  });

  /// 默认间距配置
  static const defaultSpacer = TInputSpacer(
    iconLabelSpace: 4,
    labelInputSpace: 16,
    inputRightSpace: 16,
    rightSpace: 16,
    additionInfoSpace: 16,
  );
}
