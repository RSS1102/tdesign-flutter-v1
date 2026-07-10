import 'package:flutter/material.dart';

import 't_collapse.dart' show TCollapseMode, TCollapse;

/// 折叠面板组件级 ThemeExtension
class TCollapseThemeData extends ThemeExtension<TCollapseThemeData> {
  /// 未传 [TCollapse.mode] 时的默认模式
  final TCollapseMode? mode;

  /// 面板风格（block/card）
  final String? style;

  /// 默认面板背景色
  final Color? backgroundColor;

  /// 动画时长
  final Duration? animationDuration;

  /// 阴影
  final double? elevation;

  const TCollapseThemeData({
    this.mode,
    this.style,
    this.backgroundColor,
    this.animationDuration,
    this.elevation,
  });

  @override
  TCollapseThemeData copyWith({
    TCollapseMode? mode,
    String? style,
    Color? backgroundColor,
    Duration? animationDuration,
    double? elevation,
  }) {
    return TCollapseThemeData(
      mode: mode ?? this.mode,
      style: style ?? this.style,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      animationDuration: animationDuration ?? this.animationDuration,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  TCollapseThemeData lerp(ThemeExtension<TCollapseThemeData>? other, double t) {
    if (other is! TCollapseThemeData) {
      return this;
    }
    return TCollapseThemeData(
      mode: t < 0.5 ? mode : other.mode,
      style: t < 0.5 ? style : other.style,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      elevation: t < 0.5 ? elevation : other.elevation,
    );
  }
}
