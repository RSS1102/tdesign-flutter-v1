import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

/// TInput 样式解析器
///
/// 优先级链：构造器参数 > TInputThemeData > Token 默认值
/// 这是唯一的样式 merge 入口，build 内禁止内联颜色/尺寸计算。
class TInputResolve {
  TInputResolve._(); // 私有构造，禁止实例化

  /// 解析文本样式
  ///
  /// 优先级：构造器 textStyle > Theme.textStyle > Token 默认
  static TextStyle resolveTextStyle({
    required BuildContext context,
    TInputThemeData? theme,
    TextStyle? instanceStyle,
  }) {
    if (instanceStyle != null) return instanceStyle;
    if (theme?.textStyle != null) return theme!.textStyle!;
    final tTheme = TTheme.of(context);
    return TextStyle(
      color: tTheme.textColorPrimary,
      fontSize: tTheme.fontBodyLarge?.size,
    );
  }

  /// 解析提示文本样式
  ///
  /// 优先级：构造器 hintTextStyle > Theme.hintTextStyle > Token 默认
  static TextStyle resolveHintTextStyle({
    required BuildContext context,
    TInputThemeData? theme,
    TextStyle? instanceStyle,
  }) {
    if (instanceStyle != null) return instanceStyle;
    if (theme?.hintTextStyle != null) return theme!.hintTextStyle!;
    final tTheme = TTheme.of(context);
    return TextStyle(
      color: tTheme.textColorPlaceholder,
      fontSize: tTheme.fontBodyLarge?.size,
    );
  }

  /// 解析标签文本样式
  ///
  /// 优先级：构造器 labelStyle > Theme.labelStyle > Token 默认
  static TextStyle resolveLabelStyle({
    required BuildContext context,
    TInputThemeData? theme,
    TextStyle? instanceStyle,
  }) {
    if (instanceStyle != null) return instanceStyle;
    if (theme?.labelStyle != null) return theme!.labelStyle!;
    final tTheme = TTheme.of(context);
    return TextStyle(
      color: tTheme.textColorPrimary,
      fontSize: tTheme.fontBodyLarge?.size,
      letterSpacing: 0,
    );
  }

  /// 解析输入框背景色
  ///
  /// 优先级：构造器 backgroundColor > Theme.backgroundColor > Token 默认
  static Color? resolveBackgroundColor({
    required BuildContext context,
    TInputThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.backgroundColor != null) return theme!.backgroundColor;
    return null; // null 时不设背景色，让 Material 默认处理
  }

  /// 解析文本框背景色
  ///
  /// 优先级：构造器 textInputBackgroundColor > Theme.textInputBackgroundColor > null
  static Color? resolveTextInputBackgroundColor({
    TInputThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    return theme?.textInputBackgroundColor;
  }

  /// 解析游标颜色
  ///
  /// 优先级：构造器 cursorColor > Theme.cursorColor > Token brandNormalColor
  static Color resolveCursorColor({
    required BuildContext context,
    TInputThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.cursorColor != null) return theme!.cursorColor!;
    return TTheme.of(context).brandNormalColor;
  }

  /// 解析清除按钮颜色
  ///
  /// 优先级：构造器 clearBtnColor > Theme.clearBtnColor > Token textColorPlaceholder
  static Color resolveClearBtnColor({
    required BuildContext context,
    TInputThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.clearBtnColor != null) return theme!.clearBtnColor!;
    return TTheme.of(context).textColorPlaceholder;
  }

  /// 解析附加信息颜色
  ///
  /// 优先级：构造器 additionInfoColor > Theme.additionInfoColor > Token textColorPlaceholder
  static Color resolveAdditionInfoColor({
    required BuildContext context,
    TInputThemeData? theme,
    Color? instanceColor,
  }) {
    if (instanceColor != null) return instanceColor;
    if (theme?.additionInfoColor != null) return theme!.additionInfoColor!;
    return TTheme.of(context).textColorPlaceholder;
  }

  /// 解析内容内边距
  ///
  /// 优先级：构造器 contentPadding > Theme.contentPadding > 默认 EdgeInsets
  static EdgeInsetsGeometry resolveContentPadding({
    required BuildContext context,
    required TInputLayout layout,
    required TInputSize size,
    TInputThemeData? theme,
    EdgeInsetsGeometry? instancePadding,
    String? additionInfo,
    TInputSpacer spacer = TInputSpacer.defaultSpacer,
  }) {
    if (instancePadding != null) return instancePadding;
    if (theme?.contentPadding != null) return theme!.contentPadding!;
    final padding = getInputPadding(size);
    switch (layout) {
      case TInputLayout.normal:
      case TInputLayout.normalMaxTwoLine:
        return EdgeInsets.only(
          left: spacer.labelInputSpace ?? 16,
          right: spacer.inputRightSpace != null
              ? spacer.inputRightSpace! / 2
              : 16,
          bottom: additionInfo != null && additionInfo.isNotEmpty ? 4 : padding,
          top: padding,
        );
      case TInputLayout.twoLine:
        return EdgeInsets.only(
          left: spacer.labelInputSpace ?? 16,
          right: spacer.inputRightSpace != null
              ? spacer.inputRightSpace! / 2
              : 8,
        );
      case TInputLayout.special:
        return EdgeInsets.only(
          right: spacer.inputRightSpace ?? 16,
          bottom: padding,
          top: padding,
        );
      case TInputLayout.longText:
        return const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12);
      case TInputLayout.cardStyle:
        return EdgeInsets.only(
          left: spacer.labelInputSpace ?? 16,
          right: spacer.inputRightSpace != null
              ? spacer.inputRightSpace! / 2
              : 16,
          bottom: additionInfo != null && additionInfo.isNotEmpty ? 4 : padding,
          top: padding,
        );
    }
  }

