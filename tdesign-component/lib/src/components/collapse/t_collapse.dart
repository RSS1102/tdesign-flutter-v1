/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_collapse_theme_data.dart';
import 't_collapse_salted_key.dart';
import 't_inset_divider.dart';
import 't_nonanimated_expand_icon.dart';

/// 折叠面板模式
enum TCollapseMode {
  /// 多开模式
  multiple,

  /// 手风琴模式（仅一个面板展开）
  accordion,
}

/// 折叠面板列表组件，需配合 [TCollapsePanel] 使用
class TCollapse extends StatefulWidget {
  const TCollapse({
    required this.children,
    this.mode = TCollapseMode.multiple,
    this.onExpansionChanged,
    this.animationDuration = kThemeAnimationDuration,
    this.elevation = 0,
    this.value,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  /// 折叠面板列表的子组件
  final List<TCollapsePanel> children;

  /// 折叠面板模式
  final TCollapseMode mode;

  /// 折叠面板列表的回调函数；
  /// 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded
  final ExpansionPanelCallback? onExpansionChanged;

  /// 折叠面板列表的动画时长
  final Duration animationDuration;

  /// 折叠面板列表的阴影
  final double elevation;

  /// 手风琴模式下当前展开面板的 value
  final Object? value;

  /// 手风琴模式下 value 变更回调
  final ValueChanged<Object?>? onChanged;

  @override
  State createState() => _TCollapseState();
}

class _TCollapseState extends State<TCollapse> {
  TCollapsePanel? _currentOpenPanel;

  /// 从 Theme 子树读取 L4 默认值
  TCollapseThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TCollapseThemeData>();

  bool get _isAccordion => widget.mode == TCollapseMode.accordion;

  bool _isCardStyle(BuildContext context) {
    final theme = _theme(context);
    return theme?.style == 'card';
  }

  @override
  void initState() {
    super.initState();

    if (!_isAccordion) {
      return;
    }

    assert(_allPanelsHaveValue(),
        'When allowing only one panel to be open, every panel must have a value.');
    assert(_allPanelsHaveDistinctValues(),
        'When allowing only one panel to be open, every panel must have a distinct value.');

    if (widget.value != null) {
      _currentOpenPanel = _searchPanelByValue(widget.value);
    }
  }

  @override
  void didUpdateWidget(TCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isAccordion) {
      _currentOpenPanel = null;
      return;
    }

    assert(_allPanelsHaveValue(),
        'When allowing only one panel to be open, every panel must have a value.');
    assert(_allPanelsHaveDistinctValues(),
        'When allowing only one panel to be open, every panel must have a distinct value.');

    if (oldWidget.mode != TCollapseMode.accordion) {
      _currentOpenPanel = _searchPanelByValue(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <MergeableMaterialItem>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) &&
          index != 0 &&
          !_isChildExpanded(index - 1)) {
        items.add(_buildGap(context, index * 2 - 1));
      }

      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];

      final titleWidget = _buildTitleWidget(context, child, index);
      final expandIconWidget = _buildExpandIconWidget(context, child, index);

      final borderRadius =
          _isCardStyle(context) ? _createRadius(index) : BorderRadius.zero;

      final theme = _theme(context);
      final bgColor = child.backgroundColor ?? theme?.backgroundColor ?? TTheme.of(context).bgColorContainer;

      items.add(
        MaterialSlice(
            key: TCollapseSaltedKey<BuildContext, int>(context, index * 2),
            color: bgColor,
            child: Column(
              key: TCollapseSaltedKey<BuildContext, int>(context, index * 2),
              children: [
                MergeSemantics(
                  child: InkWell(
                    borderRadius: borderRadius,
                    onTap: () => _handlePressed(index, _isChildExpanded(index)),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: widget.animationDuration,
                            curve: Curves.fastOutSlowIn,
                            margin: EdgeInsets.zero,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: kMinInteractiveDimension,
                              ),
                              child: titleWidget,
                            ),
                          ),
                        ),
                        expandIconWidget,
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: Container(height: 0.0),
                  secondChild: Column(
                    children: [
                      const TInsetDivider(),
                      Container(
                        padding: EdgeInsets.all(TTheme.of(context).spacer16),
                        child: child.body,
                      ),
                    ],
                  ),
                  firstCurve:
                      const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve:
                      const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: widget.animationDuration,
                ),
                if (!isLastChild) const TInsetDivider()
              ],
            )),
      );

      if (_isChildExpanded(index) && !isLastChild) {
        items.add(_buildGap(context, index * 2 + 1));
      }
    }

    Widget collapse = MergeableMaterial(
      hasDividers: false,
      elevation: widget.elevation,
      children: items,
    );

    if (_isCardStyle(context)) {
      collapse = Container(
        child: ClipRRect(
          child: collapse,
          borderRadius: BorderRadius.circular(TTheme.of(context).radiusLarge),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: TTheme.of(context).spacer16,
        ),
      );
    }

    return collapse;
  }

  MergeableMaterialItem _buildGap(BuildContext context, int value) {
    return MaterialGap(
      size: 0.0,
      key: TCollapseSaltedKey<BuildContext, int>(context, value),
    );
  }

  BorderRadius _createRadius(int index) {
    final radius = Radius.circular(TTheme.of(context).radiusLarge);

    final isFirst = index == 0;
    if (isFirst) {
      return BorderRadius.only(topLeft: radius, topRight: radius);
    }

    final isLast = index == widget.children.length - 1;
    if (isLast) {
      return BorderRadius.only(bottomLeft: radius, bottomRight: radius);
    }

    return BorderRadius.zero;
  }

  bool _isChildExpanded(int index) {
    final child = widget.children[index];

    if (_isAccordion) {
      return _currentOpenPanel?.value == child.value;
    }

    return child.isExpanded;
  }

  void _handlePressed(int index, bool isExpanded) {
    widget.onExpansionChanged?.call(index, isExpanded);

    if (!_isAccordion) {
      return;
    }

    for (var childIndex = 0;
        childIndex < widget.children.length;
        childIndex += 1) {
      final curChild = widget.children[childIndex];
      if (widget.onExpansionChanged != null &&
          childIndex != index &&
          curChild.value == _currentOpenPanel?.value) {
        widget.onExpansionChanged!(childIndex, false);
      }
    }

    setState(() {
      _currentOpenPanel = isExpanded ? null : widget.children[index];
    });

    // 手风琴受控回调
    widget.onChanged?.call(_currentOpenPanel?.value);
  }

  Widget _buildTitleWidget(
      BuildContext context, TCollapsePanel child, int index) {
    final titleWidget = child.headerBuilder(context, _isChildExpanded(index));
    return ListTile(
      title: titleWidget,
    );
  }

  Widget _buildExpandIconWidget(
      BuildContext context, TCollapsePanel child, int index) {
    Widget expandedIcon = Container(
      key: TCollapseSaltedKey<BuildContext, int>(context, index * 2),
      margin: const EdgeInsetsDirectional.all(0.0),
      child: TNonAnimatedExpandIcon(
        isExpanded: _isChildExpanded(index),
        padding: child.expandIconTextBuilder != null
            ? EdgeInsets.only(
                right: TTheme.of(context).spacer16,
                top: TTheme.of(context).spacer16,
                bottom: TTheme.of(context).spacer16,
                left: 0,
              )
            : EdgeInsets.all(TTheme.of(context).spacer16),
      ),
    );

    return Row(
      children: [
        if (child.expandIconTextBuilder != null)
          Text(child.expandIconTextBuilder!(context, _isChildExpanded(index)),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: TTheme.of(context).textColorPlaceholder,
              )),
        expandedIcon,
      ],
    );
  }

  bool _allPanelsHaveValue() {
    return widget.children.every((TCollapsePanel child) {
      return child.value != null;
    });
  }

  bool _allPanelsHaveDistinctValues() {
    final valueSet = <Object?>{};
    return widget.children.every((TCollapsePanel child) {
      if (!valueSet.add(child.value)) {
        return false;
      }
      return true;
    });
  }

  TCollapsePanel? _searchPanelByValue(Object? value) {
    for (var index = 0; index < widget.children.length; index += 1) {
      final child = widget.children[index];
      if (child.value == value) {
        return child;
      }
    }
    return null;
  }
}
