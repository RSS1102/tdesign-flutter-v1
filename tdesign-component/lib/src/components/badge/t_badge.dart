import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 't_badge_theme_data.dart';

/// 徽标形态
enum TBadgeVariant {
  /// 红点样式
  redPoint,

  /// 消息样式
  message,

  /// 气泡样式
  bubble,

  /// 方形样式
  square,

  /// 角标样式
  subscript
}

/// 徽标圆角大小
enum TBadgeBorder {
  /// 大圆角 8px
  large,

  /// 小圆角 2px
  small
}

/// 徽标尺寸
enum TBadgeSize {
  /// 宽 20px
  large,

  /// 宽 16px
  small,
}

class TBadge extends StatefulWidget {
  const TBadge(
    this.variant, {
    Key? key,
    this.count,
    this.maxCount = '99',
    this.size = TBadgeSize.small,
  }) : super(key: key);

  /// 红点数量
  final String? count;

  /// 最大红点数量
  final String? maxCount;

  /// 红点形态
  final TBadgeVariant variant;

  /// 红点尺寸
  final TBadgeSize size;

  @override
  State<StatefulWidget> createState() => _TBadgeState();
}

class _TBadgeState extends State<TBadge> {
  String badgeNum = '';

  /// 从 Theme 子树读取 L4 默认值
  TBadgeThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TBadgeThemeData>();

  void updateBadgeNum(String? newCount) {
    if (newCount == null) {
      return;
    }
    setState(() {
      // 如果 newCount 超过了 maxCount，则显示 `${maxCount}+`
      final countValue = int.tryParse(newCount) ?? 0;
      final maxCountValue = int.tryParse(widget.maxCount ?? '') ?? 0;
      if (maxCountValue > 0 && countValue > maxCountValue) {
        badgeNum = '${maxCountValue}+';
      } else {
        badgeNum = newCount;
      }
    });
  }

  double getBadgeSize() {
    switch (widget.size) {
      case TBadgeSize.large:
        return 20;
      case TBadgeSize.small:
        return 16;
    }
  }

  Font? getBadgeFont(BuildContext context) {
    switch (widget.size) {
      case TBadgeSize.large:
        return context.tTheme.fontMarkSmall;
      case TBadgeSize.small:
        return context.tTheme.fontMarkExtraSmall;
    }
  }

  bool get visible {
    final theme = _theme(context);
    final showZero = theme?.showZero ?? true;
    final message = theme?.message;
    final parsedValue = double.tryParse(value);
    return showZero ||
        (parsedValue != null && parsedValue != 0) ||
        parsedValue == null;
  }

  String get value {
    final theme = _theme(context);
    final message = theme?.message;
    return message ?? widget.count ?? context.resource.badgeZero;
  }

  Color _resolveColor(BuildContext context) {
    final theme = _theme(context);
    return theme?.color ?? context.tTheme.errorNormalColor;
  }

  Color _resolveTextColor(BuildContext context) {
    final theme = _theme(context);
    return theme?.textColor ?? context.tTheme.textColorAnti;
  }

  TBadgeBorder _resolveBorder(BuildContext context) {
    final theme = _theme(context);
    return theme?.border ?? TBadgeBorder.large;
  }

  EdgeInsetsGeometry _resolvePadding(BuildContext context) {
    final theme = _theme(context);
    return theme?.padding ?? const EdgeInsets.only(left: 4, bottom: 8);
  }

  double _resolveWidthLarge(BuildContext context) {
    final theme = _theme(context);
    return theme?.widthLarge ?? 32;
  }

  double _resolveWidthSmall(BuildContext context) {
    final theme = _theme(context);
    return theme?.widthSmall ?? 12;
  }

  @override
  void initState() {
    super.initState();
    updateBadgeNum(widget.count);
  }

  @override
  void didUpdateWidget(covariant TBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      updateBadgeNum(widget.count);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case TBadgeVariant.redPoint:
        return Container(
          alignment: Alignment.center,
          height: getBadgeSize() / 2,
          width: getBadgeSize() / 2,
          decoration: BoxDecoration(
              color: _resolveColor(context),
              borderRadius: BorderRadius.circular(getBadgeSize() / 4)),
        );
      case TBadgeVariant.message:
        return Visibility(
            visible: visible,
            child: badgeNum.length == 1
                ? Container(
                    height: getBadgeSize(),
                    width: getBadgeSize(),
                    decoration: BoxDecoration(
                      color: _resolveColor(context),
                      borderRadius: BorderRadius.circular(getBadgeSize() / 2),
                    ),
                    child: Center(
                      child: TText(
                        value,
                        forceVerticalCenter: true,
                        font: getBadgeFont(context),
                        fontWeight: FontWeight.w500,
                        textColor: _resolveTextColor(context),
                        textAlign: TextAlign.center,
                      ),
                    ))
                : Container(
                    height: getBadgeSize(),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: _resolveColor(context),
                      borderRadius: BorderRadius.circular(getBadgeSize() / 2),
                    ),
                    child: Center(
                      child: TText(
                        value,
                        forceVerticalCenter: true,
                        font: getBadgeFont(context),
                        fontWeight: FontWeight.w500,
                        textColor: _resolveTextColor(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ));
      case TBadgeVariant.subscript:
        return ClipPath(
          clipper: TrapezoidPath(
              _resolveWidthLarge(context), _resolveWidthSmall(context)),
          child: Container(
            alignment: Alignment.topRight,
            color: _resolveColor(context),
            height: 32,
            width: 32,
            child: Transform.rotate(
                angle: pi / 4,
                child: Padding(
                  padding: _resolvePadding(context),
                  child: TText(
                    value,
                    font: getBadgeFont(context),
                    fontWeight: FontWeight.w500,
                    textColor: _resolveTextColor(context),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        );
      case TBadgeVariant.bubble:
        return Visibility(
            visible: visible,
            child: Container(
              height: 16,
              padding: const EdgeInsets.only(left: 4, right: 4),
              decoration: BoxDecoration(
                color: _resolveColor(context),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(1)),
              ),
              child: Center(
                child: TText(
                  value,
                  forceVerticalCenter: true,
                  font: getBadgeFont(context),
                  fontWeight: FontWeight.w500,
                  textColor: _resolveTextColor(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ));
      case TBadgeVariant.square:
        return Visibility(
            visible: visible,
            child: IntrinsicWidth(
                child: Container(
              height: getBadgeSize(),
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: _resolveColor(context),
                borderRadius: _resolveBorder(context) == TBadgeBorder.large
                    ? BorderRadius.circular(8)
                    : BorderRadius.circular(2),
              ),
              child: Center(
                child: TText(
                  value,
                  forceVerticalCenter: true,
                  font: getBadgeFont(context),
                  fontWeight: FontWeight.w500,
                  textColor: _resolveTextColor(context),
                  textAlign: TextAlign.center,
                ),
              ),
            )));
    }
  }
}

class TrapezoidPath extends CustomClipper<Path> {
  final double widthLarge;
  final double widthSmall;

  TrapezoidPath(this.widthLarge, this.widthSmall);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(widthLarge - widthSmall, 0);
    path.lineTo(widthLarge, widthSmall);
    path.lineTo(widthLarge, widthLarge);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
