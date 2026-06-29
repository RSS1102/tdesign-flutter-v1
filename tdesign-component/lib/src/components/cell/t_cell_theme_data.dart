import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_cell.dart' show TCellAlign;

/// 单元格组风格
enum TCellGroupVariant { defaultTheme, cardTheme }

/// 单元格组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
/// 兼容旧 TCellStyle 的字段与 defaultStyle 逻辑。
class TCellThemeData extends ThemeExtension<TCellThemeData> {
  /// 左侧图标颜色
  Color? leftIconColor;

  /// 右侧图标颜色
  Color? rightIconColor;

  /// 标题文字样式
  TextStyle? titleStyle;

  /// 必填星号文字样式
  TextStyle? requiredStyle;

  /// 内容描述文字样式
  TextStyle? descriptionStyle;

  /// 说明文字样式
  TextStyle? noteStyle;

  /// 箭头颜色
  Color? arrowColor;

  /// 单元格边框颜色
  Color? borderedColor;

  /// 单元格组边框颜色
  Color? groupBorderedColor;

  /// 默认状态背景颜色
  Color? backgroundColor;

  /// 点击状态背景颜色
  Color? clickBackgroundColor;

  /// 单元组标题文字样式
  TextStyle? groupTitleStyle;

  /// 单元格内边距
  EdgeInsets? padding;

  /// 卡片模式边框圆角
  BorderRadius? cardBorderRadius;

  /// 卡片模式内边距
  EdgeInsets? cardPadding;

  /// 单元格组标题内边距
  EdgeInsets? titlePadding;

  /// 单元格组标题背景颜色
  @deprecated
  Color? titleBackgroundColor;

  /// 内容对齐方式（L4 默认）
  TCellAlign? align;

  /// 是否开启点击反馈（L4 默认）
  bool? hover;

  /// 是否显示下边框（L4 默认）
  bool? showBottomBorder;

  /// 高度（L4 默认）
  double? height;

  /// 单元格组风格
  TCellGroupVariant? groupVariant;

  TCellThemeData({
    this.leftIconColor,
    this.rightIconColor,
    this.titleStyle,
    this.requiredStyle,
    this.descriptionStyle,
    this.noteStyle,
    this.arrowColor,
    this.borderedColor,
    this.groupBorderedColor,
    this.backgroundColor,
    this.clickBackgroundColor,
    this.groupTitleStyle,
    this.padding,
    this.cardBorderRadius,
    this.cardPadding,
    this.titlePadding,
    this.titleBackgroundColor,
    this.align,
    this.hover,
    this.showBottomBorder,
    this.height,
    this.groupVariant,
  });

  /// 生成单元格默认样式
  TCellThemeData.cellStyle(BuildContext context) {
    defaultStyle(context);
  }

  /// 初始化默认样式
  void defaultStyle(BuildContext context) {
    backgroundColor = TTheme.of(context).bgColorContainer;
    clickBackgroundColor = TTheme.of(context).bgColorContainerHover;
    leftIconColor = TTheme.of(context).brandNormalColor;
    rightIconColor = TTheme.of(context).brandNormalColor;
    titleStyle = TextStyle(
      color: TTheme.of(context).textColorPrimary,
      fontSize: TTheme.of(context).fontBodyLarge?.size ?? 16,
      height: TTheme.of(context).fontBodyLarge?.height ?? 24,
      fontWeight: FontWeight.w400,
    );
    requiredStyle =
        titleStyle!.copyWith(color: TTheme.of(context).errorNormalColor);
    descriptionStyle = TextStyle(
      color: TTheme.of(context).textColorSecondary,
      fontSize: TTheme.of(context).fontBodyMedium?.size ?? 14,
      height: TTheme.of(context).fontBodyMedium?.height ?? 22,
      fontWeight: FontWeight.w400,
    );
    noteStyle =
        titleStyle!.copyWith(color: TTheme.of(context).textColorPlaceholder);
    arrowColor = TTheme.of(context).textColorPlaceholder;

    groupBorderedColor = TTheme.of(context).componentStrokeColor;
    borderedColor = TTheme.of(context).componentStrokeColor;
    groupTitleStyle = TextStyle(
      color: TTheme.of(context).textColorPrimary,
      fontSize: TTheme.of(context).fontTitleLarge?.size ?? 18,
      height: TTheme.of(context).fontTitleLarge?.height ?? 26,
      fontWeight:
          TTheme.of(context).fontTitleLarge?.fontWeight ?? FontWeight.w600,
    );

    padding = EdgeInsets.all(TTheme.of(context).spacer16);
    cardBorderRadius =
        BorderRadius.all(Radius.circular(TTheme.of(context).radiusLarge));
    cardPadding =
        EdgeInsets.symmetric(horizontal: TTheme.of(context).spacer16);
    titlePadding = EdgeInsets.only(
      left: TTheme.of(context).spacer16,
      right: TTheme.of(context).spacer16,
      top: TTheme.of(context).spacer24,
      bottom: TTheme.of(context).spacer8,
    );
    titleBackgroundColor = Colors.transparent;
  }

