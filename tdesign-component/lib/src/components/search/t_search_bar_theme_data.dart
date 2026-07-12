import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TSearchBar 组件级 ThemeExtension
class TSearchBarThemeData extends ThemeExtension<TSearchBarThemeData> {
  /// 默认样式
  final TSearchBarVariant? defaultStyle;

  /// 默认对齐方式
  final TSearchBarAlignment? defaultAlignment;

  /// 背景颜色
  final Color? backgroundColor;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 是否中型样式
  final bool? mediumStyle;

  /// 光标高度
  final double? cursorHeight;

  /// 是否自动高度
  final bool? autoHeight;

  const TSearchBarThemeData({
    this.defaultStyle,
    this.defaultAlignment,
    this.backgroundColor,
    this.padding,
    this.mediumStyle,
    this.cursorHeight,
    this.autoHeight,
  });

  @override
  TSearchBarThemeData copyWith({
    TSearchBarVariant? defaultStyle,
    TSearchBarAlignment? defaultAlignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    bool? mediumStyle,
    double? cursorHeight,
    bool? autoHeight,
  }) {
    return TSearchBarThemeData(
      defaultStyle: defaultStyle ?? this.defaultStyle,
      defaultAlignment: defaultAlignment ?? this.defaultAlignment,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      mediumStyle: mediumStyle ?? this.mediumStyle,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      autoHeight: autoHeight ?? this.autoHeight,
    );
  }

  @override
  TSearchBarThemeData lerp(
      ThemeExtension<TSearchBarThemeData>? other, double t) {
    if (other is! TSearchBarThemeData) {
      return this;
    }
    return TSearchBarThemeData(
      defaultStyle: t < 0.5 ? defaultStyle : other.defaultStyle,
      defaultAlignment:
          t < 0.5 ? defaultAlignment : other.defaultAlignment,
      backgroundColor:
          Color.lerp(backgroundColor, other.backgroundColor, t),
      cursorHeight:
          lerpDouble(cursorHeight, other.cursorHeight, t),
      mediumStyle: t < 0.5 ? mediumStyle : other.mediumStyle,
      autoHeight: t < 0.5 ? autoHeight : other.autoHeight,
    );
  }
}

/// 搜索框样式
enum TSearchBarVariant { square, round }

/// 搜索框对齐方式
enum TSearchBarAlignment { left, center }
