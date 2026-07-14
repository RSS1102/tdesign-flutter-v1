import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_horizontal_tab_bar.dart';

/// 标签栏
///
/// 支持滚动、指示器自定义、胶囊/填充/卡片样式等。
class TTabBar extends StatefulWidget {
  const TTabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.decoration,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorWidth,
    this.indicatorHeight,
    this.labelColor,
    this.unselectedLabelColor,
    this.isScrollable = false,
    this.unselectedLabelStyle,
    this.labelStyle,
    this.width,
    this.height,
    this.indicatorPadding,
    this.labelPadding,
    this.indicator,
    this.physics,
    this.onTap,
    this.variant = TTabBarVariant.filled,
    this.showIndicator = false,
    this.dividerColor,
    this.dividerHeight = 0.5,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.tabAlignment,
  })  : assert(
          backgroundColor == null || decoration == null,
          'Cannot provide both a backgroundColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        super(key: key);

  /// tab数组
  final List<TTab> tabs;

  /// tab控制器
  final TabController? controller;

  /// tabBar修饰（可覆盖 Theme）
  final Decoration? decoration;

  /// tabBar背景色，当 variant 为 card 时控制选中tab颜色（可覆盖 Theme）
  final Color? backgroundColor;

  /// tabBar下标颜色（可覆盖 Theme）
  final Color? indicatorColor;

  /// tabBar下标高度（可覆盖 Theme）
  final double? indicatorHeight;

  /// tabBar下标宽度（可覆盖 Theme）
  final double? indicatorWidth;

  /// tabBar 已选标签颜色（可覆盖 Theme）
  final Color? labelColor;

  /// tabBar未选标签颜色（可覆盖 Theme）
  final Color? unselectedLabelColor;

  /// 是否滚动（可覆盖 Theme）
  final bool isScrollable;

  /// 已选label字体（可覆盖 Theme）
  final TextStyle? labelStyle;

  /// unselectedLabel字体（可覆盖 Theme）
  final TextStyle? unselectedLabelStyle;

  /// tabBar宽度
  final double? width;

  /// tabBar高度（可覆盖 Theme）
  final double? height;

  /// 引导padding（可覆盖 Theme）
  final EdgeInsets? indicatorPadding;

  /// 自定义引导控件（可覆盖 Theme）
  final Decoration? indicator;

  /// 是否展示引导控件（可覆盖 Theme）
  final bool showIndicator;

  /// 自定义滑动（可覆盖 Theme）
  final ScrollPhysics? physics;

  /// 点击事件
  final Function(int)? onTap;

  /// tab间距（可覆盖 Theme）
  final EdgeInsetsGeometry? labelPadding;

  /// 选项卡样式（可覆盖 Theme）
  final TTabBarVariant variant;

  /// 分割线颜色（可覆盖 Theme）
  final Color? dividerColor;

  /// 分割线高度，小于等于0则不展示分割线（可覆盖 Theme）
  final double dividerHeight;

  /// 被选中背景色，只有 variant 为 capsule 时有效（可覆盖 Theme）
  final Color? selectedBgColor;

  /// 未选中背景色，只有 variant 为 capsule 时有效（可覆盖 Theme）
  final Color? unSelectedBgColor;

  /// Tab 对齐方式
  final TabAlignment? tabAlignment;

  @override
  State<StatefulWidget> createState() => _TTabBarState();
}

class _TTabBarState extends State<TTabBar> {
  /// 默认高度
  static const double _defaultHeight = 48;

