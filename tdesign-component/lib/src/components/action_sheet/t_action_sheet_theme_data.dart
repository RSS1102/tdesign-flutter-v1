import 'package:flutter/material.dart';

import 't_action_sheet.dart' show TActionSheetAlign;

/// TActionSheet 组件级 ThemeExtension
class TActionSheetThemeData extends ThemeExtension<TActionSheetThemeData> {
  /// 取消按钮文案
  final String? cancelText;

  /// 是否显示取消按钮
  final bool? showCancelButton;

  /// 默认对齐
  final TActionSheetAlign? defaultAlign;

  /// 项高度
  final double? itemHeight;

  /// 项最小宽度
  final double? itemMinWidth;

  /// 宫格列数
  final int? count;

  /// 宫格行数
  final int? rows;

  /// 是否显示分页
  final bool? showPagination;

  /// 是否可滚动
  final bool? scrollable;

  /// 点击蒙层是否关闭
  final bool? barrierDismissible;

  /// 蒙层颜色
  final Color? barrierColor;

  /// 面板圆角
  final double? panelRadius;

  /// 是否避让安全区
  final bool? useSafeArea;

  const TActionSheetThemeData({
    this.cancelText,
    this.showCancelButton,
    this.defaultAlign,
    this.itemHeight,
    this.itemMinWidth,
    this.count,
    this.rows,
    this.showPagination,
    this.scrollable,
    this.barrierDismissible,
    this.barrierColor,
    this.panelRadius,
    this.useSafeArea,
  });

  TActionSheetThemeData merge(TActionSheetThemeData? other) {
    if (other == null) {
      return this;
    }
    return TActionSheetThemeData(
      cancelText: other.cancelText ?? cancelText,
      showCancelButton: other.showCancelButton ?? showCancelButton,
      defaultAlign: other.defaultAlign ?? defaultAlign,
      itemHeight: other.itemHeight ?? itemHeight,
      itemMinWidth: other.itemMinWidth ?? itemMinWidth,
      count: other.count ?? count,
      rows: other.rows ?? rows,
      showPagination: other.showPagination ?? showPagination,
      scrollable: other.scrollable ?? scrollable,
      barrierDismissible: other.barrierDismissible ?? barrierDismissible,
      barrierColor: other.barrierColor ?? barrierColor,
      panelRadius: other.panelRadius ?? panelRadius,
      useSafeArea: other.useSafeArea ?? useSafeArea,
    );
  }

  @override
  TActionSheetThemeData copyWith({
    String? cancelText,
    bool? showCancelButton,
    TActionSheetAlign? defaultAlign,
    double? itemHeight,
    double? itemMinWidth,
    int? count,
    int? rows,
    bool? showPagination,
    bool? scrollable,
    bool? barrierDismissible,
    Color? barrierColor,
    double? panelRadius,
    bool? useSafeArea,
  }) {
    return TActionSheetThemeData(
      cancelText: cancelText ?? this.cancelText,
      showCancelButton: showCancelButton ?? this.showCancelButton,
      defaultAlign: defaultAlign ?? this.defaultAlign,
      itemHeight: itemHeight ?? this.itemHeight,
      itemMinWidth: itemMinWidth ?? this.itemMinWidth,
      count: count ?? this.count,
      rows: rows ?? this.rows,
      showPagination: showPagination ?? this.showPagination,
      scrollable: scrollable ?? this.scrollable,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierColor: barrierColor ?? this.barrierColor,
      panelRadius: panelRadius ?? this.panelRadius,
      useSafeArea: useSafeArea ?? this.useSafeArea,
    );
  }

  @override
  TActionSheetThemeData lerp(ThemeExtension<TActionSheetThemeData>? other, double t) {
    if (other is! TActionSheetThemeData) {
      return this;
    }
    return TActionSheetThemeData(
      cancelText: t < 0.5 ? cancelText : other.cancelText,
      showCancelButton: t < 0.5 ? showCancelButton : other.showCancelButton,
      defaultAlign: t < 0.5 ? defaultAlign : other.defaultAlign,
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t),
      itemMinWidth: lerpDouble(itemMinWidth, other.itemMinWidth, t),
      count: t < 0.5 ? count : other.count,
      rows: t < 0.5 ? rows : other.rows,
      showPagination: t < 0.5 ? showPagination : other.showPagination,
      scrollable: t < 0.5 ? scrollable : other.scrollable,
      barrierDismissible: t < 0.5 ? barrierDismissible : other.barrierDismissible,
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      useSafeArea: t < 0.5 ? useSafeArea : other.useSafeArea,
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}
