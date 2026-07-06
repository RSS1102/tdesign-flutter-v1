import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../cell/t_cell.dart';
import '../cell/t_cell_group.dart';
import '../cell/t_cell_theme_data.dart';
import '../popup/t_popup.dart';
import 't_drawer_theme_data.dart';
import 't_drawer_widget.dart';

/// 抽屉方向
enum TDrawerPlacement { left, right }

/// 抽屉组件
class TDrawer {
  TDrawer(
    this.context, {
    this.closeOnOverlayClick = true,
    this.footer,
    this.items,
    this.placement = TDrawerPlacement.right,
    this.showOverlay = true,
    this.title,
    this.titleWidget,
    this.visible,
    this.onClose,
    this.onItemClick,
    this.width,
    this.drawerTop,
    this.style,
    this.hover,
    this.backgroundColor,
    this.bordered,
    this.isShowLastBordered,
    this.child,
  }) {
    if (visible == true) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 点击蒙层时是否关闭抽屉
  final bool? closeOnOverlayClick;

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDrawerItem>? items;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? child;

  /// 抽屉方向
  final TDrawerPlacement? placement;

  /// 是否显示遮罩层
  final bool? showOverlay;

  /// 抽屉的标题
  final String? title;

  /// 抽屉的标题组件
  final Widget? titleWidget;

  /// 组件是否可见
  final bool? visible;

  /// 关闭时触发
  final VoidCallback? onClose;

  /// 点击抽屉里的列表项触发
  final TDrawerItemClickCallback? onItemClick;

  /// 宽度（优先级高于 ThemeData）
  final double? width;

  /// 距离顶部的距离
  final double? drawerTop;

  /// 列表自定义样式（优先级高于 ThemeData）
  final TCellThemeData? style;

  /// 是否开启点击反馈（优先级高于 ThemeData）
  final bool? hover;

  /// 组件背景颜色（优先级高于 ThemeData）
  final Color? backgroundColor;

  /// 是否显示边框（优先级高于 ThemeData）
  final bool? bordered;

  /// 是否显示最后一行分割线（优先级高于 ThemeData）
  final bool? isShowLastBordered;

  /// 子树级主题数据

  TPopupHandle? _drawerHandle;

  /// 从 ThemeData 解析有效值
  TDrawerThemeData _resolveTheme() {
    final theme = Theme.of(context).extension<TDrawerThemeData>() ??
        const TDrawerThemeData();
    return theme;
  }

  void show() {
    if (_drawerHandle?.isShowing == true) {
      return;
    }

    final theme = _resolveTheme();
    final overlayEnabled = showOverlay ?? true;
    final dismissible = overlayEnabled && (closeOnOverlayClick ?? true);
    final popupPlacement = placement == TDrawerPlacement.right
        ? TPopupPlacement.right
        : TPopupPlacement.left;
    final popupInset = placement == TDrawerPlacement.right
        ? TPopupRightInset(top: drawerTop ?? 0)
        : TPopupLeftInset(top: drawerTop ?? 0);

    _drawerHandle = TPopup.show(
      context,
      options: TPopupOptions(
        placement: popupPlacement,
        width: width ?? theme.width ?? 280,
        inset: popupInset,
        showOverlay: overlayEnabled,
        closeOnOverlayClick: dismissible,
        overlayColor: overlayEnabled ? null : Colors.transparent,
        onClosed: _deleteRouter,
        child: TDrawerWidget(
          footer: footer,
          items: items,
          child: child,
          title: title,
          titleWidget: titleWidget,
          onItemClick: onItemClick,
          width: width ?? theme.width ?? 280,
          style: style ?? theme.style,
          hover: hover ?? theme.hover ?? true,
          backgroundColor: backgroundColor ?? theme.backgroundColor,
          bordered: bordered ?? theme.bordered ?? true,
          isShowLastBordered:
              isShowLastBordered ?? theme.isShowLastBordered ?? true,
        ),
      ),
    );
  }

  void open() {
    show();
  }

  @mustCallSuper
  void close() {
    _drawerHandle?.close();
  }

  void _deleteRouter() {
    _drawerHandle = null;
    onClose?.call();
  }
}
