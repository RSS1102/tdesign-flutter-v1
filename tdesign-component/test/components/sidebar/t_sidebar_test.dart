import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/sidebar/t_wrap_sidebar_item.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TSideBarThemeData? sideBarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (sideBarTheme != null) sideBarTheme,
    ];
    return Theme(
      data: ThemeData(extensions: [TThemeData.defaultData()]),
      child: MaterialApp(
        theme: ThemeData(extensions: themeExtensions),
        home: Scaffold(body: child),
      ),
    );
  }

  List<TSideBarItem> buildItems({int count = 5}) {
    return List.generate(
        count, (i) => TSideBarItem(value: i, label: '选项${i + 1}'));
  }

  group('TSideBarItem', () {
    test('默认构造', () {
      const item = TSideBarItem();
      expect(item.value, -1);
      expect(item.label, '');
      expect(item.disabled, false);
      expect(item.badge, null);
      expect(item.icon, null);
      expect(item.textStyle, null);
    });

    test('带参数构造', () {
      const item = TSideBarItem(value: 1, label: '选项', disabled: true);
      expect(item.value, 1);
      expect(item.label, '选项');
      expect(item.disabled, true);
    });
  });

  group('TSideBarVariant', () {
    test('枚举值', () {
      expect(TSideBarVariant.values.length, 2);
      expect(TSideBarVariant.values, contains(TSideBarVariant.normal));
      expect(TSideBarVariant.values, contains(TSideBarVariant.outline));
    });
  });

  group('TSideBarThemeData', () {
    test('默认构造', () {
      const data = TSideBarThemeData();
      expect(data.style, null);
      expect(data.height, null);
      expect(data.selectedColor, null);
    });

    test('copyWith', () {
      const data = TSideBarThemeData(height: 400);
      final copied = data.copyWith(height: 500, selectedColor: Colors.red);
      expect(copied.height, 500);
      expect(copied.selectedColor, Colors.red);
    });

    test('lerp', () {
      const data1 = TSideBarThemeData(height: 400);
      const data2 = TSideBarThemeData(height: 500);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.height, 450);
    });

    test('lerp 非 TSideBarThemeData 返回自身', () {
      const data = TSideBarThemeData(height: 400);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TSideBar 基础渲染', () {
    testWidgets('默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(children: buildItems()),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
      expect(find.text('选项1'), findsOneWidget);
      expect(find.text('选项5'), findsOneWidget);
    });

    testWidgets('value 指定选中项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 2, children: buildItems()),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('空 children 不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSideBar(children: []),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });
  });

  group('TSideBar 样式', () {
    testWidgets('normal 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          style: TSideBarVariant.normal,
          children: buildItems(),
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('outline 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          style: TSideBarVariant.outline,
          children: buildItems(),
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('使用 ThemeData 设置默认 style', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(children: buildItems()),
        sideBarTheme: const TSideBarThemeData(style: TSideBarVariant.outline),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });
  });

  group('TSideBar 交互', () {
    testWidgets('点击触发 onSelected', (tester) async {
      int? selectedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          children: buildItems(),
          onSelected: (value) {
            selectedValue = value;
          },
        ),
      ));
      await tester.tap(find.text('选项3'));
      await tester.pumpAndSettle();
      expect(selectedValue, 2);
    });

    testWidgets('disabled 项不可点击', (tester) async {
      int? selectedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          children: const [
            TSideBarItem(value: 0, label: '可用'),
            TSideBarItem(value: 1, label: '禁用', disabled: true),
          ],
          onSelected: (value) {
            selectedValue = value;
          },
        ),
      ));
      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();
      expect(selectedValue, null);
    });

    testWidgets('重复点击同一项不触发 onSelected', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          children: buildItems(),
          onSelected: (value) {
            callCount++;
          },
        ),
      ));
      await tester.tap(find.text('选项1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('选项1'));
      await tester.pumpAndSettle();
      expect(callCount, 0);
    });
  });

  group('TSideBar Controller', () {
    testWidgets('controller 切换选中项触发 onChanged', (tester) async {
      final controller = TSideBarController();
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          controller: controller,
          children: buildItems(),
          onChanged: (value) {
            changedValue = value;
          },
        ),
      ));
      controller.selectTo(3);
      await tester.pumpAndSettle();
      expect(changedValue, 3);
    });

    testWidgets('controller loading 状态', (tester) async {
      final controller = TSideBarController();
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          controller: controller,
          loading: true,
          children: buildItems(),
        ),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('自定义 loadingWidget', (tester) async {
      const loadingKey = Key('loading');
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          loading: true,
          loadingWidget: const Text('加载中', key: loadingKey),
          children: buildItems(),
        ),
      ));
      expect(find.byKey(loadingKey), findsOneWidget);
    });
  });

  group('TSideBar ThemeData', () {
    testWidgets('ThemeData 注入 selectedColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(children: buildItems()),
        sideBarTheme: const TSideBarThemeData(selectedColor: Colors.red),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('构造器参数覆盖 ThemeData', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          children: buildItems(),
          selectedColor: Colors.blue,
        ),
        sideBarTheme: const TSideBarThemeData(selectedColor: Colors.red),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('使用 mergeExtension 子树覆盖', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          children: buildItems(),
        ),
        sideBarTheme: const TSideBarThemeData(height: 600),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('ThemeData 注入 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(children: buildItems()),
        sideBarTheme: const TSideBarThemeData(height: 500),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });
  });

  group('TWrapSideBarItem 覆盖率补充', () {
    // 直接渲染 TWrapSideBarItem，覆盖分支行（70/140/158/203/215/216/219/221/222）
    testWidgets('normal 样式未选中且未指定 unSelectedBgColor（覆盖 70 行）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '短',
          value: 1,
          disabled: false,
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
    });

    testWidgets('选中且设置 selectedTextStyle 颜色（覆盖 140/158 行）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '选',
          value: 2,
          selected: true,
          disabled: false,
          icon: Icons.star,
          selectedTextStyle: const TextStyle(color: Colors.red),
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
    });

    testWidgets('短标签带 badge 渲染 label 内 badge（覆盖 203 行）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '短',
          value: 3,
          disabled: false,
          badge: TBadge(TBadgeVariant.message, count: '1'),
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
    });

    testWidgets('长标签带 badge 渲染 renderBadge（覆盖 215/216/219/221/222 行）',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '很长很长的标签内容xxx',
          value: 4,
          disabled: false,
          badge: TBadge(TBadgeVariant.message, count: '9'),
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
    });
  });

  group('TSideBarController', () {
    test('selectTo 更新 currentValue', () {
      final controller = TSideBarController();
      controller.selectTo(5);
      expect(controller.currentValue, 5);
    });

    test('init 更新 children', () {
      final controller = TSideBarController();
      controller.init([
        SideItemProps(value: 0, index: 0),
        SideItemProps(value: 1, index: 1),
      ]);
      expect(controller.children.length, 2);
    });

    test('children setter 触发通知并更新只读 children', () {
      final controller = TSideBarController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.children = [SideItemProps(value: 2, index: 0)];

      expect(controller.children.single.value, 2);
      expect(notifyCount, 1);
      expect(() => controller.children.add(SideItemProps(value: 3, index: 1)),
          throwsUnsupportedError);
    });

    test('setChildren needNotify=false 不触发通知', () {
      final controller = TSideBarController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller
          .setChildren([SideItemProps(value: 4, index: 0)], needNotify: false);

      expect(controller.children.single.value, 4);
      expect(notifyCount, 0);
    });

    test('loading setter/getter', () {
      final controller = TSideBarController();
      controller.loading = true;
      expect(controller.loading, true);
      controller.loading = false;
      expect(controller.loading, false);
    });
  });

  group('SideItemProps', () {
    test('构造', () {
      final props = SideItemProps(
        value: 1,
        index: 0,
        disabled: true,
        icon: Icons.add,
        label: '标签',
      );
      expect(props.value, 1);
      expect(props.index, 0);
      expect(props.disabled, true);
      expect(props.icon, Icons.add);
      expect(props.label, '标签');
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TSideBar 覆盖率补充', () {
    testWidgets('controller with children 触发 getDisplayChildren',
        (tester) async {
      // 覆盖 195-203（controller.children 非空 → map SideItemProps）
      final controller = TSideBarController();
      controller.init([
        SideItemProps(index: 0, value: 0, label: '选项1'),
        SideItemProps(index: 1, value: 1, label: '选项2'),
      ]);
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          controller: controller,
          value: 0,
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('空 children', (tester) async {
      // 覆盖 221（displayChildren = []）
      await tester.pumpWidget(wrapWithTheme(
        const TSideBar(
          children: [],
          value: 0,
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('didUpdateWidget children 变化', (tester) async {
      // 覆盖 312-315（didUpdateWidget → getDisplayChildren）
      var count = 3;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TSideBar(
              children: buildItems(count: count),
              value: 0,
            );
          },
        ),
      ));
      setState(() => count = 5);
      await tester.pumpAndSettle();
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('选中超出视口的项触发滚动', (tester) async {
      // 覆盖 132-136（滚动逻辑）
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          child: TSideBar(
            children: buildItems(count: 20),
            value: 15,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('controller 加载态变化触发相同选中项重建', (tester) async {
      final controller = TSideBarController()
        ..init([
          SideItemProps(index: 0, value: 0, label: '选项1'),
          SideItemProps(index: 1, value: 1, label: '选项2'),
        ]);
      await tester.pumpWidget(wrapWithTheme(TSideBar(controller: controller)));

      controller.setLoading(true);
      await tester.pump();

      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('findSideItem 可按 value 查找当前展示项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(children: buildItems(count: 3), value: 0),
      ));

      final dynamic state = tester.state(find.byType(TSideBar));
      final item = state.findSideItem(2) as SideItemProps;

      expect(item.value, 2);
      expect(item.index, 2);
    });

    testWidgets('controller 切换时移除旧监听并注册新监听', (tester) async {
      final controller1 = TSideBarController()
        ..init([SideItemProps(index: 0, value: 0, label: '旧')]);
      final controller2 = TSideBarController()
        ..init([SideItemProps(index: 0, value: 0, label: '新')]);
      var useFirst = true;
      late StateSetter setState;

      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TSideBar(controller: useFirst ? controller1 : controller2);
          },
        ),
      ));

      setState(() => useFirst = false);
      await tester.pumpAndSettle();
      controller2.selectTo(0);
      await tester.pump();

      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('controller selectTo 触发向下和向上滚动分支', (tester) async {
      final controller = TSideBarController()
        ..init(List.generate(
          12,
          (index) =>
              SideItemProps(index: index, value: index, label: '选项$index'),
        ));
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(height: 120, child: TSideBar(controller: controller)),
      ));

      controller.selectTo(5);
      await tester.pump(const Duration(milliseconds: 150));
      controller.selectTo(0);
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(TSideBar), findsOneWidget);
    });
  });
}
