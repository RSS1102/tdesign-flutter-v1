import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TTimeCounter;
import 't_time_counter.dart' show TTimeCounter;
import 't_time_counter_style.dart' show TTimeCounterVariant, TTimeCounterSize;

/// 计时组件级 ThemeExtension
class TTimeCounterThemeData extends ThemeExtension<TTimeCounterThemeData> {
  /// 未传 [TTimeCounter.theme] 时的默认风格
  final TTimeCounterVariant? theme;

  /// 尺寸
  final TTimeCounterSize? size;

  /// 是否开启毫秒级渲染
  final bool? millisecond;

  /// 使用时间单位分割
  final bool? splitWithUnit;

  const TTimeCounterThemeData({
    this.theme,
    this.size,
    this.millisecond,
    this.splitWithUnit,
  });

  @override
  TTimeCounterThemeData copyWith({
    TTimeCounterVariant? theme,
    TTimeCounterSize? size,
    bool? millisecond,
    bool? splitWithUnit,
  }) {
    return TTimeCounterThemeData(
      theme: theme ?? this.theme,
      size: size ?? this.size,
      millisecond: millisecond ?? this.millisecond,
      splitWithUnit: splitWithUnit ?? this.splitWithUnit,
    );
  }

  @override
  TTimeCounterThemeData lerp(ThemeExtension<TTimeCounterThemeData>? other, double t) {
    if (other is! TTimeCounterThemeData) {
      return this;
    }
    return TTimeCounterThemeData(
      theme: t < 0.5 ? theme : other.theme,
      size: t < 0.5 ? size : other.size,
      millisecond: t < 0.5 ? millisecond : other.millisecond,
      splitWithUnit: t < 0.5 ? splitWithUnit : other.splitWithUnit,
    );
  }
}
