import 'package:flutter/material.dart';

import 't_check_box.dart';
import 't_selection_card.dart';

@immutable
class TCheckboxOption<T> {
  const TCheckboxOption({
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

typedef TCheckboxOptionBuilder<T> = Widget Function(
  BuildContext context,
  TCheckboxOption<T> option,
  bool selected,
  bool disabled,
);

/// Data-driven, strictly controlled checkbox group.
class TCheckboxGroup<T> extends StatelessWidget {
  const TCheckboxGroup({
    super.key,
    required this.value,
    required this.options,
    this.onChanged,
    this.direction = Axis.vertical,
    this.columns = 1,
    this.cardMode = false,
    this.showDivider = false,
    this.contentDirection = TContentDirection.right,
    this.size = TCheckboxSize.medium,
    this.maxSelected,
    this.onMaxSelected,
    this.itemBuilder,
  }) : assert(columns > 0);

  final List<T> value;
  final List<TCheckboxOption<T>> options;
  final ValueChanged<List<T>>? onChanged;
  final Axis direction;
  final int columns;
  final bool cardMode;
  final bool showDivider;
  final TContentDirection contentDirection;
  final TCheckboxSize size;
  final int? maxSelected;
  final VoidCallback? onMaxSelected;
  final TCheckboxOptionBuilder<T>? itemBuilder;

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

  Widget _buildItem(
      BuildContext context, TCheckboxOption<T> option, int index) {
    final selected = value.contains(option.value);
    final disabled = onChanged == null || option.disabled;
    if (itemBuilder != null) {
      final child = itemBuilder!(context, option, selected, disabled);
      return Semantics(
        enabled: !disabled,
        checked: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => _toggle(option, selected),
          child: child,
        ),
      );
    }
    return TCheckbox(
      value: selected,
      onChanged: disabled ? null : (_) => _toggle(option, selected),
      title: option.label,
      subTitle: option.subTitle,
      cardMode: cardMode,
      showDivider: showDivider && index < options.length - 1,
      contentDirection: contentDirection,
      size: size,
    );
  }

  void _toggle(TCheckboxOption<T> option, bool selected) {
    final next = value.toSet();
    if (selected) {
      next.remove(option.value);
    } else {
      if (maxSelected != null && next.length >= maxSelected!) {
        onMaxSelected?.call();
        return;
      }
      next.add(option.value);
    }
    onChanged?.call([
      for (final item in options)
        if (next.contains(item.value)) item.value,
    ]);
  }
}
