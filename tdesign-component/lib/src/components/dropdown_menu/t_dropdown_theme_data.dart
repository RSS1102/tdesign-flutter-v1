import 'package:flutter/material.dart';

/// TDropdownMenu 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认下拉菜单样式。
class TDropdownThemeData extends ThemeExtension<TDropdownThemeData> {
  /// 菜单栏宽度
  final double? width;

  /// 菜单栏高度
  final double? height;

  /// 菜单栏装饰
  final BoxDecoration? decoration;

  /// 箭头图标
  final Widget? arrowIcon;

  /// 箭头颜色
  final Color? arrowColor;

  /// 标签栏对齐
  final TextAlign? tabBarAlign;

  /// 动画时长
  final Duration? duration;

  /// 是否可滚动
  final bool? isScrollable;

  const TDropdownThemeData({
    this.width,
    this.height,
    this.decoration,
    this.arrowIcon,
    this.arrowColor,
    this.tabBarAlign,
    this.duration,
    this.isScrollable,
  });

  TDropdownThemeData merge(TDropdownThemeData? other) {
    if (other == null) {
      return this;
    }
    return TDropdownThemeData(
      width: other.width ?? width,
      height: other.height ?? height,
      decoration: other.decoration ?? decoration,
      arrowIcon: other.arrowIcon ?? arrowIcon,
      arrowColor: other.arrowColor ?? arrowColor,
      tabBarAlign: other.tabBarAlign ?? tabBarAlign,
      duration: other.duration ?? duration,
      isScrollable: other.isScrollable ?? isScrollable,
    );
  }

  @override
  TDropdownThemeData copyWith({
    double? width,
    double? height,
    BoxDecoration? decoration,
    Widget? arrowIcon,
    Color? arrowColor,
    TextAlign? tabBarAlign,
    Duration? duration,
    bool? isScrollable,
  }) {
    return TDropdownThemeData(
      width: width ?? this.width,
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      arrowIcon: arrowIcon ?? this.arrowIcon,
      arrowColor: arrowColor ?? this.arrowColor,
      tabBarAlign: tabBarAlign ?? this.tabBarAlign,
      duration: duration ?? this.duration,
      isScrollable: isScrollable ?? this.isScrollable,
    );
  }

  @override
  TDropdownThemeData lerp(ThemeExtension<TDropdownThemeData>? other, double t) {
    if (other is! TDropdownThemeData) {
      return this;
    }
    return TDropdownThemeData(
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      decoration: t < 0.5 ? decoration : other.decoration,
      arrowIcon: t < 0.5 ? arrowIcon : other.arrowIcon,
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t),
      tabBarAlign: t < 0.5 ? tabBarAlign : other.tabBarAlign,
      duration: t < 0.5 ? duration : other.duration,
      isScrollable: t < 0.5 ? isScrollable : other.isScrollable,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
