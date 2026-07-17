import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_form_inherited.dart';

/// 表格单元选用组件类型的枚举
enum TFormItemType {
  input,
  radios,
  dateTimePicker,
  cascader,
  stepper,
  rate,
  textarea,
  upLoadImg
}

class TFormItem extends StatefulWidget {
  const TFormItem({
    required this.type,
    this.child,
    this.itemNotifier,
    this.label,
    this.labelWidget,
    this.help,
    this.name,
    this.labelAlign,
    this.contentAlign,
    this.labelWidth,
    this.tipAlign,
    this.requiredMark = true,
    this.formRules,
    this.itemRule,
    this.showErrorMessage = true,
    this.indicator,
    this.additionInfo,
    this.select = '',
    this.selectFn,
    this.hintText = '',
    this.backgroundColor,
    Map<String, String>? radios,
    Key? key,
  }) : super(key: key);

  /// 表单项标签左侧展示的内容
  final String? label;

  /// 自定义标签
  final Widget? labelWidget;

  /// 表格单元需要使用的组件类型
  final TFormItemType type;

  /// 表单字段名称
  final String? name;

  /// TInput的辅助信息
  final String? additionInfo;

  /// TInput 默认显示文字
  final String? help;

  /// TODO: item 标签对齐方式
  /// 可选: left、right、top
  final TextAlign? labelAlign;

  /// 表单显示内容对齐方式：
  /// left、right、top
  /// TODO: TStepper TRate 等组件没用实现通用性
  final TextAlign? contentAlign;

  /// 标签宽度，如果提供则覆盖Form的labelWidth
  final double? labelWidth;

  /// 组件提示内容对齐方式
  final TextAlign? tipAlign;

  /// 表单子组件
  final Widget? child;

  final FormItemNotifier? itemNotifier;

  /// 选择器 适用于日期选择器等
  final String select;

  /// 选择器方法 适用于日期选择器等
  final Function? selectFn;

  /// 是否显示必填标记（*）
  final bool? requiredMark;

  /// 整个表单的校验规则
  final List<TFormValidation>? formRules;

  /// 表单项验证规则
  final List? itemRule;

  /// 是否显示错误信息
  final bool showErrorMessage;

  /// TTextarea 的属性，指示器
  final bool? indicator;

  ///提示内容
  final hintText;

  /// 背景色
  final Color? backgroundColor;

  @override
  _TFormItemState createState() => _TFormItemState();
}

class _TFormItemState extends State<TFormItem> {
  VoidCallback? _itemNotifierListener;

  @override
  void initState() {
    super.initState();
    _bindItemNotifier(widget.itemNotifier);
  }

