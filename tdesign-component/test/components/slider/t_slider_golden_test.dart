import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSlider P0 Golden 测试
///
/// 覆盖 normal / capsule 等关键态。
/// 首次运行用 `flutter test --update-goldens` 生成基线。
void main() {
  Widget wrapWithTheme(Widget child, {TSliderThemeData? sliderTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        TSliderThemeData(min: 0, max: 100),
        if (sliderTheme != null) sliderTheme,
      ]),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  group('TSlider Golden', () {
    testWidgets('normal 默认态', (tester) async {
      tester.view.physicalSize = const Size(800, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 30, onChanged: (_) {}),
      ));
      await expectLater(
        find.byType(TSlider),
        matchesGoldenFile('goldens/t_slider_normal.png'),
      );
    });

    testWidgets('normal 带标签', (tester) async {
      tester.view.physicalSize = const Size(800, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 60,
          label: '音量',
          rightLabel: 'MAX',
          onChanged: (_) {},
        ),
      ));
      await expectLater(
        find.byType(TSlider),
        matchesGoldenFile('goldens/t_slider_normal_labels.png'),
      );
    });

    testWidgets('normal 禁用态', (tester) async {
      tester.view.physicalSize = const Size(800, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TSlider(value: 50),
      ));
      await expectLater(
        find.byType(TSlider),
        matchesGoldenFile('goldens/t_slider_normal_disabled.png'),
      );
    });

    testWidgets('capsule 胶囊态', (tester) async {
      tester.view.physicalSize = const Size(800, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TSlider(value: 40, onChanged: (_) {}),
        sliderTheme: TSliderThemeData.capsule(min: 0, max: 100),
      ));
      await expectLater(
        find.byType(TSlider),
        matchesGoldenFile('goldens/t_slider_capsule.png'),
      );
    });

    testWidgets('capsule 带标签', (tester) async {
      tester.view.physicalSize = const Size(800, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        TSlider(
          value: 70,
          label: '亮度',
          rightLabel: '100',
          onChanged: (_) {},
        ),
        sliderTheme: TSliderThemeData.capsule(min: 0, max: 100),
      ));
      await expectLater(
        find.byType(TSlider),
        matchesGoldenFile('goldens/t_slider_capsule_labels.png'),
      );
    });
  });
}
