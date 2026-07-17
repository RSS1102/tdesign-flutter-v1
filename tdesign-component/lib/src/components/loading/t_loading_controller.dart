import 'package:flutter/material.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

class TLoadingController {
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  // 展示
  static void show(BuildContext context,
    {Widget? child,
      TLoadingSize size = TLoadingSize.medium,
      TLoadingIcon? icon = TLoadingIcon.circle,
      String? text,
      TLoadingThemeData? themeData}) {
    if (_isShowing) {
      debugPrint('warn: TLoading is showing!');
      return;
    }

    _overlayEntry = OverlayEntry(builder: (context) {
      final loadingWidget = child ??
          TLoading(
            size: size,
            icon: icon,
            text: text ?? context.resource.loading,
          );
      // v1.0 按文档 §2.1：子树覆盖用 mergeExtension，禁止构造器 themeData
      if (themeData == null) {
        return Center(child: loadingWidget);
      }
      return Center(
        child: Theme(
          data: Theme.of(context).mergeExtension(themeData),
          child: loadingWidget,
        ),
      );
    });

    _isShowing = true;
    Overlay.of(context).insert(_overlayEntry!);
  }

  // 消失
  static void dismiss() {
    if (_isShowing) {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
      _isShowing = false;
    }
  }
}