  TTabBarThemeData get _themeData =>
      Theme.of(context).extension<TTabBarThemeData>() ??
      const TTabBarThemeData();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? _themeData.height ?? _defaultHeight,
      decoration: widget.decoration ??
          _themeData.decoration ??
          (widget.variant == TTabBarVariant.card
              ? BoxDecoration(
                  color: widget.backgroundColor ??
                      _themeData.backgroundColor ??
                      context.tTheme.bgColorContainer)
              : BoxDecoration(
                  color: widget.backgroundColor ??
                      _themeData.backgroundColor ??
                      context.tTheme.bgColorContainer,
                  border: widget.dividerHeight <= 0
                      ? null
                      : Border(
                          bottom: BorderSide(
                              color: widget.dividerColor ??
                                  _themeData.dividerColor ??
                                  context.tTheme.componentStrokeColor,
                              width: widget.dividerHeight)))),
      child: THorizontalTabBar(
        physics: widget.physics ?? _themeData.physics,
        isScrollable: widget.isScrollable,
        indicator: widget.indicator ?? _getIndicator(),
        indicatorColor: widget.indicatorColor ?? _themeData.indicatorColor,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? _themeData.unselectedLabelColor,
        labelColor: widget.labelColor ??
            _themeData.labelColor ??
            context.tTheme.brandNormalColor,
        labelStyle: widget.labelStyle ?? _getLabelStyle(),
        labelPadding: widget.labelPadding ??
            _themeData.labelPadding ??
            const EdgeInsets.all(8),
        unselectedLabelStyle: widget.unselectedLabelStyle ??
            _themeData.unselectedLabelStyle ??
            _getUnSelectLabelStyle(),
        tabs: widget.tabs,
        indicatorPadding: widget.indicatorPadding ??
            _themeData.indicatorPadding ??
            EdgeInsets.zero,
        outlineType: widget.variant,
        controller: widget.controller,
        backgroundColor: widget.backgroundColor ?? _themeData.backgroundColor,
        selectedBgColor: widget.selectedBgColor ?? _themeData.selectedBgColor,
        unSelectedBgColor: widget.unSelectedBgColor ??
            _themeData.unSelectedBgColor ??
            context.tTheme.bgColorSecondaryContainer,
        tabAlignment: widget.tabAlignment ?? _themeData.tabAlignment,
        onTap: (index) {
          widget.onTap?.call(index);
        },
      ),
    );
  }

  TextStyle _getUnSelectLabelStyle() {
    return TextStyle(
        fontWeight: FontWeight.w400, color: context.tTheme.textColorPrimary);
  }

  TextStyle _getLabelStyle() {
    return TextStyle(
        fontWeight: FontWeight.w600, color: context.tTheme.textColorPrimary);
  }

  Decoration _getIndicator() {
    return widget.showIndicator
        ? TTabBarIndicator(
            context: context,
            indicatorHeight: widget.indicatorHeight,
            indicatorWidth: widget.indicatorWidth,
            indicatorColor: widget.indicatorColor,
          )
        : TNoneIndicator();
  }
}

/// TDesign自定义下标
class TTabBarIndicator extends Decoration {
  /// 上下文（用于读取主题色）
  final BuildContext? context;

  /// 指示器宽度
  final double? indicatorWidth;

  /// 指示器高度
  final double? indicatorHeight;

  /// 指示器颜色
  final Color? indicatorColor;

  const TTabBarIndicator({
    this.context,
    this.indicatorWidth,
    this.indicatorHeight,
    this.indicatorColor,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TTabBarIndicatorPainter(this, onChanged);
}

class _TTabBarIndicatorPainter extends BoxPainter {
  static const double _defaultIndicatorWidth = 16;
  static const double _defaultIndicatorHeight = 3;

  final TTabBarIndicator decoration;
  final _paint = Paint();

  _TTabBarIndicatorPainter(this.decoration, VoidCallback? onChanged) {
    _paint.color = decoration.indicatorColor ??
        decoration.context!.tTheme.brandNormalColor;
    _paint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
        Offset(offset.dx + (configuration.size!.width - _indicatorWidth()) / 2,
            configuration.size!.height - _indicatorHeight() / 2),
        Offset(offset.dx + (configuration.size!.width + _indicatorWidth()) / 2,
            configuration.size!.height - _indicatorHeight() / 2),
        _paint..strokeWidth = _indicatorHeight());
  }

  double _indicatorHeight() =>
      decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() =>
      decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

/// 垂直方向指示器
class TTabBarVerticalIndicator extends Decoration {
  /// 上下文（用于读取主题色）
  final BuildContext? context;

  /// 指示器宽度
  final double? indicatorWidth;

  /// 指示器高度
  final double? indicatorHeight;

  const TTabBarVerticalIndicator({
    this.context,
    this.indicatorWidth,
    this.indicatorHeight,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TTabBarVerticalIndicatorPainter(this, onChanged);
}

class _TTabBarVerticalIndicatorPainter extends BoxPainter {
  static const double _defaultIndicatorWidth = 1.5;
  static const double _defaultIndicatorHeight = 54;

  final TTabBarVerticalIndicator decoration;
  final _paint = Paint();

  _TTabBarVerticalIndicatorPainter(this.decoration, VoidCallback? onChanged) {
    _paint.color = decoration.context!.tTheme.brandNormalColor;
    _paint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
        Offset(
          0 + _indicatorWidth() / 2,
          offset.dx + (configuration.size!.width - _indicatorHeight()) / 2,
        ),
        Offset(
          0 + _indicatorWidth() / 2,
          offset.dx + (configuration.size!.width + _indicatorHeight()) / 2,
        ),
        _paint..strokeWidth = _indicatorWidth());
  }

  double _indicatorHeight() =>
      decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() =>
      decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

/// 空指示器（不渲染任何内容）
class TNoneIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TNoneIndicatorPainter();
}

class _TNoneIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
