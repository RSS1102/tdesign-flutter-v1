import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/cascader/t_multi_cascader.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

final data = [
  {
    'label': 'A',
    'value': 'a',
    'segmentValue': 'A',
    'children': [
      {'label': 'A1', 'value': 'a1'},
      {'label': 'A2', 'value': 'a2'},
    ],
  },
  {
    'label': 'B',
    'value': 'b',
    'segmentValue': 'B',
  },
];

Widget wrap(Widget child) => MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: child,
    );

void main() {
  group('MultiCascaderListModel', () {
    test('label 经 labelFun 解析', () {
      final m = MultiCascaderListModel(
        labelFun: () => 'hello',
        value: 'v',
        parentValue: 'p',
        level: 0,
        segmentValue: 's',
      );
      expect(m.label, 'hello');
      expect(m.value, 'v');
      expect(m.parentValue, 'p');
      expect(m.level, 0);
      expect(m.segmentValue, 's');
    });

    test('labelFun 为空时 label 为 null', () {
      final m = MultiCascaderListModel();
      expect(m.label, isNull);
    });
  });

  group('LeftLineWidget', () {
    testWidgets('渲染', (tester) async {
      await tester.pumpWidget(wrap(const LeftLineWidget(
        isCircleFill: true,
        isShowTopLine: true,
      )));
      expect(find.byType(LeftLineWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('TMultiCascader 渲染', () {
    testWidgets('默认 step 主题渲染', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      // 一级选项 A / B 可见（每项同时渲染 label 与 segmentValue）
      expect(find.text('A'), findsWidgets);
      expect(find.text('B'), findsWidgets);
    });

    testWidgets('tab 主题渲染', (tester) async {
      await tester.pumpWidget(DefaultTabController(
        length: 2,
        child: wrap(TMultiCascader(
          theme: 'tab',
          data: data,
          cascaderHeight: 300,
          onChanged: (_) {},
        )),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
    });

    testWidgets('subTitles 显示', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        data: data,
        cascaderHeight: 300,
        subTitles: const ['一级', '二级'],
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('一级'), findsWidgets);
    });

    testWidgets('isLetterSort 触发排序', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        isLetterSort: true,
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
    });

    testWidgets('title / closeText 渲染', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        title: '选择',
        closeText: '关闭',
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('选择'), findsOneWidget);
      expect(find.text('关闭'), findsOneWidget);
    });

    testWidgets('action 自定义右上角按钮', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(wrap(TMultiCascader(
        action: TCascaderAction(
          text: '确定',
          onConfirm: (_) {
            confirmed = true;
          },
        ),
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsOneWidget);
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, true);
    });

    testWidgets('initialData 定位初始选中（进入对应 tab）', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        initialData: 'a',
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      // initialData 仅定位 tab 高亮，内容区仍为一级 A/B
      expect(find.text('A'), findsWidgets);
      expect(find.text('B'), findsWidgets);
    });

    testWidgets('initialIndexes 定位初始选中', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        initialIndexes: const [0],
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('A'), findsWidgets);
      expect(find.text('B'), findsWidgets);
    });
  });

  group('TMultiCascader 交互', () {
    testWidgets('点击一级（含子项）展开二级', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        data: data,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      expect(find.text('A1'), findsOneWidget);
      expect(find.text('A2'), findsOneWidget);
    });

    testWidgets('点击叶子触发 onChanged（二级路由避免 pop 崩溃）',
        (tester) async {
      final selected = <MultiCascaderListModel>[];
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(
              builder: (_) => TMultiCascader(
                data: data,
                cascaderHeight: 300,
                onChanged: (v) => selected.addAll(v),
              ),
            )),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B').last);
      await tester.pumpAndSettle();
      expect(selected, isNotEmpty);
    });

    testWidgets('点击关闭按钮触发 onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(wrap(TMultiCascader(
        closeText: '关闭',
        data: data,
        cascaderHeight: 300,
        onClose: () => closed = true,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('关闭'));
      await tester.pumpAndSettle();
      expect(closed, true);
    });
  });

  group('TMultiCascader 导航覆盖', () {
    final data3 = [
      {
        'label': 'A',
        'value': 'a',
        'segmentValue': 'A',
        'children': [
          {
            'label': 'A1',
            'value': 'a1',
            'segmentValue': 'A1',
            'children': [
              {'label': 'A1a', 'value': 'a1a', 'segmentValue': 'A1a'},
            ],
          },
          {'label': 'A2', 'value': 'a2', 'segmentValue': 'A2'},
        ],
      },
      {
        'label': 'B',
        'value': 'b',
        'segmentValue': 'B',
      },
    ];

    testWidgets('三级数据递归构建 + 逐级展开覆盖 onTap/removeAt',
        (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        data: data3,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      // 展开到二级
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      expect(find.text('A1'), findsWidgets);
      expect(find.text('A2'), findsWidgets);
      // 展开到三级（点击 A1，覆盖 removeAt 同层 tab）
      await tester.tap(find.text('A1').first);
      await tester.pumpAndSettle();
      expect(find.text('A1a'), findsWidgets);
    });

    testWidgets('点击 tab 切换层级覆盖 _tabListChange 与 _getFindListData',
        (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        data: data3,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('A1').first);
      await tester.pumpAndSettle();
      // 点击末位 tab 'A1'（index 2）→ _tabListChange else + _getFindListData parentValue
      await tester.tap(find.text('A1'));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      // 点击中间 tab 'A'（index 1）→ _tabListChange if + _getFindListData value
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      // 回到二级内容后，点击内容项 'A1'（此时已存在同层 tab）→ 覆盖 removeAt 分支
      await tester.tap(find.text('A1').first);
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
    });

    testWidgets('subTitles 下点击更新层级(_level)', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        data: data3,
        cascaderHeight: 300,
        subTitles: const ['一级', '二级', '三级'],
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('A1').first);
      await tester.pumpAndSettle();
      expect(find.text('A1a'), findsWidgets);
    });

    testWidgets('initialData 为子节点值触发 _initLocation 递归', (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        initialData: 'a1',
        data: data3,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      // tab 应显示 A1（及 A）
      expect(find.text('A1'), findsWidgets);
    });

    testWidgets('initialIndexes 深层定位触发 _getValueByIndexes 递归',
        (tester) async {
      await tester.pumpWidget(wrap(TMultiCascader(
        initialIndexes: const [0, 0],
        data: data3,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('A1'), findsWidgets);
    });

    testWidgets('isLetterSort 乱序 segmentValue 强制比较', (tester) async {
      final sortData = [
        {'label': 'X', 'value': 'x', 'segmentValue': 'Z'},
        {'label': 'Y', 'value': 'y', 'segmentValue': 'A'},
      ];
      await tester.pumpWidget(wrap(TMultiCascader(
        isLetterSort: true,
        data: sortData,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
    });
  });
}
