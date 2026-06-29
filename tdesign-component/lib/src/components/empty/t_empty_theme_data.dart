import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_empty.dart' show TEmptyVariant;

/// 空态组件级 ThemeExtension
class TEmptyThemeData extends ThemeExtension<TEmptyThemeData> {
  /// 未传 [TEmpty.variant] 时的默认形态
  final TEmptyVariant? variant;

  /// 描述文字颜色
  final Color? emptyTextColor;

  /// 描述文字字号
  final Font? emptyTextFont;

  /// 操作按钮语义色
  final TButtonColorScheme? operationTheme;

  const TEmptyThemeData({
    this.variant,
    this.emptyTextColor,
    this.emptyTextFont,
    this.operationTheme,
  });

  @override
  TEmptyThemeData copyWith({
    TEmptyVariant? variant,
    Color? emptyTextColor,
    Font? emptyTextFont,
    TButtonColorScheme? operationTheme,
  }) {
    return TEmptyThemeData(
      variant: variant ?? this.variant,
      emptyTextColor: emptyTextColor ?? this.emptyTextColor,
      emptyTextFont: emptyTextFont ?? this.emptyTextFont,
      operationTheme: operationTheme ?? this.operationTheme,
    );
  }

  @override
  TEmptyThemeData lerp(ThemeExtension<TEmptyThemeData>? other, double t) {
    if (other is! TEmptyThemeData) return this;
    return TEmptyThemeData(
      variant: t < 0.5 ? variant : other.variant,
      emptyTextColor: Color.lerp(emptyTextColor, other.emptyTextColor, t),
      emptyTextFont: t < 0.5 ? emptyTextFont : other.emptyTextFont,
      operationTheme: t < 0.5 ? operationTheme : other.operationTheme,
    );
  }
}
