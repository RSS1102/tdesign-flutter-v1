import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 表格组件级 ThemeExtension
class TTableThemeData extends ThemeExtension<TTableThemeData> {
  /// 是否显示表格边框
  final bool? bordered;

  /// 是否显示斑马纹
  final bool? stripe;

  /// 行高
  final double? rowHeight;

  /// 表格高度
  final double? height;

  /// 表格宽度
  final double? width;

  /// 背景色
  final Color? backgroundColor;

  /// 默认排序
  final dynamic defaultSort;

  /// 自定义加载中状态
  final Widget? loadingWidget;

  /// 加载中状态
  final bool? loading;

  const TTableThemeData({
    this.bordered,
    this.stripe,
    this.rowHeight,
    this.height,
    this.width,
    this.backgroundColor,
    this.defaultSort,
    this.loadingWidget,
    this.loading,
  });

  @override
  TTableThemeData copyWith({
    bool? bordered,
    bool? stripe,
    double? rowHeight,
    double? height,
    double? width,
    Color? backgroundColor,
    dynamic defaultSort,
    Widget? loadingWidget,
    bool? loading,
  }) {
    return TTableThemeData(
      bordered: bordered ?? this.bordered,
      stripe: stripe ?? this.stripe,
      rowHeight: rowHeight ?? this.rowHeight,
      height: height ?? this.height,
      width: width ?? this.width,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      defaultSort: defaultSort ?? this.defaultSort,
      loadingWidget: loadingWidget ?? this.loadingWidget,
      loading: loading ?? this.loading,
    );
  }

  @override
  TTableThemeData lerp(ThemeExtension<TTableThemeData>? other, double t) {
    if (other is! TTableThemeData) {
      return this;
    }
    return TTableThemeData(
      bordered: t < 0.5 ? bordered : other.bordered,
      stripe: t < 0.5 ? stripe : other.stripe,
      rowHeight: lerpDouble(rowHeight, other.rowHeight, t),
      height: lerpDouble(height, other.height, t),
      width: lerpDouble(width, other.width, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      defaultSort: t < 0.5 ? defaultSort : other.defaultSort,
      loadingWidget: t < 0.5 ? loadingWidget : other.loadingWidget,
      loading: t < 0.5 ? loading : other.loading,
    );
  }
}
