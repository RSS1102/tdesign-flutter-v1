import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TBackTop;

import 't_backtop.dart' show TBackTop;

/// 返回顶部形状
enum TBackTopShape {
  /// 圆形
  circle,

  /// 半圆形
  halfCircle,
}

/// 返回顶部配色方案
enum TBackTopColorScheme {
  /// 明亮配色
  light,

  /// 暗黑配色
  dark,
}

/// 返回顶部组件 ThemeExtension
///
/// 管理 TBackTop 的子树级默认样式（形状、配色、显隐阈值、定位偏移等）。
/// 构造器参数优先级高于 ThemeData。
class TBackTopThemeData extends ThemeExtension<TBackTopThemeData> {
  /// 默认形状（circle / halfCircle）
  final TBackTopShape? shape;

  /// 默认配色方案（light / dark）
  final TBackTopColorScheme? colorScheme;

  /// 默认显示阈值（未传 [TBackTop.visibilityOffset] 时，滚动偏移 ≥ 此值才显示）
  final double? defaultVisibilityOffset;

  /// 默认距屏幕右侧偏移（逻辑像素）
  final double? defaultRight;

  /// 默认距屏幕底部偏移（逻辑像素）
  final double? defaultBottom;

  /// 半圆形态右侧负 inset（吸收 0.2.x `right: -16` 硬编码）
  final double? halfCircleRightInset;

  const TBackTopThemeData({
    this.shape,
    this.colorScheme,
    this.defaultVisibilityOffset,
    this.defaultRight,
    this.defaultBottom,
    this.halfCircleRightInset,
  });

  @override
  TBackTopThemeData copyWith({
    TBackTopShape? shape,
    TBackTopColorScheme? colorScheme,
    double? defaultVisibilityOffset,
    double? defaultRight,
    double? defaultBottom,
    double? halfCircleRightInset,
  }) {
    return TBackTopThemeData(
      shape: shape ?? this.shape,
      colorScheme: colorScheme ?? this.colorScheme,
      defaultVisibilityOffset:
          defaultVisibilityOffset ?? this.defaultVisibilityOffset,
      defaultRight: defaultRight ?? this.defaultRight,
      defaultBottom: defaultBottom ?? this.defaultBottom,
      halfCircleRightInset:
          halfCircleRightInset ?? this.halfCircleRightInset,
    );
  }

  @override
  TBackTopThemeData lerp(ThemeExtension<TBackTopThemeData>? other, double t) {
    if (other is! TBackTopThemeData) {
      return this;
    }
    return TBackTopThemeData(
      shape: t < 0.5 ? shape : other.shape,
      colorScheme: t < 0.5 ? colorScheme : other.colorScheme,
      defaultVisibilityOffset: lerpDouble(
          defaultVisibilityOffset, other.defaultVisibilityOffset, t),
      defaultRight: lerpDouble(defaultRight, other.defaultRight, t),
      defaultBottom: lerpDouble(defaultBottom, other.defaultBottom, t),
      halfCircleRightInset:
          lerpDouble(halfCircleRightInset, other.halfCircleRightInset, t),
    );
  }
}
