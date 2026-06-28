import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TRadio 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
class TRadioThemeData extends ThemeExtension<TRadioThemeData> {
  /// 勾选样式
  final TRadioStyle? radioStyle;

  /// 选择颜色
  final Color? selectColor;

  /// 禁用颜色
  final Color? disableColor;

  /// 标题文字颜色
  final Color? titleColor;

  /// 副标题文字颜色
  final Color? subTitleColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// icon和文字的距离
  final double? spacing;

  /// 选项框左侧间距
  final double? checkBoxLeftSpace;

  /// 文字和非图标侧的距离
  final double? insetSpacing;

  const TRadioThemeData({
    this.radioStyle,
    this.selectColor,
    this.disableColor,
    this.titleColor,
    this.subTitleColor,
    this.backgroundColor,
    this.spacing,
    this.checkBoxLeftSpace,
    this.insetSpacing,
  });

  @override
  TRadioThemeData copyWith({
    TRadioStyle? radioStyle,
    Color? selectColor,
    Color? disableColor,
    Color? titleColor,
    Color? subTitleColor,
    Color? backgroundColor,
    double? spacing,
    double? checkBoxLeftSpace,
    double? insetSpacing,
  }) {
    return TRadioThemeData(
      radioStyle: radioStyle ?? this.radioStyle,
      selectColor: selectColor ?? this.selectColor,
      disableColor: disableColor ?? this.disableColor,
      titleColor: titleColor ?? this.titleColor,
      subTitleColor: subTitleColor ?? this.subTitleColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      spacing: spacing ?? this.spacing,
      checkBoxLeftSpace: checkBoxLeftSpace ?? this.checkBoxLeftSpace,
      insetSpacing: insetSpacing ?? this.insetSpacing,
    );
  }

  @override
  TRadioThemeData lerp(ThemeExtension<TRadioThemeData>? other, double t) {
    if (other is! TRadioThemeData) return this;
    return TRadioThemeData(
      radioStyle: t < 0.5 ? radioStyle : other.radioStyle,
      selectColor: Color.lerp(selectColor, other.selectColor, t),
      disableColor: Color.lerp(disableColor, other.disableColor, t),
      titleColor: Color.lerp(titleColor, other.titleColor, t),
      subTitleColor: Color.lerp(subTitleColor, other.subTitleColor, t),
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t),
      spacing: lerpDouble(spacing, other.spacing, t),
      checkBoxLeftSpace:
          lerpDouble(checkBoxLeftSpace, other.checkBoxLeftSpace, t),
      insetSpacing: lerpDouble(insetSpacing, other.insetSpacing, t),
    );
  }
}

/// 单选框样式
enum TRadioStyle { circle, square, check, hollowCircle }
