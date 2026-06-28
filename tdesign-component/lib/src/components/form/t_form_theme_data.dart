import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TForm 组件级 ThemeExtension
class TFormThemeData extends ThemeExtension<TFormThemeData> {
  /// 是否显示冒号
  final bool? showColon;

  /// 默认标签宽度
  final double? labelWidth;

  /// 布局方向（true=水平, false=垂直）
  final bool? layout;

  /// 标签对齐方式
  final TextAlign? labelAlign;

  /// 内容对齐方式
  final TextAlign? contentAlign;

  /// 默认背景色
  final Color? backgroundColor;

  const TFormThemeData({
    this.showColon,
    this.labelWidth,
    this.layout,
    this.labelAlign,
    this.contentAlign,
    this.backgroundColor,
  });

  @override
  TFormThemeData copyWith({
    bool? showColon,
    double? labelWidth,
    bool? layout,
    TextAlign? labelAlign,
    TextAlign? contentAlign,
    Color? backgroundColor,
  }) {
    return TFormThemeData(
      showColon: showColon ?? this.showColon,
      labelWidth: labelWidth ?? this.labelWidth,
      layout: layout ?? this.layout,
      labelAlign: labelAlign ?? this.labelAlign,
      contentAlign: contentAlign ?? this.contentAlign,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  TFormThemeData lerp(ThemeExtension<TFormThemeData>? other, double t) {
    if (other is! TFormThemeData) return this;
    return TFormThemeData(
      showColon: t < 0.5 ? showColon : other.showColon,
      labelWidth: lerpDouble(labelWidth, other.labelWidth, t),
      layout: t < 0.5 ? layout : other.layout,
      labelAlign: t < 0.5 ? labelAlign : other.labelAlign,
      contentAlign: t < 0.5 ? contentAlign : other.contentAlign,
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t),
    );
  }
}
