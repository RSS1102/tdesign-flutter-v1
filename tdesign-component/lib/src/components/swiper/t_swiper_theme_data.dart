import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 轮播指示器形态
enum TSwiperPaginationVariant { none, dots, dotsBar, fraction, controls }

/// 切换效果
enum TSwiperPageEffect { none, cardMargin, scaleAndFade }

/// 轮播组件级 ThemeExtension
class TSwiperThemeData extends ThemeExtension<TSwiperThemeData> {
  /// 未传 TSwiper.pagination 时的默认指示器形态
  final TSwiperPaginationVariant? pagination;

  /// 未传 TSwiper.pageEffect 时的默认切换效果
  final TSwiperPageEffect? pageEffect;

  /// 指示器外边距
  final EdgeInsetsGeometry? paginationMargin;

  /// 自动播放间隔
  final Duration? autoplayInterval;

  const TSwiperThemeData({
    this.pagination,
    this.pageEffect,
    this.paginationMargin,
    this.autoplayInterval,
  });

  @override
  TSwiperThemeData copyWith({
    TSwiperPaginationVariant? pagination,
    TSwiperPageEffect? pageEffect,
    EdgeInsetsGeometry? paginationMargin,
    Duration? autoplayInterval,
  }) {
    return TSwiperThemeData(
      pagination: pagination ?? this.pagination,
      pageEffect: pageEffect ?? this.pageEffect,
      paginationMargin: paginationMargin ?? this.paginationMargin,
      autoplayInterval: autoplayInterval ?? this.autoplayInterval,
    );
  }

  @override
  TSwiperThemeData lerp(ThemeExtension<TSwiperThemeData>? other, double t) {
    if (other is! TSwiperThemeData) {
      return this;
    }
    return TSwiperThemeData(
      pagination: t < 0.5 ? pagination : other.pagination,
      pageEffect: t < 0.5 ? pageEffect : other.pageEffect,
      paginationMargin:
          EdgeInsetsGeometry.lerp(paginationMargin, other.paginationMargin, t),
      autoplayInterval:
          t < 0.5 ? autoplayInterval : other.autoplayInterval,
    );
  }
}
