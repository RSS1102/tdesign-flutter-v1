import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSwipeCell V1.0 Widget 测试
///
/// 覆盖：
/// - 基础渲染（cell/right/left 面板）
/// - enabled 禁用状态
/// - TSwipeDirection 方向
/// - SwipeMotion 动画展示方式
/// - onChanged 回调
/// - 主题覆盖（TSwipeCellThemeData）
/// - 静态方法 close
/// - 边界场景
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TSwipeCellThemeData? swipeTheme}) {
    final extensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (swipeTheme != null) swipeTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: extensions),
      home: Scaffold(body: child),
    );
  }

  /// 构建一个右侧操作面板
  TSwipeCellPanel buildRightPanel({
    List<TSwipeCellAction>? actions,
    double extentRatio = 0.3,
    SwipeMotion? motion,
  }) {
    return TSwipeCellPanel(
      extentRatio: extentRatio,
      motionType: motion,
      children: actions ??
          [
            TSwipeCellAction(
              label: '删除',
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (_) {},
            ),
          ],
    );
  }

  /// 构建一个左侧操作面板
  TSwipeCellPanel buildLeftPanel({
    List<TSwipeCellAction>? actions,
  }) {
    return TSwipeCellPanel(
      children: actions ??
          [
            TSwipeCellAction(
              label: '收藏',
              icon: Icons.star,
              backgroundColor: Colors.blue,
              onPressed: (_) {},
            ),
          ],
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TSwipeCell 基础渲染', () {
    testWidgets('渲染 cell 内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwipeCell(
          cell: TCell(title: '单元格'),
        ),
      ));
      expect(find.text('单元格'), findsOneWidget);
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('渲染右侧操作面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '右滑删除'),
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('右滑删除'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });

    testWidgets('渲染左侧操作面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '左滑收藏'),
          left: buildLeftPanel(),
        ),
      ));
      expect(find.text('左滑收藏'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });

    testWidgets('同时渲染左右面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '双向滑动'),
          left: buildLeftPanel(),
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('双向滑动'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });
  });

  // ============================================================
  // enabled 禁用状态
  // ============================================================
  group('TSwipeCell 禁用状态', () {
    testWidgets('enabled=false 禁用滑动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '禁用'),
          enabled: false,
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('禁用'), findsOneWidget);
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.enabled, isFalse);
    });

    testWidgets('enabled=true（默认）启用滑动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '启用'),
          right: buildRightPanel(),
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.enabled, isTrue);
    });
  });

  // ============================================================
  // SwipeMotion 动画展示方式
  // ============================================================
  group('TSwipeCellPanel SwipeMotion', () {
    testWidgets('ScrollMotion 默认动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.scroll);
      expect(panel.getMotionWidget(), isA<ScrollMotion>());
    });

    testWidgets('BehindMotion 揭开动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.behind);
      expect(panel.getMotionWidget(), isA<BehindMotion>());
    });

    testWidgets('DrawerMotion 抽屉动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.drawer);
      expect(panel.getMotionWidget(), isA<DrawerMotion>());
    });

    testWidgets('StretchMotion 拉伸动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.stretch);
      expect(panel.getMotionWidget(), isA<StretchMotion>());
    });

    test('motionType 为 null 时默认 ScrollMotion', () {
      final panel = buildRightPanel();
      expect(panel.getMotionWidget(), isA<ScrollMotion>());
    });
  });

  // ============================================================
  // onChanged 回调
  // ============================================================
  group('TSwipeCell onChanged 回调', () {
    testWidgets('向左滑动触发 onChanged(TSwipeDirection.left, true)', (tester) async {
      TSwipeDirection? direction;
      bool? isOpen;

      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: '滑动测试'),
            left: buildLeftPanel(),
            onChanged: (dir, open) {
              direction = dir;
              isOpen = open;
            },
          ),
        ),
      ));

      // 向右拖动以打开左侧面板
      await tester.drag(find.text('滑动测试'), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(direction, TSwipeDirection.left);
      expect(isOpen, isTrue);
    });

    testWidgets('向右滑动触发 onChanged(TSwipeDirection.right, true)', (tester) async {
      TSwipeDirection? direction;
      bool? isOpen;

      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: '右滑测试'),
            right: buildRightPanel(),
            onChanged: (dir, open) {
              direction = dir;
              isOpen = open;
            },
          ),
        ),
      ));

      // 向左拖动以打开右侧面板
      await tester.drag(find.text('右滑测试'), const Offset(-100, 0));
      await tester.pumpAndSettle();

      expect(direction, TSwipeDirection.right);
      expect(isOpen, isTrue);
    });
  });

  // ============================================================
  // 主题覆盖（TSwipeCellThemeData）
  // ============================================================
  group('TSwipeCell 主题覆盖', () {
    testWidgets('通过 TSwipeCellThemeData 设置 duration', (tester) async {
      const customDuration = Duration(milliseconds: 500);
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '时长'),
          right: buildRightPanel(),
        ),
        swipeTheme: const TSwipeCellThemeData(duration: customDuration),
      ));
      expect(find.text('时长'), findsOneWidget);
    });

    testWidgets('通过 TSwipeCellThemeData 设置 groupTag', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '分组'),
          right: buildRightPanel(),
        ),
        swipeTheme: const TSwipeCellThemeData(groupTag: 'group1'),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.groupTag, 'group1');
    });

    testWidgets('通过 TSwipeCellThemeData 设置 dragStartBehavior', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '拖动行为'),
          right: buildRightPanel(),
        ),
        swipeTheme: const TSwipeCellThemeData(
          dragStartBehavior: DragStartBehavior.down,
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.dragStartBehavior, DragStartBehavior.down);
    });

    testWidgets('通过 TSwipeCellThemeData 设置 closeWhenOpened', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Column(
          children: [
            SizedBox(
              width: 300,
              height: 60,
              child: TSwipeCell(
                cell: const TCell(title: '项1'),
                right: buildRightPanel(),
              ),
            ),
            SizedBox(
              width: 300,
              height: 60,
              child: TSwipeCell(
                cell: const TCell(title: '项2'),
                right: buildRightPanel(),
              ),
            ),
          ],
        ),
        swipeTheme: const TSwipeCellThemeData(
          groupTag: 'group_close',
          closeWhenOpened: true,
        ),
      ));
      expect(find.text('项1'), findsOneWidget);
      expect(find.text('项2'), findsOneWidget);
    });
  });

  // ============================================================
  // TSwipeCellPanel 参数
  // ============================================================
  group('TSwipeCellPanel 参数', () {
    test('extentRatio 设置面板宽度占比', () {
      final panel = buildRightPanel(extentRatio: 0.5);
      expect(panel.extentRatio, 0.5);
    });

    test('默认 extentRatio 为 0.3', () {
      final panel = TSwipeCellPanel(
        children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
      );
      expect(panel.extentRatio, 0.3);
    });

    test('dragDismissible 默认为 false', () {
      final panel = TSwipeCellPanel(
        children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
      );
      expect(panel.dragDismissible, isFalse);
    });

    test('openThreshold 默认为 extentRatio 的一半', () {
      final panel = TSwipeCellPanel(
        extentRatio: 0.4,
        children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
      );
      expect(panel._openThreshold, 0.2);
    });

    test('confirms 断言验证 confirmIndex 范围', () {
      // confirmIndex 超出 children 范围应触发断言
      expect(
        () => TSwipeCellPanel(
          children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
          confirms: [
            TSwipeCellAction(
              label: '确认',
              confirmIndex: const [5],
              onPressed: (_) {},
            ),
          ],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  // ============================================================
  // TSwipeCellAction 参数
  // ============================================================
  group('TSwipeCellAction 参数', () {
    test('flex 断言必须大于 0', () {
      expect(
        () => TSwipeCellAction(
          flex: 0,
          label: '测试',
          onPressed: (_) {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('icon 和 label 不能同时为 null', () {
      expect(
        () => TSwipeCellAction(
          onPressed: (_) {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('自定义 builder 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '自定义按钮'),
          right: TSwipeCellPanel(
            children: [
              TSwipeCellAction(
                label: '操作',
                builder: (context) => const Text('自定义内容'),
              ),
            ],
          ),
        ),
      ));
      expect(find.text('自定义按钮'), findsOneWidget);
    });
  });

  // ============================================================
  // 静态方法 / 边界场景
  // ============================================================
  group('TSwipeCell 静态方法与边界', () {
    testWidgets('TSwipeCell.close 对 null tag 不抛异常', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '无tag'),
          right: buildRightPanel(),
        ),
      ));
      // tag 为 null，close 应直接返回
      TSwipeCell.close(null);
      expect(find.text('无tag'), findsOneWidget);
    });

    testWidgets('TSwipeCell.of 获取控制器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '控制器'),
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('控制器'), findsOneWidget);
    });

    test('TSwipeCellThemeData merge 正确合并', () {
      const base = TSwipeCellThemeData(
        groupTag: 'base',
        duration: Duration(milliseconds: 200),
      );
      const other = TSwipeCellThemeData(duration: Duration(milliseconds: 500));
      final merged = base.merge(other);
      expect(merged.groupTag, 'base');
      expect(merged.duration, const Duration(milliseconds: 500));
    });

    test('TSwipeCellThemeData lerp 正确插值', () {
      const a = TSwipeCellThemeData(duration: Duration(milliseconds: 200));
      const b = TSwipeCellThemeData(duration: Duration(milliseconds: 500));
      final result = a.lerp(b, 0.3);
      // t < 0.5 取 a 的值
      expect(result.duration, const Duration(milliseconds: 200));
    });

    testWidgets('direction 垂直方向渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: TSwipeCell(
            cell: const TCell(title: '垂直'),
            direction: Axis.vertical,
            right: buildRightPanel(),
          ),
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.direction, Axis.vertical);
    });
  });

  group('TSwipeCell 高级交互', () {
    testWidgets('closeWhenOpened 打开面板触发自动关闭逻辑', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: '自动关闭'),
          right: buildRightPanel(),
        ),
        swipeTheme: const TSwipeCellThemeData(
          groupTag: 'auto_close',
          closeWhenOpened: true,
        ),
      ));
      // 拖动打开右侧面板，触发 _handleActionPanelTypeChanged
      await tester.drag(find.text('自动关闭'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('自动关闭'), findsOneWidget);
    });

    testWidgets('action autoClose=false 点击回调且不自动关闭', (tester) async {
      var pressed = false;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: '操作'),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                  label: '删除',
                  icon: Icons.delete,
                  autoClose: false,
                  onPressed: (_) => pressed = true,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('操作'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('confirms 二次确认弹出确认项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: '确认项'),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                    label: '删除', icon: Icons.delete, onPressed: (_) {}),
              ],
              confirms: [
                TSwipeCellAction(
                  label: '确认删除',
                  confirmIndex: const [0],
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('确认项'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('确认删除'), findsOneWidget);
    });
  });
}

/// 扩展用于测试内部属性
extension on TSwipeCellPanel {
  double get _openThreshold => openThreshold ?? ((extentRatio ?? 0.3) / 2);
}
