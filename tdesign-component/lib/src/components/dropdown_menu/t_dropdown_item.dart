import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../tag/t_select_tag.dart';
import '../tag/t_tag_theme_data.dart';
import 't_dropdown_inherited.dart';
import 't_dropdown_popup.dart';

/// 下拉菜单内容构建器
typedef TDropdownItemContentBuilder = Widget Function(BuildContext context,
    _TDropdownItemState itemState, TDropdownPopup? popupState);

/// 下拉菜单选项变更回调
typedef TDropdownItemOptionsCallback = void Function(
    List<TDropdownItemOption>? options);

List<TDropdownItemOption?> _getSelected(List<TDropdownItemOption>? options) {
  return options?.where((element) => element.selected == true).toList() ?? [];
}

/// 补充列数，使最后一行的选项宽度一样
int _num(List list, int? n) {
  var val = n ?? 1;
  if (list.length < val) {
    return val;
  }
  return list.length + list.length % val;
}

/// 下拉菜单控制器
class TDropdownItemController {
  _TDropdownItemState? _state;

  void _bindState(_TDropdownItemState _tdDropdownMenuState) {
    _state = _tdDropdownMenuState;
  }

  /// 将所有选项重置为未选中状态
  void reset() {
    _state?.reset();
  }

  /// 更新选项内容。注意：增删内容可能导致高度展示异常，请谨慎操作
  void updateOptions(TDropdownItemOptionsCallback callback) {
    _state?.updateOptions(callback);
  }
}

/// 下拉菜单内容
class TDropdownItem<T> extends StatefulWidget {
  const TDropdownItem({
    Key? key,
    this.disabled = false,
    this.label,
    this.arrowIcon,
    this.arrowColor,
    this.multiple = false,
    this.options = const [],
    this.builder,
    this.optionsColumns = 1,
    this.onChanged,
    this.onConfirm,
    this.onReset,
    this.minHeight,
    this.maxHeight,
    this.tabBarWidth,
    this.tabBarAlign,
    this.tabBarFlex = 1,
    this.controller,
  }) : super(key: key);

  /// 是否禁用
  final bool? disabled;

  /// 标题
  final String? label;

  /// 自定义箭头图标
  final IconData? arrowIcon;

  /// 自定义箭头颜色
  final Color? arrowColor;

  /// 是否多选
  final bool? multiple;

  /// 选项数据
  final List<TDropdownItemOption>? options;

  /// 完全自定义展示内容
  final TDropdownItemContentBuilder? builder;

  /// 选项分栏（1-3）
  final int? optionsColumns;

  /// 值改变时触发
  final ValueChanged<T?>? onChanged;

  /// 点击确认时触发
  final ValueChanged<T?>? onConfirm;

  /// 点击重置时触发
  final VoidCallback? onReset;

  /// 内容最小高度
  final double? minHeight;

  /// 内容最大高度
  final double? maxHeight;

  /// 该item在menu上的宽度，仅在[TDropdownMenu.isScrollable]为true时有效
  final double? tabBarWidth;

  /// [label]和[arrowIcon]/[TDropdownMenu.arrowIcon]的对齐方式
  final MainAxisAlignment? tabBarAlign;

  /// 该item在menu上的宽度占比，仅在[TDropdownMenu.isScrollable]为false时有效
  final int? tabBarFlex;

  /// 下拉菜单控制器
  final TDropdownItemController? controller;

  static const double operateHeight = 73;

  double? get minContentHeight => multiple == true
      ? (minHeight != null ? minHeight! + TDropdownItem.operateHeight : null)
      : minHeight;

  double? get maxContentHeight => multiple == true
      ? (maxHeight != null ? maxHeight! + TDropdownItem.operateHeight : null)
      : maxHeight;

  @override
  _TDropdownItemState createState() => _TDropdownItemState();

  String getLabel() {
    if (multiple == true) {
      return label ?? '';
    }
    var list = _getSelected(options);
    if (list.isEmpty) {
      return label ?? '';
    }
    return list[0]?.label ?? label ?? '';
  }
}

class _TDropdownItemState extends State<TDropdownItem> {
  late TDropdownPopup popupState;
  late ValueNotifier<TDropdownMenuDirection> directionListenable;

  @override
  void initState() {
    super.initState();
    widget.controller?._bindState(this);
  }

