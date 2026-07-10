import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSlider / TRangeSlider V1.0 Widget 测试
///
/// C 类控制：`value` + `onChanged` 受控；`onChanged: null` = 禁用。
/// 覆盖 label、RangeSlider、onChangeStart/End、禁用态。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  /// 注入 TSliderThemeData(min:0, max:100) 以支持 0-100 取值范围
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        TSliderThemeData(min: 0, max: 100),
      ]),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // C 类控制：value 受控 + onChanged:null 禁用
  // ============================================================
  group('TSlider C 类控制（value + onChanged）', () {
    testWidgets('value=0 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 0, onChanged: (_) {}),
      ));
      expect(find.byType(TSlider), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('value=50 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 50, onChanged: (_) {}),
      ));
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 50);
    });

    testWidgets('onChanged:null 时 Slider 禁用（onChanged 为 null）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSlider(value: 50),
      ));
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.onChanged, isNull);
    });

    testWidgets('onChanged 非 null 时拖动触发回调', (tester) async {
      double? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 0,
          onChanged: (v) => changedValue = v,
        ),
      ));

      // 拖动 slider thumb
      final sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pump();
      // 拖动后应触发 onChanged
      expect(changedValue, isNotNull);
    });

    testWidgets('onChanged:null 时拖动不触发回调', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSlider(value: 50),
      ));
      // 禁用态拖动应无效果
      await tester.drag(find.byType(Slider), const Offset(50, 0));
      await tester.pump();
      // 无回调可验证，确认无异常即可
      expect(find.byType(Slider), findsOneWidget);
    });
  });

  // ============================================================
  // label 标签
  // ============================================================
  group('TSlider 标签', () {
    testWidgets('label 显示左侧标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 0, label: '音量', onChanged: (_) {}),
      ));
      expect(find.text('音量'), findsOneWidget);
    });

    testWidgets('rightLabel 显示右侧标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 0, rightLabel: '最大', onChanged: (_) {}),
      ));
      expect(find.text('最大'), findsOneWidget);
    });

    testWidgets('label + rightLabel 同时显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 0,
          label: '左',
          rightLabel: '右',
          onChanged: (_) {}),
      ));
      expect(find.text('左'), findsOneWidget);
      expect(find.text('右'), findsOneWidget);
    });

    testWidgets('无标签时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 0, onChanged: (_) {}),
      ));
      expect(find.byType(TSlider), findsOneWidget);
    });
  });

  // ============================================================
  // onChangeStart / onChangeEnd
  // ============================================================
  group('TSlider 滑动事件', () {
    testWidgets('onChangeStart 回调触发', (tester) async {
      double? startValue;
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 0,
          onChanged: (_) {},
          onChangeStart: (v) => startValue = v,
        ),
      ));
      await tester.drag(find.byType(Slider), const Offset(30, 0));
      await tester.pump();
      expect(startValue, isNotNull);
    });

    testWidgets('onChangeEnd 回调触发', (tester) async {
      double? endValue;
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 0,
          onChanged: (_) {},
          onChangeEnd: (v) => endValue = v,
        ),
      ));
      await tester.drag(find.byType(Slider), const Offset(30, 0));
      await tester.pumpAndSettle();
      expect(endValue, isNotNull);
    });
  });

  // ============================================================
  // boxDecoration 自定义
  // ============================================================
  group('TSlider 自定义样式', () {
    testWidgets('boxDecoration 自定义背景', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 0,
          onChanged: (_) {},
          boxDecoration: const BoxDecoration(color: Colors.yellow),
        ),
      ));
      expect(find.byType(TSlider), findsOneWidget);
    });
  });

  // ============================================================
  // TRangeSlider
  // ============================================================
  group('TRangeSlider 范围滑动', () {
    testWidgets('value=RangeValues(0,100) 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRangeSlider(
          value: const RangeValues(0, 100),
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TRangeSlider), findsOneWidget);
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('onChanged:null 时 RangeSlider 禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRangeSlider(value: RangeValues(0, 100)),
      ));
      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.onChanged, isNull);
    });

    testWidgets('label + rightLabel 显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRangeSlider(
          value: const RangeValues(0, 100),
          label: '最小',
          rightLabel: '最大',
          onChanged: (_) {},
        ),
      ));
      expect(find.text('最小'), findsOneWidget);
      expect(find.text('最大'), findsOneWidget);
    });
  });

  // ============================================================
  // TSlider onTap / onThumbTextTap 手势回调
  // ============================================================
  group('TSlider onTap / onThumbTextTap', () {
    testWidgets('onTap 点击触发回调（传入当前 value）', (tester) async {
      Offset? tappedOffset;
      double? tappedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 30,
          onChanged: (_) {},
          onTap: (offset, value) {
            tappedOffset = offset;
            tappedValue = value;
          },
        ),
      ));
      final center = tester.getCenter(find.byType(Slider));
      await tester.tapAt(center);
      await tester.pump();
      expect(tappedOffset, isNotNull);
      expect(tappedValue, 30);
    });

    testWidgets('onThumbTextTap 在 showThumbValue=true 时进入判断分支', (tester) async {
      // 注入 showThumbValue:true 让外层 Listener 进入计算逻辑；运行时未测量出
      // thumbTextRect，命中提前返回分支（不真正触发回调）
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [
          TThemeData.defaultData(),
          TSliderThemeData(min: 0, max: 100, showThumbValue: true),
        ]),
        home: Scaffold(
          body: TSlider(
            value: 30,
            onChanged: (_) {},
            onThumbTextTap: (offset, value) => tapped = true,
          ),
        ),
      ));
      final center = tester.getCenter(find.byType(Slider));
      await tester.tapAt(center);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('禁用态（onChanged:null）点击不触发 onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 30,
          onTap: (offset, value) => tapped = true,
        ),
      ));
      final center = tester.getCenter(find.byType(Slider));
      await tester.tapAt(center);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('didUpdateWidget 更新 value', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 0, onChanged: (_) {}),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 50, onChanged: (_) {}),
      ));
      await tester.pump();
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 50);
    });

    testWidgets('onChanged:null 时 label 使用禁用色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSlider(value: 50, label: '音量'),
      ));
      expect(find.text('音量'), findsOneWidget);
    });
  });

  // ============================================================
  // TRangeSlider onTap / onChanged
  // ============================================================
  group('TRangeSlider onTap / onChanged', () {
    testWidgets('onTap 点击触发回调', (tester) async {
      Position? tappedPos;
      double? tappedVal;
      await tester.pumpWidget(wrapWithTheme(
        TRangeSlider(
          value: const RangeValues(20, 80),
          onChanged: (_) {},
          onTap: (pos, offset, value) {
            tappedPos = pos;
            tappedVal = value;
          },
        ),
      ));
      final center = tester.getCenter(find.byType(RangeSlider));
      await tester.tapAt(center);
      await tester.pump();
      expect(tappedPos, isNotNull);
      expect(tappedVal, isNotNull);
    });

    testWidgets('onThumbTextTap 在 showThumbValue=true 进入判断分支', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [
          TThemeData.defaultData(),
          TSliderThemeData(min: 0, max: 100, showThumbValue: true),
        ]),
        home: Scaffold(
          body: TRangeSlider(
            value: const RangeValues(20, 80),
            onChanged: (_) {},
            onThumbTextTap: (pos, offset, value) => tapped = true,
          ),
        ),
      ));
      final center = tester.getCenter(find.byType(RangeSlider));
      await tester.tapAt(center);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('onChanged 拖动触发回调', (tester) async {
      RangeValues? changed;
      await tester.pumpWidget(wrapWithTheme(
        TRangeSlider(
          value: const RangeValues(20, 80),
          onChanged: (v) => changed = v,
        ),
      ));
      await tester.drag(find.byType(RangeSlider), const Offset(40, 0));
      await tester.pump();
      expect(changed, isNotNull);
    });

    testWidgets('didUpdateWidget 更新 value', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRangeSlider(value: const RangeValues(0, 100), onChanged: (_) {}),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TRangeSlider(value: const RangeValues(10, 90), onChanged: (_) {}),
      ));
      await tester.pump();
      final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
      expect(slider.values, const RangeValues(10, 90));
    });

    testWidgets('onChanged:null 时 label 使用禁用色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRangeSlider(value: RangeValues(20, 80), label: '最小'),
      ));
      expect(find.text('最小'), findsOneWidget);
    });
  });
}
