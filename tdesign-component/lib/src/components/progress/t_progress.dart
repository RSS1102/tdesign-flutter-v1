import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import './t_progress_circular.dart';

/// 进度条形态
enum TProgressVariant { linear, circular, micro, button }

/// 标签位置
enum TProgressLabelPosition { inside, left, right }

abstract class TLabelWidget extends Widget {
  const TLabelWidget({super.key});
}

class TTextLabel extends Text implements TLabelWidget {
  const TTextLabel(
    String data, {
    Key? key,
    TextStyle? style,
  }) : super(data, key: key, style: style);
}

class TIconLabel extends Icon implements TLabelWidget {
  const TIconLabel(
    IconData icon, {
    Key? key,
    double? size,
    Color? color,
  }) : super(icon, key: key, size: size, color: color);
}

class TProgress extends StatelessWidget {
  TProgress({
    Key? key,
    required this.variant,
    double? value,
    this.label,
    this.onPressed,
  })  : value = _validateProgress(value),
        super(key: key);

  /// 进度条形态
  final TProgressVariant variant;

  /// 进度值（0.0 到 1.0 之间的正数）
  final double? value;

  /// 进度条标签
  final TLabelWidget? label;

  /// 点击事件
  final VoidCallback? onPressed;

  static double? _validateProgress(double? value) =>
      value == null ? 0 : value.clamp(0.0, 1.0);

  /// 从 Theme 子树读取 L4 默认值
  TProgressThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TProgressThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final defaultValues = _getDefaultValues(context, variant);

    final strokeWidth = theme?.strokeWidth ?? defaultValues.strokeWidth;
    final backgroundColor =
        theme?.backgroundColor ?? defaultValues.backgroundColor;
    final linearBorderRadius =
        theme?.linearBorderRadius ?? defaultValues.linearBorderRadius;
    final circleRadius = theme?.circleRadius ?? defaultValues.circleRadius;
    final showLabel = theme?.showLabel ?? true;
    final customProgressLabel = theme?.customProgressLabel;
    final labelWidgetWidth = theme?.labelWidgetWidth;
    final labelWidgetAlignment = theme?.labelWidgetAlignment;
    final progressLabelPosition =
        theme?.progressLabelPosition ?? TProgressLabelPosition.inside;
    final color = theme?.color;
    final animationDuration = theme?.animationDuration ?? const Duration(milliseconds: 300);

    return _ProgressIndicator(
      value: value,
      label: label,
      progressLabelPosition: progressLabelPosition,
      strokeWidth: strokeWidth,
      circleRadius: circleRadius,
      linearBorderRadius: linearBorderRadius,
      color: color,
      backgroundColor: backgroundColor,
      type: variant,
      showLabel: showLabel,
      customProgressLabel: customProgressLabel,
      labelWidgetWidth: labelWidgetWidth,
      labelWidgetAlignment: labelWidgetAlignment,
      onPressed: onPressed,
      animationDuration: animationDuration,
      context: context,
    );
  }

  _DefaultValues _getDefaultValues(
      BuildContext context, TProgressVariant type) {
    switch (type) {
      case TProgressVariant.linear:
        return _DefaultValues(
          strokeWidth: 20.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 0,
        );
      case TProgressVariant.circular:
        return _DefaultValues(
          strokeWidth: 5.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 100.0,
        );
      case TProgressVariant.micro:
        return _DefaultValues(
          strokeWidth: 2.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 25.0,
        );
      case TProgressVariant.button:
        return _DefaultValues(
          strokeWidth: 50.0,
          backgroundColor: context.tTheme.brandNormalColor,
          linearBorderRadius: BorderRadius.circular(8),
          circleRadius: 0,
        );
    }
  }
}

class _DefaultValues {
  final double strokeWidth;
  final Color backgroundColor;
  final BorderRadiusGeometry linearBorderRadius;
  final double circleRadius;

  _DefaultValues({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.linearBorderRadius,
    required this.circleRadius,
  });
}

class _ProgressIndicator extends StatefulWidget {
  final double? value;
  final TLabelWidget? label;
  final TProgressLabelPosition progressLabelPosition;
  final double strokeWidth;
  final double circleRadius;
  final BorderRadiusGeometry linearBorderRadius;
  final Color? color;
  final Color backgroundColor;
  final TProgressVariant type;
  final bool showLabel;
  final Widget? customProgressLabel;
  final double? labelWidgetWidth;
  final Alignment? labelWidgetAlignment;
  final VoidCallback? onPressed;
  final Duration animationDuration;
  final BuildContext? context;

