import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TPopupOptions;

import 't_popup.dart' show TPopupOptions;

/// TPopup 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认浮层样式。
/// 实例 [TPopupOptions] 的对应字段优先于 Theme Extension。
class TPopupThemeData extends ThemeExtension<TPopupThemeData> {
  /// 蒙层颜色（对应 [TPopupOptions.overlayColor] 的默认值）
  final Color? barrierColor;

  /// 蒙层透明度系数（对应 [TPopupOptions.overlayOpacity] 的默认值）
  final double? barrierOpacity;

  /// 打开/关闭动画时长（对应 [TPopupOptions.animationDuration] 的默认值）
  final Duration? transitionDuration;

  /// 内容区圆角（对应 [TPopupOptions.radius] 的默认值）
  final double? panelRadius;

  /// 内容区背景色（对应 [TPopupOptions.backgroundColor] 的默认值）
  final Color? panelBackgroundColor;

  /// 是否避让系统安全区（对应 [TPopupOptions.useSafeArea] 的默认值）
  final bool? useSafeArea;

  /// bottom 头部取消文案
  final String? cancelText;

  /// bottom 头部确认文案
  final String? confirmText;

  const TPopupThemeData({
    this.barrierColor,
    this.barrierOpacity,
    this.transitionDuration,
    this.panelRadius,
    this.panelBackgroundColor,
    this.useSafeArea,
    this.cancelText,
    this.confirmText,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TPopupThemeData merge(TPopupThemeData? other) {
    if (other == null) {
      return this;
    }
    return TPopupThemeData(
      barrierColor: other.barrierColor ?? barrierColor,
      barrierOpacity: other.barrierOpacity ?? barrierOpacity,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      panelRadius: other.panelRadius ?? panelRadius,
      panelBackgroundColor: other.panelBackgroundColor ?? panelBackgroundColor,
      useSafeArea: other.useSafeArea ?? useSafeArea,
      cancelText: other.cancelText ?? cancelText,
      confirmText: other.confirmText ?? confirmText,
    );
  }

  @override
  TPopupThemeData copyWith({
    Color? barrierColor,
    double? barrierOpacity,
    Duration? transitionDuration,
    double? panelRadius,
    Color? panelBackgroundColor,
    bool? useSafeArea,
    String? cancelText,
    String? confirmText,
  }) {
    return TPopupThemeData(
      barrierColor: barrierColor ?? this.barrierColor,
      barrierOpacity: barrierOpacity ?? this.barrierOpacity,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      panelRadius: panelRadius ?? this.panelRadius,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      useSafeArea: useSafeArea ?? this.useSafeArea,
      cancelText: cancelText ?? this.cancelText,
      confirmText: confirmText ?? this.confirmText,
    );
  }

  @override
  TPopupThemeData lerp(ThemeExtension<TPopupThemeData>? other, double t) {
    if (other is! TPopupThemeData) {
      return this;
    }
    return TPopupThemeData(
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      barrierOpacity: lerpDouble(barrierOpacity, other.barrierOpacity, t),
      transitionDuration:
          t < 0.5 ? transitionDuration : other.transitionDuration,
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      panelBackgroundColor:
          Color.lerp(panelBackgroundColor, other.panelBackgroundColor, t),
      useSafeArea: t < 0.5 ? useSafeArea : other.useSafeArea,
      cancelText: t < 0.5 ? cancelText : other.cancelText,
      confirmText: t < 0.5 ? confirmText : other.confirmText,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