  @override
  void didUpdateWidget(covariant TFormItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemNotifier != widget.itemNotifier) {
      _unbindItemNotifier(oldWidget.itemNotifier);
      _bindItemNotifier(widget.itemNotifier);
    }
  }

  @override
  void dispose() {
    _unbindItemNotifier(widget.itemNotifier);
    super.dispose();
  }

  void _bindItemNotifier(FormItemNotifier? notifier) {
    if (notifier == null || notifier.isDisposed) {
      return;
    }
    _itemNotifierListener = () {
      updateformData(notifier.formVal);
    };
    notifier.addListener(_itemNotifierListener!);
  }

  void _unbindItemNotifier(FormItemNotifier? notifier) {
    if (notifier == null || _itemNotifierListener == null) {
      return;
    }
    notifier.removeListener(_itemNotifierListener!);
    _itemNotifierListener = null;
  }

  @override
  void didChangeDependencies() {
    if (formValidate) {
      startValidation();
    }
    if (formIsReset) {
      errorMessage = '';
    }
    super.didChangeDependencies();
  }

  /// 从 TForm 继承获取整个表单的参数
  /// 获取真正的 labelWidth
  double get labelWidth {
    final inherited = TFormInherited.of(context);
    const defaultlabelWidth = 8.0;

    /// 如果 item 传入定制的 labelWidth 则使用
    if (widget.labelWidth != null) {
      return widget.labelWidth as double;
    }

    /// 使用 form 整体传入的 labelWidth
    if (inherited?.labelWidth != null) {
      return inherited!.labelWidth as double;
    }

    return defaultlabelWidth;
  }

  Map<String, dynamic> get formData { // coverage:ignore-line
    return TFormInherited.of(context)!.formData; // coverage:ignore-line
  }

  /// 获取 form 以及 formItem 的内容排列方式
  TextAlign get formContentAlign {
    final inherited = TFormInherited.of(context);
    if (widget.contentAlign != null) {
      /// 断言 widget.contentAlign 不会为空
      return widget.contentAlign!; // coverage:ignore-line
    }

    /// 如果 没用为 item 定制内容排列方式 则全部使用总表单的内容排列方式
    return inherited!.contentAlign;
  }

  /// 获取 form 是否为水平排列的状态
  bool get formIsLayout {
    final inherited = TFormInherited.of(context);
    if (inherited?.layout != null) {
      return inherited!.layout;
    }
    return false;
  }

  bool get formIsReset {
    final inherited = TFormInherited.of(context);
    if (inherited?.isReset != null) {
      return inherited!.isReset;
    }
    return false;
  }

  /// 获取 form 整体是否校验的信号状态
  bool get formValidate {
    final inherited = TFormInherited.of(context);
    return inherited!.isValidate;
  }

  bool get formRequiredMark {
    return TFormInherited.of(context)!.requiredMark ?? false;
  }

  /// 获取整个表格是否需要展示错误提示
  bool? get showErrorMessage {
    return widget.showErrorMessage;
    }

  /// 获取整个表单的校验规则
  Map<String, TFormValidation> get formRules {
    final inherited = TFormInherited.of(context);
    return inherited!.rules;
  }

  bool browseOn = false;

  /// 表单 item 的校验错误提示信息
  String? errorMessage;

  /// 调用校验方法
  void startValidation() {
    setState(() {
      errorMessage = validate();
    });
  }

  /// 遍历校验规则并执行
  String? validate() {
    dynamic value = widget.itemNotifier?.formVal;
    var name = widget.name!;
    if (formRules[name] != null) {
      var rule = formRules[name]!;

      /// 只对类型匹配的项进行校验
      if (rule.type == widget.type) {
        final result = rule.check(value);
        if (result != null) {
          /// 返回第一个不通过的错误信息
          return result;
        }
      }
    }

    return null;
  }

  void updateformData(value) { // coverage:ignore-line
    if (widget.name != null) { // coverage:ignore-line
      var name = widget.name!; // coverage:ignore-line
      var _formData = Map<String, dynamic>.from(formData); // coverage:ignore-line
      _formData[name] = value; // coverage:ignore-line
      TFormInherited.of(context)!.onFormDataChange(_formData); // coverage:ignore-line
      startValidation(); // coverage:ignore-line
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget labelContent = Visibility(
        visible: widget.label != null ? true : false,
        child: SizedBox(
            width: labelWidth,
            child: widget.labelWidget ??
                Row(
                  children: [
                    TText(widget.label,
                        font: context.tTheme.fontBodyMedium,
                        textAlign: widget.labelAlign),
                    if (formRequiredMark &&
                        (widget.requiredMark != null &&
                            widget.requiredMark == true))
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: TText('*',
                            style: const TextStyle(fontSize: 12),
                            textColor: Colors.red,
                            textAlign: widget.labelAlign),
                      ),
                  ],
                )));
    var itemRowContent = <Widget>[
      labelContent,
      Visibility(
        visible: formIsLayout,
        child: Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: widget.child ?? const SizedBox(),
        )),
        replacement: widget.child ?? const SizedBox(),
      )
    ];
    var itemColumnContent = <Widget>[
      labelContent,
      const SizedBox(height: 8),
      Visibility(
        visible: formIsLayout,
        child: Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: widget.child ?? const SizedBox(),
        )),
        replacement: widget.child ?? const SizedBox(),
      ),
    ];
    switch (widget.type) {
      case TFormItemType.input:
      case TFormItemType.rate:
        return Container(
            color:
                widget.backgroundColor ?? context.tTheme.bgColorContainer,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: formIsLayout,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: itemRowContent,
                      ),
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: itemColumnContent,
                      ),
                    ),
                    _buildTipRow(
                        left: 0,
                        top: TFormItemType.rate == widget.type ? 4 : 0)
                  ],
                )));
      case TFormItemType.radios:
        return Container(
            color:
                widget.backgroundColor ?? context.tTheme.bgColorContainer,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: formIsLayout,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: itemRowContent,
                      ),
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: itemColumnContent,
                      ),
                    ),
                    _buildTipRow(left: 0, top: 4)
                  ],
                )));
      case TFormItemType.dateTimePicker:
      case TFormItemType.cascader:
        return _buildSelectRow(context);
      case TFormItemType.stepper:
        return Container(
          color: widget.backgroundColor ?? context.tTheme.bgColorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Visibility(
                visible: formIsLayout,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [labelContent, widget.child ?? const SizedBox()]),
                replacement: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: itemColumnContent,
                ),
              ),
              _buildTipRow(top: 4, left: 0, right: 20)
            ]),
          ),
        );
      case TFormItemType.textarea:
        return Container(
            color:
                widget.backgroundColor ?? context.tTheme.bgColorContainer,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: formIsLayout,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: widget.label != null ? true : false,
                                child: labelContent),
                            Expanded(child: widget.child ?? const SizedBox()),
                          ]),
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: widget.label != null ? true : false,
                            child: SizedBox(
                              width: labelWidth,
                              child: widget.labelWidget ??
                                  TText(widget.label,
                                      font: context.tTheme.fontBodyMedium,
                                      textAlign: widget.labelAlign),
                            ),
                          ),
                          widget.child ?? const SizedBox()
                        ],
                      ),
                    ),
                    _buildTipRow(left: 0, top: 8)
                  ],
                )));
      case TFormItemType.upLoadImg:
        return Container(
          color: widget.backgroundColor ?? context.tTheme.bgColorContainer,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Visibility(
                    visible: formIsLayout,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: itemRowContent),
                    replacement: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: widget.label != null ? true : false,
                            child: SizedBox(
                              width: labelWidth,
                              child: widget.labelWidget ??
                                  TText(widget.label,
                                      font: context.tTheme.fontBodyMedium,
                                      textAlign: widget.labelAlign),
                            )),
                        widget.child ?? const SizedBox()
                      ],
                    ),
                  ),
                  _buildTipRow(top: 0)
                ],
              )),
        );
    }
  }

  Widget _buildSelectRow(BuildContext context) {
    Widget labelContent = SizedBox(
      width: labelWidth,
      child: widget.labelWidget ??
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TText(widget.label ?? '',
                    font: context.tTheme.fontBodyMedium,
                    textAlign: widget.labelAlign),
                if (formRequiredMark &&
                    (widget.requiredMark != null &&
                        widget.requiredMark == true))
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: TText('*',
                        style: const TextStyle(fontSize: 12),
                        textColor: Colors.red,
                        textAlign: widget.labelAlign),
                  ),
              ],
            ),
          ),
    );
    Widget selectText = TText(
      widget.select != '' ? widget.select : widget.hintText,
      textAlign: formContentAlign,
      font: context.tTheme.fontBodyLarge,
      textColor: widget.select != ''
          ? context.tTheme.textColorPrimary // coverage:ignore-line
          : context.tTheme.textColorPlaceholder,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    Widget rowContent = Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: selectText),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(
              TIcons.chevron_right,
              color: context.tTheme.textColorPlaceholder,
            ),
          ),
        ],
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.selectFn != null) {
          widget.selectFn!(context);
        }
      },
      child: Container(
        color: widget.backgroundColor ?? context.tTheme.bgColorContainer,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: formIsLayout,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  labelContent,
                  Expanded(
                    child: rowContent,
                  )
                ],
              ),
              replacement: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelContent,
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 2),
                        child: selectText,
                      ),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      TIcons.chevron_right,
                      color: context.tTheme.textColorPlaceholder,
                    ),
                  ),
                ],
              ),
            ),
            _buildTipRow(right: 28, top: 4)
          ],
        ),
      ),
    );
  }

  ///文案提示 如帮助信息，错误信息
  Widget _buildTipRow({double top = 6, double left = 4, double right = 20}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.help != null && (errorMessage == null || errorMessage == ''))
          Row(
            children: [
              if (widget.label != null && formIsLayout)
                SizedBox(width: labelWidth),
              Expanded(
                child: Padding(
                    padding:
                        EdgeInsets.only(left: left, right: right, top: top),
                    child: TText(
                      widget.help,
                      font: context.tTheme.fontBodySmall,
                      textAlign: widget.tipAlign ?? TextAlign.left,
                      textColor: context.tTheme.textColorPlaceholder,
                    )),
              )
            ],
          ),
        if (showErrorMessage != null &&
            showErrorMessage! &&
            errorMessage != null &&
            errorMessage != '')
          Row(
            children: [
              if (widget.label != null && formIsLayout)
                SizedBox(width: labelWidth),
              Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.only(left: left, right: right, top: top),
                      child: TText(
                        errorMessage,
                        font: context.tTheme.fontBodySmall,
                        textAlign: widget.tipAlign ?? TextAlign.left,
                        textColor: context.tTheme.errorNormalColor,
                      )))
            ],
          ),
      ],
    );
  }
}

class FormItemNotifier with ChangeNotifier {
  bool isDisposed = false;
  dynamic _formVal = '';

  dynamic get formVal => _formVal; // coverage:ignore-line

  upDataForm(val) { // coverage:ignore-line
    _formVal = val; // coverage:ignore-line
    notifyListeners(); // coverage:ignore-line
  }

  @override // coverage:ignore-line
  void dispose() {
    super.dispose(); // coverage:ignore-line
    isDisposed = true; // coverage:ignore-line
  }
}
