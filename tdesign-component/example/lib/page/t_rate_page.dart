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
    return TCell(
      title: const Text('基础评分'),
      note: TRate(
        value: _basicValue,
        onChanged: (value) => setState(() => _basicValue = value),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildHalfRate(BuildContext context) {
    return TCell(
      title: const Text('半星评分'),
      note: TRate(
        value: _halfValue,
        allowHalf: true,
        onChanged: (value) => setState(() => _halfValue = value),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildCustomRate(BuildContext context) {
    return TCell(
      title: const Text('自定义图标'),
      note: TRate(
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
      child: TCell(
        title: const Text('评分文案'),
        note: TRate(
          value: _textValue,
          texts: const ['很差', '较差', '一般', '满意', '惊喜'],
          onChanged: (value) => setState(() => _textValue = value),
        ),
      ),
    );
  }

  @Demo(group: 'rate')
  Widget _buildDisabledRate(BuildContext context) {
    return const TCell(
      title: Text('禁用状态'),
      note: TRate(value: 3),
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
      child: const TCell(
        title: Text('主题定制'),
        note: TRate(value: 4),
      ),
    );
  }
}
