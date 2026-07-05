import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TDrawerItem', () {
    test('默认构造', () {
      final item = TDrawerItem();
      expect(item.title, null);
      expect(item.icon, null);
      expect(item.content, null);
    });

    test('带参数构造', () {
      const icon = Icon(Icons.add);
      const content = Text('自定义');
      final item = TDrawerItem(title: '标题', icon: icon, content: content);
      expect(item.title, '标题');
      expect(item.icon, icon);
      expect(item.content, content);
    });
  });

  group('TDrawerThemeData', () {
    test('默认构造', () {
      const data = TDrawerThemeData();
      expect(data.width, null);
      expect(data.backgroundColor, null);
      expect(data.bordered, null);
      expect(data.isShowLastBordered, null);
      expect(data.hover, null);
      expect(data.style, null);
    });

    test('带参数构造', () {
      const data = TDrawerThemeData(
        width: 300,
        backgroundColor: Colors.red,
        bordered: false,
        isShowLastBordered: false,
        hover: false,
      );
      expect(data.width, 300);
      expect(data.backgroundColor, Colors.red);
      expect(data.bordered, false);
      expect(data.isShowLastBordered, false);
      expect(data.hover, false);
    });

    test('copyWith', () {
      const data = TDrawerThemeData(width: 280);
      final copied = data.copyWith(width: 320, backgroundColor: Colors.blue);
      expect(copied.width, 320);
      expect(copied.backgroundColor, Colors.blue);
      expect(copied.bordered, null);
    });

    test('lerp', () {
      const data1 = TDrawerThemeData(width: 280, backgroundColor: Colors.red);
      const data2 = TDrawerThemeData(width: 320, backgroundColor: Colors.blue);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.width, 300);
    });

    test('lerp 非 TDrawerThemeData 返回自身', () {
      const data = TDrawerThemeData(width: 280);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TDrawerWidget', () {
    Widget wrapWithTheme(Widget child) {
      return Theme(
        data: ThemeData(extensions: [TThemeData.defaultData()]),
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('使用 child 渲染自定义内容', (tester) async {
      const testKey = Key('custom-child');
      await tester.pumpWidget(wrapWithTheme(
        const TDrawerWidget(
          child: Text('自定义内容', key: testKey),
        ),
      ));
      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('使用 items 渲染列表项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDrawerWidget(
          items: [
            TDrawerItem(title: '菜单1'),
            TDrawerItem(title: '菜单2'),
          ],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      expect(find.text('菜单2'), findsOneWidget);
    });

    testWidgets('使用 title 渲染标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDrawerWidget(
          title: '标题',
          items: [TDrawerItem(title: '菜单1')],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
    });

    testWidgets('使用 footer 渲染底部', (tester) async {
      const footerKey = Key('footer');
      await tester.pumpWidget(wrapWithTheme(
        TDrawerWidget(
          footer: Text('底部', key: footerKey),
          items: [TDrawerItem(title: '菜单1')],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(footerKey), findsOneWidget);
    });

    testWidgets('child 优先级高于 items', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(wrapWithTheme(
        TDrawerWidget(
          child: Text('自定义', key: childKey),
          items: [TDrawerItem(title: '菜单1')],
        ),
      ));
      expect(find.byKey(childKey), findsOneWidget);
      expect(find.text('菜单1'), findsNothing);
    });

    testWidgets('自定义宽度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDrawerWidget(
          width: 300,
          child: SizedBox.expand(),
        ),
      ));
      final container = tester.widget<Container>(
        find.ancestor(of: find.byType(SizedBox), matching: find.byType(Container)).first,
      );
      expect(container.constraints?.maxWidth, 300);
    });

    testWidgets('点击列表项触发 onItemClick', (tester) async {
      int? clickedIndex;
      TDrawerItem? clickedItem;
      await tester.pumpWidget(wrapWithTheme(
        TDrawerWidget(
          items: [TDrawerItem(title: '菜单1')],
          onItemClick: (index, item) {
            clickedIndex = index;
            clickedItem = item;
          },
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('菜单1'));
      await tester.pumpAndSettle();
      expect(clickedIndex, 0);
      expect(clickedItem?.title, '菜单1');
    });
  });

  group('TDrawer', () {
    testWidgets('visible: true 时调用 show', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      items: [TDrawerItem(title: '菜单1')],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
    });

    testWidgets('open 方法打开抽屉', (tester) async {
      TDrawer? drawer;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    drawer = TDrawer(
                      context,
                      items: [TDrawerItem(title: '菜单1')],
                    );
                    drawer?.open();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      // 关闭
      drawer?.close();
      await tester.pumpAndSettle();
    });

    testWidgets('使用 child 自定义内容', (tester) async {
      const childKey = Key('drawer-child');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      child: const Text('自定义内容', key: childKey),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('使用 themeData 提供默认值', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      themeData: const TDrawerThemeData(
                        width: 320,
                        backgroundColor: Colors.yellow,
                      ),
                      items: [TDrawerItem(title: '菜单1')],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
    });

    testWidgets('构造器参数优先级高于 themeData', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      width: 250,
                      themeData: const TDrawerThemeData(width: 320),
                      items: [TDrawerItem(title: '菜单1')],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
    });

    testWidgets('placement: left 从左侧打开', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      placement: TDrawerPlacement.left,
                      items: [TDrawerItem(title: '左抽屉')],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('左抽屉'), findsOneWidget);
    });

    testWidgets('showOverlay: false 不显示遮罩', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      showOverlay: false,
                      items: [TDrawerItem(title: '无遮罩')],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('无遮罩'), findsOneWidget);
    });

    testWidgets('onClose 回调触发', (tester) async {
      bool closed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      visible: true,
                      onClose: () {
                        closed = true;
                      },
                      items: [TDrawerItem(title: '菜单1')],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      // 点击遮罩关闭
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(closed, true);
    });
  });

  group('TDrawerPlacement', () {
    test('枚举值', () {
      expect(TDrawerPlacement.values.length, 2);
      expect(TDrawerPlacement.values, contains(TDrawerPlacement.left));
      expect(TDrawerPlacement.values, contains(TDrawerPlacement.right));
    });
  });
}
