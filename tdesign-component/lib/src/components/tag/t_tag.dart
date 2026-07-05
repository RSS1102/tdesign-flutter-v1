import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import 't_tag_theme_data.dart';

/// 标签尺寸
enum TTagSize { extraLarge, large, medium, small, custom }

/// 标签形状
enum TTagShape { square, round, mark }

/// 展示型标签组件，仅展示，内部不可更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TTag extends StatelessWidget {
  const TTag(
    this.text, {
    this.colorScheme,
    this.icon,
    this.size = TTagSize.medium,
    this.onCloseTap,
    Key? key,
  }) : super(key: key);

  /// 标签内容
  final String text;

  /// 语义色
  final TTagColorScheme? colorScheme;

  /// 图标内容，可随状态改变颜色
  final IconData? icon;

  /// 标签大小
  final TTagSize size;

  /// 关闭图标点击事件
  final GestureTapCallback? onCloseTap;

  /// 从 Theme 子树读取 L4 默认值
  TTagThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TTagThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final resolvedColorScheme = colorScheme ?? theme?.colorScheme ?? TTagColorScheme.defaultTheme;
    final isOutline = theme?.isOutline ?? false;
    final isLight = theme?.isLight ?? false;
    final shape = theme?.shape ?? TTagShape.square;
    final disable = theme?.disable ?? false;
    final needCloseIcon = theme?.needCloseIcon ?? false;
    final forceVerticalCenter = theme?.forceVerticalCenter ?? true;
    final overflow = theme?.overflow;
    final fixedWidth = theme?.fixedWidth;
    final padding = theme?.padding;
    final iconWidget = theme?.iconWidget;
    final textColor = theme?.textColor;
    final backgroundColor = theme?.backgroundColor;
    final font = theme?.font;
    final fontWeight = theme?.fontWeight;

    // 计算样式颜色
    final colors = _resolveColors(context, resolvedColorScheme, isLight, isOutline, disable);
    final borderRadius = _resolveBorderRadius(context, shape);

    Widget child = TText(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      forceVerticalCenter: forceVerticalCenter,
      textColor: textColor ?? colors.textColor,
      font: font ?? _getFont(context),
      fontWeight: fontWeight ?? colors.fontWeight,
    );

    var innerIcon = _getIcon(iconWidget, colors.textColor);
    if (innerIcon != null || needCloseIcon) {
      var children = <Widget>[];
      if (innerIcon != null) {
        children.add(Container(
          margin: const EdgeInsets.only(right: 4),
          width: 14,
          height: 14,
          child: innerIcon,
        ));
      }
      children.add(child);
      if (needCloseIcon) {
        children.add(
          GestureDetector(
            onTap: onCloseTap,
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              child: Icon(
                TIcons.close,
                color: colors.closeIconColor ?? context.tTheme.textColorAnti,
                size: 14,
              ),
            ),
          ),
        );
      }
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return Container(
      width: fixedWidth,
      padding: padding ?? _getPadding(isOutline ? 1.0 : 0.0),
      decoration: BoxDecoration(
          color: backgroundColor ?? colors.backgroundColor,
          border: Border.all(width: isOutline ? 1 : 0, color: colors.borderColor),
          borderRadius: borderRadius),
      child: Align(
        widthFactor: 1,
        child: child,
      ),
    );
  }

  /// 解析颜色（原 TTagStyle 的 generateFillStyleByTheme/generateOutlineStyleByTheme/generateDisableSelectStyle 逻辑）
  _TagColors _resolveColors(
    BuildContext context,
    TTagColorScheme colorScheme,
    bool isLight,
    bool isOutline,
    bool disable,
  ) {
    if (disable) {
      return _TagColors(
        textColor: context.tTheme.textDisabledColor,
        backgroundColor: isOutline && !isLight
            ? Colors.transparent
            : context.tTheme.bgColorComponentDisabled,
        borderColor: context.tTheme.componentBorderColor,
      );
    }

    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (colorScheme) {
      case TTagColorScheme.primary:
        if (isOutline) {
          borderColor = context.tTheme.brandNormalColor;
          textColor = context.tTheme.brandNormalColor;
          backgroundColor = isLight ? context.tTheme.brandLightColor : Colors.transparent;
        } else {
          textColor = isLight ? context.tTheme.brandNormalColor : context.tTheme.textColorAnti;
          backgroundColor = isLight ? context.tTheme.brandLightColor : context.tTheme.brandNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.warning:
        if (isOutline) {
          borderColor = context.tTheme.warningNormalColor;
          textColor = context.tTheme.warningNormalColor;
          backgroundColor = isLight ? context.tTheme.warningLightColor : Colors.transparent;
        } else {
          textColor = isLight ? context.tTheme.warningNormalColor : context.tTheme.textColorAnti;
          backgroundColor = isLight ? context.tTheme.warningLightColor : context.tTheme.warningNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.danger:
        if (isOutline) {
          borderColor = context.tTheme.errorNormalColor;
          textColor = context.tTheme.errorNormalColor;
          backgroundColor = isLight ? context.tTheme.errorLightColor : Colors.transparent;
        } else {
          textColor = isLight ? context.tTheme.errorNormalColor : context.tTheme.textColorAnti;
          backgroundColor = isLight ? context.tTheme.errorLightColor : context.tTheme.errorNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.success:
        if (isOutline) {
          borderColor = context.tTheme.successNormalColor;
          textColor = context.tTheme.successNormalColor;
          backgroundColor = isLight ? context.tTheme.successLightColor : Colors.transparent;
        } else {
          textColor = isLight ? context.tTheme.successNormalColor : context.tTheme.textColorAnti;
          backgroundColor = isLight ? context.tTheme.successLightColor : context.tTheme.successNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.defaultTheme:
      default:
        if (isOutline) {
          borderColor = context.tTheme.componentBorderColor;
          textColor = context.tTheme.textColorPrimary;
          backgroundColor = isLight ? context.tTheme.bgColorSecondaryContainer : Colors.transparent;
        } else {
          textColor = context.tTheme.textColorPrimary;
          backgroundColor = isLight ? context.tTheme.bgColorSecondaryContainer : context.tTheme.bgColorComponent;
          borderColor = backgroundColor;
        }
    }

    return _TagColors(
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      closeIconColor: textColor,
    );
  }

  BorderRadiusGeometry _resolveBorderRadius(BuildContext context, TTagShape shape) {
    switch (shape) {
      case TTagShape.square:
        return BorderRadius.circular(context.tTheme.radiusSmall);
      case TTagShape.round:
        return BorderRadius.circular(context.tTheme.radiusRound);
      case TTagShape.mark:
        return BorderRadius.only(
          topRight: Radius.circular(context.tTheme.radiusRound),
          bottomRight: Radius.circular(context.tTheme.radiusRound),
        );
    }
  }

  Widget? _getIcon(Widget? iconWidget, Color textColor) {
    if (iconWidget != null) {
      return iconWidget;
    }
    if (icon != null) {
      return RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color: textColor,
            height: 1,
            fontSize: _getIconSize(),
            fontFamily: icon!.fontFamily,
            package: icon!.fontPackage,
          ),
        ),
      );
    }
    return null;
  }

  Font? _getFont(BuildContext context) {
    switch (size) {
      case TTagSize.extraLarge:
        return context.tTheme.fontBodyMedium;
      case TTagSize.large:
        return context.tTheme.fontBodyMedium;
      case TTagSize.small:
        return context.tTheme.fontBodyExtraSmall;
      default:
        return context.tTheme.fontBodySmall;
    }
  }

  /// 计算padding，需去除描边的宽对，对内描边
  EdgeInsets _getPadding(double border) {
    var hPadding = 0.0;
    var vPadding = 0.0;
    switch (size) {
      case TTagSize.extraLarge:
        hPadding = 16;
        vPadding = 9;
        break;
      case TTagSize.large:
        hPadding = 8;
        vPadding = 3;
        break;
      case TTagSize.medium:
        hPadding = 8;
        vPadding = 2;
        break;
      case TTagSize.small:
        hPadding = 6;
        vPadding = 2;
        break;
      default:
        return EdgeInsets.zero;
    }
    if (hPadding >= border) {
      hPadding = hPadding - border;
    } else {
      hPadding = 0;
    }
    if (vPadding >= border) {
      vPadding = vPadding - border;
    } else {
      vPadding = 0;
    }
    return EdgeInsets.only(
      left: hPadding,
      right: hPadding,
      top: vPadding,
      bottom: vPadding,
    );
  }

  double _getIconSize() {
    switch (size) {
      case TTagSize.extraLarge:
        return 16;
      case TTagSize.large:
        return 16;
      case TTagSize.medium:
        return 14;
      case TTagSize.small:
        return 12;
      default:
        return 14;
    }
  }
}

/// 标签颜色解析结果
class _TagColors {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color? closeIconColor;
  final FontWeight? fontWeight;

  _TagColors({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.closeIconColor,
    this.fontWeight,
  });
}
