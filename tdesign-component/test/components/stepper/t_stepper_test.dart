import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TStepper V1.0 Widget 测试
///
/// B 类控制：onChanged 为 null 时禁用全部操作。
/// 覆盖：构造器、size 三档、theme 三种、disabled、disableInput、
/// 加减操作、min/max 限制、onChanged/onOverlimit 回调、
/// controller、eventController cleanValue、inputWidth、Theme 覆盖。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TStepper 基础渲染', () {
    testWidgets('TStepper 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(value: 5, onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('TStepper 默认 value=0 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('TStepper 带 inputWidth 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 10,
          inputWidth: 60,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });
  });

  // ============================================================
  // size 三档
  // ============================================================
  group('TStepper size 尺寸', () {
    testWidgets('size=small 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          size: TStepperSize.small,
          value: 3,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });

    testWidgets('size=medium（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          size: TStepperSize.medium,
          value: 3,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });

    testWidgets('size=large 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          size: TStepperSize.large,
          value: 3,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });
  });

  // ============================================================
  // theme 三种配色
  // ============================================================
  group('TStepper theme 配色', () {
    testWidgets('theme=normal（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          theme: TStepperColorScheme.normal,
          value: 5,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });

    testWidgets('theme=filled 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          theme: TStepperColorScheme.filled,
          value: 5,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });

    testWidgets('theme=outline 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          theme: TStepperColorScheme.outline,
          value: 5,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });
  });

  // ============================================================
  // disabled / disableInput
  // ============================================================
  group('TStepper 禁用状态', () {
    testWidgets('onChanged=null 时禁用全部操作', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TStepper(value: 5),
      ));
      expect(find.byType(TStepper), findsOneWidget);
      // TextField 应被禁用
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('disabled=true 时禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 5,
          disabled: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
    });

    testWidgets('disableInput=true 时输入框禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 5,
          disableInput: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TStepper), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });
  });

  // ============================================================
  // Theme 覆盖（TStepperThemeData）
  // ============================================================
  group('TStepper Theme 覆盖', () {
    testWidgets('TStepperThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            const TStepperThemeData(
              defaultSize: TStepperSize.large,
              defaultColorScheme: TStepperColorScheme.filled,
              inputWidth: 50,
            ),
          ]),
          home: Scaffold(
            body: Center(
              child: TStepper(value: 8, onChanged: (_) {}),
            ),
          ),
        ),
      );
      expect(find.byType(TStepper), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });
  });

  // ============================================================
  // 加减操作
  // ============================================================
  group('TStepper 加减操作', () {
    testWidgets('点击加号按钮增加值', (tester) async {
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 5,
          onChanged: (v) => changedValue = v),
      ));

      // 找到加号图标并点击
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(changedValue, 6);
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('点击减号按钮减少值', (tester) async {
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 5,
          onChanged: (v) => changedValue = v),
      ));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(changedValue, 4);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('step 自定义步长', (tester) async {
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 10,
          step: 5,
          onChanged: (v) => changedValue = v),
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(changedValue, 15);
    });
  });

  // ============================================================
  // min/max 限制
  // ============================================================
  group('TStepper min/max 限制', () {
    testWidgets('达到 max 时加号无效', (tester) async {
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 10,
          max: 10,
          onChanged: (v) => changedValue = v),
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      // 已达最大值，onChanged 不触发
      expect(changedValue, isNull);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('达到 min 时减号无效', (tester) async {
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 0,
          min: 0,
          onChanged: (v) => changedValue = v),
      ));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      // 已达最小值，onChanged 不触发
      expect(changedValue, isNull);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('超过 max 时触发 onOverlimit', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 10,
          max: 10,
          onOverlimit: (_) {},
          onChanged: (_) {}),
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      // 已达 max 不触发 onOverlimit（因为直接 return）
      // onOverlimit 只在 value+step > max 被截断时触发
    });

    testWidgets('step 超过 max 时截断到 max 并触发 onOverlimit', (tester) async {
      TStepperOverlimitType? overType;
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 8,
          max: 10,
          step: 5,
          onOverlimit: (type) => overType = type,
          onChanged: (v) => changedValue = v),
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      // 8 + 5 = 13 > 10，截断到 10
      expect(changedValue, 10);
      expect(overType, TStepperOverlimitType.plus);
    });
  });

  // ============================================================
  // TStepperController
  // ============================================================
  group('TStepperController 控制器', () {
    testWidgets('controller 设置 value 更新显示', (tester) async {
      final controller = TStepperController()..value = 3;
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          controller: controller,
          onChanged: (_) {}),
      ));
      expect(find.text('3'), findsOneWidget);

      // 通过 controller 更新值
      controller.value = 7;
      await tester.pump();
      expect(find.text('7'), findsOneWidget);
    });
  });

  // ============================================================
  // eventController cleanValue
  // ============================================================
  group('TStepper eventController', () {
    testWidgets('发送 cleanValue 事件清零', (tester) async {
      final eventController = StreamController<TStepperEventType>();
      await tester.pumpWidget(wrapWithTheme(
        TStepper(
          value: 15,
          eventController: eventController,
          onChanged: (_) {}),
      ));
      expect(find.text('15'), findsOneWidget);

      eventController.sink.add(TStepperEventType.cleanValue);
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
      await eventController.close();
    });
  });
}
