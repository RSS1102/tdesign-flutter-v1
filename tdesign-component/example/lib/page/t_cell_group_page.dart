import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/example_widget.dart';

class TCellGroupPage extends StatefulWidget {
  const TCellGroupPage({Key? key}) : super(key: key);

  @override
  State<TCellGroupPage> createState() => _TCellGroupPageState();
}

class _TCellGroupPageState extends State<TCellGroupPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'CellGroup 单元格组',
      desc: '以组的形式管理多个单元格',
      exampleCodeGroup: 'cell-group',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '默认风格', builder: _buildDefault),
          ExampleItem(desc: '卡片风格', builder: _buildCard),
        ]),
      ],
    );
  }

  Widget _buildDefault(BuildContext context) {
    return TCellGroup(
      title: '标题',
      bordered: true,
      cells: [
        TCell(title: '单元格', subtitle: '描述信息'),
        TCell(title: '单元格', subtitle: '描述信息'),
        TCell(title: '单元格', arrow: true),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    return TCellGroup(
      title: '卡片风格',
      groupVariant: TCellGroupVariant.cardTheme,
      bordered: true,
      cells: [
        TCell(title: '单元格', subtitle: '描述信息'),
        TCell(title: '单元格', arrow: true),
      ],
    );
  }
}
