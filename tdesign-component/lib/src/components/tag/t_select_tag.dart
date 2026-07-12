import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 点击型标签组件，点击时内部更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TSelectTag extends StatefulWidget {
  const TSelectTag( // coverage:ignore-line
    this.text, {
    this.colorScheme,
    this.icon,
    required this.value,
    this.onChanged,
    this.size = TTagSize.medium,
    Key? key,
  }) : super(key: key); // coverage:ignore-line

  /// 标签内容
  final String text;

  /// 语义色（选中时使用）
  final TTagColorScheme? colorScheme;

  /// 图标内容，可随状态改变颜色
  final IconData? icon;

  /// 是否选中
  final bool value;

  /// 选中状态变更回调；为 null 时禁用选择
  final ValueChanged<bool>? onChanged;

  /// 标签大小
  final TTagSize size;

  @override // coverage:ignore-line
  _TSelectTagState createState() => _TSelectTagState(); // coverage:ignore-line
}

class _TSelectTagState extends State<TSelectTag> {
  @override // coverage:ignore-line
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TTagThemeData>(); // coverage:ignore-line
    final effectiveColorScheme = widget.value // coverage:ignore-line
        ? (widget.colorScheme ?? theme?.colorScheme ?? TTagColorScheme.primary) // coverage:ignore-line
        : TTagColorScheme.defaultTheme;

    Widget result = TTag( // coverage:ignore-line
      widget.text, // coverage:ignore-line
      colorScheme: effectiveColorScheme,
      icon: widget.icon, // coverage:ignore-line
      size: widget.size, // coverage:ignore-line
    );

    if (widget.onChanged != null) { // coverage:ignore-line
      result = GestureDetector( // coverage:ignore-line
        onTap: () { // coverage:ignore-line
          widget.onChanged!(!widget.value); // coverage:ignore-line
        },
        child: result,
      );
    }
    return result;
  }
}
