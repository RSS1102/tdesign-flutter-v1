import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../checkbox/t_selection_card.dart';

typedef TRadioIconBuilder = Widget Function(
  BuildContext context,
  bool selected,
  bool disabled,
);

enum TRadioSize { small, medium, large }

@immutable
class TRadioOption<T> {
  const TRadioOption({
    required this.value,
    required this.label,
    this.subTitle,
    this.disabled = false,
  });

  final T value;
  final String label;
  final String? subTitle;
  final bool disabled;
}

typedef TRadioOptionBuilder<T> = Widget Function(
  BuildContext context,
  TRadioOption<T> option,
  bool selected,
  bool disabled,
);

/// Strictly controlled radio item following Material value/groupValue semantics.
class TRadio<T> extends StatelessWidget {
  const TRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.title,
    this.subTitle,
    this.size = TRadioSize.medium,
    this.cardMode = false,
    this.showDivider = false,
    this.contentDirection = TContentDirection.right,
    this.titleMaxLines = 1,
    this.subTitleMaxLines = 1,
    this.customIconBuilder,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? title;
  final String? subTitle;
  final TRadioSize size;
  final bool cardMode;
  final bool showDivider;
  final TContentDirection contentDirection;
  final int titleMaxLines;
  final int subTitleMaxLines;
  final TRadioIconBuilder? customIconBuilder;

  bool get _selected => value == groupValue;
  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TRadioThemeData>();
    final indicator = customIconBuilder?.call(context, _selected, _disabled) ??
        (cardMode ? null : _buildIndicator(context, theme));
    final content = _buildContent(context, theme);
    final hasContent = content != null;
    final children = <Widget>[
      if (indicator != null) indicator,
      if (indicator != null && content != null)
        SizedBox(
          width: cardMode ? 0 : theme?.spacing ?? context.tTheme.spacer8,
        ),
      if (content != null) Expanded(child: content),
    ];
    final constraints = hasContent
        ? BoxConstraints(
            minHeight: switch (size) {
              TRadioSize.small => 40.0,
              TRadioSize.medium => 48.0,
              TRadioSize.large => 56.0,
            },
          )
        : _resolveTapTargetConstraints(context);
    final tileContent = Container(
      constraints: cardMode ? null : constraints,
      padding: hasContent
          ? EdgeInsets.symmetric(
              horizontal: theme?.insetSpacing ?? context.tTheme.spacer16,
              vertical: context.tTheme.spacer8,
            )
          : EdgeInsets.zero,
      decoration: cardMode
          ? null
          : BoxDecoration(
              color: hasContent
                  ? context.tTheme.bgColorContainer
                  : Colors.transparent,
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: contentDirection == TContentDirection.right
            ? children
            : children.reversed.toList(),
      ),
    );
    final tile = cardMode
        ? TSelectionCard(
            selected: _selected,
            disabled: _disabled,
            selectedColor:
                theme?.selectColor ?? context.tTheme.brandNormalColor,
            disabledColor:
                theme?.disableColor ?? context.tTheme.brandDisabledColor,
            backgroundColor:
                theme?.backgroundColor ?? context.tTheme.bgColorContainer,
            borderRadius: context.tTheme.radiusDefault,
            minHeight: subTitle?.isNotEmpty == true ? 82 : 56,
            child: tileContent,
          )
        : tileContent;
    return Semantics(
      enabled: !_disabled,
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _disabled ? null : () => onChanged!(value),
            child: tile,
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(left: context.tTheme.spacer16),
              child: const TDivider(),
            ),
        ],
      ),
    );
  }

  BoxConstraints _resolveTapTargetConstraints(BuildContext context) {
    final materialTheme = RadioTheme.of(context);
    final appTheme = Theme.of(context);
    final visualDensity = materialTheme.visualDensity ?? appTheme.visualDensity;
    final tapTargetSize =
        materialTheme.materialTapTargetSize ?? appTheme.materialTapTargetSize;
    final indicatorSize = _indicatorSize;
    final baseSize = tapTargetSize == MaterialTapTargetSize.padded
        ? kMinInteractiveDimension
        : indicatorSize;
    final adjustment = visualDensity.baseSizeAdjustment;
    return BoxConstraints(
      minWidth: math.max(indicatorSize, baseSize + adjustment.dx),
      minHeight: math.max(indicatorSize, baseSize + adjustment.dy),
    );
  }

  double get _indicatorSize => switch (size) {
        TRadioSize.small => 20.0,
        TRadioSize.medium => 24.0,
        TRadioSize.large => 28.0,
      };

  Widget _buildIndicator(BuildContext context, TRadioThemeData? theme) {
    final color = _disabled
        ? (theme?.disableColor ?? context.tTheme.brandDisabledColor)
        : _selected
            ? (theme?.selectColor ?? context.tTheme.brandNormalColor)
            : context.tTheme.componentBorderColor;
    final iconSize = _indicatorSize;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _TRadioIndicatorPainter(
          selected: _selected,
          color: color,
        ),
      ),
    );
  }

  Widget? _buildContent(BuildContext context, TRadioThemeData? theme) {
    if (title == null && subTitle == null) {
      return null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _disabled
                  ? context.tTheme.textDisabledColor
                  : (theme?.titleColor ?? context.tTheme.textColorPrimary),
              fontSize: context.tTheme.fontBodyLarge?.size,
            ),
          ),
        if (title != null && subTitle != null)
          SizedBox(height: context.tTheme.spacer4),
        if (subTitle != null)
          Text(
            subTitle!,
            maxLines: subTitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _disabled
                  ? context.tTheme.textDisabledColor
                  : (theme?.subTitleColor ??
                      context.tTheme.textColorPlaceholder),
              fontSize: context.tTheme.fontBodyMedium?.size,
            ),
          ),
      ],
    );
  }
}

