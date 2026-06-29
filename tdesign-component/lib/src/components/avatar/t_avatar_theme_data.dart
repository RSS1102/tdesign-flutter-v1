import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_avatar.dart' show TAvatarVariant, TAvatarShape;

/// 头像组件级 ThemeExtension
class TAvatarThemeData extends ThemeExtension<TAvatarThemeData> {
  /// 未传 [TAvatar.variant] 时的默认形态
  final TAvatarVariant? variant;

  /// 头像形状
  final TAvatarShape? shape;

  /// 自定义圆角
  final double? radius;

  /// 自定义头像大小
  final double? avatarSize;

  /// 带操作展示的头像描边宽度
  final double? avatarDisplayBorder;

  /// 自定义文案时背景色
  final Color? backgroundColor;

  const TAvatarThemeData({
    this.variant,
    this.shape,
    this.radius,
    this.avatarSize,
    this.avatarDisplayBorder,
    this.backgroundColor,
  });

  @override
  TAvatarThemeData copyWith({
    TAvatarVariant? variant,
    TAvatarShape? shape,
    double? radius,
    double? avatarSize,
    double? avatarDisplayBorder,
    Color? backgroundColor,
  }) {
    return TAvatarThemeData(
      variant: variant ?? this.variant,
      shape: shape ?? this.shape,
      radius: radius ?? this.radius,
      avatarSize: avatarSize ?? this.avatarSize,
      avatarDisplayBorder: avatarDisplayBorder ?? this.avatarDisplayBorder,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  TAvatarThemeData lerp(ThemeExtension<TAvatarThemeData>? other, double t) {
    if (other is! TAvatarThemeData) return this;
    return TAvatarThemeData(
      variant: t < 0.5 ? variant : other.variant,
      shape: t < 0.5 ? shape : other.shape,
      radius: lerpDouble(radius, other.radius, t),
      avatarSize: lerpDouble(avatarSize, other.avatarSize, t),
      avatarDisplayBorder:
          lerpDouble(avatarDisplayBorder, other.avatarDisplayBorder, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
    );
  }
}
