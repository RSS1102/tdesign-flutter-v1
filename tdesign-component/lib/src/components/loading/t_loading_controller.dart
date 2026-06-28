import 'package:flutter/material.dart';
import '../../util/context_extension.dart';
import 't_loading.dart';
import 't_loading_theme_data.dart';

class TLoadingController {
  static BuildContext? _context;
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
      print('warn: TLoading is showing!');
      return;
    }

    _overlayEntry = OverlayEntry(builder: (context) {
      return Center(
        child: child ??
            TLoading(
              size: size,
              icon: icon,
              text: text ?? context.resource.loading,
              themeData: themeData,
            ),
      );
    });

    _context = context;
    if (_context == null || _overlayEntry == null) {
      print('error: TLoading is not init!:${_context} ${_overlayEntry}');
      return;
    }
    _isShowing = true;
    Overlay.of(_context!).insert(_overlayEntry!);
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
