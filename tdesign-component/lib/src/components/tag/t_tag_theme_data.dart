import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_tag.dart' show TTagSize, TTagShape;

/// 标签语义色
enum TTagColorScheme {
  /// 默认
  defaultTheme,

  /// 常规
  primary,

  /// 警告
  warning,

  /// 危险
  danger,

  /// 成功
  success,
}

/// 标签组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
class TTagThemeData extends ThemeExtension<TTagThemeData> {
  /// 未传 [TTag.colorScheme] 时的默认语义色
  final TTagColorScheme? colorScheme;

  /// 是否为禁用状态（仅控制灰态样式，不阻止 onCloseTap）
  final bool? disable;

  /// 文字颜色
  final Color? textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 字体尺寸
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 自定义间距
  final EdgeInsets? padding;

  /// 是否强制中文文字居中
  final bool? forceVerticalCenter;

  /// 是否为描边类型
  final bool? isOutline;

  /// 标签形状
  final TTagShape? shape;

  /// 是否为浅色
  final bool? isLight;

  /// 是否显示关闭图标
  final bool? needCloseIcon;

  /// 文字溢出处理
  final TextOverflow? overflow;

  /// 标签固定宽度
  final double? fixedWidth;

  /// 自定义图标内容
  final Widget? iconWidget;

  const TTagThemeData({
    this.colorScheme,
    this.disable,
    this.textColor,
    this.backgroundColor,
    this.font,
    this.fontWeight,
    this.padding,
    this.forceVerticalCenter,
    this.isOutline,
    this.shape,
    this.isLight,
    this.needCloseIcon,
    this.overflow,
    this.fixedWidth,
    this.iconWidget,
  });

  @override
  TTagThemeData copyWith({
    TTagColorScheme? colorScheme,
    bool? disable,
    Color? textColor,
    Color? backgroundColor,
    Font? font,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    bool? forceVerticalCenter,
    bool? isOutline,
    TTagShape? shape,
    bool? isLight,
    bool? needCloseIcon,
    TextOverflow? overflow,
    double? fixedWidth,
    Widget? iconWidget,
  }) {
    return TTagThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      disable: disable ?? this.disable,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      font: font ?? this.font,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      forceVerticalCenter: forceVerticalCenter ?? this.forceVerticalCenter,
      isOutline: isOutline ?? this.isOutline,
      shape: shape ?? this.shape,
      isLight: isLight ?? this.isLight,
      needCloseIcon: needCloseIcon ?? this.needCloseIcon,
      overflow: overflow ?? this.overflow,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      iconWidget: iconWidget ?? this.iconWidget,
    );
  }

  @override
  TTagThemeData lerp(ThemeExtension<TTagThemeData>? other, double t) {
    if (other is! TTagThemeData) {
      return this;
    }
    return TTagThemeData(
      colorScheme: t < 0.5 ? colorScheme : other.colorScheme,
      disable: t < 0.5 ? disable : other.disable,
      textColor: Color.lerp(textColor, other.textColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      font: t < 0.5 ? font : other.font,
      fontWeight: t < 0.5 ? fontWeight : other.fontWeight,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) as EdgeInsets?,
      forceVerticalCenter: t < 0.5 ? forceVerticalCenter : other.forceVerticalCenter,
      isOutline: t < 0.5 ? isOutline : other.isOutline,
      shape: t < 0.5 ? shape : other.shape,
      isLight: t < 0.5 ? isLight : other.isLight,
      needCloseIcon: t < 0.5 ? needCloseIcon : other.needCloseIcon,
      overflow: t < 0.5 ? overflow : other.overflow,
      fixedWidth: lerpDouble(fixedWidth, other.fixedWidth, t),
      iconWidget: t < 0.5 ? iconWidget : other.iconWidget,
    );
  }
}