  const _ProgressIndicator({
    Key? key,
    this.value,
    this.label,
    this.progressLabelPosition = TProgressLabelPosition.inside,
    required this.strokeWidth,
    required this.linearBorderRadius,
    required this.circleRadius,
    this.color,
    required this.backgroundColor,
    required this.type,
    this.showLabel = true,
    this.customProgressLabel,
    this.labelWidgetWidth,
    this.labelWidgetAlignment,
    this.onPressed,
    this.animationDuration = const Duration(milliseconds: 300),
    this.context,
  }) : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Color _effectiveColor;
  late Widget _effectiveLabel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: widget.animationDuration);
    _updateAnimation();
    _updateEffectiveColor();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(_ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAnimation(oldWidgetValue: oldWidget.value);
      _updateEffectiveLabel();
    }
    if (oldWidget.color != widget.color) {
      _updateEffectiveColor();
    }
    if (oldWidget.label != widget.label) {
      _updateEffectiveLabel();
    }
  }

  void _updateEffectiveColor() {
    _effectiveColor = widget.color ?? _getDefaultColor();
  }

  void _updateEffectiveLabel() {
    _effectiveLabel = widget.label ?? _getDefaultLabel();
  }

  void _updateAnimation({double? oldWidgetValue}) {
    _animation = Tween<double>(
            begin: oldWidgetValue ?? _animationController.value,
            end: widget.value)
        .animate(_animationController);
    _animationController.forward(from: 0);
  }

  Widget _getDefaultLabel() {
    final showAutoText = widget.value != null;

    Widget getAutoText() => showAutoText && widget.type != TProgressVariant.micro
        ? Text('${(widget.value! * 100).round()}%')
        : const Text('');

    return getAutoText();
  }

  Color _getDefaultColor() {
    return widget.context!.tTheme.brandNormalColor;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.type == TProgressVariant.linear)
          _buildLinearProgress()
        else if (widget.type == TProgressVariant.circular)
          _buildCircularProgress()
        else if (widget.type == TProgressVariant.micro)
          _buildMicroProgress()
        else if (widget.type == TProgressVariant.button)
          _buildButtonProgress()
      ],
    );
  }

  Widget _buildLinearProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (widget.value != null &&
            widget.progressLabelPosition == TProgressLabelPosition.inside) {
          return _buildInsideLabel(maxWidth);
        }
        return _buildOutsideLabel(maxWidth);
      },
    );
  }

  Widget _buildInsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progressWidth = _animation.value * maxWidth;
        return ClipRRect(
            borderRadius:
                BorderRadius.circular(context.tTheme.radiusRound),
            child: Stack(
              children: [
                _buildBackgroundContainer(),
                if (widget.value! > 0.1)
                  _buildProgressContainerWithLabel(progressWidth)
                else
                  _buildProgressContainerWithLabelOutside(progressWidth),
              ],
            ));
      },
    );
  }

  Widget _buildOutsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection:
              widget.progressLabelPosition == TProgressLabelPosition.right
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          children: [
            Container(
              alignment: widget.labelWidgetAlignment ??
                  (widget.progressLabelPosition == TProgressLabelPosition.left
                      ? Alignment.centerRight
                      : Alignment.centerLeft),
              constraints:
                  BoxConstraints(minWidth: widget.labelWidgetWidth ?? 0),
              child: widget.customProgressLabel ??
                  _buildLabelWidget(context.tTheme.textColorPrimary),
            ),
            SizedBox(width: context.tTheme.spacer8),
            Expanded(
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(context.tTheme.radiusRound),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          _buildBackgroundContainer(),
                          Container(
                            height: widget.strokeWidth,
                            width: constraints.maxWidth * _animation.value,
                            decoration: BoxDecoration(
                              color: _effectiveColor,
                              borderRadius: widget.linearBorderRadius,
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      height: widget.strokeWidth,
      decoration: BoxDecoration(
        borderRadius: widget.linearBorderRadius,
        color: widget.backgroundColor,
      ),
    );
  }

  Widget _buildProgressContainerWithLabel(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        color: _effectiveColor,
        borderRadius: widget.linearBorderRadius,
      ),
      child: widget.showLabel
          ? Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: _buildLabelWidget(context.tTheme.textColorAnti),
              ),
            )
          : null,
    );
  }

  Widget _buildProgressContainerWithLabelOutside(double progressWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: widget.strokeWidth,
          width: progressWidth,
          decoration: BoxDecoration(
            color: _effectiveColor,
            borderRadius: BorderRadius.only(
              topLeft:
                  widget.linearBorderRadius.resolve(TextDirection.ltr).topLeft,
              bottomLeft: widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .bottomLeft,
              topRight: Radius.circular(widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .topRight
                  .x),
              bottomRight: Radius.circular(widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .bottomRight
                  .x),
            ),
          ),
        ),
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildLabelWidget(context.tTheme.textColorPrimary),
          ),
      ],
    );
  }

  Widget _buildLabelWidget(Color labelColor) {
    late double iconSize;
    late double fontSize;
    late FontWeight fontWeight;

    switch (widget.type) {
      case TProgressVariant.linear:
        if (widget.progressLabelPosition != TProgressLabelPosition.inside) {
          fontSize = widget.strokeWidth > 14 ? widget.strokeWidth : 14;
          iconSize = widget.strokeWidth > 20 ? widget.strokeWidth : 20;
        } else {
          fontSize = widget.strokeWidth * 0.6;
          iconSize = widget.strokeWidth;
        }
        fontWeight = FontWeight.normal;
        break;
      case TProgressVariant.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.15;
        fontWeight = FontWeight.bold;
        break;
      case TProgressVariant.micro:
        iconSize = widget.circleRadius * 0.5;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.normal;
        break;
      case TProgressVariant.button:
        iconSize = widget.strokeWidth * 0.3;
        fontSize = widget.strokeWidth * 0.3;
        fontWeight = FontWeight.normal;
        break;
    }

    return IconTheme(
      data: IconThemeData(color: _effectiveColor, size: iconSize),
      child: DefaultTextStyle(
        style: TextStyle(
          color: labelColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        child: _effectiveLabel,
      ),
    );
  }

  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: widget.circleRadius,
              width: widget.circleRadius,
              child: Padding(
                padding: EdgeInsets.all(widget.strokeWidth / 2),
                child: TProgressCircular(
                  strokeWidth: widget.strokeWidth,
                  circleRadius: widget.circleRadius,
                  value: _animation.value,
                  backgroundColor: widget.backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                ),
              ),
            ),
            if (widget.showLabel)
              _buildLabelWidget(widget.context!.tTheme.textColorPrimary),
          ],
        );
      },
    );
  }

  Widget _buildMicroProgress() {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return GestureDetector(
              onTap: widget.onPressed,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildMicroOutline(),
                  if (widget.showLabel)
                        _buildLabelWidget(
                            widget.context!.tTheme.textColorPrimary),
                ],
              ));
        });
  }

  Widget _buildMicroOutline() {
    return SizedBox(
      height: widget.circleRadius,
      width: widget.circleRadius,
      child: Padding(
        padding: EdgeInsets.all(widget.strokeWidth / 2),
        child: TProgressCircular(
          strokeWidth: widget.strokeWidth,
          circleRadius: widget.circleRadius,
          value: _animation.value,
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
        ),
      ),
    );
  }

  Widget _buildButtonProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progressWidth = maxWidth * _animation.value;
              return ClipRRect(
                borderRadius: widget.linearBorderRadius,
                child: GestureDetector(
                    onTap: widget.onPressed,
                    child: Stack(
                      children: [
                        _buildBackgroundContainer(),
                        _buildButtonActiveContainer(progressWidth),
                        if (widget.showLabel) _buildButtonLabel(maxWidth),
                      ],
                    )),
              );
            });
      },
    );
  }

  Widget _buildButtonActiveContainer(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _effectiveColor,
            widget.context!.tTheme.brandDisabledColor.withValues(alpha: .5)
          ],
        ),
      ),
    );
  }

  Widget _buildButtonLabel(double maxWidth) {
    return Container(
      height: widget.strokeWidth,
      alignment: Alignment.center,
      child: _buildLabelWidget(widget.context!.tTheme.fontWhColor1),
    );
  }
}
