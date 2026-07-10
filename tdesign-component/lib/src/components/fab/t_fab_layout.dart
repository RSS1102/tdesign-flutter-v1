import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TFab;
import '../button/t_button.dart';
import '../button/t_button_theme_data.dart';
import 't_fab.dart' show TFab;

/// 拖拽轴向
enum TFabDragAxis { all, vertical, horizontal }

/// 吸附方向
enum TFabMagnet { left, right }

/// 拖拽边界限制
class TFabBounds {
  /// 起点留白（水平：left，垂直：top）
  final double start;

  /// 终点留白（水平：right，垂直：bottom）
  final double end;

  const TFabBounds({required this.start, required this.end});
}

/// [TFab.buttonProps] 透传类型
///
/// 字段与 [TButton] 构造参数对齐，不含 onPressed / child / icon。
class TButtonProps {
  final TButtonSize? size;
  final TButtonVariant? variant;
  final TButtonColorScheme? colorScheme;
  final TButtonShape? shape;
  final ButtonStyle? style;

  const TButtonProps({
    this.size,
    this.variant,
    this.colorScheme,
    this.shape,
    this.style,
  });
}

/// 拖拽回调详情
class TFabDragDetails {
  /// 当前位置（相对父 Stack 内容区）
  final Offset position;

  /// 拖拽开始详情
  final DragStartDetails? start;

  /// 拖拽结束详情
  final DragEndDetails? end;

  const TFabDragDetails({
    required this.position,
    this.start,
    this.end,
  });
}

/// 拖拽回调
typedef TFabDragCallback = void Function(TFabDragDetails details);

/// Fab 定位层内部模型
///
/// 由构造器扁平参数经 resolveLayout 组装，内部使用，不 export。
class TFabLayout {
  final double right;
  final double bottom;
  final TFabDragAxis? draggable; // null = false
  final TFabMagnet? magnet; // null = false
  final TFabBounds? xBounds;
  final TFabBounds? yBounds;

  const TFabLayout({
    required this.right,
    required this.bottom,
    this.draggable,
    this.magnet,
    this.xBounds,
    this.yBounds,
  });
}
