import 'package:flutter/material.dart';

/// TPopover 语义色（原 TPopoverColorScheme）
enum TPopoverColorScheme {
  /// 深色
  dark,

  /// 浅色
  light,

  /// 信息
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,
}

/// TPopover 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认气泡样式。
class TPopoverThemeData extends ThemeExtension<TPopoverThemeData> {
  /// 语义色
  final TPopoverColorScheme? colorScheme;

  /// 气泡背景色
  final Color? backgroundColor;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 最小宽度
  final double? minWidth;

  /// 最大高度
  final double? maxHeight;

  /// 圆角
  final double? borderRadius;

  /// 蒙层色
  final Color? barrierColor;

  /// 箭头尺寸
  final double? arrowSize;

  const TPopoverThemeData({
    this.colorScheme,
    this.backgroundColor,
    this.padding,
    this.minWidth,
    this.maxHeight,
    this.borderRadius,
    this.barrierColor,
    this.arrowSize,
  });

  TPopoverThemeData merge(TPopoverThemeData? other) {
    if (other == null) return this;
    return TPopoverThemeData(
      colorScheme: other.colorScheme ?? colorScheme,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      padding: other.padding ?? padding,
      minWidth: other.minWidth ?? minWidth,
      maxHeight: other.maxHeight ?? maxHeight,
      borderRadius: other.borderRadius ?? borderRadius,
      barrierColor: other.barrierColor ?? barrierColor,
      arrowSize: other.arrowSize ?? arrowSize,
    );
  }

  @override
  TPopoverThemeData copyWith({
    TPopoverColorScheme? colorScheme,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? minWidth,
    double? maxHeight,
    double? borderRadius,
    Color? barrierColor,
    double? arrowSize,
  }) {
    return TPopoverThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      minWidth: minWidth ?? this.minWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      barrierColor: barrierColor ?? this.barrierColor,
      arrowSize: arrowSize ?? this.arrowSize,
    );
  }

  @override
  TPopoverThemeData lerp(ThemeExtension<TPopoverThemeData>? other, double t) {
    if (other is! TPopoverThemeData) return this;
    return TPopoverThemeData(
      colorScheme: t < 0.5 ? colorScheme : other.colorScheme,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      minWidth: lerpDouble(minWidth, other.minWidth, t),
      maxHeight: lerpDouble(maxHeight, other.maxHeight, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      arrowSize: lerpDouble(arrowSize, other.arrowSize, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
