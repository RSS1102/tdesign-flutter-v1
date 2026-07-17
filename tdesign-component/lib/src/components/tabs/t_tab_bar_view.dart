import 'package:flutter/material.dart';

import 't_tab_bar_theme_data.dart';

/// TabBarView 组件 v1.0
///
/// Material TabBarView 薄包装。
/// `physics` 可覆盖 Theme 默认值（默认 `NeverScrollableScrollPhysics`）。
class TTabsBarView extends StatefulWidget {
  /// 子widget列表
  final List<Widget> children;

  /// 控制器
  final TabController? controller;

  /// 滑动物理特性；未传时取 Theme `defaultPhysics`，Theme 也未配时默认不可滑动
  final ScrollPhysics? physics;

  const TTabsBarView({
    Key? key,
    required this.children,
    this.controller,
    this.physics,
  }) : super(key: key);

  @override
  State<TTabsBarView> createState() => _TTabsBarViewState();
}

class _TTabsBarViewState extends State<TTabsBarView> {
  TTabsBarThemeData get _themeData =>
      Theme.of(context).extension<TTabsBarThemeData>() ??
      const TTabsBarThemeData();

  ScrollPhysics get _effectivePhysics =>
      widget.physics ??
      _themeData.defaultPhysics ??
      const NeverScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: _effectivePhysics,
      controller: widget.controller,
      children: widget.children,
    );
  }
}