class _TRadioIndicatorPainter extends CustomPainter {
  const _TRadioIndicatorPainter({
    required this.selected,
    required this.color,
  });

  final bool selected;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = size.shortestSide / 16;
    final outerRadius = size.shortestSide * 7 / 16;
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, outerRadius, paint);
    if (selected) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, outerRadius * 4 / 7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TRadioIndicatorPainter oldDelegate) {
    return selected != oldDelegate.selected || color != oldDelegate.color;
  }
}

/// Data-driven, strictly controlled radio group.
class TRadioGroup<T> extends StatelessWidget {
  const TRadioGroup({
    super.key,
    required this.value,
    required this.options,
    this.onChanged,
    this.direction = Axis.vertical,
    this.columns = 1,
    this.cardMode = false,
    this.showDivider = false,
    this.contentDirection = TContentDirection.right,
    this.size = TRadioSize.medium,
    this.itemBuilder,
  }) : assert(columns > 0);

  final T? value;
  final List<TRadioOption<T>> options;
  final ValueChanged<T>? onChanged;
  final Axis direction;
  final int columns;
  final bool cardMode;
  final bool showDivider;
  final TContentDirection contentDirection;
  final TRadioSize size;
  final TRadioOptionBuilder<T>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (cardMode) {
      return TSelectionCardGroupLayout(
        direction: direction,
        columns: columns,
        children: List.generate(options.length, (index) {
          return _buildItem(context, options[index], index);
        }),
        itemHasSubtitles: [
          for (final option in options) option.subTitle?.isNotEmpty == true,
        ],
      );
    }
    if (direction == Axis.vertical && columns == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          return _buildItem(context, options[index], index);
        }),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth / columns
            : null;
        return Wrap(
          children: List.generate(options.length, (index) {
            final child = _buildItem(context, options[index], index);
            return width == null ? child : SizedBox(width: width, child: child);
          }),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, TRadioOption<T> option, int index) {
    final selected = value == option.value;
    final disabled = onChanged == null || option.disabled;
    if (itemBuilder != null) {
      final child = itemBuilder!(context, option, selected, disabled);
      return Semantics(
        enabled: !disabled,
        checked: selected,
        inMutuallyExclusiveGroup: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => onChanged!(option.value),
          child: child,
        ),
      );
    }
    return TRadio<T>(
      value: option.value,
      groupValue: value,
      onChanged: disabled ? null : onChanged,
      title: option.label,
      subTitle: option.subTitle,
      cardMode: cardMode,
      showDivider: showDivider && index < options.length - 1,
      contentDirection: contentDirection,
      size: size,
    );
  }
}
