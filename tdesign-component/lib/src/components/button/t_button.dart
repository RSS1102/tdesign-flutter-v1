import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_button_resolve.dart';
import 't_button_theme_data.dart';

// ============ 枚举定义 ============

/// 按钮尺寸
enum TButtonSize { large, medium, small, extraSmall }

/// 按钮变体（fill / outline / text / ghost）
enum TButtonVariant { fill, outline, text, ghost }

/// 按钮配色方案
enum TButtonColorScheme { defaultTheme, primary, danger, light }

/// 图标位置
enum TButtonIconPosition { left, right }

// ============ TButton Widget ============

/// TD 常规按钮（V1.0）
///
/// Material 薄包装，`onPressed: null` 表示禁用。
///
/// **L1 三维正交**：
/// - [variant]：变体类型（fill / outline / text / ghost）
/// - [colorScheme]：配色方案（defaultTheme / primary / danger / light）
/// - shape：由 Theme [TButtonThemeData.shape] 控制
///
/// **示例**：
/// ```dart
/// // 基本用法
/// TButton(
///   child: Text('填充按钮'),
///   variant: TButtonVariant.fill,
///   colorScheme: TButtonColorScheme.primary,
///   onPressed: () {},
/// )
///
/// // 图标按钮
/// TButton(
///   icon: Icon(TIcons.app),
///   child: Text('按钮'),
///   onPressed: () {},
/// )
///
/// // 禁用
/// TButton(
///   child: Text('禁用'),
///   onPressed: null,
/// )
///
/// // 通栏（外包布局）
/// SizedBox(
///   width: double.infinity,
///   child: TButton(child: Text('通栏'), onPressed: () {}),
/// )
/// ```
class TButton extends StatefulWidget {
  const TButton({
    Key? key,
    this.child,
    this.size,
    this.variant,
    this.colorScheme,
    this.icon,
    this.iconPosition = TButtonIconPosition.left,
    this.onPressed,
    this.style,
  }) : super(key: key);

  /// 内容（纯文案用 `Text('...')`）
  final Widget? child;

  /// 尺寸，未传时使用 Theme [TButtonThemeData.defaultSize]
  final TButtonSize? size;

  /// 变体（fill / outline / text / ghost），未传时使用 Theme [TButtonThemeData.defaultVariant]
  final TButtonVariant? variant;

  /// 配色方案，未传时使用 Theme 默认解析
  final TButtonColorScheme? colorScheme;

  /// 图标（Widget 类型，IconData 需包裹为 `Icon(...)`）
  final Widget? icon;

  /// 图标位置
  final TButtonIconPosition iconPosition;

  /// 点击回调，`null` 表示禁用
  final VoidCallback? onPressed;

  /// P0 逃逸舱：[ButtonStyle] 覆盖所有 resolve 结果
  final ButtonStyle? style;

  @override
  State<TButton> createState() => _TButtonState();
}

class _TButtonState extends State<TButton> {
  @override
  Widget build(BuildContext context) {
    // 获取 Theme
    final theme = Theme.of(context).extension<TButtonThemeData>();
    final effectiveVariant = widget.variant ?? theme?.defaultVariant ?? TButtonVariant.fill;
    final effectiveSize = widget.size ?? theme?.defaultSize ?? TButtonSize.medium;
    final hasGradient = theme?.gradient != null;

    // 解析 ButtonStyle
    final resolvedStyle = TButtonResolve.resolve(
      variant: effectiveVariant,
      colorScheme: widget.colorScheme,
      size: effectiveSize,
      icon: widget.icon,
      iconPosition: widget.iconPosition,
      theme: theme,
      instanceStyle: widget.style,
      context: context,
      hasGradient: hasGradient,
    );

    // 构建带图标的内容
    final hasIcon = widget.icon != null;
    final hasChild = widget.child != null;
    final iconSpacing = theme?.iconSpacing ?? 8.0;
    final gradient = theme?.gradient;

    Widget? content;
    if (hasChild || hasIcon) {
      final children = <Widget>[];

      // 左侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.left) {
        children.add(_wrapIcon(widget.icon!, effectiveSize));
      }

      // 内容
      if (hasChild) {
        children.add(Flexible(child: widget.child!));
      }

      // 右侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.right) {
        children.add(_wrapIcon(widget.icon!, effectiveSize));
      }

