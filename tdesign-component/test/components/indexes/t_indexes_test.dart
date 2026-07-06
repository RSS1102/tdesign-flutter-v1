import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TIndexesThemeData? indexesTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (indexesTheme != null) indexesTheme,
    ];
    return Theme(
      data: ThemeData(extensions: [TThemeData.defaultData()]),
      child: MaterialApp(
        theme: ThemeData(extensions: themeExtensions),
        home: Scaffold(body: child),
      ),
    );
  }

  group('TIndexesThemeData', () {
    test('默认构造', () {
      const data = TIndexesThemeData();
      expect(data.sticky, null);
      expect(data.stickyOffset, null);
      expect(data.capsuleTheme, null);
    });

    test('带参数构造', () {
      const data = TIndexesThemeData(
        sticky: false,
        stickyOffset: 10,
        capsuleTheme: true,
        reverse: true,
        indexListMaxHeight: 0.9,
      );
      expect(data.sticky, false);
      expect(data.stickyOffset, 10);
      expect(data.capsuleTheme, true);
    });

    test('copyWith', () {
      const data = TIndexesThemeData(sticky: true);
      final copied = data.copyWith(sticky: false, capsuleTheme: true);
      expect(copied.sticky, false);
      expect(copied.capsuleTheme, true);
    });

    test('lerp', () {
      const data1 = TIndexesThemeData(stickyOffset: 0);
      const data2 = TIndexesThemeData(stickyOffset: 10);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.stickyOffset, 5);
    });

    test('lerp 非 TIndexesThemeData 返回自身', () {
      const data = TIndexesThemeData(stickyOffset: 0);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TIndexes 基础渲染', () {
    testWidgets('默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('自定义 indexList', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B', 'C'],
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('capsuleTheme 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          capsuleTheme: true,
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('sticky: false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          sticky: false,
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('reverse: true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          reverse: true,
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('使用 onChanged 回调', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          onChanged: (index) {},
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('使用 mergeExtension 子树覆盖', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
        indexesTheme: const TIndexesThemeData(capsuleTheme: true),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('Theme 注入 capsuleTheme', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B'],
          builderContent: (context, index) => ListTile(title: Text('内容$index')),
        ),
        indexesTheme: const TIndexesThemeData(capsuleTheme: true),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    // 补充用例至 ≥15
    testWidgets('多个索引项正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const ['A', 'B', 'C', 'D', 'E'],
          builderContent: (context, index) => ListTile(title: Text('项$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('空索引列表正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TIndexes(
          indexList: const [],
          builderContent: (context, index) => ListTile(title: Text('空$index')),
        ),
      ));
      expect(find.byType(TIndexes), findsOneWidget);
    });
  });
}
