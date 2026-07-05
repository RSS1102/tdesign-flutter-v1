import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import 't_avatar_theme_data.dart';

/// 头像尺寸
enum TAvatarSize { large, medium, small }

/// 头像形态
enum TAvatarVariant { icon, normal, customText, display, operation }

/// 头像形状（迁入 TAvatarThemeData，但保留枚举）
enum TAvatarShape { circle, square }

/// 用于头像显示
class TAvatar extends StatelessWidget {
  const TAvatar({
    Key? key,
    this.size = TAvatarSize.medium,
    this.variant = TAvatarVariant.normal,
    this.text,
    this.icon,
    this.avatarUrl,
    this.avatarDisplayList,
    this.displayText,
    this.onPressed,
    this.defaultUrl = '',
    this.avatarDisplayWidget,
    this.avatarDisplayListAsset,
    this.fit,
  }) : super(key: key);

  /// 头像地址
  final String? avatarUrl;

  /// 头像尺寸
  final TAvatarSize size;

  /// 头像形态
  final TAvatarVariant variant;

  /// 自定义文字
  final String? text;

  /// 自定义图标
  final IconData? icon;

  /// 默认图片（本地）
  final String defaultUrl;

  /// 带操作展示的头像列表
  final List<String>? avatarDisplayList;

  /// 带操作展示的头像列表（本地资源）
  final List<String>? avatarDisplayListAsset;

  /// 带操作头像自定义操作Widget
  final Widget? avatarDisplayWidget;

  /// 纯展示类型末尾文字
  final String? displayText;

  /// 操作点击事件
  final VoidCallback? onPressed;

  /// 自定义图片对齐方式
  final BoxFit? fit;

  /// 从 Theme 子树读取 L4 默认值
  TAvatarThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TAvatarThemeData>();

  double _getAvatarWidth(BuildContext context) {
    double width;
    switch (size) {
      case TAvatarSize.large:
        width = 64;
        break;
      case TAvatarSize.medium:
        width = 48;
        break;
      case TAvatarSize.small:
        width = 40;
        break;
    }
    final theme = _theme(context);
    return theme?.avatarSize ?? width;
  }

  Font? _getTextFont(BuildContext context) {
    switch (size) {
      case TAvatarSize.large:
        return context.tTheme.fontTitleExtraLarge;
      case TAvatarSize.medium:
        return context.tTheme.fontTitleMedium;
      case TAvatarSize.small:
        return context.tTheme.fontTitleSmall;
    }
  }

  double _getIconWidth() {
    switch (size) {
      case TAvatarSize.large:
        return 32;
      case TAvatarSize.medium:
        return 24;
      case TAvatarSize.small:
        return 20;
    }
  }

  double _getAvatarRadius(BuildContext context) {
    final theme = _theme(context);
    final shape = theme?.shape ?? TAvatarShape.circle;
    double r;
    switch (shape) {
      case TAvatarShape.circle:
        r = _getAvatarWidth(context) / 2;
        break;
      case TAvatarShape.square:
        r = context.tTheme.radiusDefault;
        break;
    }
    return theme?.radius ?? r;
  }

  Color _resolveBackgroundColor(BuildContext context) {
    final theme = _theme(context);
    return theme?.backgroundColor ?? context.tTheme.brandFocusColor;
  }

