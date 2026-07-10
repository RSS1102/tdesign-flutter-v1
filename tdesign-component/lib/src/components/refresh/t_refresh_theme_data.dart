import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TRefreshHeader;
import '../loading/t_loading.dart' show TLoadingIcon;
import 't_refresh_header.dart' show TRefreshHeader;

/// TRefreshHeader 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的下拉刷新默认样式。
/// 实例 [TRefreshHeader.themeData] 优先于 Theme Extension，Theme Extension 优先于内置默认值。
class TRefreshThemeData extends ThemeExtension<TRefreshThemeData> {
  /// loading 样式
  final TLoadingIcon? loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

  /// Header 容器高度
  final double? extent;

  /// 触发刷新任务的偏移量，同 triggerOffset
  final double? triggerDistance;

  /// 是否悬浮
  final bool? float;

  /// 完成延时
  final Duration? completeDuration;

  /// 无限刷新偏移量
  final double? infiniteOffset;

  /// 越界滚动（enableInfiniteRefresh 为 true 或 [infiniteOffset] 有值时生效）
  final bool? overScroll;

  const TRefreshThemeData({
    this.loadingIcon,
    this.backgroundColor,
    this.extent,
    this.triggerDistance,
    this.float,
    this.completeDuration,
    this.infiniteOffset,
    this.overScroll,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TRefreshThemeData merge(TRefreshThemeData? other) {
    if (other == null) {
      return this;
    }
    return TRefreshThemeData(
      loadingIcon: other.loadingIcon ?? loadingIcon,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      extent: other.extent ?? extent,
      triggerDistance: other.triggerDistance ?? triggerDistance,
      float: other.float ?? float,
      completeDuration: other.completeDuration ?? completeDuration,
      infiniteOffset: other.infiniteOffset ?? infiniteOffset,
      overScroll: other.overScroll ?? overScroll,
    );
  }

  @override
  TRefreshThemeData copyWith({
    TLoadingIcon? loadingIcon,
    Color? backgroundColor,
    double? extent,
    double? triggerDistance,
    bool? float,
    Duration? completeDuration,
    double? infiniteOffset,
    bool? overScroll,
  }) {
    return TRefreshThemeData(
      loadingIcon: loadingIcon ?? this.loadingIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      extent: extent ?? this.extent,
      triggerDistance: triggerDistance ?? this.triggerDistance,
      float: float ?? this.float,
      completeDuration: completeDuration ?? this.completeDuration,
      infiniteOffset: infiniteOffset ?? this.infiniteOffset,
      overScroll: overScroll ?? this.overScroll,
    );
  }

  @override
  TRefreshThemeData lerp(ThemeExtension<TRefreshThemeData>? other, double t) {
    if (other is! TRefreshThemeData) {
      return this;
    }
    return TRefreshThemeData(
      loadingIcon: t < 0.5 ? loadingIcon : other.loadingIcon,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      extent: lerpDouble(extent, other.extent, t),
      triggerDistance: lerpDouble(triggerDistance, other.triggerDistance, t),
      float: t < 0.5 ? float : other.float,
      completeDuration: t < 0.5 ? completeDuration : other.completeDuration,
      infiniteOffset: lerpDouble(infiniteOffset, other.infiniteOffset, t),
      overScroll: t < 0.5 ? overScroll : other.overScroll,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
