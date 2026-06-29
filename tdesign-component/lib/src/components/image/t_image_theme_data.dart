import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_image.dart' show TImageVariant;

/// 图片组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
class TImageThemeData extends ThemeExtension<TImageThemeData> {
  /// 未传 [TImage.variant] 时的默认图片形态
  final TImageVariant? variant;

  /// 默认高度
  final double? height;

  /// 叠加色
  final Color? color;

  /// 透明度动画
  final Animation<double>? opacity;

  /// 颜色混合模式
  final BlendMode? colorBlendMode;

  /// 中心切片
  final Rect? centerSlice;

  /// 是否匹配文本方向
  final bool? matchTextDirection;

  /// 无缝播放
  final bool? gaplessPlayback;

  /// 是否排除语义
  final bool? excludeFromSemantics;

  /// 是否抗锯齿
  final bool? isAntiAlias;

  /// 解码缓存高度
  final int? cacheHeight;

  /// 解码缓存宽度
  final int? cacheWidth;

  const TImageThemeData({
    this.variant,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.centerSlice,
    this.matchTextDirection,
    this.gaplessPlayback,
    this.excludeFromSemantics,
    this.isAntiAlias,
    this.cacheHeight,
    this.cacheWidth,
  });

  @override
  TImageThemeData copyWith({
    TImageVariant? variant,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? excludeFromSemantics,
    bool? isAntiAlias,
    int? cacheHeight,
    int? cacheWidth,
  }) {
    return TImageThemeData(
      variant: variant ?? this.variant,
      height: height ?? this.height,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      centerSlice: centerSlice ?? this.centerSlice,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
      gaplessPlayback: gaplessPlayback ?? this.gaplessPlayback,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
      isAntiAlias: isAntiAlias ?? this.isAntiAlias,
      cacheHeight: cacheHeight ?? this.cacheHeight,
      cacheWidth: cacheWidth ?? this.cacheWidth,
    );
  }

  @override
  TImageThemeData lerp(ThemeExtension<TImageThemeData>? other, double t) {
    if (other is! TImageThemeData) {
      return this;
    }
    return TImageThemeData(
      variant: t < 0.5 ? variant : other.variant,
      height: lerpDouble(height, other.height, t),
      color: Color.lerp(color, other.color, t),
      opacity: t < 0.5 ? opacity : other.opacity,
      colorBlendMode: t < 0.5 ? colorBlendMode : other.colorBlendMode,
      centerSlice: Rect.lerp(centerSlice, other.centerSlice, t),
      matchTextDirection: t < 0.5 ? matchTextDirection : other.matchTextDirection,
      gaplessPlayback: t < 0.5 ? gaplessPlayback : other.gaplessPlayback,
      excludeFromSemantics:
          t < 0.5 ? excludeFromSemantics : other.excludeFromSemantics,
      isAntiAlias: t < 0.5 ? isAntiAlias : other.isAntiAlias,
      cacheHeight: lerpDouble(cacheHeight, other.cacheHeight, t)?.round(),
      cacheWidth: lerpDouble(cacheWidth, other.cacheWidth, t)?.round(),
    );
  }
}