  @override
  Widget build(BuildContext context) {
    popupState = TDropdownInherited.of(context)!.popupState;
    directionListenable = TDropdownInherited.of(context)!.directionListenable;
    if (widget.builder != null) {
      return widget.builder!(context, this, popupState);
    }
    return widget.multiple == true || (widget.optionsColumns ?? 1) > 1
        ? _getCheckboxList()
        : _getRadioList();
  }

  Widget _getCheckboxList() {
    var isMultiple = widget.multiple == true;
    var paddingNum = context.tTheme.spacer16;
    var groupChunk = _groupChunkOptions();
    var maxContentHeight = widget.maxContentHeight != null
        ? widget.maxContentHeight!
        : directionListenable.value == TDropdownMenuDirection.auto
            ? double.infinity
            : max<double>(
                popupState.maxContentHeight - TDropdownItem.operateHeight, 0);
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: widget.minContentHeight ?? 0.0,
                maxHeight: maxContentHeight),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(groupChunk.length, (index) {
                  var entry = groupChunk.entries.elementAt(index);
                  var chunks = entry.value;
                  return Column(
                    children: [
                      groupChunk.length == 1 && entry.key == '__default__'
                          ? const SizedBox.shrink()
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  left: paddingNum,
                                  top: paddingNum,
                                  right: paddingNum),
                              color: context.tTheme.bgColorContainer,
                              child: TText(entry.key == '__default__'
                                  ? context.resource.other
                                  : entry.key),
                            ),
                      Container(
                        padding: EdgeInsets.all(paddingNum),
                        color: context.tTheme.bgColorContainer,
                        child: Column(
                          children: List.generate(chunks.length, (ri) {
                            var num = _num(chunks[ri], widget.optionsColumns);
                            return Padding(
                              padding: _getPadding(chunks.length, ri, 'bottom'),
                              child: Row(
                                children: List.generate(num, (ci) {
                                  return Expanded(
                                    child: Padding(
                                      padding: _getPadding(num, ci, 'right'),
                                      child: _getCheckboxItem(chunks[ri], ci),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        if (isMultiple) _getCheckboxOperate(),
      ],
    );
  }

  Widget _getRadioList() {
    var selected = _getSelected(widget.options);
    var radios = TRadioGroup<String>(
      value: selected.isEmpty ? null : selected[0]?.value,
      onChanged: _handleSelectChange,
      options: [
        for (final option in widget.options ?? const <TDropdownItemOption>[])
          TRadioOption<String>(
            value: option.value,
            label: option.label,
            disabled: option.disabled ?? false,
          ),
      ],
      contentDirection: TContentDirection.left,
      itemBuilder: (context, option, isSelected, disabled) {
        final source = widget.options!.firstWhere(
          (item) => item.value == option.value,
        );
        return Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TText(
                  option.label,
                  textColor: disabled
                      ? context.tTheme.textDisabledColor
                      : context.tTheme.textColorPrimary,
                ),
              ),
              if (isSelected)
                Icon(
                  TIcons.check,
                  color: disabled
                      ? context.tTheme.textDisabledColor
                      : (source.selectedColor ??
                          context.tTheme.brandNormalColor),
                ),
            ],
          ),
        );
      },
    );
    return widget.minContentHeight != null || widget.maxContentHeight != null
        ? Container(
            color: context.tTheme.bgColorContainer,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: widget.minContentHeight ?? 0.0,
                  maxHeight: widget.maxContentHeight ?? double.infinity),
              child: widget.maxContentHeight != null
                  ? SingleChildScrollView(child: radios)
                  : radios,
            ),
          )
        : radios;
  }

  Widget? _getCheckboxItem(List<TDropdownItemOption> cols, int index) {
    var col = index >= cols.length ? null : cols[index];
    if (col == null) {
      return null;
    }
    final disabled = col.disabled ?? false;
    final checked = col.selected;
    final content = Container(
      height: 40,
      decoration: BoxDecoration(
        color: !disabled
            ? checked
                ? context.tTheme.brandLightColor
                : context.tTheme.bgColorSecondaryContainer
            : context.tTheme.bgColorSecondaryContainerHover,
        borderRadius: BorderRadius.all(
          Radius.circular(context.tTheme.radiusDefault),
        ),
      ),
      child: Center(
        child: TText(
          col.label,
          textColor: !disabled
              ? checked
                  ? (col.selectedColor ?? context.tTheme.brandColor7)
                  : context.tTheme.textColorPrimary
              : (col.disabledColor ?? context.tTheme.textDisabledColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    return Semantics(
      enabled: !disabled,
      checked: checked,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled
            ? null
            : () {
                final selectedIds = _getSelected(widget.options)
                    .map((item) => item!.value)
                    .toSet();
                if (checked) {
                  selectedIds.remove(col.value);
                } else {
                  selectedIds.add(col.value);
                }
                _handleSelectChange(selectedIds.toList());
              },
        child: content,
      ),
    );
  }

  Widget _getCheckboxOperate() {
    return Container(
      height: TDropdownItem.operateHeight,
      padding: EdgeInsets.all(context.tTheme.spacer16),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        border: Border(
          top: BorderSide(
            color: context.tTheme.componentStrokeColor,
            width: 0.5,
          ),
          bottom: directionListenable.value == TDropdownMenuDirection.up
              ? BorderSide(
                  color: context.tTheme.componentStrokeColor,
                  width: 0.5,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        // spacing: context.tTheme.spacer16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TButton(
              child: Text(context.resource.reset),
              colorScheme: TButtonColorScheme.light,
              onPressed: () {
                reset();
                widget.onReset?.call();
              },
            ),
          ),
          SizedBox(width: context.tTheme.spacer16),
          Expanded(
            child: TButton(
              child: Text(context.resource.confirm),
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                _handleClose();
                widget.onConfirm?.call(
                    _getSelected(widget.options).map((e) => e!.value).toList());
              },
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding(int length, int index, String direction) {
    var value = length - 1 == index ? 0.0 : context.tTheme.spacer12;
    if (direction == 'bottom') {
      return EdgeInsets.only(bottom: value);
    }
    if (direction == 'right') {
      return EdgeInsets.only(right: value);
    }
    return EdgeInsets.all(value);
  }

  Map<String, List<List<TDropdownItemOption>>> _groupChunkOptions() {
    var groupedOptions = widget.options
            ?.groupBy<String>((option) => option.group ?? '__default__') ??
        {};
    var groupedChunkOptions = <String, List<List<TDropdownItemOption>>>{};
    var def = groupedOptions.remove('__default__');
    if (def != null) {
      groupedOptions['__default__'] = def;
    }
    groupedOptions.forEach((key, value) {
      groupedChunkOptions[key] = value.chunk(widget.optionsColumns ?? 1);
    });
    return groupedChunkOptions;
  }

  void _handleSelectChange(dynamic selected) {
    List<String> selectedIds;
    if (selected is List<String>) {
      selectedIds = selected;
    } else if (selected is String?) {
      selectedIds = selected == null ? [] : [selected];
    } else {
      selectedIds = [];
    }
    final isRadio = widget.multiple != true;
    widget.options?.forEach((element) {
      element.selected = selectedIds.contains(element.value);
    });
    if (isRadio) {
      setState(() {});
      // 单选回传单个选中值（与 ValueChanged<T?> 类型匹配）
      widget.onChanged
          ?.call(selectedIds.isEmpty ? null : selectedIds.first as dynamic);
      if (selectedIds.isNotEmpty) {
        _handleClose();
      }
    } else {
      widget.onChanged?.call(selectedIds);
    }
  }

  void _handleClose() async {
    if (widget.multiple != true || (widget.optionsColumns ?? 1) > 1) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (!mounted) {
      return;
    }
    await Navigator.maybePop(context);
  }

  void reset() {
    widget.options?.forEach((element) {
      element.selected = false;
    });
    setState(() {});
  }

  void updateOptions(TDropdownItemOptionsCallback callback) {
    callback(widget.options);
    setState(() {});
  }
}

/// 选项数据
class TDropdownItemOption {
  TDropdownItemOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.group,
    this.selected = false,
    this.selectedColor,
    this.disabledColor,
  });

  /// 选项值
  String value;

  /// 选项标题
  final String label;

  /// 是否禁用
  bool? disabled;

  /// 分组，相同的为一组
  final String? group;

  /// 是否选中
  bool selected;

  /// 选中颜色
  final Color? selectedColor;

  /// 禁用颜色
  final Color? disabledColor;
}
