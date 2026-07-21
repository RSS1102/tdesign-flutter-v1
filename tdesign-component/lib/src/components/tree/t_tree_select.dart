import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
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
    final panel = Container(
      height: theme?.height ?? 336,
      color: theme?.backgroundColor ?? context.tTheme.bgColorContainer,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var level = 0; level < columns.length; level++)
              _buildColumn(context, columns[level], level, theme),
          ],
        ),
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

  Widget _buildColumn(
    BuildContext context,
    List<TTreeSelectOption> options,
    int level,
    TTreeSelectThemeData? theme,
  ) {
    final width =
        level == 0 ? theme?.rootColumnWidth ?? 112 : theme?.columnWidth ?? 184;
    final backgroundColor = level == 0
        ? theme?.rootBackgroundColor ?? context.tTheme.bgColorSecondaryContainer
        : theme?.backgroundColor ?? context.tTheme.bgColorContainer;
    return Container(
      width: width,
      color: backgroundColor,
      child: ListView.builder(
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
    required TTreeSelectThemeData? theme,
  }) {
    final defaultStyle = TextStyle(
      color: context.tTheme.textColorPrimary,
      fontSize: context.tTheme.fontBodyMedium?.size ?? 14,
    );
    final selectedStyle = defaultStyle.copyWith(
      color: context.tTheme.brandNormalColor,
      fontWeight: FontWeight.w600,
    );
    return Semantics(
      selected: selected,
      enabled: !option.disabled,
      child: Opacity(
        opacity: option.disabled ? 0.4 : 1,
        child: ListTile(
          key: ValueKey((level, option.value)),
          minTileHeight: theme?.itemHeight ?? 56,
          selected: selected,
          selectedTileColor:
              theme?.selectedBackgroundColor ?? context.tTheme.bgColorContainer,
          title: Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: option.disabled
                ? theme?.disabledTextStyle ??
                    defaultStyle.copyWith(
                      color: context.tTheme.textDisabledColor,
                    )
                : selected
                    ? theme?.selectedTextStyle ?? selectedStyle
                    : theme?.textStyle ?? defaultStyle,
          ),
          trailing: isBranch
              ? const Icon(TIcons.chevron_right)
              : selected
                  ? Icon(
                      TIcons.check,
                      color: theme?.indicatorColor ??
                          context.tTheme.brandNormalColor,
                    )
                  : null,
          onTap: option.disabled
              ? null
              : () => isBranch
                  ? _openBranch(path)
                  : _toggleLeaf(List.unmodifiable(path)),
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
