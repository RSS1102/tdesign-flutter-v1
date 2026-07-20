import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_group.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_list.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Future<BuildContext> pumpHost(
    WidgetTester tester, {
    TActionSheetThemeData? theme,
  }) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: theme == null
            ? TThemeBuilder.light(TThemeData.defaultData())
            : TThemeBuilder.light(TThemeData.defaultData())
                .mergeExtension(theme),
        home: Scaffold(body: SizedBox(key: key)),
      ),
    );
    return key.currentContext!;
  }

  List<TActionSheetItem> items() => [
        TActionSheetItem(label: '拍照'),
        TActionSheetItem(label: '相册'),
      ];

  group('TActionSheet 命令式入口', () {
    testWidgets('showList 返回句柄并在选择后关闭', (tester) async {
      final context = await pumpHost(tester);
      TActionSheetItem? selected;
      var selectedIndex = -1;

      final handle = TActionSheet.showList(
        context,
        items: items(),
        onChanged: (item, index) {
          selected = item;
          selectedIndex = index;
        },
      );
      await tester.pumpAndSettle();

      expect(handle.isShowing, isTrue);
      expect(find.byType(TActionSheetList), findsOneWidget);
      expect(find.text('拍照'), findsOneWidget);

      await tester.tap(find.text('相册'));
      await tester.pumpAndSettle();
      expect(selected?.label, '相册');
      expect(selectedIndex, 1);
      expect(handle.isShowing, isFalse);
    });

    testWidgets('showGrid 传递分页和尺寸配置', (tester) async {
      final context = await pumpHost(
        tester,
        theme: const TActionSheetThemeData(
          defaultAlign: TActionSheetAlign.left,
          count: 4,
          rows: 1,
          itemHeight: 88,
          itemMinWidth: 72,
        ),
      );

      final handle = TActionSheet.showGrid(
        context,
        items: items(),
        showPagination: true,
      );
      await tester.pumpAndSettle();

      final grid = tester.widget<TActionSheetGrid>(
        find.byType(TActionSheetGrid),
      );
      expect(grid.align, TActionSheetAlign.left);
      expect(grid.count, 4);
      expect(grid.rows, 1);
      expect(grid.itemHeight, 88);
      expect(grid.itemMinWidth, 72);
      expect(grid.showPagination, isTrue);

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('showGroup 渲染分组内容', (tester) async {
      final context = await pumpHost(tester);
      final handle = TActionSheet.showGroup(
        context,
        items: [
          TActionSheetItem(label: '编辑', group: '常用'),
          TActionSheetItem(label: '删除', group: '危险'),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(TActionSheetGroup), findsOneWidget);
      expect(find.text('常用'), findsOneWidget);
      expect(find.text('危险'), findsOneWidget);

      handle.close();
      await tester.pumpAndSettle();
    });

    testWidgets('取消按钮回调并关闭', (tester) async {
      final context = await pumpHost(tester);
      var cancelled = false;
      final handle = TActionSheet.showList(
        context,
        items: items(),
        cancelText: '取消操作',
        onCancel: () => cancelled = true,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('取消操作'));
      await tester.pumpAndSettle();
      expect(cancelled, isTrue);
      expect(handle.isShowing, isFalse);
    });

    testWidgets('句柄可主动关闭并触发 onClosed', (tester) async {
      final context = await pumpHost(tester);
      var closed = false;
      final handle = TActionSheet.showGrid(
        context,
        items: items(),
        showCancel: false,
        showOverlay: false,
        closeOnOverlayClick: false,
        useSafeArea: false,
        scrollable: true,
        onClosed: () => closed = true,
      );
      await tester.pumpAndSettle();

      handle.close();
      await tester.pumpAndSettle();
      expect(handle.isShowing, isFalse);
      expect(closed, isTrue);
    });
  });

  group('TActionSheetThemeData', () {
    test('merge/copyWith/lerp 保留视觉布局字段', () {
      const base = TActionSheetThemeData(
        defaultAlign: TActionSheetAlign.left,
        itemHeight: 80,
        count: 4,
        barrierColor: Colors.black,
      );
      const override = TActionSheetThemeData(
        itemHeight: 96,
        panelRadius: 12,
      );

      final merged = base.merge(override);
      expect(merged.defaultAlign, TActionSheetAlign.left);
      expect(merged.itemHeight, 96);
      expect(merged.panelRadius, 12);

      final copied = merged.copyWith(rows: 3);
      expect(copied.rows, 3);
      expect(copied.count, 4);

      final lerped = base.lerp(override, 0.75);
      expect(lerped.panelRadius, 9);
      expect(base.merge(null), same(base));
      expect(base.lerp(null, 0.5), same(base));
    });
  });
}
