import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TCascader 组件级 ThemeExtension
class TCascaderThemeData extends ThemeExtension<TCascaderThemeData> {
  /// 展示风格
  final TCascaderVariant? variant;

  /// 列视窗高度
  final double? columnHeight;

  /// 背景颜色
  final Color? panelColor;

  /// 面板圆角
  final double? panelRadius;

  /// 标题文案
  final String? title;

  const TCascaderThemeData({
    this.variant,
    this.columnHeight,
    this.panelColor,
    this.panelRadius,
    this.title,
  });

  @override
  TCascaderThemeData copyWith({
    TCascaderVariant? variant,
    double? columnHeight,
    Color? panelColor,
    double? panelRadius,
    String? title,
  }) {
    return TCascaderThemeData(
      variant: variant ?? this.variant,
      columnHeight: columnHeight ?? this.columnHeight,
      panelColor: panelColor ?? this.panelColor,
      panelRadius: panelRadius ?? this.panelRadius,
      title: title ?? this.title,
    );
  }

  @override
  TCascaderThemeData lerp(ThemeExtension<TCascaderThemeData>? other, double t) {
    if (other is! TCascaderThemeData) {
      return this;
    }
    return TCascaderThemeData(
      variant: t < 0.5 ? variant : other.variant,
      columnHeight: lerpDouble(columnHeight, other.columnHeight, t),
      panelColor: Color.lerp(panelColor, other.panelColor, t),
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      title: t < 0.5 ? title : other.title,
    );
  }
}

/// 级联选择器形态
enum TCascaderVariant { step, tab }