  /// 解析卡片布局装饰
  ///
  /// 优先级：构造器 decoration > Theme.cardStyle + Token
  static BoxDecoration? resolveCardStyleDecoration({
    required BuildContext context,
    required TInputLayout layout,
    TInputThemeData? theme,
    TInputCardStyle? cardStyle,
    Decoration? instanceDecoration,
  }) {
    if (instanceDecoration is BoxDecoration) return instanceDecoration;
    if (layout != TInputLayout.cardStyle) return null;
    final tTheme = TTheme.of(context);
    final effectiveCardStyle = cardStyle ?? theme?.cardStyle;
    if (effectiveCardStyle == null) return null;
    switch (effectiveCardStyle) {
      case TInputCardStyle.topText:
        return BoxDecoration(
          color: tTheme.bgColorContainer,
          border: Border.all(color: tTheme.componentStrokeColor),
          borderRadius: BorderRadius.circular(tTheme.radiusDefault),
        );
      case TInputCardStyle.topTextWithBlueBorder:
        return BoxDecoration(
          color: tTheme.bgColorContainer,
          border: Border.all(color: tTheme.brandNormalColor, width: 1.5),
          borderRadius: BorderRadius.circular(tTheme.radiusDefault),
        );
      case TInputCardStyle.errorStyle:
        return BoxDecoration(
          color: tTheme.bgColorContainer,
          border: Border.all(color: tTheme.errorColor6, width: 1.5),
          borderRadius: BorderRadius.circular(tTheme.radiusDefault),
        );
    }
  }

  /// 解析间距配置
  ///
  /// 优先级：构造器 spacer > Theme.spacer > 默认
  static TInputSpacer resolveSpacer({
    TInputThemeData? theme,
    TInputSpacer? instanceSpacer,
  }) {
    if (instanceSpacer != null) return instanceSpacer;
    return theme?.spacer ?? TInputSpacer.defaultSpacer;
  }

  /// 按尺寸获取输入框内边距
  static double getInputPadding(TInputSize size) {
    switch (size) {
      case TInputSize.small:
        return 12;
      case TInputSize.large:
        return 16;
    }
  }
}

// 保留 Chinese2Formatter 兼容
/// 中文算作两个字符类型的TextInputFormatter
class Chinese2Formatter extends TextInputFormatter {
  final int maxLength;

  Chinese2Formatter(this.maxLength);

  final _regExp = r'^[\u4E00-\u9FA5A-Za-z0-9_]+$';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newValueLength = newValue.text.length;
    var count = 0;
    if (newValueLength == 0) {
      return newValue;
    }
    if (maxLength > 0) {
      for (var i = 0; i < newValueLength; i++) {
        if (newValue.text.codeUnitAt(i) > 122) {
          ///中文字符按照2个计算
          count++;
        }
        if (i > 0 && count + i > maxLength - 1) {
          var text = newValue.text.substring(0, i);
          return newValue.copyWith(
              text: text,
              composing: TextRange.empty,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: i, affinity: TextAffinity.downstream)));
        }
      }
    }
    if (newValueLength > 0 &&
        RegExp(_regExp).firstMatch(newValue.text) != null) {
      if (newValueLength + count <= maxLength) {
        return newValue;
      }
    }
    return oldValue;
  }
}
