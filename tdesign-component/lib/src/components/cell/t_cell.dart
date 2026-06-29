import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_cell_inherited.dart';
import 't_cell_theme_data.dart';

/// 单元格内容对齐方式
enum TCellAlign { top, middle, bottom }

/// 单元格组件
class TCell extends StatefulWidget {
  const TCell({
    Key? key,
    this.arrow = false,
    this.bordered = true,
    this.subtitle,
    this.subtitleWidget,
    this.image,
    this.imageSize,
    this.imageWidget,
    this.prefix,
    this.prefixWidget,
    this.note,
    this.noteWidget,
    this.noteMaxWidth,
    this.noteMaxLine = 1,
    this.required = false,
    this.title,
    this.titleWidget,
    this.onTap,
    this.onLongPress,
    this.rightIcon,
    this.rightIconWidget,
    this.imageCircle = 50,
  }) : super(key: key);

  /// 是否显示右侧箭头
  final bool? arrow;

  /// 是否显示下边框，仅在TCellGroup组件下起作用
  final bool? bordered;

  /// 下方内容描述文字
  final String? subtitle;

  /// 下方内容描述组件
  final Widget? subtitleWidget;

  /// 主图
  final ImageProvider? image;

  /// 主图尺寸
  final double? imageSize;

  /// 主图圆角，默认50（圆形）
  final double? imageCircle;

  /// 主图组件
  final Widget? imageWidget;

  /// 左侧图标，出现在单元格标题的左侧
  final IconData? prefix;

  /// 左侧图标组件
  final Widget? prefixWidget;

  /// 和标题同行的说明文字
  final String? note;

  /// 说明文字组件
  final Widget? noteWidget;

  /// 说明文字组件 最大宽度，超过部分显示省略号，防止文字溢出
  final double? noteMaxWidth;

  /// 说明文字组件 最大行数
  final int noteMaxLine;

  /// 是否显示表单必填星号
  final bool? required;

  /// 最右侧图标
  final IconData? rightIcon;

  /// 最右侧图标组件
  final Widget? rightIconWidget;

  /// 标题
  final String? title;

  /// 标题组件
  final Widget? titleWidget;

  /// 点击事件（为 null 时禁用交互）
  final GestureTapCallback? onTap;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  @override
  _TCellState createState() => _TCellState();
}

class _TCellState extends State<TCell> {
  var _status = 'default';

  /// 从 TCellInherited 或 Theme 子树读取 TCellThemeData
  TCellThemeData _resolveStyle(BuildContext context) {
    return TCellInherited.of(context)?.style ??
        Theme.of(context).extension<TCellThemeData>() ??
        TCellThemeData.cellStyle(context);
  }

  bool get _disabled => widget.onTap == null;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final style = _resolveStyle(context);
    final align = Theme.of(context).extension<TCellThemeData>()?.align ??
        TCellAlign.middle;
    final hover = Theme.of(context).extension<TCellThemeData>()?.hover ?? true;
    final showBottomBorder =
        Theme.of(context).extension<TCellThemeData>()?.showBottomBorder ?? false;
    final height = Theme.of(context).extension<TCellThemeData>()?.height;
    final crossAxisAlignment = _getAlign(align);
    final color = _status == 'default'
        ? style.backgroundColor
        : style.clickBackgroundColor;
    final border = showBottomBorder
        ? Border(
      bottom: BorderSide(
        width: 0.5,
        color: style.borderedColor ?? theme.componentStrokeColor,
      ),
    )
        : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap != null && !_disabled
          ? () {
              widget.onTap!();
              TSwipeCellInherited.of(context)?.cellClick();
            }
          : null,
      onLongPress: widget.onLongPress != null && !_disabled
          ? widget.onLongPress
          : null,
      onTapDown: (_) => _setStatus('active', 0, hover),
      onTapUp: (_) => _setStatus('default', 100, hover),
      onTapCancel: () => _setStatus('default', 0, hover),
      child: Container(
        height: height,
        padding: style.padding,
        decoration: BoxDecoration(color: color, border: border),
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ..._buildImage(),
            Expanded(
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  if (widget.prefix != null ||
                      widget.prefixWidget != null) ...[
                    widget.prefixWidget ??
                        Icon(widget.prefix,
                            size: 24, color: style.leftIconColor),
                    SizedBox(width: theme.spacer12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (widget.titleWidget != null)
                              Flexible(child: widget.titleWidget!)
                            else if (widget.title?.isNotEmpty == true)
                              Flexible(
                                  child: TText(widget.title!,
                                      style: style.titleStyle)),
                            if (widget.required ?? false)
                              TText(' *', style: style.requiredStyle),
                          ],
                        ),
                        if ((widget.titleWidget != null || widget.title != null) &&
                            (widget.subtitleWidget != null || widget.subtitle?.isNotEmpty == true))
                          SizedBox(height: TTheme.of(context).spacer4),
                        if (widget.subtitleWidget != null)
                          widget.subtitleWidget!
                        else if (widget.subtitle?.isNotEmpty ?? false)
                          TText(widget.subtitle!,
                              style: style.descriptionStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: theme.spacer4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (widget.noteWidget != null)
                  widget.noteWidget!
                else if (widget.note?.isNotEmpty ?? false)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: widget.noteMaxWidth ??
                              MediaQuery.of(context).size.width - 84),
                      child: TText(
                        widget.note!,
                        style: style.noteStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: widget.noteMaxLine,
                      )),
                if (widget.rightIconWidget != null)
                  widget.rightIconWidget!
                else if (widget.rightIcon != null)
                  Icon(widget.rightIcon, size: 24, color: style.rightIconColor),
                if (widget.arrow ?? false)
                  Icon(TIcons.chevron_right,
                      size: 24, color: style.arrowColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CrossAxisAlignment _getAlign(TCellAlign align) {
    switch (align) {
      case TCellAlign.top:
        return CrossAxisAlignment.start;
      case TCellAlign.middle:
        return CrossAxisAlignment.center;
      case TCellAlign.bottom:
        return CrossAxisAlignment.end;
    }
  }

  void _setStatus(String status, int milliseconds, bool hover) {
    if (_disabled || !hover) {
      return;
    }
    if (milliseconds == 0) {
      setState(() {
        _status = status;
      });
      return;
    }
    Future.delayed(Duration(milliseconds: milliseconds), () {
      setState(() {
        _status = status;
      });
    });
  }

  List<Widget> _buildImage() {
    final imageSize = widget.imageSize ?? 48;
    final imageWidgets = <Widget>[];

    if (widget.imageWidget != null) {
      imageWidgets.add(widget.imageWidget!);
    } else if (widget.image != null) {
      imageWidgets.add(ClipRRect(
        borderRadius: BorderRadius.circular(widget.imageCircle ?? 50),
        child: Image(
          image: widget.image!,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      ));
    }

    if (imageWidgets.isNotEmpty) {
      imageWidgets.add(SizedBox(width: TTheme.of(context).spacer12));
    }

    return imageWidgets;
  }
}
