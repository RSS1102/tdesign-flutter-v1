import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_selection_card.dart';

enum TContentDirection { left, right }

enum TCheckboxSize { small, medium, large }

typedef TCheckboxIconBuilder = Widget Function(
  BuildContext context,
  bool? value,
  bool disabled,
);

/// Strictly controlled checkbox. A null [onChanged] means disabled.
class TCheckbox extends StatelessWidget {
  const TCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subTitle,
    this.size = TCheckboxSize.medium,
    this.cardMode = false,
    this.showDivider = false,
    this.contentDirection = TContentDirection.right,
    this.titleMaxLines = 1,
    this.subTitleMaxLines = 1,
    this.customIconBuilder,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final String? title;
  final String? subTitle;
  final TCheckboxSize size;
  final bool cardMode;
  final bool showDivider;
  final TContentDirection contentDirection;
  final int titleMaxLines;
  final int subTitleMaxLines;
  final TCheckboxIconBuilder? customIconBuilder;

  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TCheckboxThemeData>();
    final selected = value == true;
    final indicator = customIconBuilder?.call(context, value, _disabled) ??
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

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: contentDirection == TContentDirection.right
          ? children
          : children.reversed.toList(),
    );
    final constraints = hasContent
        ? BoxConstraints(
            minHeight: switch (size) {
              TCheckboxSize.small => 40.0,
              TCheckboxSize.medium => 48.0,
              TCheckboxSize.large => 56.0,
            },
          )
        : _resolveTapTargetConstraints(context);

    final tileContent = Container(
      constraints: cardMode ? null : constraints,
      padding: hasContent
          ? (theme?.customSpace ??
              EdgeInsets.symmetric(
                horizontal: theme?.insetSpacing ?? context.tTheme.spacer16,
                vertical: context.tTheme.spacer8,
              ))
          : EdgeInsets.zero,
      decoration: cardMode
          ? null
          : BoxDecoration(
              color: hasContent
                  ? context.tTheme.bgColorContainer
                  : Colors.transparent,
            ),
      child: row,
    );
    final tile = cardMode
        ? TSelectionCard(
            selected: selected,
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
      checked: value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _disabled
                ? null
                : () => onChanged!(value == true ? false : true),
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
    final materialTheme = CheckboxTheme.of(context);
    final appTheme = Theme.of(context);
    final visualDensity = materialTheme.visualDensity ?? appTheme.visualDensity;
    final tapTargetSize =
        materialTheme.materialTapTargetSize ?? appTheme.materialTapTargetSize;
    final indicatorSize = switch (size) {
      TCheckboxSize.small => 20.0,
      TCheckboxSize.medium => 24.0,
      TCheckboxSize.large => 28.0,
    };
    final baseSize = tapTargetSize == MaterialTapTargetSize.padded
        ? kMinInteractiveDimension
        : indicatorSize;
    final adjustment = visualDensity.baseSizeAdjustment;
    return BoxConstraints(
      minWidth: math.max(indicatorSize, baseSize + adjustment.dx),
      minHeight: math.max(indicatorSize, baseSize + adjustment.dy),
    );
  }

  Widget _buildIndicator(BuildContext context, TCheckboxThemeData? theme) {
    final variant = theme?.style ?? TCheckboxVariant.square;
    final selected = value == true;
    final indeterminate = value == null;
    final icon = switch (variant) {
      TCheckboxVariant.circle => indeterminate
          ? TIcons.minus_circle_filled
          : selected
              ? TIcons.check_circle_filled
              : TIcons.circle,
      TCheckboxVariant.square => indeterminate
          ? TIcons.minus_rectangle_filled
          : selected
              ? TIcons.check_rectangle_filled
              : TIcons.rectangle,
      TCheckboxVariant.check => selected || indeterminate
          ? (indeterminate ? TIcons.minus : TIcons.check)
          : null,
    };
    final color = _disabled
        ? (theme?.disableColor ?? context.tTheme.brandDisabledColor)
        : selected || indeterminate
            ? (theme?.selectColor ?? context.tTheme.brandNormalColor)
            : context.tTheme.componentBorderColor;
    final iconSize = switch (size) {
      TCheckboxSize.small => 20.0,
      TCheckboxSize.medium => 24.0,
      TCheckboxSize.large => 28.0,
    };
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: icon == null ? null : Icon(icon, size: iconSize, color: color),
    );
  }

  Widget? _buildContent(BuildContext context, TCheckboxThemeData? theme) {
    if (title == null && subTitle == null) {
      return null;
    }
    final titleColor = _disabled
        ? context.tTheme.textDisabledColor
        : (theme?.titleColor ?? context.tTheme.textColorPrimary);
    final subTitleColor = _disabled
        ? context.tTheme.textDisabledColor
        : (theme?.subTitleColor ?? context.tTheme.textColorPlaceholder);
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
              color: titleColor,
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
              color: subTitleColor,
              fontSize: context.tTheme.fontBodyMedium?.size,
            ),
          ),
      ],
    );
  }
}
