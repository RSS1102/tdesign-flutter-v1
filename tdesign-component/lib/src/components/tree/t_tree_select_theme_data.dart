import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_tree_select.dart' show TTreeSelectStyle;

/// TTreeSelect 组件级 ThemeExtension
class TTreeSelectThemeData extends ThemeExtension<TTreeSelectThemeData> {
  /// 样式
  final TTreeSelectStyle? style;

  /// 高度
  final double? height;

  /// 外角半径
  final double? outwardCornerRadius;

  const TTreeSelectThemeData({
    this.style,
    this.height,
    this.outwardCornerRadius,
  });

  @override
  TTreeSelectThemeData copyWith({
    TTreeSelectStyle? style,
    double? height,
    double? outwardCornerRadius,
  }) {
    return TTreeSelectThemeData(
      style: style ?? this.style,
      height: height ?? this.height,
      outwardCornerRadius: outwardCornerRadius ?? this.outwardCornerRadius,
    );
  }

  @override
  TTreeSelectThemeData lerp(
      ThemeExtension<TTreeSelectThemeData>? other, double t) {
    if (other is! TTreeSelectThemeData) {
      return this;
    }
    return TTreeSelectThemeData(
      style: t < 0.5 ? style : other.style,
      height: lerpDouble(height, other.height, t),
      outwardCornerRadius:
          lerpDouble(outwardCornerRadius, other.outwardCornerRadius, t),
    );
  }
}
