import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_stepper.dart' show TStepperSize;

/// TStepper 组件级 ThemeExtension
class TStepperThemeData extends ThemeExtension<TStepperThemeData> {
  /// 默认尺寸
  final TStepperSize? defaultSize;

  /// 默认配色方案
  final TStepperColorScheme? defaultColorScheme;

  /// 输入框宽度
  final double? inputWidth;

  const TStepperThemeData({
    this.defaultSize,
    this.defaultColorScheme,
    this.inputWidth,
  });

  @override
  TStepperThemeData copyWith({
    TStepperSize? defaultSize,
    TStepperColorScheme? defaultColorScheme,
    double? inputWidth,
  }) {
    return TStepperThemeData(
      defaultSize: defaultSize ?? this.defaultSize,
      defaultColorScheme: defaultColorScheme ?? this.defaultColorScheme,
      inputWidth: inputWidth ?? this.inputWidth,
    );
  }

  @override
  TStepperThemeData lerp(ThemeExtension<TStepperThemeData>? other, double t) {
    if (other is! TStepperThemeData) {
      return this;
    }
    return TStepperThemeData(
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      defaultColorScheme:
          t < 0.5 ? defaultColorScheme : other.defaultColorScheme,
      inputWidth: lerpDouble(inputWidth, other.inputWidth, t),
    );
  }
}

/// 步进器配色
enum TStepperColorScheme { normal, filled, outline }
