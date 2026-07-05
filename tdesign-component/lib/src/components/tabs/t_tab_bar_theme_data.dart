import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart';

/// TabBar 形态枚举（替代 0.2.x TTabBarOutlineType / TTabOutlineType）
enum TTabBarVariant {
  /// 填充样式
  filled,

  /// 胶囊样式
  capsule,

  /// 卡片
  card,
}

/// Tab 尺寸枚举（保留）
enum TTabSize {
  /// 大尺寸
  large,

  /// 小尺寸
  small,
}

/// TabBar 组件 ThemeExtension
///
/// 管理 TTabBar / TTab / TTabBarView 的子树级默认样式。
class TTabBarThemeData extends ThemeExtension<TTabBarThemeData> {
  // ---- TTabBar 级 ----
  final Decoration? decoration;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double? indicatorHeight;
  final double? indicatorWidth;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final bool? isScrollable;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final double? height;
  final EdgeInsets? indicatorPadding;
  final EdgeInsetsGeometry? labelPadding;
  final Decoration? indicator;
  final bool? showIndicator;
  final ScrollPhysics? physics;
  final TTabBarVariant? variant;
  final Color? dividerColor;
  final double? dividerHeight;
  final Color? selectedBgColor;
  final Color? unSelectedBgColor;
  final TabAlignment? tabAlignment;

  // ---- TTab 级 ----
  final EdgeInsetsGeometry? iconMargin;
  final EdgeInsetsGeometry? textMargin;
  final double? contentHeight;

  // ---- TTabBarView 级 ----
  final ScrollPhysics? defaultPhysics;

  const TTabBarThemeData({
    this.decoration,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorHeight,
    this.indicatorWidth,
    this.labelColor,
    this.unselectedLabelColor,
    this.isScrollable,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.height,
    this.indicatorPadding,
    this.labelPadding,
    this.indicator,
    this.showIndicator,
    this.physics,
    this.variant,
    this.dividerColor,
    this.dividerHeight,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.tabAlignment,
    this.iconMargin,
    this.textMargin,
    this.contentHeight,
    this.defaultPhysics,
  });

  @override
  TTabBarThemeData copyWith({
    Decoration? decoration,
    Color? backgroundColor,
    Color? indicatorColor,
    double? indicatorHeight,
    double? indicatorWidth,
    Color? labelColor,
    Color? unselectedLabelColor,
    bool? isScrollable,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    double? height,
    EdgeInsets? indicatorPadding,
    EdgeInsetsGeometry? labelPadding,
    Decoration? indicator,
    bool? showIndicator,
    ScrollPhysics? physics,
    TTabBarVariant? variant,
    Color? dividerColor,
    double? dividerHeight,
    Color? selectedBgColor,
    Color? unSelectedBgColor,
    TabAlignment? tabAlignment,
    EdgeInsetsGeometry? iconMargin,
    EdgeInsetsGeometry? textMargin,
    double? contentHeight,
    ScrollPhysics? defaultPhysics,
  }) {
    return TTabBarThemeData(
      decoration: decoration ?? this.decoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorHeight: indicatorHeight ?? this.indicatorHeight,
      indicatorWidth: indicatorWidth ?? this.indicatorWidth,
      labelColor: labelColor ?? this.labelColor,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      isScrollable: isScrollable ?? this.isScrollable,
      labelStyle: labelStyle ?? this.labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      height: height ?? this.height,
      indicatorPadding: indicatorPadding ?? this.indicatorPadding,
      labelPadding: labelPadding ?? this.labelPadding,
      indicator: indicator ?? this.indicator,
      showIndicator: showIndicator ?? this.showIndicator,
      physics: physics ?? this.physics,
      variant: variant ?? this.variant,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      selectedBgColor: selectedBgColor ?? this.selectedBgColor,
      unSelectedBgColor: unSelectedBgColor ?? this.unSelectedBgColor,
      tabAlignment: tabAlignment ?? this.tabAlignment,
      iconMargin: iconMargin ?? this.iconMargin,
      textMargin: textMargin ?? this.textMargin,
      contentHeight: contentHeight ?? this.contentHeight,
      defaultPhysics: defaultPhysics ?? this.defaultPhysics,
    );
  }

  @override
  TTabBarThemeData lerp(ThemeExtension<TTabBarThemeData>? other, double t) {
    if (other is! TTabBarThemeData) {
      return this;
    }
    return TTabBarThemeData(
      decoration: t < 0.5 ? decoration : other.decoration,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      indicatorHeight: lerpDouble(indicatorHeight, other.indicatorHeight, t),
      indicatorWidth: lerpDouble(indicatorWidth, other.indicatorWidth, t),
      labelColor: Color.lerp(labelColor, other.labelColor, t),
      unselectedLabelColor:
          Color.lerp(unselectedLabelColor, other.unselectedLabelColor, t),
      isScrollable: t < 0.5 ? isScrollable : other.isScrollable,
      labelStyle: t < 0.5 ? labelStyle : other.labelStyle,
      unselectedLabelStyle:
          t < 0.5 ? unselectedLabelStyle : other.unselectedLabelStyle,
      height: lerpDouble(height, other.height, t),
      indicatorPadding: t < 0.5 ? indicatorPadding : other.indicatorPadding,
      labelPadding: t < 0.5 ? labelPadding : other.labelPadding,
      indicator: t < 0.5 ? indicator : other.indicator,
      showIndicator: t < 0.5 ? showIndicator : other.showIndicator,
      physics: t < 0.5 ? physics : other.physics,
      variant: t < 0.5 ? variant : other.variant,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      dividerHeight: lerpDouble(dividerHeight, other.dividerHeight, t),
      selectedBgColor: Color.lerp(selectedBgColor, other.selectedBgColor, t),
      unSelectedBgColor:
          Color.lerp(unSelectedBgColor, other.unSelectedBgColor, t),
      tabAlignment: t < 0.5 ? tabAlignment : other.tabAlignment,
      iconMargin: t < 0.5 ? iconMargin : other.iconMargin,
      textMargin: t < 0.5 ? textMargin : other.textMargin,
      contentHeight: lerpDouble(contentHeight, other.contentHeight, t),
      defaultPhysics: t < 0.5 ? defaultPhysics : other.defaultPhysics,
    );
  }
}
