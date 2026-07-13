import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCheckboxGroup / TCheckboxGroupContainer / TCheckboxGroupController 测试
///
/// 覆盖控制器方法（toggle/toggleAll/reverseAll/allChecked/checked）、
/// maxChecked 超限、容器布局（横向/纵向/卡片/多列）与各类断言分支。
void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  /// 捕获构建期抛出的 FlutterError（断言在构造期或异步上报均可能）
  Future<void> expectFlutterError(
      WidgetTester tester, Widget Function() buildWidget) async {
    FlutterError? err;
    try {
      final widget = buildWidget();
      await tester.pumpWidget(wrap(widget));
      await tester.pump();
    } catch (e) {
      if (e is FlutterError) err = e;
    }
    err ??= tester.takeException() as FlutterError?;
    expect(err, isA<FlutterError>());
  }

  List<TCheckbox> checkboxes(List<String> ids) => ids
      .map((id) => TCheckbox(id: id, value: false, onChanged: (_) {}))
      .toList();

  group('TCheckboxGroupController 状态控制', () {
    testWidgets('toggle 勾选并触发 onChanged', (tester) async {
      final c = TCheckboxGroupController();
      List<String>? result;
      await tester.pumpWidget(wrap(TCheckboxGroup(
        controller: c,
        onChanged: (ids) => result = ids,
        child: Row(children: checkboxes(['a', 'b'])),
      )));
      c.toggle('a', true);
      await tester.pump();
      expect(c.checked('a'), isTrue);
      expect(c.allChecked(), contains('a'));
      expect(result, contains('a'));
    });

    testWidgets('toggleAll 全选 / 全部取消', (tester) async {
      final c = TCheckboxGroupController();
      await tester.pumpWidget(wrap(TCheckboxGroup(
        controller: c,
        child: Row(children: checkboxes(['a', 'b', 'c'])),
      )));
      c.toggleAll(true);
      await tester.pump();
      expect(c.allChecked(), unorderedEquals(['a', 'b', 'c']));
      c.toggleAll(false);
      await tester.pump();
      expect(c.allChecked(), isEmpty);
    });

    testWidgets('reverseAll 反选', (tester) async {
      final c = TCheckboxGroupController();
      await tester.pumpWidget(wrap(TCheckboxGroup(
        controller: c,
        child: Row(children: checkboxes(['a', 'b'])),
      )));
      c.toggle('a', true);
      await tester.pump();
      c.reverseAll();
      await tester.pump();
      expect(c.checked('a'), isFalse);
      expect(c.checked('b'), isTrue);
    });

    testWidgets('maxChecked 超限触发 onOverloadChecked', (tester) async {
      final c = TCheckboxGroupController();
      bool overloaded = false;
      await tester.pumpWidget(wrap(TCheckboxGroup(
        controller: c,
        maxChecked: 1,
        onOverloadChecked: () => overloaded = true,
        child: Row(children: checkboxes(['a', 'b'])),
      )));
      c.toggle('a', true);
      await tester.pump();
      // maxChecked=1，第二次勾选应被拒绝
      c.toggle('b', true);
      await tester.pump();
      expect(c.checked('b'), isFalse);
      expect(overloaded, isTrue);
    });

    testWidgets('didUpdateWidget 同步新 value', (tester) async {
      final c = TCheckboxGroupController();
      await tester.pumpWidget(wrap(TCheckboxGroup(
        controller: c,
        value: const ['a'],
        child: Row(children: checkboxes(['a', 'b'])),
      )));
      expect(c.checked('a'), isTrue);
      await tester.pumpWidget(wrap(TCheckboxGroup(
        controller: c,
        value: const ['b'],
        child: Row(children: checkboxes(['a', 'b'])),
      )));
      await tester.pump();
      expect(c.checked('b'), isTrue);
      expect(c.checked('a'), isFalse);
    });
  });

  group('TCheckboxGroupContainer 布局分支', () {
    testWidgets('direction=horizontal 横向排列', (tester) async {
      await tester.pumpWidget(wrap(TCheckboxGroupContainer(
        direction: Axis.horizontal,
        directionalTdCheckboxes: checkboxes(['a', 'b']),
      )));
      expect(find.byType(TCheckboxGroupContainer), findsOneWidget);
    });

    testWidgets('direction=vertical 纵向列表', (tester) async {
      await tester.pumpWidget(wrap(TCheckboxGroupContainer(
        direction: Axis.vertical,
        directionalTdCheckboxes: checkboxes(['a', 'b', 'c']),
      )));
      expect(find.byType(TCheckboxGroupContainer), findsOneWidget);
    });

    testWidgets('cardMode=true 卡片换行布局', (tester) async {
      await tester.pumpWidget(wrap(TCheckboxGroupContainer(
        direction: Axis.horizontal,
        cardMode: true,
        directionalTdCheckboxes: [
          TCheckbox(id: 'a', value: false, cardMode: true, onChanged: (_) {}),
          TCheckbox(id: 'b', value: false, cardMode: true, onChanged: (_) {}),
        ],
      )));
      expect(find.byType(TCheckboxGroupContainer), findsOneWidget);
    });

    testWidgets('rowCount>1 多列布局（末行补位分支）', (tester) async {
      await tester.pumpWidget(wrap(TCheckboxGroupContainer(
        direction: Axis.horizontal,
        rowCount: 3,
        directionalTdCheckboxes: checkboxes(['a', 'b', 'c', 'd']),
      )));
      expect(find.byType(TCheckboxGroupContainer), findsOneWidget);
    });

    testWidgets('passThrough + 非横向 使用裁剪装饰', (tester) async {
      await tester.pumpWidget(wrap(TCheckboxGroupContainer(
        direction: Axis.vertical,
        passThrough: true,
        directionalTdCheckboxes: checkboxes(['a', 'b']),
      )));
      expect(find.byType(TCheckboxGroupContainer), findsOneWidget);
    });

    testWidgets('child 模式（无 direction）', (tester) async {
      await tester.pumpWidget(wrap(TCheckboxGroupContainer(
        child: Row(children: checkboxes(['a', 'b'])),
      )));
      expect(find.byType(TCheckboxGroupContainer), findsOneWidget);
    });
  });

  group('TCheckboxGroupContainer 断言分支', () {
    testWidgets('direction 设置但缺 directionalTdCheckboxes 抛错', (tester) async {
      await expectFlutterError(
        tester,
        () => TCheckboxGroupContainer(
          direction: Axis.horizontal,
          directionalTdCheckboxes: null,
        ),
      );
    });

    testWidgets('无 direction 且无 child 抛错', (tester) async {
      await expectFlutterError(
        tester,
        () => TCheckboxGroupContainer(
          direction: null,
          child: null,
        ),
      );
    });

    testWidgets('横向含 subTitle 抛错', (tester) async {
      await expectFlutterError(
        tester,
        () => TCheckboxGroupContainer(
          direction: Axis.horizontal,
          directionalTdCheckboxes: [
            TCheckbox(id: 'a', value: false, subTitle: '副标题', onChanged: (_) {}),
          ],
        ),
      );
    });

    testWidgets('横向标题超字数（>7）抛错', (tester) async {
      await expectFlutterError(
        tester,
        () => TCheckboxGroupContainer(
          direction: Axis.horizontal,
          directionalTdCheckboxes: [
            TCheckbox(
                id: 'a', value: false, title: '一二三四五六七八', onChanged: (_) {}),
          ],
        ),
      );
    });

    testWidgets('cardMode 但子项 cardMode=false 抛错', (tester) async {
      await expectFlutterError(
        tester,
        () => TCheckboxGroupContainer(
          direction: Axis.horizontal,
          cardMode: true,
          directionalTdCheckboxes: [
            TCheckbox(id: 'a', value: false, cardMode: false, onChanged: (_) {}),
          ],
        ),
      );
    });

    testWidgets('cardMode 横向含 subTitle 抛错', (tester) async {
      await expectFlutterError(
        tester,
        () => TCheckboxGroupContainer(
          direction: Axis.horizontal,
          cardMode: true,
          directionalTdCheckboxes: [
            TCheckbox(
                id: 'a', value: false, cardMode: true, subTitle: '副标题', onChanged: (_) {}),
          ],
        ),
      );
    });
  });
}
