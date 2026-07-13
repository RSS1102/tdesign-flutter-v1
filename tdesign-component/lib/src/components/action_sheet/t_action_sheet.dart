import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../popup/t_popup.dart';
import 't_action_sheet.dart';
import 't_action_sheet_grid.dart';
import 't_action_sheet_group.dart';
import 't_action_sheet_list.dart';
import 't_action_sheet_theme_data.dart';

export 't_action_sheet_item.dart';

/// 选择项目时的回调函数类型
///
/// [item] 被选中的项目，[index] 项目索引
typedef TActionSheetOnChanged = void Function(
    TActionSheetItem item, int index);

/// 动作面板主题样式
enum TActionSheetTheme { list, grid, group }

/// 动作面板对齐方式
enum TActionSheetAlign { center, left, right }

/// 动作面板
class TActionSheet {
  TActionSheet(
    this.context, {
    this.align,
    this.cancelText,
    this.count,
    this.rows,
    this.itemHeight,
    this.itemMinWidth,
    this.subtitle,
    required this.items,
    this.showCancel,
    this.showPagination,
    this.scrollable,
    this.theme = TActionSheetTheme.list,
    this.visible = false,
    this.onCancel,
    this.onClose,
    this.onChanged,
    this.showOverlay = true,
    this.closeOnOverlayClick = true,
    this.useSafeArea,
  }) {
    if (visible) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 对齐方式
  final TActionSheetAlign? align;

  /// 取消按钮的文本
  final String? cancelText;

  /// 每页显示的项目数
  /// 当[theme]等于[TActionSheetTheme.grid]且[showPagination]为true时有效
  final int? count;

  /// 显示的行数
  /// 当[theme]等于[TActionSheetTheme.grid]时有效
  final int? rows;

  /// 项目的行高
  /// 当[theme]等于[TActionSheetTheme.grid]或[theme]等于[TActionSheetTheme.group]时有效
  final double? itemHeight;

  /// 项目的最小宽度
  /// 当[theme]等于[TActionSheetTheme.grid]且[scrollable]为true时有效
  /// 或当[theme]等于[TActionSheetTheme.group]时有效
  final double? itemMinWidth;

  /// 描述文本
  /// 当[theme]等于[TActionSheetTheme.grid]或[theme]等于[TActionSheetTheme.list]时有效
  final String? subtitle;

  /// ActionSheet的项目列表
  final List<TActionSheetItem> items;

  /// 是否显示取消按钮
  final bool? showCancel;

  /// 是否显示遮罩层
  final bool showOverlay;

  /// 点击蒙层时是否关闭
  final bool closeOnOverlayClick;

  /// 主题样式
  final TActionSheetTheme theme;

  /// 是否立即显示
  final bool visible;

  /// 是否显示分页
  /// 当[theme]等于[TActionSheetTheme.grid]时有效
  final bool? showPagination;

  /// 是否可以横向滚动
  /// 当[theme]等于[TActionSheetTheme.grid]且[showPagination]为false时有效
  final bool? scrollable;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 关闭时的回调函数
  final VoidCallback? onClose;

  /// 选择项目时的回调函数
  final TActionSheetOnChanged? onChanged;

  /// 使用安全区域
  final bool? useSafeArea;

  static TPopupHandle? _actionSheetHandle;

  /// 显示列表类型面板
  static void showListActionSheet(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    bool? showCancel,
    VoidCallback? onCancel,
    TActionSheetOnChanged? onChanged,
    bool? showOverlay,
    bool? closeOnOverlayClick,
    VoidCallback? onClose,
    bool? useSafeArea,
  }) {
    _createRoute(
      context,
      theme: TActionSheetTheme.list,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onChanged: onChanged,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 显示宫格类型面板
  static void showGridActionSheet(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    bool? showCancel,
    TActionSheetOnChanged? onChanged,
    bool? showOverlay,
    bool? closeOnOverlayClick,
    int? count,
    int? rows,
    double? itemHeight,
    double? itemMinWidth,
    bool? scrollable,
    bool? showPagination,
    VoidCallback? onCancel,
    String? subtitle,
    VoidCallback? onClose,
    bool? useSafeArea,
  }) {
    _createRoute(
      context,
      theme: TActionSheetTheme.grid,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onChanged: onChanged,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      scrollable: scrollable,
      showPagination: showPagination,
      subtitle: subtitle,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 显示分组类型面板
  static void showGroupActionSheet(
    BuildContext context, {
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    bool? showCancel,
    TActionSheetOnChanged? onChanged,
    bool? showOverlay,
    bool? closeOnOverlayClick,
    double? itemHeight,
    double? itemMinWidth,
    VoidCallback? onCancel,
    VoidCallback? onClose,
    bool? useSafeArea,
  }) {
    _createRoute(
      context,
      theme: TActionSheetTheme.group,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onChanged: onChanged,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 显示动作面板
  void show() {
    TActionSheet._createRoute(
      context,
      theme: theme,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onChanged: onChanged,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      scrollable: scrollable,
      showPagination: showPagination,
      subtitle: subtitle,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  /// 打开动作面板（等同 [show]）
  void open() {
    show();
  }

  /// 关闭动作面板
  @mustCallSuper
  void close() {
    _actionSheetHandle?.close();
  }

  /// 创建路由
  static void _createRoute(
    BuildContext context, {
    required TActionSheetTheme theme,
    required List<TActionSheetItem> items,
    TActionSheetAlign? align,
    String? cancelText,
    bool? showCancel,
    TActionSheetOnChanged? onChanged,
    bool? showOverlay,
    bool? closeOnOverlayClick,
    int? count,
    int? rows,
    double? itemHeight,
    double? itemMinWidth,
    bool? scrollable,
    bool? showPagination,
    VoidCallback? onCancel,
    String? subtitle,
    VoidCallback? onClose,
    bool? useSafeArea,
  }) {
    if (_actionSheetHandle?.isShowing == true) {
      return;
    }

    // P1: 组件级 ThemeExtension 回退
    final tTheme = Theme.of(context).extension<TActionSheetThemeData>();
    final effectiveAlign = align ?? tTheme?.defaultAlign ?? TActionSheetAlign.center;
    final effectiveShowCancel = showCancel ?? tTheme?.showCancelButton ?? true;
    final effectiveShowOverlay = showOverlay ?? true;
    final effectiveCloseOnOverlayClick = closeOnOverlayClick ?? true;
    final effectiveCount = count ?? tTheme?.count ?? 8;
    final effectiveRows = rows ?? tTheme?.rows ?? 2;
    final effectiveItemHeight = itemHeight ?? tTheme?.itemHeight ?? 96.0;
    final effectiveItemMinWidth = itemMinWidth ?? tTheme?.itemMinWidth ?? 80.0;
    final effectiveScrollable = scrollable ?? tTheme?.scrollable ?? false;
    final effectiveShowPagination = showPagination ?? tTheme?.showPagination ?? false;
    final effectiveUseSafeArea = useSafeArea ?? tTheme?.useSafeArea ?? true;
    final effectiveCancelText = cancelText ?? tTheme?.cancelText ?? context.resource.cancel;

    Widget sheetChild;
    switch (theme) {
      case TActionSheetTheme.list:
        sheetChild = TActionSheetList(
          items: items,
          align: effectiveAlign,
          cancelText: effectiveCancelText,
          subtitle: subtitle,
          showCancel: effectiveShowCancel,
          onCancel: onCancel,
          onChanged: onChanged,
          useSafeArea: effectiveUseSafeArea,
        );
        break;
      case TActionSheetTheme.grid:
        sheetChild = TActionSheetGrid(
          items: items,
          align: effectiveAlign,
          onChanged: onChanged,
          showCancel: effectiveShowCancel,
          showPagination: effectiveShowPagination,
          scrollable: effectiveScrollable,
          cancelText: effectiveCancelText,
          subtitle: subtitle,
          count: effectiveCount,
          rows: effectiveRows,
          onCancel: onCancel,
          itemHeight: effectiveItemHeight,
          itemMinWidth: effectiveItemMinWidth,
          useSafeArea: effectiveUseSafeArea,
        );
        break;
      case TActionSheetTheme.group:
        sheetChild = TActionSheetGroup(
          items: items,
          align: effectiveAlign,
          cancelText: effectiveCancelText,
          showCancel: effectiveShowCancel,
          onCancel: onCancel,
          onChanged: onChanged,
          itemHeight: effectiveItemHeight,
          itemMinWidth: effectiveItemMinWidth,
          useSafeArea: effectiveUseSafeArea,
        );
        break;
    }

    _actionSheetHandle = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        cancelBuilder: null,
        confirmBuilder: null,
        showOverlay: effectiveShowOverlay,
        closeOnOverlayClick: effectiveShowOverlay && effectiveCloseOnOverlayClick,
        overlayColor: effectiveShowOverlay ? null : Colors.transparent,
        onClosed: onClose,
        child: sheetChild,
      ),
    );
  }
}
