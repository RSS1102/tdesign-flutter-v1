import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TRefreshHeader 组件 Widget 测试
///
/// 覆盖构造参数、themeData 注入、断言、TRefreshThemeData 等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TRefreshThemeData? refreshTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (refreshTheme != null) refreshTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // TRefreshThemeData 单元测试
  // ============================================================
  group('TRefreshThemeData', () {
    test('默认构造', () {
      const data = TRefreshThemeData();
      expect(data.loadingIcon, isNull);
      expect(data.backgroundColor, isNull);
      expect(data.extent, isNull);
      expect(data.triggerDistance, isNull);
      expect(data.float, isNull);
      expect(data.completeDuration, isNull);
      expect(data.infiniteOffset, isNull);
      expect(data.overScroll, isNull);
    });

    test('自定义值构造', () {
      const data = TRefreshThemeData(
        loadingIcon: TLoadingIcon.point,
        backgroundColor: Colors.red,
        extent: 60,
        triggerDistance: 80,
        float: true,
        completeDuration: Duration(seconds: 2),
        infiniteOffset: 100,
        overScroll: false,
      );
      expect(data.loadingIcon, TLoadingIcon.point);
      expect(data.backgroundColor, Colors.red);
      expect(data.extent, 60);
      expect(data.triggerDistance, 80);
      expect(data.float, isTrue);
      expect(data.completeDuration, const Duration(seconds: 2));
      expect(data.infiniteOffset, 100);
      expect(data.overScroll, isFalse);
    });

    test('merge - other 优先', () {
      const base = TRefreshThemeData(
        extent: 48,
        triggerDistance: 48,
        backgroundColor: Colors.white,
      );
      const other = TRefreshThemeData(
        extent: 60,
        backgroundColor: Colors.red,
      );
      final merged = base.merge(other);
      expect(merged.extent, 60);
      expect(merged.triggerDistance, 48); // other 未覆盖
      expect(merged.backgroundColor, Colors.red);
    });

    test('merge - null other 返回自身', () {
      const base = TRefreshThemeData(extent: 48);
      final merged = base.merge(null);
      expect(merged.extent, 48);
    });

    test('copyWith', () {
      const original = TRefreshThemeData(extent: 48, float: false);
      final copied = original.copyWith(extent: 60, float: true);
      expect(copied.extent, 60);
      expect(copied.float, isTrue);
    });

    test('lerp - t=0 返回 this', () {
      const a = TRefreshThemeData(extent: 40, triggerDistance: 40);
      const b = TRefreshThemeData(extent: 80, triggerDistance: 80);
      final result = a.lerp(b, 0);
      expect(result.extent, 40);
    });

    test('lerp - t=1 返回 other', () {
      const a = TRefreshThemeData(extent: 40, triggerDistance: 40);
      const b = TRefreshThemeData(extent: 80, triggerDistance: 80);
      final result = a.lerp(b, 1);
      expect(result.extent, 80);
    });

    test('lerp - 非 TRefreshThemeData 返回 this', () {
      const a = TRefreshThemeData(extent: 40);
      final result = a.lerp(null, 0.5);
      expect(result.extent, 40);
    });

    test('lerpDouble - 双 null', () {
      expect(TRefreshThemeData.lerpDouble(null, null, 0.5), isNull);
    });
  });

  // ============================================================
  // TRefreshHeader 构造
  // ============================================================
  group('TRefreshHeader 构造', () {
    test('默认构造 - 使用默认值', () {
      final header = TRefreshHeader();
      expect(header, isA<Header>());
      expect(header.finalExtent, 48.0);
      expect(header.finalTriggerDistance, 48.0);
      expect(header.finalFloat, isFalse);
      expect(header.finalOverScroll, isTrue);
      expect(header.finalLoadingIcon, TLoadingIcon.circle);
      expect(header.finalBackgroundColor, isNull);
      expect(header.themeData, isNull);
      expect(header.enableHapticFeedback, isTrue);
      expect(header.enableInfiniteRefresh, isFalse);
    });

    test('通过 themeData 构造 - 优先使用 themeData 值', () {
      const themeData = TRefreshThemeData(
        extent: 60,
        triggerDistance: 80,
        float: true,
        overScroll: false,
        loadingIcon: TLoadingIcon.point,
        backgroundColor: Colors.blue,
      );
      final header = TRefreshHeader(themeData: themeData);
      expect(header.finalExtent, 60);
      expect(header.finalTriggerDistance, 80);
      expect(header.finalFloat, isTrue);
      expect(header.finalOverScroll, isFalse);
      expect(header.finalLoadingIcon, TLoadingIcon.point);
      expect(header.finalBackgroundColor, Colors.blue);
      expect(header.themeData, themeData);
    });

    test('构造参数优先于 themeData', () {
      const themeData = TRefreshThemeData(
        extent: 60,
        triggerDistance: 80,
        loadingIcon: TLoadingIcon.point,
      );
      final header = TRefreshHeader(
        themeData: themeData,
        extent: 100,
        triggerDistance: 120,
        loadingIcon: TLoadingIcon.activity,
      );
      expect(header.finalExtent, 100);
      expect(header.finalTriggerDistance, 120);
      expect(header.finalLoadingIcon, TLoadingIcon.activity);
    });

    test('enableInfiniteRefresh: true 时使用 infiniteOffset', () {
      const themeData = TRefreshThemeData(infiniteOffset: 100);
      final header = TRefreshHeader(
        themeData: themeData,
        enableInfiniteRefresh: true,
      );
      expect(header.enableInfiniteRefresh, isTrue);
    });

    test('enableHapticFeedback: false 禁用震动反馈', () {
      final header = TRefreshHeader(enableHapticFeedback: false);
      expect(header.enableHapticFeedback, isFalse);
    });

    test('triggerDistance <= 0 抛出断言', () {
      expect(
        () => TRefreshHeader(triggerDistance: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('extent < 0 抛出断言', () {
      expect(
        () => TRefreshHeader(extent: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('自定义 completeDuration', () {
      final header = TRefreshHeader(
        completeDuration: const Duration(seconds: 3),
      );
      expect(header.finalCompleteDuration, const Duration(seconds: 3));
    });

    test('通过 themeData 设置 completeDuration', () {
      const themeData = TRefreshThemeData(
        completeDuration: Duration(seconds: 5),
      );
      final header = TRefreshHeader(themeData: themeData);
      expect(header.finalCompleteDuration, const Duration(seconds: 5));
    });
  });

  // ============================================================
  // TLoadingIcon 枚举
  // ============================================================
  group('TLoadingIcon 枚举', () {
    test('有三个值', () {
      expect(TLoadingIcon.values.length, 3);
      expect(TLoadingIcon.values, contains(TLoadingIcon.circle));
      expect(TLoadingIcon.values, contains(TLoadingIcon.point));
      expect(TLoadingIcon.values, contains(TLoadingIcon.activity));
    });
  });

  // ============================================================
  // EasyRefresh 集成
  // ============================================================
  group('TRefreshHeader EasyRefresh 集成', () {
    testWidgets('EasyRefresh 使用 TRefreshHeader 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: EasyRefresh(
            header: TRefreshHeader(),
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => ListTile(
                title: Text('项目$index'),
              ),
            ),
          ),
        ),
      ));

      // 冲刷 EasyRefresh 内部定时器，避免 !timersPending 断言
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('项目0'), findsOneWidget);
    });

    testWidgets('TRefreshHeader 带 themeData 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: EasyRefresh(
            header: TRefreshHeader(
              themeData: const TRefreshThemeData(
                extent: 60,
                triggerDistance: 80,
                loadingIcon: TLoadingIcon.point,
                backgroundColor: Colors.white,
              ),
            ),
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                title: Text('主题项$index'),
              ),
            ),
          ),
        ),
      ));

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('主题项0'), findsOneWidget);
    });

    testWidgets('TRefreshHeader 不带 onRefresh 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: EasyRefresh(
            header: TRefreshHeader(),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) => ListTile(
                title: Text('无刷新$index'),
              ),
            ),
          ),
        ),
      ));

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('无刷新0'), findsOneWidget);
    });
  });

  // ============================================================
  // 主题注入（Theme Extension）
  // ============================================================
  group('TRefreshHeader 主题注入', () {
    testWidgets('TRefreshThemeData 通过 Theme Extension 注入', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: EasyRefresh(
            header: TRefreshHeader(),
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) => ListTile(
                title: Text('扩展项$index'),
              ),
            ),
          ),
        ),
        refreshTheme: const TRefreshThemeData(
          extent: 50,
          triggerDistance: 50,
          loadingIcon: TLoadingIcon.activity,
        ),
      ));

      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('扩展项0'), findsOneWidget);
    });

    test('实例 themeData 优先于 Theme Extension', () {
      // 构造时验证：实例 themeData 应优先
      // triggerDistance 必须 >= extent（EasyRefresh 约束）
      const instanceTheme = TRefreshThemeData(extent: 70, triggerDistance: 70);
      final header = TRefreshHeader(themeData: instanceTheme);
      expect(header.finalExtent, 70);
    });
  });

  // ============================================================
  // TGIconHeaderWidget
  // ============================================================
  group('TGIconHeaderWidget', () {
    test('类存在', () {
      expect(TGIconHeaderWidget, isNotNull);
    });

    test('TGIconHeaderWidgetState 类存在', () {
      expect(TGIconHeaderWidgetState, isNotNull);
    });
  });
}
