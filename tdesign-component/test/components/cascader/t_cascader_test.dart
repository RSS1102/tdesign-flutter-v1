import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCascader / TMultiCascader V1.0 Widget 测试
///
/// 覆盖：默认 step 主题渲染、tab 主题（TCustomTab）、标题/副标题/关闭文案、
/// 字母排序、initialData/initialIndexes 定位、点击展开下一级、点击叶子触发
/// onChanged 并关闭、关闭按钮（action / onClose 分支）、showMultiCascader 弹窗。
void main() {
  /// 用 TTheme 包裹以提供基础 Token 与默认文案资源
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  /// 两级联数据：广东省(gd) -> 深圳市(sz)/广州市(gz)，以及 北京(bj)
  final testData = <Map<String, dynamic>>[
    <String, dynamic>{
      'label': '广东省',
      'value': 'gd',
      'children': <Map<String, dynamic>>[
        <String, dynamic>{'label': '深圳市', 'value': 'sz'},
        <String, dynamic>{'label': '广州市', 'value': 'gz'},
      ],
    },
    <String, dynamic>{'label': '北京', 'value': 'bj'},
  ];

  group('TMultiCascader 渲染', () {
    testWidgets('默认 step 主题 + 标题正常渲染列表', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      // 一级列表项
      expect(find.text('广东省'), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);
    });

    testWidgets('title 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        title: '请选择地区',
        data: testData,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('请选择地区'), findsOneWidget);
    });

    testWidgets('theme=tab 时使用 TCustomTab', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        theme: 'tab',
        data: testData,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      expect(find.byType(TCustomTab), findsOneWidget);
    });

    testWidgets('subTitles 渲染副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        subTitles: const ['请选择省份', '请选择城市'],
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('请选择省份'), findsOneWidget);
    });

    testWidgets('closeText 渲染自定义关闭文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        closeText: '关闭',
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.text('关闭'), findsOneWidget);
    });

    testWidgets('isLetterSort 带 segmentValue 排序渲染', (tester) async {
      final sortedData = <Map<String, dynamic>>[
        <String, dynamic>{
          'label': '北京',
          'value': 'bj',
          'segmentValue': 'B',
        },
        <String, dynamic>{
          'label': '广东',
          'value': 'gd',
          'segmentValue': 'G',
          'children': <Map<String, dynamic>>[
            <String, dynamic>{'label': '深圳', 'value': 'sz'}
          ],
        },
      ];
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: sortedData,
        isLetterSort: true,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);
    });

    testWidgets('initialData 定位到已有值不抛异常', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        initialData: 'gd',
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
    });

    testWidgets('initialIndexes 定位不抛异常', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        initialIndexes: const [0],
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
    });
  });

  group('TMultiCascader 交互', () {
    testWidgets('点击一级项展开下一级', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        cascaderHeight: 300,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('广东省'));
      await tester.pumpAndSettle();
      // 展开后应出现下一级城市
      expect(find.text('深圳市'), findsOneWidget);
      expect(find.text('广州市'), findsOneWidget);
    });

    testWidgets('点击叶子节点触发 onChanged 并关闭弹窗', (tester) async {
      var changedCount = 0;
      var lastResult = <MultiCascaderListModel>[];
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        cascaderHeight: 300,
        onChanged: (result) {
          changedCount++;
          lastResult = result;
        },
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('广东省'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('深圳市'));
      await tester.pumpAndSettle();
      expect(changedCount, 1);
      expect(lastResult.length, greaterThanOrEqualTo(1));
      // 叶子选中后 Navigator.pop，组件被移除
      expect(find.byType(TMultiCascader), findsNothing);
    });

    testWidgets('action 分支：点击自定义按钮触发 onConfirm', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        cascaderHeight: 300,
        action: TCascaderAction(
          text: '完成',
          onConfirm: (_) => confirmed = true,
        ),
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('完成'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    });

    testWidgets('onClose 分支：点击关闭图标触发 onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(wrapWithTheme(TMultiCascader(
        data: testData,
        cascaderHeight: 300,
        onClose: () => closed = true,
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.close));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });
  });

  group('TCascader.showMultiCascader', () {
    testWidgets('弹窗展示 TMultiCascader', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => TCascader.showMultiCascader(
                context,
                data: testData,
                cascaderHeight: 300,
                onChanged: (_) {},
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(TMultiCascader), findsOneWidget);
      // 弹窗内容存在
      expect(find.text('广东省'), findsOneWidget);
    });
  });
}
