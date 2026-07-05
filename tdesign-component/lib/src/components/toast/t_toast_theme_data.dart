import 'package:flutter/material.dart';

/// TToast 组件级 ThemeExtension
class TToastThemeData extends ThemeExtension<TToastThemeData> {
  /// 背景色
  final Color? backgroundColor;

  /// 文案样式
  final TextStyle? textStyle;

  /// 图标尺寸
  final double? iconSize;

  /// 图标颜色
  final Color? iconColor;

  /// 是否拦截点击穿透
  final bool? preventTap;

  /// 默认展示时长
  final Duration? defaultDuration;

  /// 展示时长（alias for [defaultDuration]）
  final Duration? duration;

  /// 圆角
  final double? borderRadius;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 最大宽度
  final double? maxWidth;

  const TToastThemeData({
    this.backgroundColor,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.preventTap,
    this.defaultDuration,
    this.duration,
    this.borderRadius,
    this.padding,
    this.maxWidth,
  });

  /// 合并其他 ThemeData，非空字段优先取 [other]
  TToastThemeData merge(TToastThemeData? other) {
    if (other == null) return this;
    return TToastThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: other.textStyle ?? textStyle,
      iconSize: other.iconSize ?? iconSize,
      iconColor: other.iconColor ?? iconColor,
      preventTap: other.preventTap ?? preventTap,
      defaultDuration: other.defaultDuration ?? defaultDuration,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      maxWidth: other.maxWidth ?? maxWidth,
    );
  }

  @override
  TToastThemeData copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    bool? preventTap,
    Duration? defaultDuration,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
  }) {
    return TToastThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      preventTap: preventTap ?? this.preventTap,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
    );
  }

  @override
  TToastThemeData lerp(ThemeExtension<TToastThemeData>? other, double t) {
    if (other is! TToastThemeData) return this;
    return TToastThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      preventTap: t < 0.5 ? preventTap : other.preventTap,
      defaultDuration: t < 0.5 ? defaultDuration : other.defaultDuration,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
