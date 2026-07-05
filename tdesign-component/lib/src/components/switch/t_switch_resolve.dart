import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// TSwitch 样式解析器
class TSwitchResolve {
  TSwitchResolve._();

  /// 解析开关宽度
  static double getWidth(TSwitchSize size) {
    switch (size) {
      case TSwitchSize.large:
        return 52;
      case TSwitchSize.medium:
        return 45;
      case TSwitchSize.small:
        return 39;
    }
  }

  /// 解析开关高度
  static double getHeight(TSwitchSize size) {
    switch (size) {
      case TSwitchSize.large:
        return 32;
      case TSwitchSize.medium:
        return 28;
      case TSwitchSize.small:
        return 24;
    }
  }

  /// 解析轨道开启颜色
  static Color resolveTrackOnColor({
    required BuildContext context,
    TSwitchThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.trackOnColor != null) return theme!.trackOnColor!;
    return context.tTheme.brandNormalColor;
  }

  /// 解析轨道关闭颜色
  static Color resolveTrackOffColor({
    required BuildContext context,
    TSwitchThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.trackOffColor != null) return theme!.trackOffColor!;
    return context.tTheme.textDisabledColor;
  }

  /// 解析Thumb开启颜色
  static Color resolveThumbOnColor({
    required BuildContext context,
    TSwitchThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.thumbContentOnColor != null) {
      return theme!.thumbContentOnColor!;
    }
    return context.tTheme.brandNormalColor;
  }

  /// 解析Thumb关闭颜色
  static Color resolveThumbOffColor({
    required BuildContext context,
    TSwitchThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.thumbContentOffColor != null) {
      return theme!.thumbContentOffColor!;
    }
    return context.tTheme.textDisabledColor;
  }

  /// 解析Thumb开启字体样式
  static TextStyle resolveThumbOnFont({
    TSwitchThemeData? theme,
    TextStyle? instanceFont,
  }) {
    if (instanceFont != null) return instanceFont;
    return theme?.thumbContentOnFont ?? const TextStyle(fontSize: 14);
  }

  /// 解析Thumb关闭字体样式
  static TextStyle resolveThumbOffFont({
    TSwitchThemeData? theme,
    TextStyle? instanceFont,
  }) {
    if (instanceFont != null) return instanceFont;
    return theme?.thumbContentOffFont ?? const TextStyle(fontSize: 14);
  }
}
