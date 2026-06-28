import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';
import '../input/input_view.dart';
import '../input/t_input_resolve.dart';
import '../input/t_input_theme_data.dart';

/// TTextarea 多行文本布局方式
enum TTextareaLayout { vertical, horizontal }

/// TTextarea 多行文本输入组件
///
/// 基于 Material [TextField] 薄包装。
/// 与 TInput 共用 [TInputThemeData]。
/// D 类禁用：`enabled: false` / `readOnly: true`。
/// 推荐新代码使用 [TInput.multiline()]。
class TTextarea extends StatefulWidget {
  const TTextarea({
    Key? key,
    this.width,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.hintText,
    this.inputType,
    this.maxLines,
    this.minLines = 4,
    this.maxLength,
    this.maxLengthEnforcement,
    this.allowInputOverMax = false,
    this.autofocus = false,
    this.readOnly = false,
    this.inputFormatters,
    this.textAlign,
    this.inputDecoration,
    this.label,
    this.labelIcon,
    this.labelWidget,
    this.required,
    this.additionInfo,
    this.additionInfoColor,
    this.indicator = false,
    this.layout = TTextareaLayout.horizontal,
    this.autosize,
    this.labelWidth,
    this.margin,
    this.padding,
    this.decoration,
    this.textareaDecoration,
    this.bordered,
    this.showBottomDivider = true,
    // L4 参数（P0 优先级，覆盖 Theme）
    this.textStyle,
    this.hintTextStyle,
    this.labelStyle,
    this.backgroundColor,
    this.textInputBackgroundColor,
    this.cursorColor,
    this.size,
  }) : super(key: key);

  // ---- L1 语义属性 ----

  /// 标题输入框布局方式
  final TTextareaLayout? layout;

  /// 输入框尺寸
  final TInputSize? size;

  // ---- L2 内容属性 ----

  /// 输入框宽度
  final double? width;

  /// 输入框标题
  final String? label;

  /// 输入框标题图标
  final Widget? labelIcon;

  /// 输入框标题宽度
  final double? labelWidth;

  /// label组件
  final Widget? labelWidget;

  /// 是否必填标志
  final bool? required;

  /// 提示文案
  final String? hintText;

  /// 错误提示信息
  final String? additionInfo;

  /// 错误提示颜色
  final Color? additionInfoColor;

  /// 文本颜色
  final TextStyle? textStyle;

  /// 提示文本颜色
  final TextStyle? hintTextStyle;

  /// 标签文本样式
  final TextStyle? labelStyle;

  /// 输入框背景色
  final Color? backgroundColor;

  /// 文本框背景色
  final Color? textInputBackgroundColor;

  /// 游标颜色
  final Color? cursorColor;

  /// 输入框样式(包括标签)
  final Decoration? decoration;

  /// 输入框样式(不包括标签)
  final Decoration? textareaDecoration;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 是否显示外边框
  final bool? bordered;

  /// 边框外部下划线
  final bool? showBottomDivider;

  /// 否显示文本计数器
  final bool? indicator;

  /// 文字对齐方向
  final TextAlign? textAlign;

  /// 自定义输入框TextField组件样式
  final InputDecoration? inputDecoration;

  // ---- L3 行为属性 ----

  /// 是否只读
  final bool? readOnly;

  /// 是否自动获取焦点
  final bool? autofocus;

  /// 点击键盘完成按钮
  final VoidCallback? onEditingComplete;

  /// 提交回调
  final ValueChanged<String>? onSubmitted;

  /// 文本变更回调
  final ValueChanged<String>? onChanged;

  /// 键盘类型
  final TextInputType? inputType;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  /// controller
  final TextEditingController? controller;

  /// 最大行数
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// focusNode
  final FocusNode? focusNode;

  /// 最大字数
  final int? maxLength;

  /// 长度限制方式
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// 超出后是否允许输入
  final bool? allowInputOverMax;

  /// 是否自动增高
  final bool? autosize;

  @override
  State<TTextarea> createState() => _TTextareaState();
}

