import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TUpload 组件级 ThemeExtension
class TUploadThemeData extends ThemeExtension<TUploadThemeData> {
  /// 类型
  final TUploadVariant? variant;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 横向间距
  final double? wrapSpacing;

  /// 纵向间距
  final double? wrapRunSpacing;

  /// 对齐方式
  final WrapAlignment? wrapAlignment;

  const TUploadThemeData({
    this.variant,
    this.width,
    this.height,
    this.wrapSpacing,
    this.wrapRunSpacing,
    this.wrapAlignment,
  });

  @override
  TUploadThemeData copyWith({
    TUploadVariant? variant,
    double? width,
    double? height,
    double? wrapSpacing,
    double? wrapRunSpacing,
    WrapAlignment? wrapAlignment,
  }) {
    return TUploadThemeData(
      variant: variant ?? this.variant,
      width: width ?? this.width,
      height: height ?? this.height,
      wrapSpacing: wrapSpacing ?? this.wrapSpacing,
      wrapRunSpacing: wrapRunSpacing ?? this.wrapRunSpacing,
      wrapAlignment: wrapAlignment ?? this.wrapAlignment,
    );
  }

  @override
  TUploadThemeData lerp(ThemeExtension<TUploadThemeData>? other, double t) {
    if (other is! TUploadThemeData) return this;
    return TUploadThemeData(
      variant: t < 0.5 ? variant : other.variant,
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      wrapSpacing: lerpDouble(wrapSpacing, other.wrapSpacing, t),
      wrapRunSpacing: lerpDouble(wrapRunSpacing, other.wrapRunSpacing, t),
      wrapAlignment: t < 0.5 ? wrapAlignment : other.wrapAlignment,
    );
  }
}

/// 上传展示形态
enum TUploadVariant { roundedSquare, circle }
