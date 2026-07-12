import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TPicker 组件级 ThemeExtension
///
/// 被 TPicker 和 TDateTimePicker 共用。
class TPickerThemeData extends ThemeExtension<TPickerThemeData> {
  /// 滚轮视窗高度（像素）
  final double? height;

  /// 每屏显示项数
  final int? itemCount;

  /// 列滚动结束回调默认
  final void Function(int col, dynamic value)? onColumnScrollEnd;

  const TPickerThemeData({
    this.height,
    this.itemCount,
    this.onColumnScrollEnd,
  });

  @override
  TPickerThemeData copyWith({
    double? height,
    int? itemCount,
    void Function(int col, dynamic value)? onColumnScrollEnd,
  }) {
    return TPickerThemeData(
      height: height ?? this.height,
      itemCount: itemCount ?? this.itemCount,
      onColumnScrollEnd: onColumnScrollEnd ?? this.onColumnScrollEnd,
    );
  }

  @override
  TPickerThemeData lerp(ThemeExtension<TPickerThemeData>? other, double t) {
    if (other is! TPickerThemeData) {
      return this;
    }
    return TPickerThemeData(
      height: lerpDouble(height, other.height, t),
      itemCount: t < 0.5 ? itemCount : other.itemCount,
    );
  }
}
