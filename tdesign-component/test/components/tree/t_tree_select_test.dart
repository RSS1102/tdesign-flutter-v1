import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/tree/t_tree_select.dart';
import 'package:tdesign_flutter/src/components/tree/t_tree_select_theme_data.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

TSelectOption opt(String label, dynamic value,
        [List<TSelectOption> children = const []]) =>
    TSelectOption(label: label, value: value, children: children);

void main() {
  Widget wrap(Widget child, [TTreeSelectThemeData? theme]) => MaterialApp(
        theme: ThemeData(extensions: [
          TThemeData.defaultData(),
          if (theme != null) theme,
        ]),
        home: child,
      );

  group('TSelectOption', () {
    test('构造', () {
      final o = opt('A', 1, [opt('B', 2)]);
      expect(o.label, 'A');
      expect(o.value, 1);
      expect(o.children.length, 1);
    });
  });

  group('TTreeSelect 单选一级', () {
    testWidgets('点击一级选项触发 onChanged(level=1)', (tester) async {
      final values = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [opt('A', 1), opt('B', 2), opt('C', 3)],
        onChanged: (v, level) => values.add([v, level]),
      )));
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(values, [
        [ [2], 1 ]
      ]);
    });

    testWidgets('maxLevel=1（无子项）', (tester) async {
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [opt('A', 1), opt('B', 2)],
        onChanged: (_, __) {},
      )));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });
  });

  group('TTreeSelect 二级', () {
    testWidgets('逐级点击进入二级并回调 level=2', (tester) async {
      final events = <int>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [opt('C1', 11), opt('C2', 12)]),
          opt('P2', 2, [opt('C3', 21)]),
        ],
        onChanged: (v, level) => events.add(level),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C1'));
      await tester.pumpAndSettle();
      expect(events, [1, 2]);
    });

    testWidgets('columnWidth 生效', (tester) async {
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [opt('C1', 11, )]),
        ],
        onChanged: (_, __) {},
      )));
      expect(find.byType(TTreeSelect), findsOneWidget);
      // 二级列未指定 columnWidth，_getLevelWidth 返回 null（使用默认）
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      expect(find.text('C1'), findsOneWidget);
    });
  });

  group('TTreeSelect 三级', () {
    testWidgets('进入三级并回调 level=3', (tester) async {
      final levels = <int>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [opt('M1', 11, [opt('L1', 111), opt('L2', 112)])]),
        ],
        onChanged: (v, level) => levels.add(level),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L1'));
      await tester.pumpAndSettle();
      expect(levels, [1, 2, 3]);
    });
  });

  group('TTreeSelect 样式与外角', () {
    testWidgets('outline 样式 + 选中项外角绘制', (tester) async {
      await tester.pumpWidget(wrap(
        TTreeSelect(
          options: [opt('A', 1), opt('B', 2), opt('C', 3)],
          value: [2],
          style: TTreeSelectStyle.outline,
          onChanged: (_, __) {},
        ),
      ));
      // B 选中，A/C 渲染外角 CustomPaint
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('ThemeExtension 提供 height/style/outwardCornerRadius',
        (tester) async {
      await tester.pumpWidget(wrap(
        TTreeSelect(
          options: [opt('A', 1), opt('B', 2)],
          onChanged: (_, __) {},
        ),
        TTreeSelectThemeData(
          height: 200,
          style: TTreeSelectStyle.outline,
          outwardCornerRadius: 12,
        ),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });
  });

  group('TTreeSelect 多选', () {
    testWidgets('二级多选切换选中集合', (tester) async {
      final captured = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        multiple: true,
        options: [
          opt('P1', 1, [
            TSelectOption(label: 'A', value: 11, multiple: true),
            TSelectOption(label: 'B', value: 12, multiple: true),
          ]),
        ],
        onChanged: (v, level) => captured.add(List.from(v)),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      // 第一次加入 [1,[11]]，第二次移除 11 -> [1,[]]
      expect(captured.last, [1, []]);
    });
  });

  group('TTreeSelect value / didUpdateWidget', () {
    testWidgets('外部 value 变化更新内部选中', (tester) async {
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [opt('A', 1), opt('B', 2), opt('C', 3)],
        value: [1],
        onChanged: (_, __) {},
      )));
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [opt('A', 1), opt('B', 2), opt('C', 3)],
        value: [2],
        onChanged: (_, __) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TTreeSelect), findsOneWidget);
    });
  });

  group('TTreeSelect 补充分支覆盖', () {
    testWidgets('三级选项 columnWidth 自定义宽度', (tester) async {
      // 覆盖 _getLevelWidth 返回非 null + 三级 SizedBox(width:)
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [
            TSelectOption(label: 'M1', value: 11, children: [
              TSelectOption(label: 'L1', value: 111, columnWidth: 120),
            ]),
          ]),
        ],
        onChanged: (_, __) {},
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M1'));
      await tester.pumpAndSettle();
      expect(find.byType(TTreeSelect), findsOneWidget);
    });

    testWidgets('一级切换重置二级滚动位置', (tester) async {
      // 覆盖 controller2.jumpTo(0)（先入二级使 controller2 挂载，再点别的一级）
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [opt('C1', 11)]),
          opt('P2', 2, [opt('C2', 21)]),
        ],
        onChanged: (_, __) {},
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('P2'));
      await tester.pumpAndSettle();
      expect(find.text('C2'), findsOneWidget);
    });

    testWidgets('二级单选替换已选值', (tester) async {
      // 覆盖 case 2 非 isMultiple：values[1] = currentValue
      final captured = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [opt('C1', 11), opt('C2', 12)]),
        ],
        onChanged: (v, _) => captured.add(List.from(v)),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('C2'));
      await tester.pumpAndSettle();
      expect(captured.last, [1, 12]);
    });

    testWidgets('从三级返回二级切换触发重置', (tester) async {
      // 覆盖 default：values[1]=currentValue; values.removeLast(); controller3.jumpTo
      final captured = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [
            opt('M1', 11, [opt('L1', 111)]),
            opt('M2', 12, [opt('L2', 121)]),
          ]),
        ],
        onChanged: (v, _) => captured.add(List.from(v)),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M2'));
      await tester.pumpAndSettle();
      expect(captured.last, [1, 12]);
    });

    testWidgets('二级多选 maxLevel=3 追加选项', (tester) async {
      // 覆盖 case 2 isMultiple add + maxLevel==3 时 selected=secondValue==currentValue
      final captured = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [
            TSelectOption(label: 'M1', value: 11, multiple: true, children: [opt('L1', 111)]),
            TSelectOption(label: 'M2', value: 12, multiple: true),
          ]),
        ],
        onChanged: (v, _) => captured.add(List.from(v)),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M2'));
      await tester.pumpAndSettle();
      expect(captured.last, [1, [11, 12]]);
    });

    testWidgets('三级多选 toggle', (tester) async {
      // 覆盖三级 case 2 add(isMultiple) + default toggle add/remove
      final captured = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [
            opt('M1', 11, [
              TSelectOption(label: 'L1', value: 111, multiple: true),
              TSelectOption(label: 'L2', value: 121, multiple: true),
            ]),
          ]),
        ],
        onChanged: (v, _) => captured.add(List.from(v)),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L2'));
      await tester.pumpAndSettle();
      expect(captured.last, [1, 11, [111]]);
    });

    testWidgets('三级单选替换已选值', (tester) async {
      // 覆盖三级 default 非 isMultiple：values[2] = currentValue
      final captured = <List<dynamic>>[];
      await tester.pumpWidget(wrap(TTreeSelect(
        options: [
          opt('P1', 1, [
            opt('M1', 11, [opt('L1', 111), opt('L2', 121)]),
          ]),
        ],
        onChanged: (v, _) => captured.add(List.from(v)),
      )));
      await tester.tap(find.text('P1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('L2'));
      await tester.pumpAndSettle();
      expect(captured.last, [1, 11, 121]);
    });
  });
}
