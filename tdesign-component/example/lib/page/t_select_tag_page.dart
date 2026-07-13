import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/example_widget.dart';

class TSelectTagPage extends StatefulWidget {
  const TSelectTagPage({Key? key}) : super(key: key);

  @override
  State<TSelectTagPage> createState() => _TSelectTagPageState();
}

class _TSelectTagPageState extends State<TSelectTagPage> {
  bool _selected1 = false;
  bool _selected2 = true;
  bool _selected3 = false;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'SelectTag 可选标签',
      desc: '用于选中/取消选中的标签组件',
      exampleCodeGroup: 'select-tag',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '默认形态', builder: _buildDefault),
          ExampleItem(desc: '不同语义色', builder: _buildColorSchemes),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
        ]),
      ],
    );
  }

  Widget _buildDefault(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        TSelectTag('标签一', value: _selected1, onChanged: (v) => setState(() => _selected1 = v)),
        TSelectTag('标签二', value: _selected2, onChanged: (v) => setState(() => _selected2 = v)),
        TSelectTag('标签三', value: _selected3, onChanged: (v) => setState(() => _selected3 = v)),
      ],
    );
  }

  Widget _buildColorSchemes(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        TSelectTag('主要', colorScheme: TTagColorScheme.primary, value: true, onChanged: (_) {}),
        TSelectTag('成功', colorScheme: TTagColorScheme.success, value: true, onChanged: (_) {}),
        TSelectTag('警告', colorScheme: TTagColorScheme.warning, value: true, onChanged: (_) {}),
        TSelectTag('危险', colorScheme: TTagColorScheme.danger, value: true, onChanged: (_) {}),
      ],
    );
  }

  Widget _buildDisabled(BuildContext context) {
    return const TSelectTag('禁用标签', value: false, onChanged: null);
  }
}