      // 图标与文案间距
      if (children.length == 2) {
        children.insert(1, SizedBox(width: iconSpacing));
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    // 使用 ElevatedButton 作为底层（Flutter 3.16+ MaterialButton 已弃用）
    // 渐变模式：放弃 ElevatedButton，使用原生控件替代。
    //   Web 上 ElevatedButton(MaterialType.button) 即使设置 backgroundColor=Colors.transparent
    //   也会绘制不透明覆盖层，无法穿透显示底层渐变。
    Widget button;

    if (gradient != null) {
      // 渐变按钮：Material(type: transparency) + InkWell + Container(gradient)
      final shape = theme?.effectiveShape ?? TButtonShape.rectangle;
      final borderRadius = BorderRadius.all(Radius.circular(_borderRadiusForShape(shape)));

      // 从 resolvedStyle 获取前景色（用于文本/图标）
      final bool isDisabled = widget.onPressed == null;
      final Set<WidgetState> states = {if (isDisabled) WidgetState.disabled};
      final Color? fgColor = resolvedStyle.foregroundColor?.resolve(states);

      // 根据 size 计算 padding
      final EdgeInsets padding = _gradientPadding(effectiveSize, widget.icon != null, widget.child != null, shape);

      Widget? styledContent = content;
      if (styledContent != null && fgColor != null) {
        styledContent = IconTheme(
          data: IconThemeData(color: fgColor),
          child: DefaultTextStyle(
            style: TextStyle(color: fgColor, fontSize: _fontSizeForButton(effectiveSize)),
            child: styledContent,
          ),
        );
      }

      // 最小高度约束（对齐 ElevatedButton minimumSize）
      final double minHeight = _sideLengthForSize(effectiveSize);
      final bool isSquareOrCircle = shape == TButtonShape.square || shape == TButtonShape.circle;
      final bool onlyIcon = widget.icon != null && widget.child == null;
      final double? minWidth = (isSquareOrCircle && onlyIcon) ? minHeight : null;

      button = IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth ?? 0,
            minHeight: minHeight,
          ),
          child: Container(
            decoration: BoxDecoration(gradient: gradient, borderRadius: borderRadius),
            clipBehavior: Clip.antiAlias,
            child: Material(
              type: MaterialType.transparency,
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: widget.onPressed,
                child: Padding(
                  padding: padding,
                  child: styledContent,
                ),
              ),
            ),
          ),
        ),
      );

      if (theme?.margin != null) {
        button = Container(margin: theme!.margin, child: button);
      }
    } else {
      button = ElevatedButton(
        onPressed: widget.onPressed,
        style: resolvedStyle,
        child: content,
      );

      // margin 外包（非渐变）
      if (theme?.margin != null) {
        button = Container(margin: theme!.margin, child: button);
      }
    }

    return button;
  }

  /// 包裹图标，按 TButtonSize 设置默认尺寸
  Widget _wrapIcon(Widget iconWidget, TButtonSize effectiveSize) {
    if (iconWidget is Icon) {
      final icon = iconWidget;
      final useDefaultSize = icon.size == null;
      final useDefaultColor = icon.color == null;

      if (useDefaultSize || useDefaultColor) {
        final iconSize = _iconSizeForButton(effectiveSize);
        return Icon(
          icon.icon!,
          size: useDefaultSize ? iconSize : icon.size,
          color: useDefaultColor ? null : icon.color,
        );
      }
    }
    return iconWidget;
  }

  /// 根据 size 获取默认图标尺寸
  static double _iconSizeForButton(TButtonSize size) {
    switch (size) {
      case TButtonSize.large:
        return 24;
      case TButtonSize.medium:
        return 20;
      case TButtonSize.small:
        return 18;
      case TButtonSize.extraSmall:
        return 14;
    }
  }

  /// 根据 shape 获取渐变裁剪圆角值
  double _borderRadiusForShape(TButtonShape shape) {
    final tTheme = context.tTheme;
    return switch (shape) {
      TButtonShape.rectangle => tTheme.radiusDefault,
      TButtonShape.round => tTheme.radiusRound,
      TButtonShape.square || TButtonShape.filled || TButtonShape.circle => 0,
    };
  }

  /// 渐变模式下根据 size 计算 padding（与 _resolveSize 对齐）
  EdgeInsets _gradientPadding(TButtonSize size, bool hasIcon, bool hasChild, TButtonShape shape) {
    final isSquareOrCircle = shape == TButtonShape.square || shape == TButtonShape.circle;
    final onlyIcon = hasIcon && !hasChild;

    double padH;
    double padV;

    switch (size) {
      case TButtonSize.large:
        padH = onlyIcon ? 12 : 20;
        padV = onlyIcon ? 12 : 12;
      case TButtonSize.medium:
        padH = onlyIcon ? 10 : 16;
        padV = onlyIcon ? 10 : 8;
      case TButtonSize.small:
        padH = onlyIcon ? 7 : 12;
        padV = onlyIcon ? 7 : 5;
      case TButtonSize.extraSmall:
        padH = onlyIcon ? 5 : 8;
        padV = onlyIcon ? 5 : 3;
    }

    if (isSquareOrCircle && onlyIcon) {
      return EdgeInsets.all(padH);
    }
    return EdgeInsets.symmetric(horizontal: padH, vertical: padV);
  }

  /// 根据 size 获取默认字体大小
  double _fontSizeForButton(TButtonSize size) {
    return switch (size) {
      TButtonSize.large => 16,
      TButtonSize.medium => 14,
      TButtonSize.small => 12,
      TButtonSize.extraSmall => 10,
    };
  }

  /// 根据 size 获取按钮边长（对齐 _resolveSize 中的 sideLength）
  double _sideLengthForSize(TButtonSize size) {
    return switch (size) {
      TButtonSize.large => 48,
      TButtonSize.medium => 40,
      TButtonSize.small => 32,
      TButtonSize.extraSmall => 28,
    };
  }
}
