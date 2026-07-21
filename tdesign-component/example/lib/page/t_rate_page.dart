import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

/// TRate 演示。
class TRatePage extends StatefulWidget {
  const TRatePage({super.key});

  @override
  State<TRatePage> createState() => _TRatePageState();
}

class _TRatePageState extends State<TRatePage> {
  double _basicValue = 3;
  double _halfValue = 2.5;
  double _customValue = 2;
  double _textValue = 3;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于对某行为或事物进行评分。',
      exampleCodeGroup: 'rate',
      children: [
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '基础评分', builder: _buildBasicRate),
          ExampleItem(desc: '半星评分', builder: _buildHalfRate),
          ExampleItem(desc: '自定义图标', builder: _buildCustomRate),
          ExampleItem(desc: '评分文案', builder: _buildTextRate),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '禁用状态', builder: _buildDisabledRate),
          ExampleItem(desc: '主题定制', builder: _buildThemedRate),
        ]),
      ],
    );
  }

  @Demo(group: 'rate')
  Widget _buildBasicRate(BuildContext context) {
    return _RateDemoRow(
      title: '基础评分',
      child: TRate(
        value: _basicValue,
        onChanged: (value) => setState(() => _basicValue = value),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildHalfRate(BuildContext context) {
    return _RateDemoRow(
      title: '半星评分',
      child: TRate(
        value: _halfValue,
        allowHalf: true,
        onChanged: (value) => setState(() => _halfValue = value),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildCustomRate(BuildContext context) {
    return _RateDemoRow(
      title: '自定义图标',
      child: TRate(
        value: _customValue,
        icon: (filled) => Icon(
          filled ? Icons.favorite : Icons.favorite_border,
          color: filled ? Colors.red : context.tTheme.bgColorComponent,
        ),
        onChanged: (value) => setState(() => _customValue = value),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildTextRate(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TRateThemeData(showText: true, textWidth: 64),
      ),
      child: _RateDemoRow(
        title: '评分文案',
        child: TRate(
          value: _textValue,
          texts: const ['很差', '较差', '一般', '满意', '惊喜'],
          onChanged: (value) => setState(() => _textValue = value),
        ),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildDisabledRate(BuildContext context) {
    return const _RateDemoRow(
      title: '禁用状态',
      child: TRate(value: 3),
    );
  }

  @Demo(group: 'rate')
  Widget _buildThemedRate(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TRateThemeData(
          starColor: Colors.green,
          inactiveStarColor: Color(0xFFDCDCDC),
          iconSize: 30,
          iconGap: 4,
        ),
      ),
      child: const _RateDemoRow(
        title: '主题定制',
        child: TRate(value: 4),
      ),
    );
  }
}

class _RateDemoRow extends StatelessWidget {
  const _RateDemoRow({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(token.spacer16),
      color: token.bgColorContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: token.textColorPrimary,
              fontSize: token.fontBodyLarge?.size,
            ),
          ),
          SizedBox(height: token.spacer12),
          child,
        ],
      ),
    );
  }
}