  double _resolveDisplayBorder(BuildContext context) {
    final theme = _theme(context);
    return theme?.avatarDisplayBorder ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case TAvatarVariant.icon:
        return GestureDetector(
          child: Container(
            width: _getAvatarWidth(context),
            height: _getAvatarWidth(context),
            decoration: BoxDecoration(
              color: _resolveBackgroundColor(context),
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
                child: Icon(
              icon ?? TIcons.user,
              size: _getIconWidth(),
              color: context.tTheme.brandNormalColor,
            )),
          ),
          onTap: onPressed,
        );
      case TAvatarVariant.normal:
        return GestureDetector(
          child: Container(
            width: _getAvatarWidth(context),
            height: _getAvatarWidth(context),
            decoration: BoxDecoration(
                color: _resolveBackgroundColor(context),
                borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
                image: avatarUrl != null
                    ? DecorationImage(image: NetworkImage(avatarUrl!))
                    : defaultUrl != ''
                        ? DecorationImage(image: AssetImage(defaultUrl))
                        : null),
          ),
          onTap: onPressed,
        );
      case TAvatarVariant.customText:
        return GestureDetector(
          child: Container(
            width: _getAvatarWidth(context),
            height: _getAvatarWidth(context),
            decoration: BoxDecoration(
              color: _resolveBackgroundColor(context) == context.tTheme.brandFocusColor
                  ? context.tTheme.brandNormalColor
                  : _resolveBackgroundColor(context),
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
              child: TText(
                text,
                forceVerticalCenter: true,
                textAlign: TextAlign.center,
                font: _getTextFont(context),
                textColor: context.tTheme.whiteColor1,
              ),
            ),
          ),
          onTap: onPressed,
        );
      case TAvatarVariant.display:
        return buildDisplayAvatar(context);
      case TAvatarVariant.operation:
        return buildOperationAvatar(context);
    }
  }

  double _getDisplayPadding() {
    switch (size) {
      case TAvatarSize.large:
        return 10;
      case TAvatarSize.medium:
        return 8;
      case TAvatarSize.small:
        return 6;
    }
  }

  Widget buildOperationAvatar(BuildContext context) {
    var list = <Widget>[];
    if ((avatarDisplayList == null || avatarDisplayList!.isEmpty) &&
        (avatarDisplayListAsset == null || avatarDisplayListAsset!.isEmpty)) {
      return Container();
    }

    var length = 0;
    final displayBorder = _resolveDisplayBorder(context);
    final avatarWidth = _getAvatarWidth(context);

    if (avatarDisplayList != null) {
      length = avatarDisplayList!.length;
      for (var i = 0; i < avatarDisplayList!.length + 1; i++) {
        var left = (avatarWidth - _getDisplayPadding()) * i;
        if (i == avatarDisplayList!.length) {
          list.add(Positioned(
              left: left,
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                    child: Center(
                      child: Icon(TIcons.user_add,
                          size: _getIconWidth(),
                          color: context.tTheme.brandNormalColor),
                    ),
                    width: avatarWidth,
                    height: avatarWidth,
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      color: context.tTheme.brandFocusColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              avatarWidth - _getDisplayPadding()),
                          side: BorderSide(
                              color: Colors.transparent,
                              width: displayBorder)),
                    )),
              )));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: avatarWidth,
                  height: avatarWidth,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              avatarWidth - _getDisplayPadding()),
                          side: BorderSide(
                              color: context.tTheme.bgColorContainer,
                              width: displayBorder)),
                      image: DecorationImage(
                          image: NetworkImage(avatarDisplayList![i]),
                          fit: fit ?? BoxFit.cover)))));
        }
      }
    } else if (avatarDisplayListAsset != null) {
      length = avatarDisplayListAsset!.length;
      for (var i = 0; i < avatarDisplayListAsset!.length + 1; i++) {
        var left = (avatarWidth - _getDisplayPadding()) * i;
        if (i == avatarDisplayListAsset!.length) {
          list.add(Positioned(
              left: left,
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                    child: Center(
                      child: avatarDisplayWidget ??
                          Icon(TIcons.user_add,
                              size: _getIconWidth(),
                              color: context.tTheme.brandNormalColor),
                    ),
                    width: avatarWidth,
                    height: avatarWidth,
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      color: context.tTheme.brandFocusColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              avatarWidth - _getDisplayPadding()),
                          side: BorderSide(
                              color: context.tTheme.bgColorContainer,
                              width: displayBorder)),
                    )),
              )));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: avatarWidth,
                  height: avatarWidth,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              avatarWidth - _getDisplayPadding()),
                          side: BorderSide(
                              color: context.tTheme.bgColorContainer,
                              width: displayBorder)),
                      image: DecorationImage(
                          image: AssetImage(avatarDisplayListAsset![i]),
                          fit: fit ?? BoxFit.fill)))));
        }
      }
    }

    return SizedBox(
      height: avatarWidth,
      width: avatarWidth * (length + 1) - length * _getDisplayPadding(),
      child: Stack(children: list),
    );
  }

  Widget buildDisplayAvatar(BuildContext context) {
    var list = <Widget>[];
    if ((avatarDisplayList == null || avatarDisplayList!.isEmpty) &&
        (avatarDisplayListAsset == null || avatarDisplayListAsset!.isEmpty)) {
      return Container();
    }

    var length = 0;
    final displayBorder = _resolveDisplayBorder(context);
    final avatarWidth = _getAvatarWidth(context);

    if (avatarDisplayList != null) {
      length = avatarDisplayList!.length;
      for (var i = avatarDisplayList!.length; i >= 0; i--) {
        var left = (avatarWidth - _getDisplayPadding()) * i;
        if (i == avatarDisplayList!.length) {
          list.add(Positioned(
              left: left,
              child: Container(
                  child: Center(
                    child: TText(
                      displayText,
                      fontWeight: FontWeight.w600,
                      forceVerticalCenter: true,
                      textAlign: TextAlign.center,
                      font: _getTextFont(context),
                      textColor: context.tTheme.brandNormalColor,
                    ),
                  ),
                  width: avatarWidth,
                  height: avatarWidth,
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: context.tTheme.brandFocusColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            avatarWidth - _getDisplayPadding()),
                        side: BorderSide(
                            color: context.tTheme.bgColorContainer,
                            width: displayBorder)),
                  ))));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: avatarWidth,
                  height: avatarWidth,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              avatarWidth - _getDisplayPadding()),
                          side: BorderSide(
                              color: context.tTheme.bgColorContainer,
                              width: displayBorder)),
                      image: DecorationImage(
                          image: NetworkImage(avatarDisplayList![i]),
                          fit: fit ?? BoxFit.cover)))));
        }
      }
    } else if (avatarDisplayListAsset != null) {
      length = avatarDisplayListAsset!.length;
      for (var i = avatarDisplayListAsset!.length; i >= 0; i--) {
        var left = (avatarWidth - _getDisplayPadding()) * i;
        if (i == avatarDisplayListAsset!.length) {
          list.add(Positioned(
              left: left,
              child: Container(
                  child: Center(
                    child: TText(
                      displayText,
                      fontWeight: FontWeight.w600,
                      forceVerticalCenter: true,
                      textAlign: TextAlign.center,
                      font: _getTextFont(context),
                      textColor: context.tTheme.brandNormalColor,
                    ),
                  ),
                  width: avatarWidth,
                  height: avatarWidth,
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: context.tTheme.brandFocusColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            avatarWidth - _getDisplayPadding()),
                        side: BorderSide(
                            color: context.tTheme.bgColorContainer,
                            width: displayBorder)),
                  ))));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: avatarWidth,
                  height: avatarWidth,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              avatarWidth - _getDisplayPadding()),
                          side: BorderSide(
                              color: context.tTheme.bgColorContainer,
                              width: displayBorder)),
                      image: DecorationImage(
                          image: AssetImage(avatarDisplayListAsset![i]),
                          fit: fit ?? BoxFit.cover)))));
        }
      }
    }

    return SizedBox(
      height: avatarWidth,
      width: avatarWidth * (length + 1) - length * _getDisplayPadding(),
      child: Stack(children: list),
    );
  }
}
