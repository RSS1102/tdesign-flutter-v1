import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_footer.dart' show TFooterVariant, TFooter;

/// 页脚组件级 ThemeExtension
class TFooterThemeData extends ThemeExtension<TFooterThemeData> {
  /// 未传 [TFooter.variant] 时的默认形态
  final TFooterVariant? variant;

  /// 默认高度
  final double? height;

  const TFooterThemeData({
    this.variant,
    this.height,
  });

  @override
  TFooterThemeData copyWith({
    TFooterVariant? variant,
    double? height,
  }) {
    return TFooterThemeData(
      variant: variant ?? this.variant,
      height: height ?? this.height,
    );
  }

  @override
  TFooterThemeData lerp(ThemeExtension<TFooterThemeData>? other, double t) {
    if (other is! TFooterThemeData) {
      return this;
    }
    return TFooterThemeData(
      variant: t < 0.5 ? variant : other.variant,
      height: lerpDouble(height, other.height, t),
    );
  }
}
