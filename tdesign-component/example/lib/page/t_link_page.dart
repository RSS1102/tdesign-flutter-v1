import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TLinkViewPage extends StatefulWidget {
  const TLinkViewPage({super.key});

  @override
  State<TLinkViewPage> createState() => _TLinkViewPageState();
}

class _TLinkViewPageState extends State<TLinkViewPage> {
  void _onLinkPressed() {
    TToast.showText('点击了链接', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '文字超链接用于跳转一个新页面，如当前项目跳转，友情链接等。',
      exampleCodeGroup: 'link',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '链接类型', builder: _buildVariantLinks),
          ExampleItem(desc: '图标链接', builder: _buildIconLinks),
        ]),
        ExampleModule(title: '状态与主题色', children: [
          ExampleItem(desc: '语义色', builder: _buildColorSchemeLinks),
          ExampleItem(desc: '禁用态', builder: _buildDisabledLinks),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '链接尺寸', builder: _buildLinkSizes),
        ]),
      ],
    );
  }

  @Demo(group: 'link')
  Widget _buildVariantLinks(BuildContext context) {
    return _surface(
      context,
      _linkWrap([
        _buildLink(label: '基础链接', variant: TLinkVariant.basic),
        _buildLink(label: '下划线链接', variant: TLinkVariant.underline),
        _buildLink(label: '默认图标', variant: TLinkVariant.icon),
      ]),
    );
  }

  @Demo(group: 'link')
  Widget _buildColorSchemeLinks(BuildContext context) {
    return _surface(
      context,
      _linkWrap([
        for (final scheme in TLinkColorScheme.values)
          _buildLink(
            label: '${_labelForColorScheme(scheme)}链接',
            colorScheme: scheme,
          ),
      ]),
    );
  }

  @Demo(group: 'link')
  Widget _buildDisabledLinks(BuildContext context) {
    return _surface(
      context,
      _linkWrap([
        _buildLink(label: '基础禁用', disabled: true),
        _buildLink(
          label: '下划线禁用',
          variant: TLinkVariant.underline,
          disabled: true,
        ),
        _buildLink(
          label: '图标禁用',
          variant: TLinkVariant.icon,
          disabled: true,
        ),
      ]),
    );
  }

  @Demo(group: 'link')
  Widget _buildIconLinks(BuildContext context) {
    return _surface(
      context,
      _linkWrap([
        _buildLink(label: '默认图标', variant: TLinkVariant.icon),
        _buildLink(
          label: '前置图标',
          variant: TLinkVariant.icon,
          prefixIcon: const Icon(TIcons.link),
        ),
        _buildLink(
          label: '后置图标',
          variant: TLinkVariant.icon,
          suffixIcon: const Icon(TIcons.jump),
        ),
      ]),
    );
  }

  @Demo(group: 'link')
  Widget _buildLinkSizes(BuildContext context) {
    return _surface(
      context,
      _linkWrap([
        _buildLink(
            label: '小号链接', variant: TLinkVariant.icon, size: TLinkSize.small),
        _buildLink(label: '中号链接', variant: TLinkVariant.icon),
        _buildLink(
            label: '大号链接', variant: TLinkVariant.icon, size: TLinkSize.large),
      ]),
    );
  }

  Widget _surface(BuildContext context, Widget child) {
    return Container(
      width: double.infinity,
      color: context.tTheme.bgColorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: child,
    );
  }

  Widget _linkWrap(List<Widget> children) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  TLink _buildLink({
    required String label,
    TLinkVariant variant = TLinkVariant.basic,
    TLinkColorScheme colorScheme = TLinkColorScheme.primary,
    TLinkSize size = TLinkSize.medium,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return TLink(
      child: Text(label),
      colorScheme: colorScheme,
      variant: variant,
      size: size,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onPressed: disabled ? null : _onLinkPressed,
    );
  }

  String _labelForColorScheme(TLinkColorScheme colorScheme) {
    return switch (colorScheme) {
      TLinkColorScheme.primary => '品牌',
      TLinkColorScheme.defaultTheme => '默认',
      TLinkColorScheme.danger => '危险',
      TLinkColorScheme.warning => '警告',
      TLinkColorScheme.success => '成功',
    };
  }
}
