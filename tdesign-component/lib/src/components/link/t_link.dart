import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_link_resolve.dart';

/// 链接形态
enum TLinkVariant {
  /// 纯文本链接
  basic,

  /// 下划线链接
  underline,

  /// 带图标链接（通过 prefixIcon / suffixIcon 区分前后）
  icon,
}

/// 语义颜色方案（对齐 Button colorScheme）
enum TLinkColorScheme {
  primary,
  defaultTheme,
  danger,
  warning,
  success,
}

/// 链接尺寸
enum TLinkSize {
  small,
  medium,
  large,
}

/// 文字超链接用于跳转一个新页面，如当前项目跳转、友情链接等。
///
/// 基于 Material [InkWell] + [Text] 薄包装。
class TLink extends StatelessWidget {
  const TLink({
    Key? key,
    this.child,
    this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = TLinkVariant.basic,
    this.colorScheme,
    this.size = TLinkSize.medium,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
  }) : super(key: key);

  /// 链接内容，一般是 [Text]
  final Widget? child;

  /// 跳转 URI
  final Uri? uri;

  /// 链接形态
  final TLinkVariant variant;

  /// 语义颜色方案
  final TLinkColorScheme? colorScheme;

  /// 尺寸
  final TLinkSize size;

  /// 前置图标（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  final Widget? prefixIcon;

  /// 后置图标（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  final Widget? suffixIcon;

  /// 点击回调。为 null 时链接为禁用态
  final VoidCallback? onPressed;

  /// 语义标签（无障碍）
  final String? semanticLabel;

  /// 悬浮提示
  final String? tooltip;

  /// 是否禁用
  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme(context);
    final isDisabled = _isDisabled;

    // resolve 颜色
    final effectiveColor = TLinkResolve.resolveColor(
      context: context,
      colorScheme: colorScheme ?? theme?.defaultColorScheme,
      theme: theme,
      isDisabled: isDisabled,
    );

    // 构建链接文本
    final text = _buildLinkText(
      context: context,
      theme: theme,
      effectiveColor: effectiveColor,
    );

    // 带图标时组装 Row
    if (variant == TLinkVariant.icon) {
      return _buildIconRow(context, text, effectiveColor, theme);
    }

    // 纯文本 / 下划线：直接返回 InkWell 包裹的文本
    final Widget link = InkWell(
      onTap: onPressed,
      child: text,
    );

    if (isDisabled) {
      return IgnorePointer(child: link);
    }
    return link;
  }

  /// 构建链接文本（含下划线样式）
  Widget _buildLinkText({
    required BuildContext context,
    required TLinkThemeData? theme,
    required Color effectiveColor,
  }) {
    final effectiveFontSize = TLinkResolve.resolveFontSize(
      size: size,
      theme: theme,
    );

    final hasUnderline = variant == TLinkVariant.underline;

    final defaultChild = child ?? const SizedBox.shrink();

    // 如果 child 是纯文本 Text（data 非空），重新构建以注入样式
    if (defaultChild is Text && defaultChild.data != null) {
      return Text(
        defaultChild.data!,
        style: defaultChild.style?.copyWith(
              fontSize: effectiveFontSize,
              color: effectiveColor,
              decoration: hasUnderline ? TextDecoration.underline : null,
              decorationColor: hasUnderline ? effectiveColor : null,
            ) ??
            TextStyle(
              fontSize: effectiveFontSize,
              color: effectiveColor,
              decoration: hasUnderline ? TextDecoration.underline : null,
              decorationColor: hasUnderline ? effectiveColor : null,
            ),
        semanticsLabel: semanticLabel ?? defaultChild.semanticsLabel,
      );
    }

    // Text.rich 或其他 Widget：用 DefaultTextStyle 包裹注入样式
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: effectiveFontSize,
        color: effectiveColor,
        decoration: hasUnderline ? TextDecoration.underline : null,
        decorationColor: hasUnderline ? effectiveColor : null,
      ),
      child: defaultChild,
    );
  }

  /// 带图标时组装 Row
  Widget _buildIconRow(
    BuildContext context,
    Widget text,
    Color effectiveColor,
    TLinkThemeData? theme,
  ) {
    final (leftGap, rightGap) = TLinkResolve.resolveGap(
      size: size,
      theme: theme,
    );

    final effectiveIconSize = TLinkResolve.resolveIconSize(
      size: size,
      theme: theme,
    );

    // 构建图标（优先用户传入，否则使用默认图标）
    Widget? resolvedPrefix;
    Widget? resolvedSuffix;

    final hasPrefix = prefixIcon != null;
    final hasSuffix = suffixIcon != null;

    if (hasPrefix) {
      resolvedPrefix = prefixIcon;
    } else if (hasSuffix) {
      // 只有 suffix 时，prefix 使用默认链接图标
      resolvedPrefix = _defaultIcon(context, TIcons.link, effectiveIconSize,
          effectiveColor);
    } else {
      // 两者都没传：默认显示链接图标 + 跳转图标
      resolvedPrefix = _defaultIcon(context, TIcons.link, effectiveIconSize,
          effectiveColor);
      resolvedSuffix = _defaultIcon(context, TIcons.jump, effectiveIconSize,
          effectiveColor);
    }

    resolvedSuffix ??= suffixIcon;

    final rowChildren = <Widget>[];
    if (resolvedPrefix != null) {
      rowChildren.add(resolvedPrefix);
      rowChildren.add(SizedBox(width: leftGap));
    }
    rowChildren.add(Flexible(child: text));
    if (resolvedSuffix != null) {
      rowChildren.add(SizedBox(width: rightGap));
      rowChildren.add(resolvedSuffix);
    }

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: rowChildren,
    );

    final wrapped = tooltip != null
        ? Tooltip(message: tooltip!, child: row)
        : row;

    if (_isDisabled) {
      return IgnorePointer(child: wrapped);
    }

    return InkWell(
      onTap: onPressed,
      child: wrapped,
    );
  }

  /// 构建默认图标
  Widget _defaultIcon(BuildContext context, IconData icon, double size,
      Color color) {
    return Icon(icon, size: size, color: color);
  }

  /// 获取当前上下文中的 TLinkThemeData
  TLinkThemeData? _resolveTheme(BuildContext context) {
    return Theme.of(context).extension<TLinkThemeData>();
  }
}

/// 存储可以自定义 TLink 跳转算法的控件（保留 v0.2.x 兼容）
///
/// 用法：
/// ```dart
/// TLinkConfiguration(
///   onTapAll: (uri) { /* 统一处理所有链接跳转 */ },
///   child: MaterialApp(...),
/// )
/// ```
class TLinkConfiguration extends InheritedWidget {
  /// 统一跳转回调
  final void Function(Uri? uri)? onTapAll;

  const TLinkConfiguration({
    Key? key,
    required Widget child,
    this.onTapAll,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant TLinkConfiguration oldWidget) {
    return onTapAll != oldWidget.onTapAll;
  }
}
