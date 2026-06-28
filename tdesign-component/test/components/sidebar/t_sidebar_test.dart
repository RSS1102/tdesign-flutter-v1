import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TSideBarThemeData? sideBarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (sideBarTheme != null) sideBarTheme,
    ];
    return TTheme(
      data: TThemeData.defaultData(),
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

  group('TSideBarStyle', () {
    test('枚举值', () {
      expect(TSideBarStyle.values.length, 2);
      expect(TSideBarStyle.values, contains(TSideBarStyle.normal));
      expect(TSideBarStyle.values, contains(TSideBarStyle.outline));
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
          style: TSideBarStyle.normal,
          children: buildItems(),
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('outline 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          style: TSideBarStyle.outline,
          children: buildItems(),
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('使用 ThemeData 设置默认 style', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(children: buildItems()),
        sideBarTheme: const TSideBarThemeData(style: TSideBarStyle.outline),
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
          children: [
            const TSideBarItem(value: 0, label: '可用'),
            const TSideBarItem(value: 1, label: '禁用', disabled: true),
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
      int callCount = 0;
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

    testWidgets('使用 themeData 参数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          children: buildItems(),
          themeData: const TSideBarThemeData(height: 600),
        ),
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
}
