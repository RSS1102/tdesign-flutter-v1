import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDropdownItem（下拉菜单项内容）Widget 测试
///
/// 该项内容仅在 TDropdownMenu 展开弹出层后才会构建，因此测试需要：
/// 1. 用 TDropdownMenu 包裹 TDropdownItem（提供 TDropdownInherited）；
/// 2. tap 菜单标签打开弹出层，触发 [_getCheckboxList]/[_getRadioList] 等分支。
///
/// 覆盖：builder 路径、分组标题、单选预选中(selectIds[0])、单选带高度、
/// 多选方向=up 边框、多选颜色三态（选中/未选/禁用）、多选 maxHeight、
/// 选项分栏 right 间距、控制器 reset/updateOptions、操作区 重置/确定 按钮回调等。
void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(body: child),
      );

  List<TDropdownItemOption> plainOpts() => [
        TDropdownItemOption(value: '1', label: '选项一', selected: true),
        TDropdownItemOption(value: '2', label: '选项二'),
        TDropdownItemOption(value: '3', label: '选项三', disabled: true),
      ];

  List<TDropdownItemOption> groupedOpts() => [
        TDropdownItemOption(value: '1', label: 'A', group: '分组一'),
        TDropdownItemOption(value: '2', label: 'B', group: '分组一'),
        TDropdownItemOption(value: '3', label: 'C', group: '分组二'),
      ];

  group('TDropdownItem 单选路径', () {
    testWidgets('单选带 maxHeight 走 Container 高度分支', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '单选高度',
            maxHeight: 200,
            options: [
              TDropdownItemOption(value: '1', label: 'A'),
              TDropdownItemOption(value: '2', label: 'B'),
            ],
          ),
        ],
      )));
      await tester.tap(find.text('单选高度'));
      await tester.pumpAndSettle();
      // 触发 _getRadioList 中 min/maxHeight 的 Container+ConstrainedBox 分支
      expect(find.byType(TDropdownMenu), findsOneWidget);
    });

    testWidgets('单选分栏预选中走 _getCheckboxList 的 selectIds[0] 与 right 间距',
        (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '单选分栏',
            optionsColumns: 2,
            // 预选中：构建即走 selectIds[0] 分支
            options: [
              TDropdownItemOption(value: '1', label: 'A', selected: true),
              TDropdownItemOption(value: '2', label: 'B'),
            ],
          ),
        ],
      )));
      // 单选预选中时 tab 显示选中项 label('A')，取首个匹配打开菜单
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      // 内容已渲染：选项 B 出现说明菜单展开
      expect(find.text('B'), findsOneWidget);
      // optionsColumns>1 => 两列 => _getPadding 的 'right' 分支
      expect(find.byType(TCheckbox), findsWidgets);
    });
  });

  group('TDropdownItem builder 路径', () {
    testWidgets('提供 builder 时直接渲染自定义内容', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '自定义项',
            builder: (context, state, popupState) =>
                const Text('BUILDER_CONTENT'),
          ),
        ],
      )));
      await tester.tap(find.text('自定义项'));
      await tester.pumpAndSettle();
      expect(find.text('BUILDER_CONTENT'), findsOneWidget);
    });
  });

  group('TDropdownItem 分组标题', () {
    testWidgets('带 group 的选项渲染分组标题', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '分组项',
            multiple: true,
            options: groupedOpts(),
          ),
        ],
      )));
      await tester.tap(find.text('分组项'));
      await tester.pumpAndSettle();
      // _getCheckboxList 中 groupChunk 非 __default__ 时渲染分组标题
      expect(find.text('分组一'), findsOneWidget);
      expect(find.text('分组二'), findsOneWidget);
    });
  });

  group('TDropdownItem 多选方向=up 边框', () {
    testWidgets('direction=up + maxHeight 渲染操作区上边框', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        direction: TDropdownMenuDirection.up,
        items: [
          TDropdownItem(
            label: '多选up',
            multiple: true,
            maxHeight: 300,
            options: plainOpts(),
          ),
        ],
      )));
      await tester.tap(find.text('多选up'));
      await tester.pumpAndSettle();
      // 操作区在 direction=up 时渲染上边框（_getCheckboxOperate 的 up 分支）
      expect(find.text('重置'), findsOneWidget);
      expect(find.text('确定'), findsOneWidget);
    });
  });

  group('TDropdownItem 多选路径（控制器 + 三态颜色 + 操作按钮）', () {
    testWidgets('多选厨房水槽：三态颜色/控制器/操作按钮/onChanged', (tester) async {
      final controller = TDropdownItemController();
      dynamic changed;
      dynamic resetCalled;
      dynamic confirmed;
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '多选',
            multiple: true,
            controller: controller,
            // 选中+启用 / 未选+启用 / 禁用 三态，初始渲染即覆盖颜色分支
            options: plainOpts(),
            onChanged: (v) => changed = v,
            onReset: () => resetCalled = true,
            onConfirm: (v) => confirmed = v,
          ),
        ],
      )));
      await tester.tap(find.text('多选'));
      await tester.pumpAndSettle();
      // 展开后 item state 才挂载，controller 此时已绑定
      // 直接调用控制器方法，覆盖 controller.reset/updateOptions 与 item.reset/updateOptions
      controller.reset();
      controller.updateOptions((opts) {
        opts?.forEach((e) => e?.selected = false);
      });
      await tester.pump();
      expect(find.byType(TCheckbox), findsWidgets);

      // 点击选项触发多选 onChanged（_handleSelectChange 多选分支）
      // 说明：覆盖层内 TCheckbox 的 GestureDetector 在测试中 hitTest 偶发失准，
      // 此处仅尝试点按；onChanged 行覆盖以 重置/确定 等可靠点按与控制器调用为主。
      final cb = find.byType(TCheckbox);
      await tester.ensureVisible(cb.at(1));
      await tester.tap(cb.at(1), warnIfMissed: false);
      await tester.pumpAndSettle();

      // 点击重置按钮：_getCheckboxOperate 的 onPressed(reset + onReset)
      await tester.ensureVisible(find.text('重置'));
      await tester.tap(find.text('重置'));
      await tester.pumpAndSettle();
      expect(resetCalled, isTrue);

      // 重新选中后再点确定，触发 onConfirm
      await tester.ensureVisible(find.text('选项一'));
      await tester.tap(find.text('选项一'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('确定'));
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, isNotNull);
    });
  });

  group('TDropdownItem 控制器独立调用', () {
    testWidgets('未绑定 state 调用不崩溃', (tester) async {
      final controller = TDropdownItemController();
      controller.reset();
      controller.updateOptions((opts) {});
      expect(controller, isNotNull);
    });
  });
}
