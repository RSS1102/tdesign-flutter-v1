import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TCalendar 组件级 ThemeExtension
class TCalendarThemeData extends ThemeExtension<TCalendarThemeData> {
  /// 日历选择模式
  final TCalendarVariant? defaultVariant;

  /// 每周第一天
  final int? firstDayOfWeek;

  /// 高度
  final double? height;

  const TCalendarThemeData({
    this.defaultVariant,
    this.firstDayOfWeek,
    this.height,
  });

  @override
  TCalendarThemeData copyWith({
    TCalendarVariant? defaultVariant,
    int? firstDayOfWeek,
    double? height,
  }) {
    return TCalendarThemeData(
      defaultVariant: defaultVariant ?? this.defaultVariant,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      height: height ?? this.height,
    );
  }

  @override
  TCalendarThemeData lerp(ThemeExtension<TCalendarThemeData>? other, double t) {
    if (other is! TCalendarThemeData) return this;
    return TCalendarThemeData(
      defaultVariant: t < 0.5 ? defaultVariant : other.defaultVariant,
      firstDayOfWeek: t < 0.5 ? firstDayOfWeek : other.firstDayOfWeek,
      height: lerpDouble(height, other.height, t),
    );
  }
}

/// 日历选择形态
enum TCalendarVariant { single, multiple, range }
