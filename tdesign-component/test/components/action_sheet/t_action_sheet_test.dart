import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TActionSheet 组件 Widget 测试
///
/// 覆盖 list / grid / group 三种主题、对齐方式、禁用项、回调等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TActionSheetThemeData? sheetTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (sheetTheme != null) sheetTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: Builder(builder: (context) => child)),
    );
  }

  /// 基础菜单项
  List<TActionSheetItem> baseItems() => [
        TActionSheetItem(label: '选项一'),
        TActionSheetItem(label: '选项二'),
        TActionSheetItem(label: '选项三'),
      ];

  // ============================================================
  // TActionSheetItem 单元测试
  // ============================================================
  group('TActionSheetItem', () {
    test('默认值 - disabled 为 false', () {
      final item = TActionSheetItem(label: '测试');
      expect(item.label, '测试');
      expect(item.disabled, isFalse);
    });

    test('disabled: true 设置禁用', () {
      final item = TActionSheetItem(label: '禁用项', disabled: true);
      expect(item.disabled, isTrue);
    });

    test('带图标和副标题', () {
      final item = TActionSheetItem(
        label: '带图标',
        icon: const Icon(Icons.star),
        subtitle: '副标题',
        group: 'A组',
      );
      expect(item.icon, isNotNull);
      expect(item.subtitle, '副标题');
      expect(item.group, 'A组');
    });
  });

  // ============================================================
  // 枚举验证
  // ============================================================
  group('枚举', () {
    test('TActionSheetTheme 有三个值', () {
      expect(TActionSheetTheme.values.length, 3);
      expect(TActionSheetTheme.values, contains(TActionSheetTheme.list));
      expect(TActionSheetTheme.values, contains(TActionSheetTheme.grid));
      expect(TActionSheetTheme.values, contains(TActionSheetTheme.group));
    });

    test('TActionSheetAlign 有三个值', () {
      expect(TActionSheetAlign.values.length, 3);
      expect(TActionSheetAlign.values, contains(TActionSheetAlign.left));
      expect(TActionSheetAlign.values, contains(TActionSheetAlign.center));
      expect(TActionSheetAlign.values, contains(TActionSheetAlign.right));
    });
  });

  // ============================================================
  // list 主题
  // ============================================================
  group('TActionSheet list 主题', () {
    testWidgets('showListActionSheet 渲染列表项', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: baseItems(),
        showCancel: true,
      );
      await tester.pumpAndSettle();

      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项三'), findsOneWidget);
    });

    testWidgets('点击列表项触发 onChanged 回调', (tester) async {
      int? selectedIndex;
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: baseItems(),
        onChanged: (item, index) {
          selectedIndex = index;
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('showCancel: false 不显示取消按钮', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: baseItems(),
        showCancel: false,
      );
      await tester.pumpAndSettle();

      // 默认取消文案不应出现
      expect(find.text('取消'), findsNothing);
    });

    testWidgets('自定义 cancelText', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: baseItems(),
        showCancel: true,
        cancelText: '关闭',
      );
      await tester.pumpAndSettle();

      expect(find.text('关闭'), findsOneWidget);
    });

    testWidgets('subtitle 描述文本渲染', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      // subtitle 仅在实例构造函数中可用
      TActionSheet(
        ctx,
        items: baseItems(),
        theme: TActionSheetTheme.list,
        subtitle: '请选择操作',
      ).show();
      await tester.pumpAndSettle();

      expect(find.text('请选择操作'), findsOneWidget);
    });

    testWidgets('align: left 左对齐渲染', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: baseItems(),
        align: TActionSheetAlign.left,
      );
      await tester.pumpAndSettle();

      expect(find.text('选项一'), findsOneWidget);
    });
  });

  // ============================================================
  // grid 主题
  // ============================================================
  group('TActionSheet grid 主题', () {
    testWidgets('showGridActionSheet 渲染宫格项', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showGridActionSheet(
        ctx,
        items: [
          TActionSheetItem(label: '宫格1', icon: const Icon(Icons.add)),
          TActionSheetItem(label: '宫格2', icon: const Icon(Icons.remove)),
        ],
        count: 2,
        rows: 1,
      );
      await tester.pumpAndSettle();

      expect(find.text('宫格1'), findsOneWidget);
      expect(find.text('宫格2'), findsOneWidget);
    });

    testWidgets('grid 模式点击项触发 onChanged', (tester) async {
      String? selectedLabel;
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showGridActionSheet(
        ctx,
        items: [
          TActionSheetItem(label: '宫格A'),
          TActionSheetItem(label: '宫格B'),
        ],
        count: 2,
        rows: 1,
        onChanged: (item, index) {
          selectedLabel = item.label;
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('宫格B'));
      await tester.pumpAndSettle();

      expect(selectedLabel, '宫格B');
    });
  });

  // ============================================================
  // group 主题
  // ============================================================
  group('TActionSheet group 主题', () {
    testWidgets('showGroupActionSheet 渲染分组项', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showGroupActionSheet(
        ctx,
        items: [
          TActionSheetItem(label: '组1项1', group: '分组一'),
          TActionSheetItem(label: '组1项2', group: '分组一'),
          TActionSheetItem(label: '组2项1', group: '分组二'),
        ],
        itemHeight: 80,
      );
      await tester.pumpAndSettle();

      expect(find.text('组1项1'), findsOneWidget);
      expect(find.text('组1项2'), findsOneWidget);
      expect(find.text('组2项1'), findsOneWidget);
    });
  });

  // ============================================================
  // 实例方法 show / open / close
  // ============================================================
  group('TActionSheet 实例方法', () {
    testWidgets('构造函数 visible: true 自动展示', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      // 在 post-frame 回调中创建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TActionSheet(
          ctx,
          items: baseItems(),
          visible: true,
          theme: TActionSheetTheme.list,
        );
      });

      await tester.pumpAndSettle();
      expect(find.text('选项一'), findsOneWidget);
    });

    testWidgets('show() 方法手动展示', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet(
        ctx,
        items: baseItems(),
        theme: TActionSheetTheme.list,
      ).show();
      await tester.pumpAndSettle();

      expect(find.text('选项一'), findsOneWidget);
    });
  });

  // ============================================================
  // 禁用项
  // ============================================================
  group('TActionSheet 禁用项', () {
    testWidgets('禁用项渲染但不触发回调', (tester) async {
      int? tappedIndex;
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: [
          TActionSheetItem(label: '可用项'),
          TActionSheetItem(label: '禁用项', disabled: true),
        ],
        onChanged: (item, index) {
          tappedIndex = index;
        },
      );
      await tester.pumpAndSettle();

      // 点击禁用项
      await tester.tap(find.text('禁用项'));
      await tester.pumpAndSettle();

      // 不应触发回调
      expect(tappedIndex, isNull);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TActionSheet 主题覆盖', () {
    testWidgets('TActionSheetThemeData 注入后正常渲染', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
        sheetTheme: const TActionSheetThemeData(
          showCancelButton: true,
          cancelText: '主题取消',
          itemHeight: 100,
          count: 4,
          rows: 2,
        ),
      ));

      TActionSheet.showListActionSheet(
        ctx,
        items: baseItems(),
      );
      await tester.pumpAndSettle();

      // 主题 cancelText 应被使用
      expect(find.text('主题取消'), findsOneWidget);
    });

    test('TActionSheetThemeData merge 合并', () {
      const base = TActionSheetThemeData(
        cancelText: '取消',
        itemHeight: 80,
      );
      const override = TActionSheetThemeData(
        itemHeight: 100,
      );
      final merged = base.merge(override);
      expect(merged.cancelText, '取消');
      expect(merged.itemHeight, 100);
    });

    test('TActionSheetThemeData copyWith', () {
      const original = TActionSheetThemeData(cancelText: '取消');
      final copied = original.copyWith(cancelText: '关闭');
      expect(copied.cancelText, '关闭');
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TActionSheet 覆盖率补充', () {
    testWidgets('TActionSheet open/close', (tester) async {
      // 覆盖 258-259（open → show）+ 263-265（close → handle.close）
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      final sheet = TActionSheet(ctx, items: [TActionSheetItem(label: 'test')]);
      sheet.open();
      await tester.pumpAndSettle();
      sheet.close();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
