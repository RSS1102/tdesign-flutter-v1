import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

/// TInput 输入框组件
///
/// 基于 Material [TextField] 薄包装，提供六种布局形态。
/// D 类禁用：`enabled: false` / `readOnly: true`。
class TInput extends StatelessWidget {
  const TInput({
    super.key,
    this.width,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.hintText,
    this.inputType,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.obscureText = false,
    this.readOnly = false,
    this.inputFormatters,
    this.textAlign,
    this.label,
    this.prefix,
    this.suffix,
    this.onBtnTap,
    this.rightBtn,
    this.onClearTap,
    this.inputAction,
    this.required,
    this.labelWidget,
    this.decoration,
    this.inputDecoration,
    this.additionInfo,
    this.onTapOutside,
    this.selectionControls,
    this.contextMenuBuilder,
    this.enableInteractiveSelection,
    // L4 参数（P0 优先级，覆盖 Theme）
    this.textStyle,
    this.hintTextStyle,
    this.labelStyle,
    this.backgroundColor,
    this.textInputBackgroundColor,
    this.cursorColor,
    this.clearBtnColor,
    this.additionInfoColor,
    this.contentPadding,
    this.layout = TInputLayout.normal,
    this.size = TInputSize.large,
    this.contentAlignment = TextAlign.start,
    this.cardStyleTopText,
    this.cardStyleBottomText,
    this.showBottomDivider,
    this.showClearButton,
    this.clearIconSize,
    this.leftInfoWidth,
    this.spacer,
  });

  // ---- L1 语义属性 ----

  /// 输入框布局形态
  final TInputLayout layout;

  /// 输入框尺寸
  final TInputSize size;

  // ---- L2 内容属性 ----

  /// 输入框宽度
  final double? width;

  /// 左侧标签文案
  final String? label;

  /// 左侧图标
  final Widget? prefix;

  /// 右侧自定义组件
  final Widget? suffix;

  /// label右侧组件，支持自定义
  final Widget? labelWidget;

  /// 标签文本样式
  final TextStyle? labelStyle;

  /// 文本样式
  final TextStyle? textStyle;

  /// 提示文本样式
  final TextStyle? hintTextStyle;

  /// 右侧按钮
  final Widget? rightBtn;

  /// 提示文案
  final String? hintText;

  /// 是否必填标志（红色*）
  final bool? required;

  /// 错误提示信息
  final String? additionInfo;

  /// 输入框背景色
  final Color? backgroundColor;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// 清除按钮颜色
  final Color? clearBtnColor;

  /// 附加信息颜色
  final Color? additionInfoColor;

  /// 文本对齐方向
  final TextAlign? textAlign;

  /// 内容对齐方向
  final TextAlign contentAlignment;

  /// 清除图标大小
  final double? clearIconSize;

  /// 是否显示清除按钮
  final bool? showClearButton;

  /// 输入框左侧的宽度
  final double? leftInfoWidth;

  /// 卡片模式上方文字
  final String? cardStyleTopText;

  /// 卡片模式下方文字
  final String? cardStyleBottomText;

  /// 是否展示底部分割线
  final bool? showBottomDivider;

  /// 内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 组件各模块间间距
  final TInputSpacer? spacer;

  // ---- L3 行为属性 ----

  /// 是否只读
  final bool readOnly;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 是否隐藏输入的文字
  final bool obscureText;

  /// 点击键盘完成按钮时触发的回调
  final VoidCallback? onEditingComplete;

  /// 点击键盘完成按钮时触发的回调, 参数值为输入的内容
  final ValueChanged<String>? onSubmitted;

  /// 输入文本变化时回调
  final ValueChanged<String>? onChanged;

  /// 键盘类型
  final TextInputType? inputType;

  /// 键盘动作类型
  final TextInputAction? inputAction;

  /// 最大输入行数
  final int? maxLines;

  /// 最大字数限制
  final int? maxLength;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  /// 右侧按钮点击
  final GestureTapCallback? onBtnTap;

  /// 右侧删除点击
  final GestureTapCallback? onClearTap;

  /// controller
  final TextEditingController? controller;

  /// focusNode
  final FocusNode? focusNode;

  /// 自定义输入框样式
  final InputDecoration? inputDecoration;