  @override
  TCellThemeData copyWith({
    Color? leftIconColor,
    Color? rightIconColor,
    TextStyle? titleStyle,
    TextStyle? requiredStyle,
    TextStyle? descriptionStyle,
    TextStyle? noteStyle,
    Color? arrowColor,
    Color? borderedColor,
    Color? groupBorderedColor,
    Color? backgroundColor,
    Color? clickBackgroundColor,
    TextStyle? groupTitleStyle,
    EdgeInsets? padding,
    BorderRadius? cardBorderRadius,
    EdgeInsets? cardPadding,
    EdgeInsets? titlePadding,
    Color? titleBackgroundColor,
    TCellAlign? align,
    bool? hover,
    bool? showBottomBorder,
    double? height,
    TCellGroupVariant? groupVariant,
  }) {
    return TCellThemeData(
      leftIconColor: leftIconColor ?? this.leftIconColor,
      rightIconColor: rightIconColor ?? this.rightIconColor,
      titleStyle: titleStyle ?? this.titleStyle,
      requiredStyle: requiredStyle ?? this.requiredStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      noteStyle: noteStyle ?? this.noteStyle,
      arrowColor: arrowColor ?? this.arrowColor,
      borderedColor: borderedColor ?? this.borderedColor,
      groupBorderedColor: groupBorderedColor ?? this.groupBorderedColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      clickBackgroundColor: clickBackgroundColor ?? this.clickBackgroundColor,
      groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
      padding: padding ?? this.padding,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      cardPadding: cardPadding ?? this.cardPadding,
      titlePadding: titlePadding ?? this.titlePadding,
      titleBackgroundColor: titleBackgroundColor ?? this.titleBackgroundColor,
      align: align ?? this.align,
      hover: hover ?? this.hover,
      showBottomBorder: showBottomBorder ?? this.showBottomBorder,
      height: height ?? this.height,
      groupVariant: groupVariant ?? this.groupVariant,
    );
  }

  @override
  TCellThemeData lerp(ThemeExtension<TCellThemeData>? other, double t) {
    if (other is! TCellThemeData) {
      return this;
    }
    return TCellThemeData(
      leftIconColor: Color.lerp(leftIconColor, other.leftIconColor, t),
      rightIconColor: Color.lerp(rightIconColor, other.rightIconColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      requiredStyle: TextStyle.lerp(requiredStyle, other.requiredStyle, t),
      descriptionStyle: TextStyle.lerp(descriptionStyle, other.descriptionStyle, t),
      noteStyle: TextStyle.lerp(noteStyle, other.noteStyle, t),
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t),
      borderedColor: Color.lerp(borderedColor, other.borderedColor, t),
      groupBorderedColor: Color.lerp(groupBorderedColor, other.groupBorderedColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      clickBackgroundColor: Color.lerp(clickBackgroundColor, other.clickBackgroundColor, t),
      groupTitleStyle: TextStyle.lerp(groupTitleStyle, other.groupTitleStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) as EdgeInsets?,
      cardBorderRadius: BorderRadius.lerp(cardBorderRadius, other.cardBorderRadius, t),
      cardPadding: EdgeInsetsGeometry.lerp(cardPadding, other.cardPadding, t) as EdgeInsets?,
      titlePadding: EdgeInsetsGeometry.lerp(titlePadding, other.titlePadding, t) as EdgeInsets?,
      align: t < 0.5 ? align : other.align,
      hover: t < 0.5 ? hover : other.hover,
      showBottomBorder: t < 0.5 ? showBottomBorder : other.showBottomBorder,
      height: t < 0.5 ? height : other.height,
      groupVariant: t < 0.5 ? groupVariant : other.groupVariant,
    );
  }
}
