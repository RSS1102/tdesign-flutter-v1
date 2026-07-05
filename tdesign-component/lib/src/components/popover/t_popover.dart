import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

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
    OnTap? onTap,
    OnLongTap? onLongTap,
    BorderRadius? radius,
  }) {
    return showDialog(
      barrierDismissible: closeOnClickOutside,
      barrierColor: overlayColor,
      useSafeArea: false,
      context: context,
      builder: (ctx) => TPopoverWidget(
        context: context,
        content: content,
        contentWidget: contentWidget,
        offset: offset,
        colorScheme: colorScheme,
        placement: placement,
        showArrow: showArrow,
        arrowSize: arrowSize,
        padding: padding,
        width: width,
        height: height,
        onTap: onTap,
        onLongTap: onLongTap,
        radius: radius,
      ),
    );
  }
}
