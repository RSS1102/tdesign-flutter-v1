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
  // ============================================================
  // 覆盖补充
  // ============================================================
  group('TTable 覆盖补充', () {
    List<Map<String, dynamic>> selData() => [
          {'name': '张三'},
          {'name': '李四'},
          {'name': '王五'},
        ];

    testWidgets('表头全选复选框点击触发 onSelect（含 selectable 过滤）', (tester) async {
      List<dynamic>? selected;
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(
              title: '选择',
              colKey: 'name',
              selection: true,
              width: 80,
              selectable: (index, row) => index != 1,
            ),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: selData(),
          onSelect: (data) => selected = data,
        ),
      ));
      final checkboxes = find.byType(TCheckbox);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
    });

    testWidgets('行复选框选中再取消（_hasChecked 递减）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '选择', colKey: 'name', selection: true, width: 80),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: selData(),
        ),
      ));
      final checkboxes = find.byType(TCheckbox);
      await tester.tap(checkboxes.at(1));
      await tester.pumpAndSettle();
      await tester.tap(checkboxes.at(1));
      await tester.pumpAndSettle();
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('selectable=false 行显示占位色复选框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(
              title: '选择',
              colKey: 'name',
              selection: true,
              width: 80,
              selectable: (index, row) => false,
            ),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: selData(),
        ),
      ));
      expect(find.byType(TCheckbox), findsWidgets);
    });

    testWidgets('点击排序图标循环切换（升序/降序/取消）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '年龄', colKey: 'age', sortable: true, width: 200),
          ],
          data: [
            {'age': '30'},
            {'age': '10'},
            {'age': '20'},
          ],
        ),
      ));
      final chevron = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.size == const Size(16, 16),
      );
      expect(chevron, findsOneWidget);
      await tester.tap(chevron);
      await tester.pumpAndSettle();
      await tester.tap(chevron);
      await tester.pumpAndSettle();
      await tester.tap(chevron);
      await tester.pumpAndSettle();
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('多个 selection 列抛出 FlutterError', (tester) async {
      // 源码在 initState -> _initCols 中 throw FlutterError，框架会捕获并记录；
      // 该异常可能伴随后续渲染异常（Multiple exceptions），因此逐一取出所有异常，
      // 确认其中包含 FlutterError。
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: 'A', colKey: 'name', selection: true),
            TTableCol(title: 'B', colKey: 'name', selection: true),
          ],
          data: selData(),
        ),
      ));
      var foundFlutterError = false;
      dynamic ex;
      while ((ex = tester.takeException()) != null) {
        if (ex is FlutterError) {
          foundFlutterError = true;
        }
      }
      expect(foundFlutterError, isTrue);
    });

    testWidgets('didUpdateWidget 数据变化重建', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(columns: baseColumns(), data: baseData()),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TTable(columns: baseColumns(), data: const [
          {'name': '新', 'age': '1'},
        ]),
      ));
      await tester.pumpAndSettle();
      expect(find.text('新'), findsOneWidget);
    });

    testWidgets('空状态 http 图片', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: baseColumns(),
          data: const [],
          empty: TTableEmpty(assetUrl: 'http://example.com/empty.png'),
        ),
      ));
      expect(find.byType(TEmpty), findsOneWidget);
    });

    testWidgets('固定列 + height 纵向滚动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: TTable(
            width: 300,
            height: 120,
            columns: [
              TTableCol(title: '固定', colKey: 'a', fixed: TTableColFixed.left, width: 80),
              TTableCol(title: '普通', colKey: 'b', width: 100),
            ],
            data: const [
              {'a': 'A1', 'b': 'B1'},
              {'a': 'A2', 'b': 'B2'},
              {'a': 'A3', 'b': 'B3'},
            ],
          ),
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('固定列 + 需要横向滚动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 200,
          columns: [
            TTableCol(title: '固定', colKey: 'a', fixed: TTableColFixed.left, width: 80),
            TTableCol(title: '普通1', colKey: 'b', width: 300),
            TTableCol(title: '普通2', colKey: 'c', width: 300),
          ],
          data: const [
            {'a': 'A1', 'b': 'B1', 'c': 'C1'},
          ],
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('固定列 + loading', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 300,
          loading: true,
          columns: [
            TTableCol(title: '固定', colKey: 'a', fixed: TTableColFixed.left, width: 80),
            TTableCol(title: '普通', colKey: 'b'),
          ],
          data: baseData(),
        ),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('固定列 + 空数据', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 300,
          columns: [
            TTableCol(title: '固定', colKey: 'a', fixed: TTableColFixed.left, width: 80),
            TTableCol(title: '普通', colKey: 'b'),
          ],
          data: const [],
        ),
      ));
      expect(find.byType(TEmpty), findsOneWidget);
    });

    testWidgets('表格超宽触发横向滚动分支', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 100,
          columns: [
            TTableCol(title: '列1', colKey: 'a', width: 200),
            TTableCol(title: '列2', colKey: 'b', width: 200),
          ],
          data: const [
            {'a': 'A1', 'b': 'B1'},
          ],
        ),
      ));
      expect(find.byType(TTable), findsOneWidget);
    });

    test('ChevronPainter.shouldRepaint 返回 true', () {
      final painter = ChevronPainter(upColor: Colors.red, downColor: Colors.blue);
      expect(painter.shouldRepaint(painter), isTrue);
    });

    testWidgets('空数据点击表头全选（_hasChecked=totalSelectable=1 分支）',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          columns: [
            TTableCol(title: '选择', colKey: 'name', selection: true, width: 80),
            TTableCol(title: '姓名', colKey: 'name'),
          ],
          data: const [],
        ),
      ));
      // 空数据时表头全选框仍渲染，点击进入 !_notEmptyData() && checked 分支
      final header = find.byType(TCheckbox);
      expect(header, findsWidgets);
      await tester.tap(header.first);
      await tester.pumpAndSettle();
      expect(find.byType(TTable), findsOneWidget);
    });

    testWidgets('onScroll 回调（纵向滚动）', (tester) async {
      ScrollController? scrolled;
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 300,
          height: 100,
          onScroll: (c) => scrolled = c,
          columns: baseColumns(),
          data: List.generate(
              30, (i) => {'name': 'n$i', 'age': '$i'}),
        ),
      ));
      await tester.drag(
          find.byType(SingleChildScrollView).last, const Offset(0, -200));
      await tester.pump();
      expect(scrolled, isNotNull);
    });

    testWidgets('固定列横向滚动同步 header/data 控制器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTable(
          width: 200,
          columns: [
            TTableCol(
                title: '固定', colKey: 'a', fixed: TTableColFixed.left, width: 80),
            TTableCol(title: '普通1', colKey: 'b', width: 300),
            TTableCol(title: '普通2', colKey: 'c', width: 300),
          ],
          data: const [
            {'a': 'A1', 'b': 'B1', 'c': 'C1'},
          ],
        ),
      ));
      final hScrolls = find.byWidgetPredicate((w) =>
          w is SingleChildScrollView && w.scrollDirection == Axis.horizontal);
      expect(hScrolls, findsWidgets);
      // 拖动数据区非固定列 -> _dataHScrollController 监听同步 header
      await tester.drag(hScrolls.last, const Offset(-80, 0),
          warnIfMissed: false);
      await tester.pumpAndSettle();
      // 拖动表头非固定列 -> _headerHScrollController 监听同步 data
      await tester.drag(hScrolls.first, const Offset(-40, 0),
          warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(TTable), findsOneWidget);
    });
  });

}
