import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TSelectTag] 的选中/未选中、colorScheme、icon、size 与 onChanged 分支。
void main() {
  Widget wrap(Widget child) => Theme(
        data: ThemeData(extensions: [TThemeData.defaultData()]),
        child: MaterialApp(home: Scaffold(body: child)),
      );

  group('TSelectTag', () {
    testWidgets('未选中且无回调（defaultTheme）', (tester) async {
      await tester.pumpWidget(wrap(
        const TSelectTag('标签', value: false),
      ));
      expect(find.byType(TSelectTag), findsOneWidget);
      expect(find.text('标签'), findsOneWidget);
    });

    testWidgets('未选中带 onChanged，点击触发取反回调', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrap(
        TSelectTag(
          '点击',
          value: false,
          colorScheme: TTagColorScheme.primary,
          icon: Icons.star,
          size: TTagSize.small,
          onChanged: (v) => changed = v,
        ),
      ));
      expect(find.byType(TSelectTag), findsOneWidget);
      // 点击触发 onChanged（取反：false -> true）
      await tester.tap(find.byType(TSelectTag));
      await tester.pump();
      expect(changed, isTrue);
    });

    testWidgets('选中态带 colorScheme/icon/size 且 onChanged 为 null',
        (tester) async {
      await tester.pumpWidget(wrap(
        const TSelectTag(
          '选中',
          value: true,
          colorScheme: TTagColorScheme.danger,
          icon: Icons.check,
          size: TTagSize.large,
        ),
      ));
      expect(find.byType(TSelectTag), findsOneWidget);
    });
  });
}
