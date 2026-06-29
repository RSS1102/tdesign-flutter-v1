import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_skeleton.dart' show TSkeletonVariant, TSkeletonAnimation;

/// 骨架屏组件级 ThemeExtension
class TSkeletonThemeData extends ThemeExtension<TSkeletonThemeData> {
  /// 未传 [TSkeleton.variant] 时的默认形态
  final TSkeletonVariant? variant;

  /// 动画效果
  final TSkeletonAnimation? animation;

  /// 延迟显示加载时间（毫秒）
  final int? delay;

  const TSkeletonThemeData({
    this.variant,
    this.animation,
    this.delay,
  });

  @override
  TSkeletonThemeData copyWith({
    TSkeletonVariant? variant,
    TSkeletonAnimation? animation,
    int? delay,
  }) {
    return TSkeletonThemeData(
      variant: variant ?? this.variant,
      animation: animation ?? this.animation,
      delay: delay ?? this.delay,
    );
  }

  @override
  TSkeletonThemeData lerp(ThemeExtension<TSkeletonThemeData>? other, double t) {
    if (other is! TSkeletonThemeData) return this;
    return TSkeletonThemeData(
      variant: t < 0.5 ? variant : other.variant,
      animation: t < 0.5 ? animation : other.animation,
      delay: t < 0.5 ? delay : other.delay,
    );
  }
}
