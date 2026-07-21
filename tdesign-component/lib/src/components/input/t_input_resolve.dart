import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';

/// TInput 的内部装饰解析入口。
class TInputResolve {
  static InputDecoration resolveDecoration({
    BuildContext? context,
    InputDecoration? base,
    String? label,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    bool enabled = true,
    bool multiline = false,
  }) {
    final source = base ?? const InputDecoration();
    final token = context?.tTheme;
    final textTheme = context == null ? null : Theme.of(context).textTheme;
    final borderColor = token?.componentStrokeColor;
    final enabledBorderColor = token?.componentBorderColor ?? borderColor;
    final focusedBorderColor = token?.brandNormalColor ?? enabledBorderColor;
    final disabledBorderColor = token?.componentStrokeColor ?? borderColor;
    final defaultBorder = enabledBorderColor == null
        ? null
        : UnderlineInputBorder(
            borderSide: BorderSide(color: enabledBorderColor),
          );
    final focusedBorder = focusedBorderColor == null
        ? null
        : UnderlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor),
          );
    final disabledBorder = disabledBorderColor == null
        ? null
        : UnderlineInputBorder(
            borderSide: BorderSide(color: disabledBorderColor),
          );
    final defaultTextStyle = textTheme?.bodyLarge ?? const TextStyle();
    return source.copyWith(
      labelText: source.labelText ?? label,
      hintText: source.hintText ?? hintText,
      prefixIcon: source.prefixIcon ?? prefix,
      suffixIcon: source.suffixIcon ?? suffix,
      isDense: source.isDense ?? true,
      filled: source.filled ?? !enabled,
      fillColor: source.fillColor ??
          (enabled ? token?.bgColorContainer : token?.bgColorComponentDisabled),
      contentPadding: source.contentPadding ??
          EdgeInsets.symmetric(
            horizontal: token?.spacer16 ?? 16,
            vertical: multiline ? 12 : 13,
          ),
      hintStyle: source.hintStyle ??
          defaultTextStyle.copyWith(color: token?.textColorPlaceholder),
      labelStyle: source.labelStyle ??
          defaultTextStyle.copyWith(color: token?.textColorPrimary),
      floatingLabelStyle: source.floatingLabelStyle ??
          defaultTextStyle.copyWith(color: token?.brandNormalColor),
      border: source.border ?? defaultBorder,
      enabledBorder: source.enabledBorder ?? defaultBorder,
      focusedBorder: source.focusedBorder ?? focusedBorder,
      disabledBorder: source.disabledBorder ?? disabledBorder,
    );
  }
}
