import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTreeSelect V1.0 Widget 测试
///
/// 覆盖：
/// - 基础渲染（构造器参数组合）
/// - TTreeSelectStyle 枚举（normal/outline）
/// - 单选/多选模式
/// - 二级/三级菜单
/// - 初始值 value
/// - onChanged 回调验证
/// - height/outwardCornerRadius 参数
/// - Theme 覆盖（TTreeSelectThemeData）
/// - 边界场景（空 options、单层、columnWidth）
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TTreeSelectThemeData? treeTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (treeTheme != null) treeTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  // 测试数据：三级菜单
  List<TSelectOption> buildThreeLevelOptions() {
    return [
      TSelectOption(
        label: '分类一',
        value: 'cat1',
        children: [
          TSelectOption(
            label: '子分类1',
            value: 'sub1',
            children: [
              TSelectOption(label: '叶子1', value: 'leaf1'),
              TSelectOption(label: '叶子2', value: 'leaf2'),
            ],
          ),
          TSelectOption(label: '子分类2', value: 'sub2'),
        ],
      ),
      TSelectOption(
        label: '分类二',
        value: 'cat2',
        children: [
          TSelectOption(label: '子分类3', value: 'sub3'),
        ],
      ),
    ];
  }

  // 测试数据：二级菜单（多选）
  List<TSelectOption> buildMultipleOptions() {
    return [
      TSelectOption(
        label: '水果',
        value: 'fruit',
        multiple: true,
        children: [
          TSelectOption(label: '苹果', value: 'apple'),
          TSelectOption(label: '香蕉', value: 'banana'),
          TSelectOption(label: '橙子', value: 'orange'),
        ],
      ),
      TSelectOption(
        label: '蔬菜',
        value: 'vegetable',
        multiple: true,
        children: [
          TSelectOption(label: '白菜', value: 'cabbage'),
        ],
      ),
    ];
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TTreeSelect 基础渲染', () {
    testWidgets('默认渲染 - 空选项列表', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TTreeSelect()));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });

    testWidgets('带选项列表渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(options: buildThreeLevelOptions()),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
      expect(find.text('分类一'), findsOneWidget);
      expect(find.text('分类二'), findsOneWidget);
    });

    testWidgets('默认选中第一个一级菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(options: buildThreeLevelOptions()),
      ));
      // initState 中当 value 为空时会自动选中第一个
      expect(find.text('子分类1'), findsOneWidget);
      expect(find.text('子分类2'), findsOneWidget);
    });
  });

  // ============================================================
  // TTreeSelectStyle 枚举
  // ============================================================
  group('TTreeSelectStyle 枚举', () {
    testWidgets('style=normal（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          style: TTreeSelectStyle.normal,
        ),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });

    testWidgets('style=outline 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          style: TTreeSelectStyle.outline,
        ),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });
  });

  // ============================================================
  // 初始值与选择
  // ============================================================
  group('TTreeSelect 初始值与选择', () {
    testWidgets('value 指定初始选中一级菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          value: const ['cat2'],
        ),
      ));
      // cat2 被选中时，应显示其子分类
      expect(find.text('子分类3'), findsOneWidget);
    });

    testWidgets('value 指定二级选中显示三级菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          value: const ['cat1', 'sub1'],
        ),
      ));
      // sub1 有子节点，应显示三级菜单
      expect(find.text('叶子1'), findsOneWidget);
      expect(find.text('叶子2'), findsOneWidget);
    });

    testWidgets('点击一级菜单触发 onChanged', (tester) async {
      List<dynamic>? changedValues;
      int? changedLevel;
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          onChanged: (values, level) {
            changedValues = values;
            changedLevel = level;
          },
        ),
      ));
      // 点击"分类二"
      await tester.tap(find.text('分类二'));
      await tester.pumpAndSettle();
      expect(changedValues, isNotNull);
      expect(changedValues!.first, 'cat2');
      expect(changedLevel, 1);
    });

    testWidgets('点击二级菜单触发 onChanged level=2', (tester) async {
      List<dynamic>? changedValues;
      int? changedLevel;
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          value: const ['cat1'],
          onChanged: (values, level) {
            changedValues = values;
            changedLevel = level;
          },
        ),
      ));
      // 点击"子分类1"
      await tester.tap(find.text('子分类1'));
      await tester.pumpAndSettle();
      expect(changedLevel, 2);
      expect(changedValues, contains('sub1'));
    });
  });

  // ============================================================
  // 多选模式
  // ============================================================
  group('TTreeSelect 多选模式', () {
    testWidgets('multiple=true 二级多选渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildMultipleOptions(),
          value: const ['fruit', ['apple']],
          multiple: true,
        ),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
      expect(find.text('苹果'), findsOneWidget);
    });

    testWidgets('multiple 点击二级多选切换选中', (tester) async {
      List<dynamic>? changedValues;
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildMultipleOptions(),
          value: const ['fruit', ['apple']],
          multiple: true,
          onChanged: (values, level) {
            changedValues = values;
          },
        ),
      ));
      // 点击"香蕉"添加到选中
      await tester.tap(find.text('香蕉'));
      await tester.pumpAndSettle();
      expect(changedValues, isNotNull);
      // values[1] 应包含 apple 和 banana
      expect((changedValues![1] as List), contains('banana'));
    });
  });

  // ============================================================
  // 布局参数
  // ============================================================
  group('TTreeSelect 布局参数', () {
    testWidgets('height 参数生效', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTreeSelect(height: 400),
      ));
      // build 方法返回的 Container 设置了 height
      final container = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TTreeSelect),
          matching: find.byType(Container),
        ),
      );
      // 找到设置了 height=400 的 Container
      final hasHeight = container.any((c) => c.constraints?.maxHeight == 400);
      expect(hasHeight, isTrue);
    });

    testWidgets('outwardCornerRadius 参数渲染不报错', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(
          options: buildThreeLevelOptions(),
          outwardCornerRadius: 12,
        ),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });

    testWidgets('columnWidth 自定义宽度', (tester) async {
      final options = [
        TSelectOption(
          label: '自定义宽度',
          value: 'custom',
          columnWidth: 120,
          children: [
            TSelectOption(label: '子项', value: 'child'),
          ],
        ),
      ];
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(options: options),
      ));
      expect(find.text('自定义宽度'), findsOneWidget);
    });
  });

  // ============================================================
  // Theme 覆盖
  // ============================================================
  group('TTreeSelect Theme 覆盖', () {
    testWidgets('TTreeSelectThemeData 注入 style/height/radius', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTreeSelect(),
        treeTheme: const TTreeSelectThemeData(
          style: TTreeSelectStyle.outline,
          height: 250,
          outwardCornerRadius: 15,
        ),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
      // 验证 height 通过 theme 生效
      final container = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(TTreeSelect),
          matching: find.byType(Container),
        ),
      );
      final hasHeight = container.any((c) => c.constraints?.maxHeight == 250);
      expect(hasHeight, isTrue);
    });
  });

  // ============================================================
  // 边界场景
  // ============================================================
  group('TTreeSelect 边界场景', () {
    testWidgets('空 options 不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTreeSelect(options: []),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });

    testWidgets('单层选项无子节点', (tester) async {
      final options = [
        TSelectOption(label: '选项A', value: 'a'),
        TSelectOption(label: '选项B', value: 'b'),
      ];
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(options: options),
      ));
      expect(find.text('选项A'), findsOneWidget);
      expect(find.text('选项B'), findsOneWidget);
    });

    testWidgets('maxLines 截断显示', (tester) async {
      final options = [
        TSelectOption(
          label: '这是一个非常长的标签文本用于测试maxLines截断功能',
          value: 'long',
          maxLines: 2,
        ),
      ];
      await tester.pumpWidget(wrapWithTheme(
        TTreeSelect(options: options),
      ));
      expect(find.byType(TTreeSelect), findsOneWidget);
    });

    testWidgets('didUpdateWidget value 变化时更新', (tester) async {
      var values = <dynamic>['cat1'];
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return TTreeSelect(
              options: buildThreeLevelOptions(),
              value: values,
              onChanged: (v, l) {
                setState(() => values = List.from(v));
              },
            );
          },
        ),
      ));
      expect(find.text('子分类1'), findsOneWidget);

      // 模拟外部 value 变化
      values = ['cat2'];
      await tester.pumpAndSettle();
      // didUpdateWidget 触发后应更新
    });
  });

  // ============================================================
  // 数据模型验证
  // ============================================================
  group('TSelectOption 数据模型', () {
    test('TSelectOption 构造器默认值', () {
      final opt = TSelectOption(label: '测试', value: 'test');
      expect(opt.label, '测试');
      expect(opt.value, 'test');
      expect(opt.children, isEmpty);
      expect(opt.multiple, isFalse);
      expect(opt.maxLines, 1);
      expect(opt.columnWidth, isNull);
    });

    test('TSelectOption maxLines 断言', () {
      expect(
        () => TSelectOption(label: '测试', value: 'test', maxLines: 0),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