class _TTextareaState extends State<TTextarea> {
  final _hasFocus = ValueNotifier<bool>(false);
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _hasFocus.dispose();
    super.dispose();
  }

  void _focusListener() {
    _hasFocus.value = _focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TInputThemeData>();
    final effectiveSize = widget.size ?? TInputSize.large;
    final padding = _getInputPadding(context, effectiveSize);
    final textareaView =
        _getTextareaView(context, _getInputView(context, theme, effectiveSize),
            _getIndicatorView(context));
    final container =
        _getContainer(context, _getLabelView(context, effectiveSize), textareaView);
    if (widget.bordered == true || widget.decoration != null) {
      return container;
    }
    return Stack(
      children: [
        container,
        if (widget.showBottomDivider == true)
          Positioned(
            bottom: 0,
            left: padding,
            right: 0,
            child: Divider(
              height: 0.5,
              color: TTheme.of(context).componentStrokeColor,
            ),
          ),
      ],
    );
  }

  Widget _getLabelView(BuildContext context, TInputSize size) {
    final pad = _getInputPadding(context, size);
    final isHorizontal = widget.layout == TTextareaLayout.horizontal;
    final fontSize = isHorizontal
        ? TTheme.of(context).fontBodyLarge?.size
        : TTheme.of(context).fontBodyMedium?.size;
    if ((widget.label == null || widget.label == '') &&
        widget.labelIcon == null &&
        widget.labelWidget == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: widget.labelWidth,
      padding: isHorizontal
          ? EdgeInsets.only(right: pad)
          : EdgeInsets.only(bottom: TTheme.of(context).spacer8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.labelIcon ?? const SizedBox.shrink(),
          widget.label != null && widget.label != ''
              ? Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: widget.labelIcon != null
                            ? TTheme.of(context).spacer4
                            : 0),
                    child: TText(
                      widget.label!,
                      maxLines: isHorizontal ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TInputResolve.resolveLabelStyle(
                        context: context,
                        theme: Theme.of(context).extension<TInputThemeData>(),
                        instanceStyle: widget.labelStyle ??
                            TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.labelWidget ?? const SizedBox.shrink(),
          widget.required == true
              ? Padding(
                  padding:
                      EdgeInsets.only(left: TTheme.of(context).spacer4),
                  child: TText(
                    '*',
                    style: TextStyle(
                        color: TTheme.of(context).errorColor6,
                        fontSize: fontSize,
                        height: 1.3),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _getInputView(
      BuildContext context, TInputThemeData? theme, TInputSize size) {
    final textStyle = TInputResolve.resolveTextStyle(
        context: context, theme: theme, instanceStyle: widget.textStyle);
    final hintTextStyle = TInputResolve.resolveHintTextStyle(
        context: context, theme: theme, instanceStyle: widget.hintTextStyle);
    final cursorColor = TInputResolve.resolveCursorColor(
        context: context, theme: theme, instanceColor: widget.cursorColor);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 24),
        child: TInputView(
          textStyle: textStyle,
          readOnly: widget.readOnly ?? false,
          autofocus: widget.autofocus ?? false,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          hintText: widget.hintText,
          inputType: widget.inputType,
          textAlign: widget.textAlign,
          onChanged: (val) {
            setState(() {});
            if (widget.onChanged != null) {
              widget.onChanged!(val);
            }
          },
          inputFormatters: [
            ...(widget.inputFormatters ?? []),
            ...(widget.maxLength != null &&
                    !(widget.allowInputOverMax ?? false)
                ? [
                    LengthLimitingTextInputFormatter(
                      widget.maxLength,
                      maxLengthEnforcement: widget.maxLengthEnforcement,
                    )
                  ]
                : [])
          ],
          inputDecoration: widget.inputDecoration,
          minLines: widget.minLines,
          maxLines: widget.autosize == true ? null : widget.maxLines,
          focusNode: _focusNode,
          isCollapsed: true,
          hintTextStyle: widget.readOnly == true
              ? TextStyle(color: TTheme.of(context).textDisabledColor)
              : hintTextStyle,
          cursorColor: cursorColor,
          textInputBackgroundColor: TInputResolve.resolveTextInputBackgroundColor(
              theme: theme, instanceColor: widget.textInputBackgroundColor),
          controller: widget.controller,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _getIndicatorView(BuildContext context) {
    final pad = _getInputPadding(context, widget.size ?? TInputSize.large);
    final showAdditionInfo = widget.additionInfo != null &&
        widget.additionInfo!.isNotEmpty;
    final showIndicator =
        widget.indicator == true && widget.maxLength != null;
    final widgetList = <Widget>[];
    if (showAdditionInfo) {
      widgetList.add(
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _hasFocus,
            builder: (context, value, child) {
              return Opacity(
                opacity: value ? 0 : 1,
                child: TText(
                  widget.additionInfo!,
                  style: TextStyle(
                    fontSize: TTheme.of(context).fontBodySmall?.size,
                    color: TInputResolve.resolveAdditionInfoColor(
                      context: context,
                      theme: Theme.of(context).extension<TInputThemeData>(),
                      instanceColor: widget.additionInfoColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    if (showAdditionInfo && showIndicator) {
      widgetList.add(SizedBox(width: pad));
    }
    if (showIndicator) {
      widgetList.add(TText(
        '${widget.controller?.text.length ?? 0}/${widget.maxLength}',
        style: TextStyle(
            fontSize: TTheme.of(context).fontBodySmall?.size,
            color: TTheme.of(context).textColorPlaceholder),
      ));
    }
    return Visibility(
      visible: showIndicator || showAdditionInfo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widgetList,
      ),
    );
  }

  Widget _getTextareaView(
      BuildContext context, Widget inputView, Widget indicatorView) {
    final size = widget.size ?? TInputSize.large;
    final padding = _getInputPadding(context, size);
    return Container(
      decoration: widget.textareaDecoration ??
          (widget.bordered == true
              ? BoxDecoration(
                  color: widget.decoration != null
                      ? null
                      : (widget.backgroundColor ??
                          TTheme.of(context).bgColorContainer),
                  borderRadius:
                      BorderRadius.circular(TTheme.of(context).radiusDefault),
                  border: Border.all(
                      color: TTheme.of(context).componentBorderColor),
                )
              : null),
      padding: widget.bordered == true ? EdgeInsets.all(padding) : null,
      child: Column(
        children: [
          inputView,
          indicatorView,
        ],
      ),
    );
  }

  Widget _getContainer(
      BuildContext context, Widget labelView, Widget textareaView) {
    final size = widget.size ?? TInputSize.large;
    final padding = _getInputPadding(context, size);
    final isHorizontal = widget.layout == TTextareaLayout.horizontal;
    return Container(
      width: widget.width,
      decoration: widget.decoration,
      padding: widget.padding ?? EdgeInsets.all(padding),
      margin: widget.margin,
      child: isHorizontal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelView,
                Expanded(
                  child: textareaView,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelView,
                textareaView,
              ],
            ),
    );
  }

  /// 获取输入框规格内边距
  double _getInputPadding(BuildContext context, TInputSize size) {
    switch (size) {
      case TInputSize.small:
        return TTheme.of(context).spacer12;
      case TInputSize.large:
        return TTheme.of(context).spacer16;
    }
  }
}
