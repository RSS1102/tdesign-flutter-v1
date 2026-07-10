import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';


import 't_badge.dart' show TBadgeVariant, TBadgeBorder, TBadge;

/// 徽标组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
class TBadgeThemeData extends ThemeExtension<TBadgeThemeData> {
  /// 未传 [TBadge.variant] 时的默认徽标形态
  final TBadgeVariant? variant;

  /// 未传 TBadge.border 时的默认圆角
  final TBadgeBorder? border;

  /// 徽标背景色
  final Color? color;

  /// 徽标文字色
  final Color? textColor;

  /// 消息内容（覆盖 count 展示）
  final String? message;

  /// 角标大三角形宽
  final double? widthLarge;

  /// 角标小三角形宽
  final double? widthSmall;

  /// 角标自定义 padding
  final EdgeInsetsGeometry? padding;

  /// 值为 0 是否显示
  final bool? showZero;

  const TBadgeThemeData({
    this.variant,
    this.border,
    this.color,
    this.textColor,
    this.message,
    this.widthLarge,
    this.widthSmall,
    this.padding,
    this.showZero,
  });

  @override
  TBadgeThemeData copyWith({
    TBadgeVariant? variant,
    TBadgeBorder? border,
    Color? color,
    Color? textColor,
    String? message,
    double? widthLarge,
    double? widthSmall,
    EdgeInsetsGeometry? padding,
    bool? showZero,
  }) {
    return TBadgeThemeData(
      variant: variant ?? this.variant,
      border: border ?? this.border,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      message: message ?? this.message,
      widthLarge: widthLarge ?? this.widthLarge,
      widthSmall: widthSmall ?? this.widthSmall,
      padding: padding ?? this.padding,
      showZero: showZero ?? this.showZero,
    );
  }

  @override
  TBadgeThemeData lerp(ThemeExtension<TBadgeThemeData>? other, double t) {
    if (other is! TBadgeThemeData) {
      return this;
    }
    return TBadgeThemeData(
      variant: t < 0.5 ? variant : other.variant,
      border: t < 0.5 ? border : other.border,
      color: Color.lerp(color, other.color, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      message: t < 0.5 ? message : other.message,
      widthLarge: lerpDouble(widthLarge, other.widthLarge, t),
      widthSmall: lerpDouble(widthSmall, other.widthSmall, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      showZero: t < 0.5 ? showZero : other.showZero,
    );
  }
}
