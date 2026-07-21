import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_rate_theme_data.dart';

/// 自定义评分图标构建器。
///
/// [filled] 表示构建选中或未选中图标；半星由组件裁剪选中图标实现。
typedef TRateIconBuilder = Widget Function(bool filled);

/// 严格受控的评分组件。
class TRate extends StatefulWidget {
  const TRate({
    super.key,

    /// 受控评分值。
    required this.value,

    /// 评分变更回调；为 null 时禁用。
    this.onChanged,

    /// 开始交互时触发。
    this.onChangeStart,

    /// 结束交互时触发。
    this.onChangeEnd,

    /// 评分项数量。
    this.count = 5,

    /// 是否允许半星。
    this.allowHalf = false,

    /// 自定义评分图标。
    this.icon,

    /// 各评分对应的文案。
    this.texts,
  })  : assert(count > 0),
        assert(value >= 0 && value <= count);

  /// 受控评分值。
  final double value;

  /// 评分变更回调；为 null 时禁用。
  final ValueChanged<double>? onChanged;

  /// 开始交互时触发。
  final ValueChanged<double>? onChangeStart;

  /// 结束交互时触发。
  final ValueChanged<double>? onChangeEnd;

  /// 评分项数量。
  final int count;

  /// 是否允许半星。
  final bool allowHalf;

  /// 自定义评分图标。
  final TRateIconBuilder? icon;

  /// 各评分对应的文案。
  final List<String>? texts;

  @override
  State<TRate> createState() => _TRateState();
}

class _TRateState extends State<TRate> {
  double? _lastInteractionValue;

  bool get _enabled => widget.onChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TRateThemeData>();
    final iconSize = theme?.iconSize ?? 24;
    final iconGap = theme?.iconGap ?? context.tTheme.spacer8;
    final showText = theme?.showText ?? false;

    return Semantics(
      enabled: _enabled,
      value: widget.value.toString(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled
                ? (details) {
                    final next =
                        _valueAt(details.localPosition.dx, iconSize, iconGap);
                    if (next == null) {
                      return;
                    }
                    _lastInteractionValue = next;
                    widget.onChangeStart?.call(widget.value);
                  }
                : null,
            onTapUp: _enabled
                ? (details) {
                    final next =
                        _valueAt(details.localPosition.dx, iconSize, iconGap);
                    if (next == null) {
                      return;
                    }
                    _lastInteractionValue = next;
                    widget.onChanged?.call(next);
                    widget.onChangeEnd?.call(next);
                  }
                : null,
            onHorizontalDragStart: _enabled
                ? (_) {
                    _lastInteractionValue = widget.value;
                    widget.onChangeStart?.call(widget.value);
                  }
                : null,
            onHorizontalDragUpdate: _enabled
                ? (details) {
                    final next =
                        _valueAt(details.localPosition.dx, iconSize, iconGap);
                    if (next == null) {
                      return;
                    }
                    _lastInteractionValue = next;
                    widget.onChanged?.call(next);
                  }
                : null,
            onHorizontalDragEnd: _enabled
                ? (_) => widget.onChangeEnd?.call(
                      _lastInteractionValue ?? widget.value,
                    )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < widget.count; index++) ...[
                  _buildItem(context, index, iconSize, theme),
                  if (index < widget.count - 1) SizedBox(width: iconGap),
                ],
              ],
            ),
          ),
          if (showText) ...[
            SizedBox(width: theme?.textGap ?? context.tTheme.spacer16),
            SizedBox(
              width: theme?.textWidth,
              child: Text(
                _resolveText(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme?.textStyle ??
                    TextStyle(
                      color: _enabled
                          ? context.tTheme.textColorPrimary
                          : context.tTheme.textDisabledColor,
                      fontSize: context.tTheme.fontBodyLarge?.size,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    double iconSize,
    TRateThemeData? theme,
  ) {
    final fill = (widget.value - index).clamp(0, 1).toDouble();
    final selectedColor = _enabled
        ? (theme?.starColor ?? context.tTheme.warningColor5)
        : context.tTheme.textDisabledColor;
    final inactiveColor = _enabled
        ? (theme?.inactiveStarColor ?? context.tTheme.bgColorComponent)
        : context.tTheme.bgColorComponentDisabled;
    final unselected = widget.icon?.call(false) ??
        Icon(TIcons.star_filled, size: iconSize, color: inactiveColor);
    final selected = widget.icon?.call(true) ??
        Icon(TIcons.star_filled, size: iconSize, color: selectedColor);

    return SizedBox.square(
      dimension: iconSize,
      child: Stack(
        children: [
          Positioned.fill(child: unselected),
          if (fill > 0)
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: SizedBox.square(dimension: iconSize, child: selected),
              ),
            ),
        ],
      ),
    );
  }

  double? _valueAt(double dx, double iconSize, double iconGap) {
    final itemExtent = iconSize + iconGap;
    final maxDx = itemExtent * widget.count - iconGap;
    if (dx < 0) {
      return 0;
    }
    if (dx >= maxDx) {
      return widget.count.toDouble();
    }
    final index = (dx / itemExtent).floor().clamp(0, widget.count - 1);
    final local = dx - index * itemExtent;
    if (local > iconSize) {
      return null;
    }
    final fraction = widget.allowHalf && local <= iconSize / 2 ? 0.5 : 1.0;
    return index + fraction;
  }

  String _resolveText() {
    final texts = widget.texts;
    if (widget.value <= 0 || texts == null || texts.isEmpty) {
      return widget.value.toString();
    }
    final halfIndex = (widget.value * 2).ceil() - 1;
    final wholeIndex = widget.value.ceil() - 1;
    final index = texts.length >= widget.count * 2 ? halfIndex : wholeIndex;
    return index >= 0 && index < texts.length
        ? texts[index]
        : widget.value.toString();
  }
}
