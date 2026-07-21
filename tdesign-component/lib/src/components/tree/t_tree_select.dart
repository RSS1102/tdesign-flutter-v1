import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_tree_select_theme_data.dart';

/// 不可变的树形选择选项。
@immutable
class TTreeSelectOption {
  const TTreeSelectOption({
    /// 展示文案。
    required this.label,

    /// 业务值。
    required this.value,

    /// 子选项。
    this.children = const [],

    /// 是否禁用。
    this.disabled = false,
  });

  /// 展示文案。
  final String label;

  /// 业务值。
  final Object? value;

  /// 子选项。
  final List<TTreeSelectOption> children;

  /// 是否禁用。
  final bool disabled;
}

/// 严格受控的树形选择器。
///
/// [value] 中每一项都是从根到叶子的完整路径。单选模式最多保留一条路径，
/// 多选模式可同时保留多条路径。
class TTreeSelect extends StatefulWidget {
  const TTreeSelect({
    super.key,

    /// 根选项。
    required this.options,

    /// 受控选中路径。
    required this.value,

    /// 选中路径变化回调；为 null 时禁用。
    this.onChanged,

    /// 是否允许选择多个叶子节点。
    this.multiple = false,
  });

  /// 根选项。
  final List<TTreeSelectOption> options;

  /// 受控选中路径。
  final List<List<Object?>> value;

  /// 选中路径变化回调；为 null 时禁用。
  final ValueChanged<List<List<Object?>>>? onChanged;

  /// 是否允许选择多个叶子节点。
  final bool multiple;

  @override
  State<TTreeSelect> createState() => _TTreeSelectState();
}

class _TTreeSelectState extends State<TTreeSelect> {
  late List<Object?> _activePath;

