import 'dart:ui' as ui show TextHeightBehavior;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart';

/// TText 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认视觉样式。
/// 构造器参数优先于 Theme，P0 style 实例优先于构造器糖。
///
/// 用法：
/// ```dart
/// Theme.of(context).mergeExtension(
///   TTextThemeData(
///     defaultFont: Font(size: 18, lineHeight: 26),
///     forceVerticalCenter: true,
///   ),
/// )
/// ```
class TTextThemeData extends ThemeExtension<TTextThemeData> {
  /// 默认字体（包含字号和行高）
  final Font? defaultFont;

  /// 默认文本颜色
  final Color? defaultTextColor;

  /// 默认背景颜色
  final Color? defaultBackgroundColor;

  /// 是否默认启用强制垂直居中
  ///
  /// 替代 v0.2.x 的全局变量 kTextForceVerticalCenterEnable。
  /// 默认值为 false，可通过子树 mergeExtension 全局开启。
  final bool forceVerticalCenter;

  /// 是否默认显示删除线
  final bool isTextThrough;

  /// 删除线默认颜色（为 null 时使用前景色）
  final Color? lineThroughColor;

  /// 是否处于字体加载器中
  final bool isInFontLoader;

  /// 默认 strut 样式
  final StrutStyle? strutStyle;

  /// 默认文本宽度计算方式
  final TextWidthBasis? textWidthBasis;

  /// 默认文本高度行为（控制段落首尾行的 leading 裁剪等）
  ///
  /// 替代 v0.2.x 的 kTextNeedGlobalFontFamily 间接控制的部分行为，
  /// 以及原构造器上的 textHeightBehavior 参数。
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 默认文本缩放因子
  ///
  /// 用于统一控制子树的字体缩放，替代全局 MediaQuery 缩放。
  final double? textScaleFactor;

  const TTextThemeData({
    this.defaultFont,
    this.defaultTextColor,
    this.defaultBackgroundColor,
    this.forceVerticalCenter = false,
    this.isTextThrough = false,
    this.lineThroughColor,
    this.isInFontLoader = false,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.textScaleFactor,
  });

  @override
  TTextThemeData copyWith({
    Font? defaultFont,
    Color? defaultTextColor,
    Color? defaultBackgroundColor,
    bool? forceVerticalCenter,
    bool? isTextThrough,
    Color? lineThroughColor,
    bool? isInFontLoader,
    StrutStyle? strutStyle,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
    double? textScaleFactor,
  }) {
    return TTextThemeData(
      defaultFont: defaultFont ?? this.defaultFont,
      defaultTextColor: defaultTextColor ?? this.defaultTextColor,
      defaultBackgroundColor:
          defaultBackgroundColor ?? this.defaultBackgroundColor,
      forceVerticalCenter: forceVerticalCenter ?? this.forceVerticalCenter,
      isTextThrough: isTextThrough ?? this.isTextThrough,
      lineThroughColor: lineThroughColor ?? this.lineThroughColor,
      isInFontLoader: isInFontLoader ?? this.isInFontLoader,
      strutStyle: strutStyle ?? this.strutStyle,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }

  @override
  TTextThemeData lerp(ThemeExtension<TTextThemeData>? other, double t) {
    if (other is! TTextThemeData) {
      return this;
    }
    return TTextThemeData(
      defaultFont: t < 0.5 ? defaultFont : other.defaultFont,
      defaultTextColor:
          Color.lerp(defaultTextColor, other.defaultTextColor, t),
      defaultBackgroundColor: Color.lerp(
          defaultBackgroundColor, other.defaultBackgroundColor, t),
      forceVerticalCenter: t < 0.5 ? forceVerticalCenter : other.forceVerticalCenter,
      isTextThrough: t < 0.5 ? isTextThrough : other.isTextThrough,
      lineThroughColor:
          Color.lerp(lineThroughColor, other.lineThroughColor, t),
      isInFontLoader:
          t < 0.5 ? isInFontLoader : other.isInFontLoader,
      strutStyle: t < 0.5 ? strutStyle : other.strutStyle,
      textWidthBasis:
          t < 0.5 ? textWidthBasis : other.textWidthBasis,
      textHeightBehavior:
          t < 0.5 ? textHeightBehavior : other.textHeightBehavior,
      textScaleFactor: lerpDouble(textScaleFactor, other.textScaleFactor, t),
    );
  }
}
