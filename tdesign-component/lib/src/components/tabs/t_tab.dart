import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// Tab 组件 v1.0
///
/// Material Tab 薄包装。禁用：`enabled: false`。
/// L4 样式（badge、iconMargin、height、contentHeight、textMargin、outlineType）→ [TTabBarThemeData]。
class TTab extends Tab {
  /// 文字内容
  @override
  final String? text;

  /// 子widget
  @override
  final Widget? child;

  /// 图标
  @override
  final Widget? icon;

  /// 徽标
  final TBadge? badge;

  /// 图标间距（可覆盖 Theme）
  @override
  final EdgeInsetsGeometry iconMargin;

  /// tab高度（可覆盖 Theme）
  @override
  final double? height;

  /// 中间内容高度（可覆盖 Theme）
  final double? contentHeight;

  /// 文本边距（可覆盖 Theme）
  final EdgeInsetsGeometry? textMargin;

  /// 是否可用，默认 true；`false` 即禁用
  final bool enabled;

  /// 选项卡尺寸
  final TTabSize size;

  @override
  const TTab({
    Key? key,
    this.text,
    this.child,
    this.icon,
    this.badge,
    this.contentHeight,
    this.textMargin,
    this.size = TTabSize.small,
    this.enabled = true,
    this.iconMargin = const EdgeInsets.only(bottom: 4.0, right: 4.0),
    double? height,
  })  : height = height,
        super(
          key: key,
          text: text,
          child: child,
          icon: icon,
          height: height,
          iconMargin: iconMargin,
        );

  static const double _kTabHeight = 48.0;
  static const double _kTextAndIconTabHeight = 72.0;

  @override
  Widget build(BuildContext context) {
    final double calculatedHeight;
    Widget label;
    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText(context);
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon ?? Container(),
          SizedBox(
            width: iconMargin.horizontal,
            height: iconMargin.vertical,
          ),
          _buildLabelText(context),
        ],
      );
    }
    if (badge != null) {
      label = Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(margin: textMargin, child: label),
          Positioned(
            child: badge!,
            right: 0,
            top: 0,
          ),
        ],
      );
    }

    return IgnorePointer(
      ignoring: !enabled,
      child: Container(
        alignment: Alignment.center,
        height: height ?? calculatedHeight,
        child: Center(
          widthFactor: 1.0,
          child: label,
        ),
      ),
    );
  }

  Widget _buildLabelText(BuildContext context) {
    if (child != null) {
      return DefaultTextStyle(
        child: child!,
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(fontSize: context.tTheme.fontBodySmall?.size ?? 14),
      );
    }
    return Text(
      text!,
      softWrap: false,
      overflow: TextOverflow.fade,
      style: TextStyle(fontSize: _getFontSize(context)),
    );
  }

  double _getFontSize(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    if (defaultTextStyle.style.fontSize != null) {
      return defaultTextStyle.style.fontSize!;
    }
    if (size == TTabSize.large) {
      return 16.0;
    } else {
      return 14.0;
    }
  }
}