  bool get _enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _activePath = _initialActivePath();
  }

  @override
  void didUpdateWidget(covariant TTreeSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options ||
        !_pathsEqual(oldWidget.value, widget.value)) {
      _activePath = _initialActivePath();
    }
  }

  List<Object?> _initialActivePath() {
    if (widget.value.isEmpty) {
      return const [];
    }
    final active = <Object?>[];
    var options = widget.options;
    for (final value in widget.value.first) {
      final index = options.indexWhere((option) => option.value == value);
      if (index < 0) {
        break;
      }
      final option = options[index];
      if (option.children.isEmpty) {
        break;
      }
      active.add(option.value);
      options = option.children;
    }
    return active;
  }

  List<List<TTreeSelectOption>> _visibleColumns() {
    final columns = <List<TTreeSelectOption>>[];
    var options = widget.options;
    var level = 0;
    while (options.isNotEmpty) {
      columns.add(options);
      if (level >= _activePath.length) {
        break;
      }
      final index = options.indexWhere(
        (option) => option.value == _activePath[level],
      );
      if (index < 0 || options[index].children.isEmpty) {
        break;
      }
      options = options[index].children;
      level += 1;
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TTreeSelectThemeData>();
    final columns = _visibleColumns();
    final rightColumns = _rightColumns(columns);
    final panel = Container(
      height: theme?.height ?? 336,
      color: theme?.backgroundColor ?? context.tTheme.bgColorContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: theme?.rootColumnWidth ?? 106,
            child: _buildColumn(
              context,
              options: columns.isEmpty ? const [] : columns.first,
              level: 0,
              theme: theme,
              isRoot: true,
              isLastVisibleColumn: rightColumns.isEmpty,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < rightColumns.length; index++)
                  _buildRightColumnSlot(
                    context,
                    column: rightColumns[index],
                    theme: theme,
                    isLastVisibleColumn: index == rightColumns.length - 1,
                    hasTrailingColumn: index < rightColumns.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return Semantics(
      enabled: _enabled,
      child: AnimatedOpacity(
        opacity: _enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(absorbing: !_enabled, child: panel),
      ),
    );
  }

  List<_TreeSelectColumn> _rightColumns(
    List<List<TTreeSelectOption>> columns,
  ) {
    if (columns.length <= 1) {
      return const [];
    }
    final start = columns.length > 3 ? columns.length - 2 : 1;
    return [
      for (var level = start; level < columns.length; level++)
        _TreeSelectColumn(level: level, options: columns[level]),
    ];
  }

  Widget _buildRightColumnSlot(
    BuildContext context, {
    required _TreeSelectColumn column,
    required TTreeSelectThemeData? theme,
    required bool isLastVisibleColumn,
    required bool hasTrailingColumn,
  }) {
    final child = _buildColumn(
      context,
      options: column.options,
      level: column.level,
      theme: theme,
      isRoot: false,
      isLastVisibleColumn: isLastVisibleColumn,
    );
    final themedWidth = theme?.columnWidth;
    if (themedWidth != null) {
      return SizedBox(width: themedWidth, child: child);
    }
    if (hasTrailingColumn) {
      return SizedBox(width: 103, child: child);
    }
    return Expanded(child: child);
  }

  Widget _buildColumn(
    BuildContext context, {
    required List<TTreeSelectOption> options,
    required int level,
    required TTreeSelectThemeData? theme,
    required bool isRoot,
    required bool isLastVisibleColumn,
  }) {
    final backgroundColor = isRoot
        ? theme?.rootBackgroundColor ?? context.tTheme.bgColorSecondaryContainer
        : theme?.backgroundColor ?? context.tTheme.bgColorContainer;
    final itemHeight = theme?.itemHeight ?? 56;
    return Container(
      color: backgroundColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemExtent: itemHeight,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final path = <Object?>[
            ..._activePath.take(level),
            option.value,
          ];
          final isBranch = option.children.isNotEmpty;
          final selected = isBranch
              ? level < _activePath.length && _activePath[level] == option.value
              : widget.value.any((value) => listEquals(value, path));
          return _buildOption(
            context,
            option: option,
            path: path,
            level: level,
            selected: selected,
            isBranch: isBranch,
            isRoot: isRoot,
            isLastVisibleColumn: isLastVisibleColumn,
            theme: theme,
          );
        },
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required TTreeSelectOption option,
    required List<Object?> path,
    required int level,
    required bool selected,
    required bool isBranch,
    required bool isRoot,
    required bool isLastVisibleColumn,
    required TTreeSelectThemeData? theme,
  }) {
    final token = context.tTheme;
    final itemHeight = theme?.itemHeight ?? 56;
    final selectedBackgroundColor =
        isRoot ? token.bgColorContainer : Colors.transparent;
    final backgroundColor = selected
        ? theme?.selectedBackgroundColor ?? selectedBackgroundColor
        : Colors.transparent;
    final defaultStyle = TextStyle(
      color: token.textColorPrimary,
      fontSize: token.fontBodyLarge?.size ?? 16,
    );
    final selectedStyle = defaultStyle.copyWith(
      color: token.brandNormalColor,
      fontWeight: FontWeight.w600,
    );
    final leafSelectedStyle = defaultStyle.copyWith(
      fontWeight: FontWeight.w400,
    );
    final textStyle = option.disabled
        ? theme?.disabledTextStyle ??
            defaultStyle.copyWith(color: token.textDisabledColor)
        : selected
            ? theme?.selectedTextStyle ??
                (isLastVisibleColumn && !isBranch
                    ? leafSelectedStyle
                    : selectedStyle)
            : theme?.textStyle ?? defaultStyle;
    final iconColor = theme?.indicatorColor ?? token.brandNormalColor;
    final showCheck = selected && !isBranch && isLastVisibleColumn;
    return Semantics(
      selected: selected,
      enabled: !option.disabled,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          key: ValueKey((level, option.value)),
          onTap: option.disabled
              ? null
              : () => isBranch
                  ? _openBranch(path)
                  : _toggleLeaf(List.unmodifiable(path)),
          child: SizedBox(
            height: itemHeight,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: token.spacer16,
                      top: token.spacer16,
                      bottom: token.spacer16,
                      right: showCheck ? 0 : token.spacer16,
                    ),
                    child: Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                ),
                if (showCheck)
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(TIcons.check, size: 16, color: iconColor),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openBranch(List<Object?> path) {
    setState(() => _activePath = List.unmodifiable(path));
  }

  void _toggleLeaf(List<Object?> path) {
    if (!widget.multiple) {
      widget.onChanged?.call(List.unmodifiable([path]));
      return;
    }
    final next = [
      for (final selected in widget.value)
        if (!listEquals(selected, path)) selected,
    ];
    if (next.length == widget.value.length) {
      next.add(path);
    }
    widget.onChanged?.call(
      List.unmodifiable(
        next.map(List<Object?>.unmodifiable),
      ),
    );
  }

  static bool _pathsEqual(
    List<List<Object?>> first,
    List<List<Object?>> second,
  ) {
    if (first.length != second.length) {
      return false;
    }
    for (var index = 0; index < first.length; index++) {
      if (!listEquals(first[index], second[index])) {
        return false;
      }
    }
    return true;
  }
}

class _TreeSelectColumn {
  const _TreeSelectColumn({
    required this.level,
    required this.options,
  });

  final int level;
  final List<TTreeSelectOption> options;
}