  /// 自定义容器装饰（P0 逃逸舱）
  final Decoration? decoration;

  /// 点击输入框外部区域回调
  final TapRegionCallback? onTapOutside;

  /// 自定义选择控制器
  final TextSelectionControls? selectionControls;

  /// 自定义上下文菜单构建器
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// 是否启用交互式选择
  final bool? enableInteractiveSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TInputThemeData>();
    final resolvedSpacer =
        TInputResolve.resolveSpacer(theme: theme, instanceSpacer: spacer);
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: buildInputView(context, theme, resolvedSpacer),
    );
  }

  Widget buildInputView(
      BuildContext context, TInputThemeData? theme, TInputSpacer spacer) {
    final leftLabelWidth = _calculateLeftInfoWidth(context, theme, spacer);
    switch (layout) {
      case TInputLayout.normal:
        return buildNormalInput(context, leftLabelWidth, theme, spacer);
      case TInputLayout.twoLine:
        return buildTwoLineInput(context, leftLabelWidth, theme, spacer);
      case TInputLayout.special:
        return buildSpecialInput(context, leftLabelWidth, theme, spacer);
      case TInputLayout.longText:
        return buildLongTextInput(context, theme, spacer);
      case TInputLayout.normalMaxTwoLine:
        return buildNormalInput(context, leftLabelWidth, theme, spacer);
      case TInputLayout.cardStyle:
        return buildCardStyleInput(context, leftLabelWidth, theme, spacer);
    }
  }

  /// 计算文本渲染宽度
  double _measureTextWidth(
      String? text, TextStyle? style, BuildContext context) {
    if (text == null || text.isEmpty) {
      return 0;
    }
    final effectiveStyle = (style ?? const TextStyle()).copyWith(
      fontSize: TTheme.of(context).fontBodyLarge?.size,
      letterSpacing: 0,
      height: 1.0,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return textPainter.width + 2;
  }

  /// 计算输入框左侧信息总宽度
  double _calculateLeftInfoWidth(
      BuildContext context, TInputThemeData? theme, TInputSpacer spacer) {
    final iconSpace = prefix != null ? (spacer.iconLabelSpace ?? 4) : 0;
    final iconWidth = prefix != null ? 24 + iconSpace : 0;
    final labelWidth = _measureTextWidth(label, labelStyle, context);
    final requiredWidth = (required ?? false) ? 14 : 0;
    return iconWidth + labelWidth + requiredWidth + (leftInfoWidth ?? 4);
  }

  double _getBottomDividerMarginLeft(
      double leftLabelWidth, TInputSpacer spacer) {
    switch (layout) {
      case TInputLayout.normal:
      case TInputLayout.twoLine:
      case TInputLayout.normalMaxTwoLine:
      case TInputLayout.cardStyle:
        if (contentPadding != null && contentPadding is EdgeInsets) {
          return (contentPadding as EdgeInsets).left;
        }
        return spacer.labelInputSpace ?? 16;
      case TInputLayout.special:
      case TInputLayout.longText:
        if (contentPadding != null && contentPadding is EdgeInsets) {
          return (contentPadding as EdgeInsets).left;
        }
        return 16;
    }
  }

  Widget buildNormalInput(BuildContext context, double leftLabelWidth,
      TInputThemeData? theme, TInputSpacer spacer) {
    final cardStyleDecoration = TInputResolve.resolveCardStyleDecoration(
      context: context,
      layout: layout,
      theme: theme,
      cardStyle: layout == TInputLayout.cardStyle ? theme?.cardStyle : null,
      instanceDecoration: decoration,
    );
    final hasLeftWidget =
        label != null || prefix != null || (required ?? false);
    final padding = TInputResolve.resolveContentPadding(
      context: context,
      layout: layout,
      size: size,
      theme: theme,
      instancePadding: contentPadding,
      additionInfo: additionInfo,
      spacer: spacer,
    );
    final textStyle = TInputResolve.resolveTextStyle(
        context: context, theme: theme, instanceStyle: this.textStyle);
    final hintTextStyle = TInputResolve.resolveHintTextStyle(
        context: context, theme: theme, instanceStyle: this.hintTextStyle);
    final cursorColor = TInputResolve.resolveCursorColor(
        context: context, theme: theme, instanceColor: this.cursorColor);
    final clearBtnColor = TInputResolve.resolveClearBtnColor(
        context: context, theme: theme, instanceColor: this.clearBtnColor);
    final additionInfoColor = TInputResolve.resolveAdditionInfoColor(
        context: context,
        theme: theme,
        instanceColor: this.additionInfoColor);
    final bgColor = TInputResolve.resolveBackgroundColor(
        context: context, theme: theme, instanceColor: backgroundColor);
    final showDivider = showBottomDivider ?? theme?.showBottomDivider ?? true;
    final showClear =
        showClearButton ?? theme?.showClearButton ?? true;
    final clearSize = clearIconSize ?? theme?.clearIconSize;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: (cardStyleDecoration != null || decoration != null)
              ? null
              : (bgColor ?? TTheme.of(context).bgColorContainer),
          decoration: cardStyleDecoration ?? decoration,
          child: Row(
            crossAxisAlignment: additionInfo != null && additionInfo!.isNotEmpty
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: hasLeftWidget,
                child: SizedBox(width: spacer.labelInputSpace ?? 16),
              ),
              SizedBox(
                width: leftLabelWidth,
                child: GestureDetector(
                  child: Row(
                    children: [
                      Visibility(
                        visible: prefix != null,
                        child: SizedBox(
                          width: 24,
                          child: prefix ?? const SizedBox.shrink(),
                        ),
                      ),
                      Visibility(
                        visible: label != null,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: prefix != null
                                ? (spacer.iconLabelSpace ?? 4)
                                : 0,
                            top: TInputResolve.getInputPadding(size),
                            bottom: TInputResolve.getInputPadding(size),
                          ),
                          child: TText(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: TInputResolve.resolveLabelStyle(
                              context: context,
                              theme: theme,
                              instanceStyle: labelStyle,
                            ),
                            font: TTheme.of(context).fontBodyLarge,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: labelWidget != null,
                        child: labelWidget ?? const SizedBox.shrink(),
                      ),
                      Visibility(
                        visible: required ?? false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: TText(
                            '*',
                            maxLines: 1,
                            style: TextStyle(
                                color: TTheme.of(context).errorColor6),
                            font: TTheme.of(context).fontBodyLarge,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TInputView(
                      textStyle: textStyle,
                      readOnly: readOnly,
                      autofocus: autofocus,
                      obscureText: obscureText,
                      onEditingComplete: onEditingComplete,
                      onSubmitted: onSubmitted,
                      hintText: hintText,
                      inputType: inputType,
                      onChanged: onChanged,
                      onTapOutside: onTapOutside,
                      inputFormatters: inputFormatters,
                      inputDecoration: inputDecoration,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      focusNode: focusNode,
                      isCollapsed: true,
                      textAlign: contentAlignment,
                      hintTextStyle: hintTextStyle,
                      cursorColor: cursorColor,
                      textInputBackgroundColor:
                          TInputResolve.resolveTextInputBackgroundColor(
                              theme: theme,
                              instanceColor: textInputBackgroundColor),
                      controller: controller,
                      contentPadding: padding,
                      inputAction: inputAction,
                      selectionControls: selectionControls,
                      contextMenuBuilder: contextMenuBuilder,
                      enableInteractiveSelection: enableInteractiveSelection,
                    ),
                    Visibility(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: spacer.additionInfoSpace ?? 16,
                            right: TextAlign.end == contentAlignment ? 8 : 0,
                            bottom: TInputResolve.getInputPadding(size)),
                        child: TText(
                          additionInfo,
                          font: TTheme.of(context).fontBodySmall,
                          textAlign: contentAlignment != TextAlign.center
                              ? contentAlignment
                              : TextAlign.start,
                          textColor: additionInfoColor,
                        ),
                      ),
                      visible:
                          additionInfo != null && additionInfo!.isNotEmpty,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: suffix != null,
                child: Container(
                  margin: EdgeInsets.only(
                      top: TInputResolve.getInputPadding(size),
                      bottom: TInputResolve.getInputPadding(size),
                      right: 16),
                  child: suffix,
                ),
              ),
              Visibility(
                visible: controller != null &&
                    controller!.text.isNotEmpty &&
                    showClear &&
                    suffix == null,
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: spacer.inputRightSpace != null
                          ? spacer.inputRightSpace! / 2
                          : 8,
                      right: spacer.rightSpace ?? 16,
                      top: additionInfo != null && additionInfo!.isNotEmpty
                          ? TInputResolve.getInputPadding(size)
                          : 0,
                    ),
                    child: Icon(
                      size: clearSize,
                      TIcons.close_circle_filled,
                      color: clearBtnColor,
                    ),
                  ),
                  onTap: onClearTap ??
                      () {
                        controller?.text = '';
                      },
                ),
                replacement: Visibility(
                  visible: rightBtn != null,
                  child: GestureDetector(
                    onTap: onBtnTap,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: spacer.inputRightSpace != null
                            ? spacer.inputRightSpace! / 2
                            : 8,
                        right: spacer.rightSpace ?? 16,
                        top: additionInfo != null && additionInfo!.isNotEmpty
                            ? TInputResolve.getInputPadding(size)
                            : 0,
                      ),
                      child: rightBtn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Visibility(
            visible: layout != TInputLayout.cardStyle,
            child: Padding(
              padding: EdgeInsets.only(
                left: _getBottomDividerMarginLeft(leftLabelWidth, spacer),
              ),
              child: const TDivider(),
            ),
          ),
      ],
    );
  }

  Widget buildTwoLineInput(BuildContext context, double leftLabelWidth,
      TInputThemeData? theme, TInputSpacer spacer) {
    final textStyle = TInputResolve.resolveTextStyle(
        context: context, theme: theme, instanceStyle: this.textStyle);
    final hintTextStyle = TInputResolve.resolveHintTextStyle(
        context: context, theme: theme, instanceStyle: this.hintTextStyle);
    final cursorColor = TInputResolve.resolveCursorColor(
        context: context, theme: theme, instanceColor: this.cursorColor);
    final clearBtnColor = TInputResolve.resolveClearBtnColor(
        context: context, theme: theme, instanceColor: this.clearBtnColor);
    final bgColor = TInputResolve.resolveBackgroundColor(
        context: context, theme: theme, instanceColor: backgroundColor);
    final showDivider = showBottomDivider ?? theme?.showBottomDivider ?? true;
    final showClear =
        showClearButton ?? theme?.showClearButton ?? true;
    final clearSize = clearIconSize ?? theme?.clearIconSize;
    final padding = TInputResolve.resolveContentPadding(
      context: context,
      layout: layout,
      size: size,
      theme: theme,
      instancePadding: contentPadding,
      additionInfo: additionInfo,
      spacer: spacer,
    );

    return Container(
      alignment: Alignment.centerLeft,
      color: decoration != null
          ? null
          : (bgColor ?? TTheme.of(context).bgColorContainer),
      decoration: decoration,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: label != null,
                child: Row(
                  children: [
                    Visibility(
                      visible: label != null,
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: leftLabelWidth +
                                (spacer.labelInputSpace ?? 12)),
                        padding: EdgeInsets.only(
                            left: spacer.labelInputSpace ?? 12.0, top: 10.0),
                        child: Column(
                          children: [
                            TText(
                              label,
                              maxLines: 2,
                              style: TInputResolve.resolveLabelStyle(
                                context: context,
                                theme: theme,
                                instanceStyle: labelStyle,
                              ),
                              font: TTheme.of(context).fontBodyLarge,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: labelWidget != null,
                      child: labelWidget ?? const SizedBox.shrink(),
                    ),
                    Visibility(
                      visible: required ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: TText(
                          '*',
                          maxLines: 1,
                          style: TextStyle(
                              color: TTheme.of(context).errorColor6),
                          font: TTheme.of(context).fontBodyLarge,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 12, top: 7),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: labelWidget != null,
                      child: labelWidget ?? const SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 1,
                      child: TInputView(
                        textStyle: textStyle,
                        readOnly: readOnly,
                        autofocus: autofocus,
                        obscureText: obscureText,
                        onEditingComplete: onEditingComplete,
                        onSubmitted: onSubmitted,
                        hintText: hintText,
                        inputType: inputType,
                        onChanged: onChanged,
                        textAlign: textAlign,
                        inputFormatters: inputFormatters,
                        inputDecoration: inputDecoration,
                        isCollapsed: true,
                        maxLines: maxLines,
                        focusNode: focusNode,
                        hintTextStyle: hintTextStyle,
                        cursorColor: cursorColor,
                        textInputBackgroundColor:
                            TInputResolve.resolveTextInputBackgroundColor(
                                theme: theme,
                                instanceColor: textInputBackgroundColor),
                        controller: controller,
                        contentPadding: padding,
                        inputAction: inputAction,
                        selectionControls: selectionControls,
                        contextMenuBuilder: contextMenuBuilder,
                        enableInteractiveSelection: enableInteractiveSelection,
                      ),
                    ),
                    Visibility(
                      visible: controller != null &&
                          controller!.text.isNotEmpty &&
                          showClear,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: spacer.inputRightSpace != null
                                ? spacer.inputRightSpace! / 2
                                : 8,
                            right: spacer.rightSpace ?? 16,
                          ),
                          child: Icon(
                            size: clearSize,
                            TIcons.close_circle_filled,
                            color: clearBtnColor,
                          ),
                        ),
                        onTap: onClearTap,
                      ),
                      replacement: Visibility(
                        visible: rightBtn != null,
                        child: GestureDetector(
                          onTap: onBtnTap,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: spacer.inputRightSpace != null
                                  ? spacer.inputRightSpace! / 2
                                  : 8,
                              right: spacer.rightSpace ?? 16,
                            ),
                            child: rightBtn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(
                left: _getBottomDividerMarginLeft(leftLabelWidth, spacer),
              ),
              child: const TDivider(),
            ),
        ],
      ),
    );
  }

  Widget buildLongTextInput(
      BuildContext context, TInputThemeData? theme, TInputSpacer spacer) {
    final textStyle = TInputResolve.resolveTextStyle(
        context: context, theme: theme, instanceStyle: this.textStyle);
    final hintTextStyle = TInputResolve.resolveHintTextStyle(
        context: context, theme: theme, instanceStyle: this.hintTextStyle);
    final cursorColor = TInputResolve.resolveCursorColor(
        context: context, theme: theme, instanceColor: this.cursorColor);
    final bgColor = TInputResolve.resolveBackgroundColor(
        context: context, theme: theme, instanceColor: backgroundColor);
    final showDivider = showBottomDivider ?? theme?.showBottomDivider ?? true;
    final padding = TInputResolve.resolveContentPadding(
      context: context,
      layout: layout,
      size: size,
      theme: theme,
      instancePadding: contentPadding,
      additionInfo: additionInfo,
      spacer: spacer,
    );

    return Container(
      alignment: Alignment.centerLeft,
      color: decoration != null
          ? null
          : (bgColor ?? TTheme.of(context).bgColorContainer),
      decoration: decoration,
      height: label != null ? 197 : 148,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: label != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      top: TInputResolve.getInputPadding(size),
                      bottom: TInputResolve.getInputPadding(size)),
                  child: TText(
                    label,
                    maxLines: 2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (showDivider)
                  Padding(
                    padding: EdgeInsets.only(
                      left: _getBottomDividerMarginLeft(0, spacer),
                    ),
                    child: const TDivider(),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TInputView(
              textStyle: textStyle,
              readOnly: readOnly,
              autofocus: autofocus,
              obscureText: obscureText,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
              hintText: hintText,
              inputType: inputType,
              textAlign: textAlign,
              onChanged: onChanged,
              inputFormatters: inputFormatters ??
                  [LengthLimitingTextInputFormatter(maxLength)],
              inputDecoration: inputDecoration,
              maxLines: maxLines,
              focusNode: focusNode,
              hintTextStyle: hintTextStyle,
              cursorColor: cursorColor,
              textInputBackgroundColor: TInputResolve
                  .resolveTextInputBackgroundColor(
                      theme: theme, instanceColor: textInputBackgroundColor),
              controller: controller,
              contentPadding: padding,
              inputAction: inputAction,
              selectionControls: selectionControls,
              contextMenuBuilder: contextMenuBuilder,
              enableInteractiveSelection: enableInteractiveSelection,
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: TText(
              '${controller?.text.length}/${maxLength}',
              font: TTheme.of(context).fontBodySmall,
              textColor: TTheme.of(context).textColorPlaceholder,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpecialInput(BuildContext context, double leftLabelWidth,
      TInputThemeData? theme, TInputSpacer spacer) {
    final textStyle = TInputResolve.resolveTextStyle(
        context: context, theme: theme, instanceStyle: this.textStyle);
    final hintTextStyle = TInputResolve.resolveHintTextStyle(
        context: context, theme: theme, instanceStyle: this.hintTextStyle);
    final cursorColor = TInputResolve.resolveCursorColor(
        context: context, theme: theme, instanceColor: this.cursorColor);
    final bgColor = TInputResolve.resolveBackgroundColor(
        context: context, theme: theme, instanceColor: backgroundColor);
    final showDivider = showBottomDivider ?? theme?.showBottomDivider ?? true;
    final padding = TInputResolve.resolveContentPadding(
      context: context,
      layout: layout,
      size: size,
      theme: theme,
      instancePadding: contentPadding,
      additionInfo: additionInfo,
      spacer: spacer,
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: decoration != null
              ? null
              : (bgColor ?? TTheme.of(context).bgColorContainer),
          decoration: decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Visibility(
                visible: label != null,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: spacer.labelInputSpace ?? 16,
                      top: TInputResolve.getInputPadding(size),
                      bottom: TInputResolve.getInputPadding(size)),
                  child: leftInfoWidth != null
                      ? SizedBox(
                          width: leftLabelWidth,
                          child: TText(
                            label,
                            maxLines: 1,
                            font: TTheme.of(context).fontBodyLarge,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : TText(
                          label,
                          maxLines: 1,
                          font: TTheme.of(context).fontBodyLarge,
                          fontWeight: FontWeight.w400,
                        ),
                ),
              ),
              Visibility(
                visible: labelWidget != null,
                child: labelWidget ?? const SizedBox.shrink(),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: spacer.labelInputSpace ?? 16),
                  child: TInputView(
                    textStyle: textStyle,
                    readOnly: readOnly,
                    autofocus: autofocus,
                    obscureText: obscureText,
                    onEditingComplete: onEditingComplete,
                    onSubmitted: onSubmitted,
                    hintText: hintText,
                    inputType: inputType,
                    onChanged: onChanged,
                    inputFormatters: inputFormatters,
                    inputDecoration: inputDecoration,
                    maxLines: maxLines,
                    focusNode: focusNode,
                    isCollapsed: true,
                    hintTextStyle: hintTextStyle,
                    cursorColor: cursorColor,
                    textInputBackgroundColor:
                        TInputResolve.resolveTextInputBackgroundColor(
                            theme: theme,
                            instanceColor: textInputBackgroundColor),
                    controller: controller,
                    textAlign: textAlign,
                    contentPadding: padding,
                    inputAction: inputAction,
                    selectionControls: selectionControls,
                    contextMenuBuilder: contextMenuBuilder,
                    enableInteractiveSelection: enableInteractiveSelection,
                  ),
                ),
              ),
              Visibility(
                visible: suffix != null,
                child: Container(
                  margin: EdgeInsets.only(
                      top: TInputResolve.getInputPadding(size),
                      bottom: TInputResolve.getInputPadding(size),
                      right: spacer.rightSpace ?? 16),
                  child: suffix,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Visibility(
            child: Padding(
              padding: EdgeInsets.only(
                left: _getBottomDividerMarginLeft(leftLabelWidth, spacer),
              ),
              child: const TDivider(),
            ),
          ),
      ],
    );
  }

  Widget buildCardStyleInput(BuildContext context, double leftLabelWidth,
      TInputThemeData? theme, TInputSpacer spacer) {
    final topText = cardStyleTopText ?? theme?.cardStyleTopText;
    final bottomText = cardStyleBottomText ?? theme?.cardStyleBottomText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: topText != null,
          child: Column(
            children: [
              Text(
                topText ?? '',
                style: TextStyle(
                    fontSize: TTheme.of(context).fontBodyMedium!.size,
                    height: TTheme.of(context).fontBodyMedium!.height),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        buildNormalInput(context, leftLabelWidth, theme, spacer),
        Visibility(
          visible: bottomText != null,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                bottomText ?? '',
                style: TextStyle(
                    color: TTheme.of(context).errorColor6,
                    fontSize: TTheme.of(context).fontBodySmall!.size,
                    height: TTheme.of(context).fontBodySmall!.height),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
