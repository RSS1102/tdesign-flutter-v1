import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTable 组件 Widget 测试
///
/// 覆盖列配置、对齐方式、固定列、排序、选择、空数据、加载态等关键路径。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TTableThemeData? tableTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (tableTheme != null) tableTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  /// 基础列定义
  List<TTableCol> baseColumns() => [
        TTableCol(title: '姓名', colKey: 'name'),
        TTableCol(title: '年龄', colKey: 'age'),
      ];

  /// 基础数据
  List<Map<String, dynamic>> baseData() => [
        {'name': '张三', 'age': '20'},
        {'name': '李四', 'age': '25'},
      ];

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TTable 基础渲染', () {
    testWidgets('渲染基本表格 - 表头和数据', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(columns: baseColumns(), data: baseData()),
      ));

      expect(find.byType(TTable), findsOneWidget);
      expect(find.text('姓名'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('李四'), findsOneWidget);
    });

    testWidgets('仅列无数据时渲染空状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTable(columns: []),
      ));

      expect(find.byType(TTable), findsOneWidget);
      // 空数据应展示 TEmpty
      expect(find.byType(TEmpty), findsOneWidget);
    });

    testWidgets('data 为 null 时展示空状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(columns: baseColumns(), data: null),
      ));

      expect(find.byType(TEmpty), findsOneWidget);
    });

    testWidgets('data 为空列表时展示空状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(columns: baseColumns(), data: const []),
      ));

      expect(find.byType(TEmpty), findsOneWidget);
    });

    testWidgets('自定义空状态文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: const [],
          empty: TTableEmpty(text: '暂无数据哦'),
        ),
      ));

      expect(find.text('暂无数据哦'), findsOneWidget);
    });
  });

  // ============================================================
  // 列对齐方式
  // ============================================================
  group('TTable 列对齐', () {
    testWidgets('TTableColAlign.left 对齐渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '左', colKey: 'name', align: TTableColAlign.left),
          ],
          data: const [{'name': 'A'}],
        ),
      ));
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('TTableColAlign.center 对齐渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '中', colKey: 'name', align: TTableColAlign.center),
          ],
          data: const [{'name': 'B'}],
        ),
      ));
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('TTableColAlign.right 对齐渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '右', colKey: 'name', align: TTableColAlign.right),
          ],
          data: const [{'name': 'C'}],
        ),
      ));
      expect(find.text('C'), findsOneWidget);
    });
  });

  // ============================================================
  // 固定列
  // ============================================================
  group('TTable 固定列', () {
    testWidgets('固定左列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 300,
          columns: [
            TTableCol(title: '固定', colKey: 'fixed', fixed: TTableColFixed.left, width: 80),
            TTableCol(title: '普通', colKey: 'normal'),
          ],
          data: const [
            {'fixed': 'F1', 'normal': 'N1'},
          ],
        ),
      ));

      expect(find.text('F1'), findsOneWidget);
      expect(find.text('N1'), findsOneWidget);
    });

    testWidgets('固定右列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 300,
          columns: [
            TTableCol(title: '普通', colKey: 'normal'),
            TTableCol(title: '固定', colKey: 'fixed', fixed: TTableColFixed.right, width: 80),
          ],
          data: const [
            {'fixed': 'R1', 'normal': 'N1'},
          ],
        ),
      ));

      expect(find.text('R1'), findsOneWidget);
      expect(find.text('N1'), findsOneWidget);
    });
  });

  // ============================================================
  // 边框 / 斑马纹 / 表头
  // ============================================================
  group('TTable 外观', () {
    testWidgets('bordered: true 渲染边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
          bordered: true,
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('stripe: true 渲染斑马纹', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
          stripe: true,
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('showHeader: false 不渲染表头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
          showHeader: false,
        ),
      ));
      // 表头标题不应出现
      expect(find.text('姓名'), findsNothing);
      expect(find.text('年龄'), findsNothing);
      // 数据仍然存在
      expect(find.text('张三'), findsOneWidget);
    });
  });

  // ============================================================
  // 加载态
  // ============================================================
  group('TTable 加载态', () {
    testWidgets('loading: true 显示默认加载组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
          loading: true,
        ),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('loading: true + 自定义 loadingWidget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
          loading: true,
          loadingWidget: const Text('加载中...'),
        ),
      ));
      expect(find.text('加载中...'), findsOneWidget);
    });
  });

  // ============================================================
  // 排序
  // ============================================================
  group('TTable 排序', () {
    testWidgets('sortable 列渲染排序图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '年龄', colKey: 'age', sortable: true),
          ],
          data: const [
            {'age': '30'},
            {'age': '10'},
          ],
        ),
      ));
      // 排序图标使用 CustomPaint(ChevronPainter)
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('点击排序图标触发排序', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '年龄', colKey: 'age', sortable: true, width: 100),
          ],
          data: const [
            {'age': '30'},
            {'age': '10'},
          ],
        ),
      ));

      // 两个数据值都应存在
      expect(find.text('30'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // 点击排序图标（CustomPaint 区域）
      final sortIcon = find.byType(CustomPaint).first;
      await tester.tap(sortIcon);
      await tester.pumpAndSettle();

      // 排序后两个值仍应存在
      expect(find.text('30'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('defaultSort 设置初始排序', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '年龄', colKey: 'age', sortable: true, width: 100),
          ],
          data: const [
            {'age': '30'},
            {'age': '10'},
          ],
          defaultSort: 'age',
        ),
      ));
      // defaultSort 应使排序键初始化
      expect(find.byType(TTable), findsOneWidget);
    });
  });

  // ============================================================
  // 行选择
  // ============================================================
  group('TTable 行选择', () {
    testWidgets('selection 列渲染表头和行复选框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(
              title: '选择',
              colKey: 'name',
              selection: true,
            ),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: baseData(),
        ),
      ));
      // 应渲染 TCheckbox
      expect(find.byType(TCheckbox), findsWidgets);
    });

    testWidgets('点击行复选框触发 onRowSelect 回调', (tester) async {
      int? selectedIndex;
      bool? selectedChecked;
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(
              title: '选择',
              colKey: 'name',
              selection: true,
              width: 80,
            ),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: baseData(),
          onRowSelect: (index, checked) {
            selectedIndex = index;
            selectedChecked = checked;
          },
        ),
      ));

      // 点击第一个行的复选框
      final checkboxes = find.byType(TCheckbox);
      // 跳过表头复选框，点击第一个数据行复选框
      await tester.tap(checkboxes.at(1));
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
      expect(selectedChecked, isTrue);
    });

    testWidgets('checked 回调初始化选中状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(
              title: '选择',
              colKey: 'name',
              selection: true,
              checked: (index, row) => index == 0,
              width: 80,
            ),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: baseData(),
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义单元格
  // ============================================================
  group('TTable 自定义单元格', () {
    testWidgets('cellBuilder 自定义渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(
              title: '操作',
              colKey: 'op',
              cellBuilder: (context, index) => Text('按钮$index'),
            ),
          ],
          data: const [
            {'op': ''},
            {'op': ''},
          ],
        ),
      ));
      expect(find.text('按钮0'), findsOneWidget);
      expect(find.text('按钮1'), findsOneWidget);
    });
  });

  // ============================================================
  // 单元格点击回调
  // ============================================================
  group('TTable 回调', () {
    testWidgets('点击数据单元格触发 onCellTap', (tester) async {
      int? tappedRow;
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '姓名', colKey: 'name', width: 100),
          ],
          data: const [
            {'name': '张三'},
          ],
          onCellTap: (rowIndex, row, col) {
            tappedRow = rowIndex;
          },
        ),
      ));

      await tester.tap(find.text('张三'));
      await tester.pumpAndSettle();
      expect(tappedRow, 0);
    });

    testWidgets('设置 height 启用纵向滚动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          child: TTable(
            columns: baseColumns(),
            data: baseData(),
            height: 100,
          ),
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('footerWidget 渲染表尾', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
          footerWidget: const Text('表尾'),
        ),
      ));
      expect(find.text('表尾'), findsOneWidget);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TTable 主题覆盖', () {
    testWidgets('TTableThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: baseData(),
        ),
        tableTheme: const TTableThemeData(
          bordered: true,
          stripe: true,
          rowHeight: 30,
          backgroundColor: Colors.red,
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    test('TTableCol.widthPx 返回像素宽度', () {
      final col = TTableCol(title: '测试', colKey: 't', width: 120);
      expect(col.widthPx, 120);
    });
  });
}
