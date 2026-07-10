import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TLoading V1.0 Widget 测试
///
/// Tier1 组件：覆盖 Theme 子树 mergeExtension(TLoadingThemeData)。
/// 覆盖 size 三档、icon 三种、text、axis 方向。
void main() {
  Widget wrapWithTheme(Widget child, {TLoadingThemeData? loadingTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (loadingTheme != null) loadingTheme,
      ]),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TLoading 基础渲染', () {
    testWidgets('size=small 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.small),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('size=medium 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('size=large 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.large),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });
  });

  // ============================================================
  // icon 图标类型
  // ============================================================
  group('TLoading icon 类型', () {
    testWidgets('circle 图标正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, icon: TLoadingIcon.circle),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('point 点状图标正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, icon: TLoadingIcon.point),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('activity 菊花状图标正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, icon: TLoadingIcon.activity),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });
  });

  // ============================================================
  // text 文案
  // ============================================================
  group('TLoading 文案', () {
    testWidgets('text 显示加载文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, text: '加载中...'),
      ));
      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('无 text 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });
  });

  // ============================================================
  // Tier1：Theme 子树 mergeExtension
  // ============================================================
  group('TLoading Theme 子树 mergeExtension', () {
    testWidgets('mergeExtension 覆盖 axis 方向', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, text: '横向加载'),
        loadingTheme: const TLoadingThemeData(axis: Axis.horizontal),
      ));
      expect(find.text('横向加载'), findsOneWidget);
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('mergeExtension 覆盖 iconColor 颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium),
        loadingTheme: const TLoadingThemeData(iconColor: Colors.red),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('mergeExtension 覆盖 textColor 颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, text: '颜色测试'),
        loadingTheme: const TLoadingThemeData(textColor: Colors.blue),
      ));
      expect(find.text('颜色测试'), findsOneWidget);
    });

    testWidgets('mergeExtension 覆盖 duration 动画速度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium),
        loadingTheme: const TLoadingThemeData(duration: 1000),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('mergeExtension 覆盖 customIcon 自定义图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium),
        loadingTheme: const TLoadingThemeData(
          customIcon: Icon(Icons.refresh, size: 24),
        ),
      ));
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('未注入 Theme 时使用默认值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TLoading(size: TLoadingSize.medium, text: '默认'),
      ));
      expect(find.text('默认'), findsOneWidget);
      expect(find.byType(TLoading), findsOneWidget);
    });
  });
}
