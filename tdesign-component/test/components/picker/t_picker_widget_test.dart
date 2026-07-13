import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TPicker widget 级用例', () {
    testWidgets('多列独立数据可构建并渲染选项', (tester) async {
      await tester.pumpWidget(wrap(TPicker(
        items: const TPickerColumns([
          [
            TPickerOption(label: '北京', value: 'bj'),
            TPickerOption(label: '上海', value: 'sh'),
          ],
          [
            TPickerOption(label: '朝阳', value: 'cy'),
            TPickerOption(label: '浦东', value: 'pd'),
          ],
        ]),
        onChanged: (_, __) {},
      )));
      expect(find.byType(TPicker), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);
      expect(find.text('浦东'), findsOneWidget);
    });

    testWidgets('fromRaw 松散数据可构建', (tester) async {
      await tester.pumpWidget(wrap(TPicker(
        items: TPickerColumns.fromRaw(const [
          ['A', 'B', 'C'],
          [
            {'label': '一', 'value': 1},
            {'label': '二', 'value': 2},
          ],
        ]),
        onChanged: (_, __) {},
      )));
      expect(find.byType(TPicker), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('一'), findsOneWidget);
    });

    testWidgets('disabled 整组禁用可构建', (tester) async {
      await tester.pumpWidget(wrap(TPicker(
        items: const TPickerColumns([
          [TPickerOption(label: 'X', value: 'x')],
        ]),
        disabled: true,
        onChanged: (_, __) {},
      )));
      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('itemBuilder 自定义子项可构建', (tester) async {
      await tester.pumpWidget(wrap(TPicker(
        items: const TPickerColumns([
          [
            TPickerOption(label: '甲', value: 'a'),
            TPickerOption(label: '乙', value: 'b', disabled: true),
          ],
        ]),
        itemBuilder: (context, content, colIndex, index, distanceCalculator, distance) {
          if (distance == 0) {
            return Container(key: const Key('centerItem'), child: Text(content));
          }
          return null;
        },
        onChanged: (_, __) {},
      )));
      expect(find.byKey(const Key('centerItem')), findsOneWidget);
    });

    testWidgets('联动数据 TPickerLinked.fromRaw 可构建', (tester) async {
      await tester.pumpWidget(wrap(TPicker(
        items: TPickerLinked.fromRaw(const {
          '广东': {
            '深圳': ['南山', '福田'],
            '广州': ['天河', '越秀'],
          },
          '浙江': {
            '杭州': ['西湖', '滨江'],
          },
        }),
        onChanged: (_, __) {},
      )));
      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('itemCount / height 参数可构建', (tester) async {
      await tester.pumpWidget(wrap(TPicker(
        items: const TPickerColumns([
          [TPickerOption(label: '1', value: 1), TPickerOption(label: '2', value: 2)],
        ]),
        height: 240,
        itemCount: 7,
        onChanged: (_, __) {},
      )));
      expect(find.byType(TPicker), findsOneWidget);
    });
  });
}
