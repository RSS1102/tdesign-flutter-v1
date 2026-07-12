import 'package:flutter/material.dart';
import '../../theme/t_theme.dart';
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

    _context = context;
    // coverage:ignore-start
    // 以下分支为不可达死代码：_context 来自非可空参数、_overlayEntry 已在上方赋值，
    // 二者均不可能为 null，运行期恒定进入 else，标记覆盖率例外。
    if (_context == null || _overlayEntry == null) {
      print('error: TLoading is not init!:${_context} ${_overlayEntry}');
      return;
    }
    // coverage:ignore-end
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
