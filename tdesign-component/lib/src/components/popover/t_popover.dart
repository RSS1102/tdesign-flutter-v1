import 'package:flutter/material.dart';

import 't_popover_theme_data.dart';
import 't_popover_widget.dart';

/// 气泡弹层
///
/// 通过 [showPopover] 静态方法弹出，支持 12 个方向定位和箭头。
class TPopover {
  /// 显示气泡弹层
  static Future showPopover({
    required BuildContext context,
    String? content,
    Widget? contentWidget,
    double offset = 4,
    TPopoverColorScheme? colorScheme,
    bool closeOnClickOutside = true,
    TPopoverPlacement? placement,
    bool? showArrow = true,
    double arrowSize = 8,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    Color? overlayColor = Colors.transparent,
    TPopoverTapCallback? onTap,
    TPopoverLongPressCallback? onLongTap,
    BorderRadius? radius,
  }) {
    final theme = Theme.of(context).extension<TPopoverThemeData>() ??
        const TPopoverThemeData();
    return showDialog(
      barrierDismissible: closeOnClickOutside,
      barrierColor: overlayColor ?? theme.barrierColor,
      useSafeArea: false,
      context: context,
      builder: (ctx) => TPopoverWidget(
        context: context,
        content: content,
        contentWidget: contentWidget,
        offset: offset == 4 ? theme.offset ?? offset : offset,
        colorScheme: colorScheme ?? theme.colorScheme,
        placement: placement,
        showArrow: showArrow ?? theme.showArrow,
        arrowSize: arrowSize == 8 ? theme.arrowSize ?? arrowSize : arrowSize,
        padding: padding ?? theme.padding,
        width: width ?? theme.minWidth,
        height: height ?? theme.maxHeight,
        onTap: onTap,
        onLongTap: onLongTap,
        radius: radius ?? (theme.borderRadius == null
            ? null
            : BorderRadius.circular(theme.borderRadius!)),
      ),
    );
  }
}
