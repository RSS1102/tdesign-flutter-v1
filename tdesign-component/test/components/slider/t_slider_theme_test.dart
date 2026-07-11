import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/slider/t_slider_theme.dart';

/// TSliderThemeData 及其所有自定义 Slider/RangeSlider shape 的测试。
///
/// paint 方法通过真实渲染 Slider/RangeSlider（注入对应 SliderTheme）来覆盖。
void main() {
  TThemeData readToken(BuildContext context) =>
      Theme.of(context).extension<TThemeData>()!;

  /// 用给定主题渲染 Slider 或 RangeSlider。
  Widget build(
    TSliderThemeData theme, {
    required bool range,
    bool rtl = false,
    bool disabled = false,
    double value = 0.5,
    RangeValues rangeValues = const RangeValues(0.3, 0.7),
  }) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData(), theme]),
      home: Builder(builder: (context) {
        final token = readToken(context);
        final sTheme = theme.sliderThemeData(token);
        final child = range
            ? RangeSlider(
                values: rangeValues,
                onChanged: disabled ? null : (v) {},
                divisions: theme.divisions,
                labels: theme.divisions != null
                    ? RangeLabels('${rangeValues.start}', '${rangeValues.end}')
                    : null,
              )
            : Slider(
                value: value,
                onChanged: disabled ? null : (v) {},
                divisions: theme.divisions,
                label: theme.divisions != null ? '$value' : null,
              );
        return Directionality(
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          child: Material(
            child: SliderTheme(
              data: sTheme.copyWith(overlappingShapeStrokeColor: Colors.transparent),
              child: child,
            ),
          ),
        );
      }),
    );
  }

  group('TSliderThemeData ThemeExtension', () {
    test('默认构造字段', () {
      final data = TSliderThemeData();
      expect(data.showScaleValue, isFalse);
      expect(data.showThumbValue, isFalse);
      expect(data.divisions, isNull);
      expect(data.min, 0.0);
      expect(data.max, 1.0);
      expect(data.activeTrackColor, isNull);
      expect(data.inactiveTrackColor, isNull);
    });

    test('capsule 构造 _capsule 为 true', () {
      final data = TSliderThemeData.capsule(min: 0, max: 100);
      expect(data.min, 0.0);
      expect(data.max, 100.0);
    });

    test('copyWith 复制并覆写字段', () {
      final base = TSliderThemeData();
      final copied = base.copyWith(
        showScaleValue: true,
        divisions: 10,
        scaleFormatter: null,
        activeTrackColor: Colors.red,
      );
      expect(copied.showScaleValue, isTrue);
      expect(copied.divisions, 10);
      expect(copied.activeTrackColor, Colors.red);
      expect(copied.showThumbValue, base.showThumbValue);
      expect(copied.min, base.min);
    });

    test('lerp 阈值切换（t<0.5 返回 this，t>=0.5 返回 other）', () {
      final a = TSliderThemeData(divisions: 1);
      final b = TSliderThemeData(divisions: 2);
      expect(a.lerp(b, 0.0), same(a));
      expect(a.lerp(b, 0.4), same(a));
      expect(a.lerp(b, 0.5), same(b));
      expect(a.lerp(b, 1.0), same(b));
    });

    test('lerp 非 TSliderThemeData 返回自身', () {
      final a = TSliderThemeData(divisions: 1);
      expect(a.lerp(null, 0.5), same(a));
    });

    test('sliderThemeData 返回 SliderThemeData 并缓存', () {
      final data = TSliderThemeData(min: 0, max: 100);
      final token = TThemeData.defaultData();
      final first = data.sliderThemeData(token);
      final second = data.sliderThemeData(token);
      expect(first, same(second));
      expect(first.trackHeight, 4);
    });

    test('updateSliderThemeData 通过回调更新缓存', () {
      final data = TSliderThemeData(min: 0, max: 100);
      final token = TThemeData.defaultData();
      final before = data.sliderThemeData(token);
      data.updateSliderThemeData(token, (d) => d.copyWith(activeTrackColor: Colors.green));
      final after = data.sliderThemeData(token);
      expect(before, isNot(same(after)));
      expect(after.activeTrackColor, Colors.green);
    });

    test('effective* 文本样式 getter（带/不带 token）', () {
      final withToken = TSliderThemeData().sliderThemeData(TThemeData.defaultData());
      expect(withToken, isA<SliderThemeData>());
      final data = TSliderThemeData(
        thumbTextStyle: const TextStyle(fontSize: 12),
        scaleTextStyle: const TextStyle(fontSize: 10),
      );
      expect(data.effectiveThumbTextStyle, isA<TextStyle>());
      expect(data.effectiveDisabledThumbTextStyle, isA<TextStyle>());
      expect(data.effectiveScaleTextStyle, isA<TextStyle>());
      expect(data.effectiveDisabledScaleTextStyle, isA<TextStyle>());
      // 先设置 token 后再取（覆盖 _token 分支）
      data.sliderThemeData(TThemeData.defaultData());
      expect(data.effectiveThumbTextStyle, isA<TextStyle>());
    });

    test('normal/capsule 构建对应自定义 shape', () {
      final token = TThemeData.defaultData();
      final normal = TSliderThemeData(min: 0, max: 100).normal(token);
      expect(normal.trackShape, isA<TRoundedRectSliderTrackShape>());
      expect(normal.thumbShape, isA<TRoundSliderThumbShape>());
      expect(normal.tickMarkShape, isA<TRoundSliderTickMarkShape>());
      expect(normal.rangeTrackShape, isA<TRoundedRectRangeSliderTrackShape>());
      final capsule = TSliderThemeData.capsule(min: 0, max: 100).capsule(token);
      expect(capsule.trackShape, isA<TCapsuleRectSliderTrackShape>());
      expect(capsule.thumbShape, isA<TCapsuleSliderThumbShape>());
      expect(capsule.tickMarkShape, isA<TCapsuleSliderTickMarkShape>());
    });

    test('SliderMeasureData 字段可写', () {
      final m = SliderMeasureData();
      m.trackerRect = Rect.zero;
      m.thumbCenter = Offset.zero;
      m.thumbTextRect = Rect.zero;
      m.startRangeThumbTextRect = Rect.zero;
      m.endRangeThumbTextRect = Rect.zero;
      expect(m.trackerRect, Rect.zero);
    });
  });

  group('Slider shape getPreferredSize', () {
    final td = TSliderThemeData();
    test('各 thumb shape 在 enabled/disabled 下尺寸', () {
      expect(
          TRoundSliderThumbShape(themeData: td, strokeColor: Colors.transparent)
              .getPreferredSize(true, false)
              .width,
          20.0);
      expect(
          TRoundSliderThumbShape(themeData: td, strokeColor: Colors.transparent)
              .getPreferredSize(false, false)
              .width,
          20.0);
      expect(
          TRoundRangeSliderThumbShape(themeData: td, strokeColor: Colors.transparent)
              .getPreferredSize(true, false)
              .width,
          20.0);
      expect(
          TCapsuleSliderThumbShape(themeData: td, strokeColor: Colors.transparent)
              .getPreferredSize(true, false)
              .width,
          18.0);
      expect(
          TCapsuleRangeSliderThumbShape(themeData: td, strokeColor: Colors.transparent)
              .getPreferredSize(true, false)
              .width,
          18.0);
    });

    test('各 tick mark shape getPreferredSize', () {
      expect(
          TRoundSliderTickMarkShape(themeData: td)
              .getPreferredSize(sliderTheme: SliderThemeData(trackHeight: 4), isEnabled: true)
              .width,
          8.0);
      expect(
          TRoundRangeSliderTickMarkShape(themeData: td)
              .getPreferredSize(sliderTheme: SliderThemeData(trackHeight: 4), isEnabled: true)
              .width,
          8.0);
      expect(
          TCapsuleSliderTickMarkShape(themeData: td)
              .getPreferredSize(sliderTheme: SliderThemeData(trackHeight: 4), isEnabled: true)
              .width,
          8.0);
      expect(
          TCapsuleRangeSliderTickMarkShape(themeData: td)
              .getPreferredSize(sliderTheme: SliderThemeData(trackHeight: 4), isEnabled: true)
              .width,
          8.0);
    });

    test('TCapsuleTrackShape.adjustThumbCenter 限制范围', () {
      final shape = _AdjustHelper();
      final rect = Rect.fromLTRB(0, 0, 100, 24);
      final center = shape.adjust(Offset(50, 12), rect);
      expect(center.dx, greaterThanOrEqualTo(rect.left + 12));
      expect(center.dx, lessThanOrEqualTo(rect.right - 12));
    });

    test('TCapsuleRectAdjustment 辅助方法', () {
      final shape = TCapsuleRectSliderTrackShape(
        themeData: TSliderThemeData.capsule(divisions: 4),
        trackColorWhenShowScale: Colors.red,
      );
      expect(shape.hasDivisions(), isTrue);
      expect(shape.extraPadding(), 12);
      expect(shape.trackPadding(), 0);
    });
  });

  group('普通 Slider 渲染（覆盖 paint）', () {
    testWidgets('ltr 启用 + divisions', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100, divisions: 5),
        range: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('rtl 启用', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100),
        range: false,
        rtl: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('disabled（onChanged=null）', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100),
        range: false,
        disabled: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('showThumbValue 绘制游标文本', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100, showThumbValue: true, divisions: 5),
        range: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('showScaleValue + divisions 绘制刻度文本', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(
          min: 0,
          max: 100,
          showScaleValue: true,
          divisions: 10,
          scaleFormatter: (v) => '${v.toInt()}',
        ),
        range: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('showThumbValue + showScaleValue 同时开启', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(
          min: 0,
          max: 100,
          showThumbValue: true,
          showScaleValue: true,
          divisions: 5,
          scaleFormatter: (v) => '${v.toInt()}',
        ),
        range: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('rtl + divisions 绘制刻度与 rtl 分支（651-658）', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100, divisions: 5),
        range: false,
        rtl: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });
  });

  group('普通 RangeSlider 渲染（覆盖 paint）', () {
    testWidgets('ltr 启用 + divisions', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100, divisions: 5),
        range: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('rtl 启用', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100),
        range: true,
        rtl: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('showThumbValue 绘制游标文本', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100, showThumbValue: true, divisions: 5),
        range: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('showScaleValue + divisions 绘制刻度文本', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(
          min: 0,
          max: 100,
          showScaleValue: true,
          divisions: 10,
          scaleFormatter: (v) => '${v.toInt()}',
        ),
        range: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('disabled（onChanged=null）', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100),
        range: true,
        disabled: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('thumbs 重叠绘制 overlappingStroke（999-1003）', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData(min: 0, max: 100, divisions: 5),
        range: true,
        rangeValues: const RangeValues(0.499, 0.501),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });
  });

  group('胶囊 Slider 渲染（覆盖 paint）', () {
    testWidgets('ltr 启用 + showScaleValue', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(
          min: 0,
          max: 100,
          showScaleValue: true,
          divisions: 10,
          scaleFormatter: (v) => '${v.toInt()}',
        ),
        range: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('rtl 启用 + showThumbValue', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(
          min: 0,
          max: 100,
          showThumbValue: true,
        ),
        range: false,
        rtl: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('showThumbValue + showScaleValue 同时开启', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(
          min: 0,
          max: 100,
          showThumbValue: true,
          showScaleValue: true,
          divisions: 5,
          scaleFormatter: (v) => '${v.toInt()}',
        ),
        range: false,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(Slider), findsOneWidget);
    });
  });

  group('胶囊 RangeSlider 渲染（覆盖 paint）', () {
    testWidgets('ltr 启用 + showScaleValue', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(
          min: 0,
          max: 100,
          showScaleValue: true,
          divisions: 10,
          scaleFormatter: (v) => '${v.toInt()}',
        ),
        range: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('rtl 启用 + showThumbValue', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(
          min: 0,
          max: 100,
          showThumbValue: true,
        ),
        range: true,
        rtl: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('disabled（onChanged=null）', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(min: 0, max: 100),
        range: true,
        disabled: true,
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });

    testWidgets('thumbs 重叠绘制 overlappingStroke（1937-1941）', (tester) async {
      await tester.pumpWidget(build(
        TSliderThemeData.capsule(min: 0, max: 100, divisions: 5),
        range: true,
        rangeValues: const RangeValues(0.499, 0.501),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RangeSlider), findsOneWidget);
    });
  });
}

/// 仅用于访问私有 mixin 的测试辅助类
class _AdjustHelper with TCapsuleTrackShape {
  Offset adjust(Offset c, Rect r) => adjustThumbCenter(c, r);
}
