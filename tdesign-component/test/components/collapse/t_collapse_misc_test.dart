import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/collapse/t_collapse_salted_key.dart';
import 'package:tdesign_flutter/src/components/collapse/t_nonanimated_expand_icon.dart';

/// 覆盖 t_collapse_salted_key.dart 的 toString 和 t_nonanimated_expand_icon.dart 的深色主题分支
void main() {
  group('TCollapseSaltedKey', () {
    test('toString 两个 String 泛型参数加引号', () {
      final key = TCollapseSaltedKey<String, String>('salt', 'value');
      final str = key.toString();
      expect(str, contains("salt"));
      expect(str, contains("value"));
    });

    test('toString 非 String 泛型参数不加引号', () {
      final key = TCollapseSaltedKey<int, int>(1, 2);
      final str = key.toString();
      expect(str, contains('1'));
      expect(str, contains('2'));
    });

    test('toString 混合泛型 String+int', () {
      final key = TCollapseSaltedKey<String, int>('hello', 42);
      final str = key.toString();
      expect(str, contains('hello'));
      expect(str, contains('42'));
    });

    test('toString 混合泛型 int+String', () {
      final key = TCollapseSaltedKey<int, String>(10, 'world');
      final str = key.toString();
      expect(str, contains('10'));
      expect(str, contains('world'));
    });

    test('== 相同参数返回 true', () {
      final k1 = TCollapseSaltedKey<String, int>('a', 1);
      final k2 = TCollapseSaltedKey<String, int>('a', 1);
      expect(k1 == k2, isTrue);
    });

    test('== 不同参数返回 false', () {
      final k1 = TCollapseSaltedKey<String, int>('a', 1);
      final k2 = TCollapseSaltedKey<String, int>('b', 2);
      expect(k1 == k2, isFalse);
    });
  });

  group('TNonAnimatedExpandIcon', () {
    testWidgets('深色主题下返回 white60', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          extensions: [TThemeData.defaultData()],
        ),
        home: const Scaffold(
          body: TNonAnimatedExpandIcon(isExpanded: false, padding: EdgeInsets.zero),
        ),
      ));
      expect(find.byType(TNonAnimatedExpandIcon), findsOneWidget);
    });

    testWidgets('浅色主题下正常渲染', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          extensions: [TThemeData.defaultData()],
        ),
        home: const Scaffold(
          body: TNonAnimatedExpandIcon(isExpanded: true, padding: EdgeInsets.zero),
        ),
      ));
      expect(find.byType(TNonAnimatedExpandIcon), findsOneWidget);
    });
  });
}
