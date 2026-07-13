import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_image_viewer_theme_data.dart';
import 't_image_viewer_widget.dart';

/// 图片预览工具
class TImageViewer {

  /// 显示图片预览
  static void showImageViewer({
    required BuildContext context,
    required List<dynamic> images,
    List<String>? labels,
    bool? closeBtn = true,
    bool? deleteBtn = false,
    bool? showIndex = false,
    bool? loop = false,
    bool? autoplay = false,
    int? duration,
    Color? bgColor,
    Color? navBarBgColor,
    Color? iconColor,
    TextStyle? labelStyle,
    TextStyle? indexStyle,
    Color? modalBarrierColor,
    bool? barrierDismissible,
    int? defaultIndex,
    double? width,
    double? height,
    OnIndexChange? onIndexChange,
    OnClose? onClose,
    OnDelete? onDelete,
    bool? ignoreDeleteError,
    OnImageTap? onTap,
    OnLongPress? onLongPress,
    LeftItemBuilder? leftItemBuilder,
    RightItemBuilder? rightItemBuilder,
  }) {
    // P1: 组件级 ThemeExtension 回退
    final theme = Theme.of(context).extension<TImageViewerThemeData>();
    bgColor ??= theme?.backgroundColor;
    navBarBgColor ??= theme?.appBarBackgroundColor;
    iconColor ??= theme?.iconColor;
    labelStyle ??= theme?.labelStyle;
    indexStyle ??= theme?.indexStyle;
    modalBarrierColor ??= theme?.barrierColor ?? context.tTheme.fontGyColor1;
    width ??= theme?.viewerWidth;
    height ??= theme?.viewerHeight;
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      barrierColor: modalBarrierColor,
      useSafeArea: false,
      builder: (context) {
        return TImageViewerWidget(
          images: images,
          labels: labels,
          closeBtn: closeBtn,
          deleteBtn: deleteBtn,
          showIndex: showIndex,
          loop: loop,
          autoplay: autoplay,
          duration: duration,
          bgColor: bgColor,
          navBarBgColor: navBarBgColor,
          iconColor: iconColor,
          labelStyle: labelStyle,
          indexStyle: indexStyle,
          defaultIndex: defaultIndex,
          onIndexChange: onIndexChange,
          width: width,
          height: height,
          onClose: onClose,
          onDelete: onDelete,
          ignoreDeleteError: ignoreDeleteError,
          onTap: onTap,
          onLongPress: onLongPress,
          leftItemBuilder: leftItemBuilder,
          rightItemBuilder: rightItemBuilder,
        );
      },
    );
  }
}
