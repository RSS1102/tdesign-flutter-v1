import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, TextInputFormatter;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_stepper_theme_data.dart';
import 't_stepper_types.dart';

export 't_stepper_types.dart';

/// Material 连续数值步进器。
///
/// 严格受控：数值由 [value] 提供，通过 [onChanged] 回传；[onChanged] 为
/// null 时整组禁用。
class TStepper extends StatefulWidget {
  const TStepper({
    super.key,

    /// 受控数值。
    required this.value,

    /// 数值变化回调；为 null 时禁用。
    this.onChanged,

    /// 最小值。
    this.min = 0,

    /// 最大值。
    this.max = 100,

    /// 步长。
    this.step = 1,
  })  : assert(min <= max),
        assert(step > 0);

  /// 受控数值。
  final num value;

  /// 数值变化回调；为 null 时禁用。
  final ValueChanged<num>? onChanged;

  /// 最小值。
  final num min;

  /// 最大值。
  final num max;

  /// 步长。
  final num step;

  @override
  State<TStepper> createState() => _TStepperState();
}

class _TStepperState extends State<TStepper> {
  static const double _height = 24;
  static const double _buttonSize = 24;
  static const double _defaultInputWidth = 38;

  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  bool get _disabled => widget.onChanged == null;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(covariant TStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _setText(widget.value);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TStepperThemeData>();
    final variant = theme?.variant ?? TStepperVariant.normal;
    final inputWidth = theme?.inputWidth ?? _defaultInputWidth;
    final canDecrease = !_disabled && widget.value > widget.min;
    final canIncrease = !_disabled && widget.value < widget.max;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperIconButton(
          icon: Icons.remove,
          disabled: !canDecrease,
          variant: variant,
          position: _StepperSegmentPosition.left,
          onPressed: () => _commit(widget.value - widget.step),
        ),
        Container(
          width: inputWidth,
          height: _height,
          alignment: Alignment.center,
          decoration: _inputDecoration(context, variant, _disabled),
          child: TextField(
            controller: _textController,
            enabled: !_disabled,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            style: TextStyle(
              color: _disabled
                  ? context.tTheme.textDisabledColor
                  : context.tTheme.textColorPrimary,
              fontSize: context.tTheme.fontBodyMedium?.size ?? 12,
              height: 1,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text == '-' || newValue.text == '.') {
                  return newValue;
                }
                if (newValue.text.isEmpty) {
                  return newValue;
                }
                return num.tryParse(newValue.text) == null
                    ? oldValue
                    : newValue;
              }),
            ],
            onSubmitted: _handleInput,
            onEditingComplete: () => _handleInput(_textController.text),
          ),
        ),
        _StepperIconButton(
          icon: Icons.add,
          disabled: !canIncrease,
          variant: variant,
          position: _StepperSegmentPosition.right,
          onPressed: () => _commit(widget.value + widget.step),
        ),
      ],
    );
  }

  BoxDecoration _inputDecoration(
    BuildContext context,
    TStepperVariant variant,
    bool disabled,
  ) {
    final token = context.tTheme;
    final backgroundColor = switch (variant) {
      TStepperVariant.filled => disabled
          ? token.bgColorComponentDisabled
          : token.bgColorSecondaryContainer,
      TStepperVariant.normal => null,
    };
    final borderSide = BorderSide(color: token.componentBorderColor);
    final disabledBorderSide = BorderSide(color: token.componentStrokeColor);
    return BoxDecoration(
      color: backgroundColor,
      border: variant == TStepperVariant.normal
          ? Border(
              top: disabled ? disabledBorderSide : borderSide,
              bottom: disabled ? disabledBorderSide : borderSide,
            )
          : null,
    );
  }

  void _handleInput(String text) {
    final parsed = num.tryParse(text);
    if (parsed == null) {
      _setText(widget.value);
      _focusNode.unfocus();
      return;
    }
    _commit(parsed);
  }

  void _commit(num next) {
    final clamped = next.clamp(widget.min, widget.max);
    _setText(clamped);
    _focusNode.unfocus();
    if (clamped != widget.value) {
      widget.onChanged?.call(clamped);
    }
  }

  void _setText(num value) {
    final text = _format(value);
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String _format(num value) {
    if (value is int) {
      return value.toString();
    }
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }
}

enum _StepperSegmentPosition { left, right }

class _StepperIconButton extends StatelessWidget {
  static const double _buttonSize = _TStepperState._buttonSize;

  const _StepperIconButton({
    required this.icon,
    required this.disabled,
    required this.variant,
    required this.position,
    required this.onPressed,
  });

  final IconData icon;
  final bool disabled;
  final TStepperVariant variant;
  final _StepperSegmentPosition position;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    final backgroundColor = switch (variant) {
      TStepperVariant.filled => disabled
          ? token.bgColorComponentDisabled
          : token.bgColorSecondaryContainer,
      TStepperVariant.normal => null,
    };
    final foregroundColor =
        disabled ? token.textDisabledColor : token.textColorPrimary;
    return SizedBox(
      width: _buttonSize,
      height: _buttonSize,
      child: GestureDetector(
        key: ValueKey(
          icon == Icons.add ? 'stepper-increase' : 'stepper-decrease',
        ),
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: _borderRadius(),
            border: _border(context),
          ),
          child: Icon(icon, size: 16, color: foregroundColor),
        ),
      ),
    );
  }

  BorderRadius? _borderRadius() {
    return position == _StepperSegmentPosition.left
        ? const BorderRadius.horizontal(left: Radius.circular(3))
        : const BorderRadius.horizontal(right: Radius.circular(3));
  }

  BoxBorder? _border(BuildContext context) {
    if (variant != TStepperVariant.normal) {
      return null;
    }
    final side = BorderSide(
      color: disabled
          ? context.tTheme.componentStrokeColor
          : context.tTheme.componentBorderColor,
    );
    return Border.all(color: side.color, width: side.width);
  }
}
