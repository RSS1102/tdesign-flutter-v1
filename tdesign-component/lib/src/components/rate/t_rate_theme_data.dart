import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_rate.dart' show PlacementEnum;

/// TRate 组件级 ThemeExtension
class TRateThemeData extends ThemeExtension<TRateThemeData> {
  /// 是否允许半选
  final bool? allowHalf;

  /// 评分图标的颜色 [选中颜色, 未选中颜色]
  final List<Color>? color;

  /// 评分的数量
  final int? count;

  /// 间距
  final double? gap;

  /// 评分弹框位置
  final PlacementEnum? placement;

  /// 是否显示辅助文字
  final bool? showText;

  /// 辅助文字宽度
  final double? textWidth;

  /// 横向对齐
  final MainAxisAlignment? mainAxisAlignment;

  /// 纵向对齐
  final CrossAxisAlignment? crossAxisAlignment;

  /// 主轴尺寸
  final MainAxisSize? mainAxisSize;

  /// 图标与文字间距
  final double? iconTextGap;

  const TRateThemeData({
    this.allowHalf,
    this.color,
    this.count,
    this.gap,
    this.placement,
    this.showText,
    this.textWidth,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize,
    this.iconTextGap,
  });

  @override
  TRateThemeData copyWith({
    bool? allowHalf,
    List<Color>? color,
    int? count,
    double? gap,
    PlacementEnum? placement,
    bool? showText,
    double? textWidth,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    double? iconTextGap,
  }) {
    return TRateThemeData(
      allowHalf: allowHalf ?? this.allowHalf,
      color: color ?? this.color,
      count: count ?? this.count,
      gap: gap ?? this.gap,
      placement: placement ?? this.placement,
      showText: showText ?? this.showText,
      textWidth: textWidth ?? this.textWidth,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      iconTextGap: iconTextGap ?? this.iconTextGap,
    );
  }

  @override
  TRateThemeData lerp(ThemeExtension<TRateThemeData>? other, double t) {
    if (other is! TRateThemeData) {
      return this;
    }
    return TRateThemeData(
      allowHalf: t < 0.5 ? allowHalf : other.allowHalf,
      count: t < 0.5 ? count : other.count,
      gap: lerpDouble(gap, other.gap, t),
      placement: t < 0.5 ? placement : other.placement,
      showText: t < 0.5 ? showText : other.showText,
      textWidth: lerpDouble(textWidth, other.textWidth, t),
      mainAxisAlignment:
          t < 0.5 ? mainAxisAlignment : other.mainAxisAlignment,
      crossAxisAlignment:
          t < 0.5 ? crossAxisAlignment : other.crossAxisAlignment,
      mainAxisSize: t < 0.5 ? mainAxisSize : other.mainAxisSize,
      iconTextGap: lerpDouble(iconTextGap, other.iconTextGap, t),
    );
  }
}
