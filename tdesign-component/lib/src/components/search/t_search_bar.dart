import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_search_bar_theme_data.dart';

/// v1 搜索输入框。
///
/// 文本控制遵循 D 类：优先使用 [controller]，无 controller 时内部创建控制器；
/// [initialValue] 仅用于初始化内部控制器。
class TSearchBar extends StatefulWidget {
  const TSearchBar({
    super.key,

    /// 文本控制器。
    this.controller,

    /// 初始文本；仅在未传 [controller] 时初始化一次。
    this.initialValue,

    /// 文本变化通知。
    this.onChanged,

    /// 提交回调。
    this.onSubmitted,

    /// 是否可交互。
    this.enabled = true,

    /// 是否只读。
    this.readOnly = false,

    /// 占位提示。
    this.hintText,

    /// 是否显示取消按钮。
    this.needCancel = false,

    /// 取消按钮文案。
    this.cancelText = '取消',

    /// 取消按钮点击回调。
    this.onCancelPressed,

    /// 清除按钮点击回调。
    this.onClearPressed,

    /// 是否自动聚焦。
    this.autoFocus = false,

    /// 键盘动作。
    this.inputAction = TextInputAction.search,

    /// 输入框装饰逃逸口。
    this.decoration,

    /// 自定义焦点。
    this.focusNode,
  });

  /// 文本控制器。
  final TextEditingController? controller;

  /// 初始文本；仅在未传 [controller] 时初始化一次。
  final String? initialValue;

  /// 文本变化通知。
  final ValueChanged<String>? onChanged;

  /// 提交回调。
  final ValueChanged<String>? onSubmitted;

  /// 是否可交互。
  final bool enabled;

  /// 是否只读。
  final bool readOnly;

  /// 占位提示。
  final String? hintText;

  /// 是否显示取消按钮。
  final bool needCancel;

  /// 取消按钮文案。
  final String cancelText;

  /// 取消按钮点击回调。
  final VoidCallback? onCancelPressed;

  /// 清除按钮点击回调。
  final VoidCallback? onClearPressed;

  /// 是否自动聚焦。
  final bool autoFocus;

  /// 键盘动作。
  final TextInputAction inputAction;

  /// 输入框装饰逃逸口。
  final InputDecoration? decoration;

  /// 自定义焦点。
  final FocusNode? focusNode;

  @override
  State<TSearchBar> createState() => _TSearchBarState();
}

class _TSearchBarState extends State<TSearchBar> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _hasText = false;
  bool _hasFocus = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _internalFocusNode = FocusNode();
    _controller = _effectiveController;
    _focusNode = _effectiveFocusNode;
    _hasText = _controller.text.isNotEmpty;
    _hasFocus = _focusNode.hasFocus;
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant TSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
    _syncFocusNode();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    final theme = Theme.of(context).extension<TSearchBarThemeData>();
    final variant = theme?.variant ?? TSearchBarVariant.square;
    final textAlignment = theme?.textAlignment ?? TSearchBarAlignment.left;
    final padding = theme?.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final backgroundColor = theme?.backgroundColor ?? token.bgColorContainer;
    final autoHeight = theme?.autoHeight ?? false;
    final inputDecoration = _buildDecoration(context);
    final textStyle = TextStyle(
      textBaseline: TextBaseline.ideographic,
      fontSize: token.fontBodyLarge?.size,
      color: widget.enabled ? token.textColorPrimary : token.textDisabledColor,
    );

    return Semantics(
      enabled: widget.enabled,
      textField: true,
      child: AbsorbPointer(
        absorbing: !widget.enabled,
        child: Container(
          padding: padding,
          height: autoHeight ? null : 56,
          color: backgroundColor,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: autoHeight ? null : double.infinity,
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? token.bgColorSecondaryContainer
                        : token.bgColorComponentDisabled,
                    borderRadius: BorderRadius.circular(
                      variant == TSearchBarVariant.square ? 4 : 28,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        TIcons.search,
                        size: 24,
                        color: widget.enabled
                            ? token.textColorPlaceholder
                            : token.textDisabledColor,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 1),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: widget.autoFocus,
                            enabled: widget.enabled,
                            readOnly: widget.readOnly,
                            onChanged: widget.onChanged,
                            onSubmitted: widget.onSubmitted,
                            textInputAction: widget.inputAction,
                            cursorColor: token.brandNormalColor,
                            cursorHeight: theme?.cursorHeight,
                            textAlign:
                                textAlignment == TSearchBarAlignment.center
                                    ? TextAlign.center
                                    : TextAlign.left,
                            style: textStyle,
                            decoration: inputDecoration,
                            maxLines: 1,
                            cursorOpacityAnimates: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      if (_hasText)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _handleClear,
                          child: Icon(
                            TIcons.close_circle_filled,
                            size: 21,
                            color: widget.enabled
                                ? token.textColorPlaceholder
                                : token.textDisabledColor,
                          ),
                        ),
                      const SizedBox(width: 9),
                    ],
                  ),
                ),
              ),
              if (widget.needCancel && _hasFocus)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleCancel,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.center,
                    child: Text(
                      widget.cancelText,
                      style: TextStyle(
                        fontSize: token.fontBodyLarge?.size,
                        color: token.brandNormalColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final token = context.tTheme;
    final base = widget.decoration ?? const InputDecoration();
    return base.copyWith(
      hintText: base.hintText ?? widget.hintText,
      hintStyle: base.hintStyle ??
          TextStyle(
            fontSize: token.fontBodyLarge?.size,
            color: widget.enabled
                ? token.textColorPlaceholder
                : token.textDisabledColor,
            textBaseline: TextBaseline.ideographic,
            overflow: TextOverflow.ellipsis,
          ),
      border: base.border ?? InputBorder.none,
      enabledBorder: base.enabledBorder ?? InputBorder.none,
      focusedBorder: base.focusedBorder ?? InputBorder.none,
      disabledBorder: base.disabledBorder ?? InputBorder.none,
      hintMaxLines: base.hintMaxLines ?? 1,
      isCollapsed: widget.decoration?.isCollapsed ?? true,
      contentPadding: base.contentPadding ?? EdgeInsets.zero,
    );
  }

  void _syncController() {
    final next = _effectiveController;
    if (_controller == next) {
      return;
    }
    _controller.removeListener(_handleTextChanged);
    _controller = next;
    _controller.addListener(_handleTextChanged);
    _setHasText(_controller.text.isNotEmpty);
  }

  void _syncFocusNode() {
    final next = _effectiveFocusNode;
    if (_focusNode == next) {
      return;
    }
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode = next;
    _focusNode.addListener(_handleFocusChanged);
    _setHasFocus(_focusNode.hasFocus);
  }

  void _handleTextChanged() {
    _setHasText(_controller.text.isNotEmpty);
  }

  void _handleFocusChanged() {
    _setHasFocus(_focusNode.hasFocus);
  }

  void _setHasText(bool value) {
    if (_hasText == value) {
      return;
    }
    setState(() => _hasText = value);
  }

  void _setHasFocus(bool value) {
    if (_hasFocus == value) {
      return;
    }
    setState(() => _hasFocus = value);
  }

  void _handleClear() {
    _controller.clear();
    widget.onClearPressed?.call();
    widget.onChanged?.call('');
  }

  void _handleCancel() {
    _controller.clear();
    widget.onCancelPressed?.call();
    widget.onChanged?.call('');
    _focusNode.unfocus();
  }
}
