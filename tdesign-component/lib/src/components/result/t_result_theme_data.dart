import 'package:flutter/material.dart';

import 't_result.dart' show TResultVariant, TResult;

/// 结果组件级 ThemeExtension
class TResultThemeData extends ThemeExtension<TResultThemeData> {
  /// 未传 [TResult.variant] 时的默认形态
  final TResultVariant? variant;

  /// 标题文字样式
  final TextStyle? titleStyle;

  const TResultThemeData({
    this.variant,
    this.titleStyle,
  });

  @override
  TResultThemeData copyWith({
    TResultVariant? variant,
    TextStyle? titleStyle,
  }) {
    return TResultThemeData(
      variant: variant ?? this.variant,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  @override
  TResultThemeData lerp(ThemeExtension<TResultThemeData>? other, double t) {
    if (other is! TResultThemeData) {
      return this;
    }
    return TResultThemeData(
      variant: t < 0.5 ? variant : other.variant,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
    );
  }
}
