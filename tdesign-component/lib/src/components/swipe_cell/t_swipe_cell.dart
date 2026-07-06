import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util/list_ext.dart';
import '../cell/t_cell.dart';
import 't_swipe_cell_action.dart';
import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_panel.dart';
import 't_swipe_cell_theme_data.dart';

export 'package:flutter_slidable/flutter_slidable.dart';

/// 滑动方向
enum TSwipeDirection { right, left }

/// 滑动单元格组件
class TSwipeCell extends StatefulWidget {
  const TSwipeCell({
    Key? key,
    required this.cell,
    this.enabled = true,
    this.right,
    this.left,
    this.onChanged,
    this.controller,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  /// 单元格 [TCell]
  final Widget cell;

  /// 是否启用滑动（默认 true，false 表示禁用）
  final bool enabled;

  /// 右侧滑动操作项面板
  final TSwipeCellPanel? right;

  /// 左侧滑动操作项面板
  final TSwipeCellPanel? left;

  /// 滑动展开事件
  final Function(TSwipeDirection direction, bool open)? onChanged;

  /// 自定义控制滑动窗口
  final SlidableController? controller;

  /// 可拖动的方向
  final Axis? direction;

  /// 组件级主题配置，优先级高于 Theme Extension

  /// 获取生效的 Theme（实例 themeData > Theme Extension > 默认值）
  TSwipeCellThemeData _effectiveTheme(BuildContext context) {
    return (Theme.of(context).extension<TSwipeCellThemeData>() ??
            const TSwipeCellThemeData());
  }

  /// 获取滑动动画时长
  Duration getDuration(BuildContext context) =>
      _effectiveTheme(context).duration ?? const Duration(milliseconds: 200);

  static final Map<Object, List<SlidableController>> _controllers = {};

  static void _pushController(SlidableController controller, Object? tag,
      {bool del = false}) {
    if (tag == null) {
      return;
    }
    if (del) {
      if (_controllers.keys.contains(tag)) {
        _controllers[tag]!.remove(controller);
      }
    } else {
      if (_controllers.keys.contains(tag)) {
        if (!_controllers[tag]!.contains(controller)) {
          _controllers[tag]!.add(controller);
        }
      } else {
        _controllers[tag] = [controller];
      }
    }
  }

  /// 根据[groupTag]关闭[TSwipeCell]
  ///
  /// current：保留当前不关闭
  static void close(Object? tag, {SlidableController? current}) {
    if (tag == null || !_controllers.keys.contains(tag)) {
      return;
    }
    _controllers[tag]!.forEach((element) {
      if (element != current) {
        element.close();
      }
    });
  }

  /// 获取上下文最近的[controller]
  static SlidableController? of(BuildContext context) {
    return Slidable.of(context);
  }

  @override
  _TSwipeCellState createState() => _TSwipeCellState();
}

class _TSwipeCellState extends State<TSwipeCell>
    with TickerProviderStateMixin {
  late final SlidableController controller;
  final confirmListenable = ValueNotifier<TSwipeCellAction?>(null);
  TSwipeDirection? openDirection;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ?? SlidableController(this))
      ..actionPaneType.addListener(_handleActionPanelTypeChanged)
      ..animation.addStatusListener((status) {
        confirmListenable.value = null;
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final theme = widget._effectiveTheme(context);
      final opened = theme.opened;
      if ((opened?.length ?? 0) > 0 && opened![0] == true) {
        controller.openStartActionPane(duration: widget.getDuration(context));
      }
      if ((opened?.length ?? 0) > 1 && opened![1] == true) {
        controller.openEndActionPane(duration: widget.getDuration(context));
      }
    });
  }

  @override
  void didUpdateWidget(covariant TSwipeCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final theme = widget._effectiveTheme(context);
      controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
      TSwipeCell._pushController(controller, theme.groupTag, del: true);
      controller = (widget.controller ?? SlidableController(this))
        ..actionPaneType.addListener(_handleActionPanelTypeChanged);
      TSwipeCell._pushController(controller, theme.groupTag);
    }
  }

  @override
  void dispose() {
    controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
    controller.dispose();
    final theme = widget._effectiveTheme(context);
    TSwipeCell._pushController(controller, theme.groupTag, del: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget._effectiveTheme(context);
    final rightConfirmLength = widget.right?.confirms?.length ?? 0;
    final leftConfirmLength = widget.left?.confirms?.length ?? 0;

    final slidable = Slidable(
      key: theme.slidableKey ?? UniqueKey(),
      closeOnScroll: false,
      child: widget.cell,
      controller: controller,
      enabled: widget.enabled,
      groupTag: theme.groupTag,
      startActionPane: widget.left?.build(context),
      endActionPane: widget.right?.build(context),
      dragStartBehavior:
          theme.dragStartBehavior ?? DragStartBehavior.start,
      direction: widget.direction ?? Axis.horizontal,
    );
    return TSwipeCellInherited(
      duration: widget.getDuration(context),
      controller: controller,
      cellClick: () {
        if (theme.closeWhenTapped == true) {
          TSwipeCell.close(theme.groupTag);
        }
      },
      actionClick: (action) {
        final isLeft = openDirection == TSwipeDirection.left;
        final panel = isLeft ? widget.left! : widget.right!;
        final index = panel.children.indexOf(action);
        final confirm = panel.confirms
            ?.find((element) => element.confirmIndex?.contains(index) == true);
        confirmListenable.value = confirm;
        return confirm != null;
      },
      child: rightConfirmLength > 0 || leftConfirmLength > 0
          ? ValueListenableBuilder(
              valueListenable: confirmListenable,
              builder: (BuildContext context, value, Widget? child) {
                return Stack(
                  children: [
                    slidable,
                    _confirmWidget(),
                  ],
                );
              },
            )
          : slidable,
    );
  }

  Widget _confirmWidget() {
    final isHorizontal = widget.direction == Axis.horizontal;
    final isLeft = openDirection == TSwipeDirection.left;
    final pane = isLeft ? widget.left : widget.right;
    final extentRatio = pane?.extentRatio ?? 0.3;
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: isHorizontal
            ? (isLeft ? Alignment.centerLeft : Alignment.centerRight)
            : (isLeft ? Alignment.topCenter : Alignment.bottomCenter),
        widthFactor: isHorizontal ? extentRatio : null,
        heightFactor: isHorizontal ? null : extentRatio,
        child: AnimatedSwitcher(
          duration: widget.getDuration(context),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              child: child,
              position: Tween<Offset>(
                begin: isLeft ? const Offset(-1, 0) : const Offset(1, 0),
                end: isLeft ? const Offset(0, 0) : const Offset(0, 0),
              ).animate(animation),
            );
          },
          child: confirmListenable.value ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _handleActionPanelTypeChanged() {
    final theme = widget._effectiveTheme(context);
    switch (controller.actionPaneType.value) {
      case ActionPaneType.none:
        widget.onChanged?.call(openDirection!, false);
        openDirection = null;
        break;
      case ActionPaneType.start:
        if (theme.closeWhenOpened == true) {
          TSwipeCell.close(theme.groupTag, current: controller);
        }
        openDirection = TSwipeDirection.left;
        widget.onChanged?.call(openDirection!, true);
        break;
      case ActionPaneType.end:
        if (theme.closeWhenOpened == true) {
          TSwipeCell.close(theme.groupTag, current: controller);
        }
        openDirection = TSwipeDirection.right;
        widget.onChanged?.call(openDirection!, true);
        break;
    }
  }
}
