import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_slider_theme.dart';

/// 基于 Material [Slider] 的严格受控单值滑块。
class TSlider extends StatelessWidget {
  const TSlider({
    super.key,

    /// 受控滑块值。
    required this.value,

    /// 值变更回调；为 null 时禁用。
    this.onChanged,

    /// 开始拖动时触发。
    this.onChangeStart,

    /// 结束拖动时触发。
    this.onChangeEnd,

    /// 最小值。
    this.min = 0,

    /// 最大值。
    this.max = 1,

    /// 离散刻度数；null 表示连续。
    this.divisions,
  })  : assert(max > min),
        assert(value >= min && value <= max),
        assert(divisions == null || divisions > 0);

  /// 受控滑块值。
  final double value;

  /// 值变更回调；为 null 时禁用。
  final ValueChanged<double>? onChanged;

  /// 开始拖动时触发。
  final ValueChanged<double>? onChangeStart;

  /// 结束拖动时触发。
  final ValueChanged<double>? onChangeEnd;

  /// 最小值。
  final double min;

  /// 最大值。
  final double max;

  /// 离散刻度数；null 表示连续。
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    final slider = _TSliderDefaults(
      child: Slider(
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
      ),
    );
    return _TSliderDecoration(child: slider);
  }
}

class _TSliderDecoration extends StatelessWidget {
  const _TSliderDecoration({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final decoration =
        Theme.of(context).extension<TSliderThemeData>()?.decoration;
    return decoration == null
        ? child
        : DecoratedBox(decoration: decoration, child: child);
  }
}

class _TSliderDefaults extends StatelessWidget {
  const _TSliderDefaults({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    final inherited = context.dependOnInheritedWidgetOfExactType<SliderTheme>();
    final base = inherited?.data ?? Theme.of(context).sliderTheme;
    final useTokenDefaults = inherited == null;
    return SliderTheme(
      data: base.copyWith(
        trackHeight: base.trackHeight ?? 4,
        activeTrackColor: useTokenDefaults
            ? token.brandNormalColor
            : base.activeTrackColor ?? token.brandNormalColor,
        inactiveTrackColor: useTokenDefaults
            ? token.bgColorComponent
            : base.inactiveTrackColor ?? token.bgColorComponent,
        disabledActiveTrackColor: useTokenDefaults
            ? token.brandDisabledColor
            : base.disabledActiveTrackColor ?? token.brandDisabledColor,
        disabledInactiveTrackColor: useTokenDefaults
            ? token.bgColorComponentDisabled
            : base.disabledInactiveTrackColor ??
                token.bgColorComponentDisabled,
        activeTickMarkColor: useTokenDefaults
            ? token.brandNormalColor
            : base.activeTickMarkColor ?? token.brandNormalColor,
        inactiveTickMarkColor: useTokenDefaults
            ? token.bgColorComponent
            : base.inactiveTickMarkColor ?? token.bgColorComponent,
        disabledActiveTickMarkColor: useTokenDefaults
            ? token.brandDisabledColor
            : base.disabledActiveTickMarkColor ?? token.brandDisabledColor,
        disabledInactiveTickMarkColor: useTokenDefaults
            ? token.bgColorComponentDisabled
            : base.disabledInactiveTickMarkColor ??
                token.bgColorComponentDisabled,
        thumbColor: useTokenDefaults ? Colors.white : base.thumbColor ?? Colors.white,
        disabledThumbColor: useTokenDefaults
            ? token.bgColorSecondaryContainer
            : base.disabledThumbColor ?? token.bgColorSecondaryContainer,
        overlappingShapeStrokeColor: useTokenDefaults
            ? token.componentStrokeColor
            : base.overlappingShapeStrokeColor ?? token.componentStrokeColor,
      ),
      child: child,
    );
  }
}

/// 基于 Material [RangeSlider] 的严格受控范围滑块。
class TRangeSlider extends StatelessWidget {
  const TRangeSlider({
    super.key,

    /// 受控范围值。
    required this.value,

    /// 范围变更回调；为 null 时禁用。
    this.onChanged,

    /// 开始拖动时触发。
    this.onChangeStart,

    /// 结束拖动时触发。
    this.onChangeEnd,

    /// 最小值。
    this.min = 0,

    /// 最大值。
    this.max = 1,

    /// 离散刻度数；null 表示连续。
    this.divisions,
  })  : assert(max > min),
        assert(divisions == null || divisions > 0);

  /// 受控范围值。
  final RangeValues value;

  /// 范围变更回调；为 null 时禁用。
  final ValueChanged<RangeValues>? onChanged;

  /// 开始拖动时触发。
  final ValueChanged<RangeValues>? onChangeStart;

  /// 结束拖动时触发。
  final ValueChanged<RangeValues>? onChangeEnd;

  /// 最小值。
  final double min;

  /// 最大值。
  final double max;

  /// 离散刻度数；null 表示连续。
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    final slider = _TSliderDefaults(
      child: RangeSlider(
        values: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
      ),
    );
    return _TSliderDecoration(child: slider);
  }
}
