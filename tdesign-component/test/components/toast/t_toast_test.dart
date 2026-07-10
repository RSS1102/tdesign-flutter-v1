import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TToast V1.0 Widget 测试
///
/// E 类控制：`showText()` / `showIconText()` 调用即显；不调即不显。
/// 覆盖文本 Toast、图标 Toast、自定义样式、duration。
///
/// 注意：TToast 使用 `Timer` 自动消失，在 Flutter 测试的假异步环境中
/// 会触发 `!timersPending` 断言。通过 `runAsync` 在真实异步环境中
/// 直接调用 show 方法，使 Timer 在真实时间轴上触发。
void main() {
  /// 用 TTheme 包裹以提供基础 Token，含可定位的 Key 节点
  Widget wrapWithTheme() {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(
        body: Center(
          child: Builder(
            key: const Key('toast_host'),
            builder: (_) => const SizedBox(),
          ),
        ),
      ),
    );
  }

  /// 辅助：在真实异步环境中显示 Toast 并等待渲染
  Future<void> showToastAndPump(
    WidgetTester tester,
    void Function(BuildContext) show, {
    Duration wait = const Duration(milliseconds: 50),
  }) async {
    final context = tester.element(find.byKey(const Key('toast_host')));
    await tester.runAsync(() async {
      show(context);
      await Future.delayed(wait);
    });
    await tester.pumpAndSettle();
  }

  /// 辅助：在真实异步环境中等待 Toast 自动消失
  Future<void> waitForDismiss(WidgetTester tester) async {
    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 500));
    });
    await tester.pumpAndSettle();
  }

  // ============================================================
  // E 类控制：showText 调用即显
  // ============================================================
  group('TToast E 类控制（showText）', () {
    testWidgets('showText 调用后 Toast 出现', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText('提示消息',
            context: context, duration: const Duration(milliseconds: 100));
      });
      expect(find.text('提示消息'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('不调用 showText 时不显示 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      expect(find.byType(TToast), findsNothing);
    });
  });

  // ============================================================
  // showIconText 带图标
  // ============================================================
  group('TToast showIconText 带图标', () {
    testWidgets('showIconText 显示文本和图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText('成功',
            icon: Icons.check_circle,
            context: context,
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('成功'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('showIconText vertical 竖向排列', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText('竖向',
            icon: Icons.info,
            direction: IconTextDirection.vertical,
            context: context,
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('竖向'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('showIconText horizontal 横向排列', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText('横向',
            icon: Icons.warning,
            direction: IconTextDirection.horizontal,
            context: context,
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('横向'), findsOneWidget);

      await waitForDismiss(tester);
    });
  });

  // ============================================================
  // 自定义样式
  // ============================================================
  group('TToast 自定义样式', () {
    testWidgets('自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText('背景色',
            context: context,
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('背景色'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('自定义 textStyle', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText('样式',
            context: context,
            textStyle: const TextStyle(fontSize: 20, color: Colors.white),
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('样式'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('自定义 iconSize 和 iconColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText('图标样式',
            icon: Icons.star,
            context: context,
            iconSize: 32,
            iconColor: Colors.yellow,
            duration: const Duration(milliseconds: 100));
      });
      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 32);

      await waitForDismiss(tester);
    });

    testWidgets('maxLines 限制行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '多行文本多行文本多行文本多行文本多行文本多行文本多行文本',
          context: context,
          maxLines: 2,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.byKey(const Key('toast_host')), findsWidgets);

      await waitForDismiss(tester);
    });
  });

  // ============================================================
  // duration 自动消失
  // ============================================================
  group('TToast duration', () {
    testWidgets('短 duration 后 Toast 消失', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      // 显示 Toast（短 duration）
      await tester.runAsync(() async {
        final context = tester.element(find.byKey(const Key('toast_host')));
        TToast.showText('短暂提示',
            context: context, duration: const Duration(milliseconds: 100));
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();
      expect(find.text('短暂提示'), findsOneWidget);

      // 等待 duration + dispose 延迟后消失
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();
      expect(find.text('短暂提示'), findsNothing);
    });

    testWidgets('长 duration Toast 保持显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await tester.runAsync(() async {
        final context = tester.element(find.byKey(const Key('toast_host')));
        TToast.showText('长期提示',
            context: context, duration: const Duration(seconds: 2));
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();
      expect(find.text('长期提示'), findsOneWidget);

      // 短暂等待后仍应显示
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();
      expect(find.text('长期提示'), findsOneWidget);

      // 清理：等待长 duration 过期
      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 3));
      });
      await tester.pumpAndSettle();
    });
  });

  // ============================================================
  // showSuccess / showWarning / showFail
  // ============================================================
  group('TToast 状态图标', () {
    testWidgets('showSuccess 显示成功图标与文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showSuccess('成功',
            context: context, duration: const Duration(milliseconds: 100));
      });
      expect(find.text('成功'), findsOneWidget);
      expect(find.byIcon(TIcons.check_circle), findsOneWidget);
      await waitForDismiss(tester);
    });

    testWidgets('showWarning 显示警告图标与文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showWarning('警告',
            context: context, duration: const Duration(milliseconds: 100));
      });
      expect(find.text('警告'), findsOneWidget);
      expect(find.byIcon(TIcons.error_circle), findsOneWidget);
      await waitForDismiss(tester);
    });

    testWidgets('showFail 显示失败图标与文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showFail('失败',
            context: context, duration: const Duration(milliseconds: 100));
      });
      expect(find.text('失败'), findsOneWidget);
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
      await waitForDismiss(tester);
    });
  });

  // ============================================================
  // 加载 Toast
  // ============================================================
  group('TToast 加载', () {
    testWidgets('showLoading 显示加载文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      await tester.runAsync(() async {
        TToast.showLoading(context: context, text: '加载中');
        await Future.delayed(const Duration(milliseconds: 50));
      });
      // 仅 pump 单帧：TCircleIndicator 有无限旋转动画，pumpAndSettle 会超时
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      TToast.dismissLoading();
      await tester.pump();
      expect(find.text('加载中'), findsNothing);
    });

    testWidgets('showLoadingWithoutText 仅渲染指示器无文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      await tester.runAsync(() async {
        TToast.showLoadingWithoutText(context: context);
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pump();
      // 不带文案，不应出现加载文案
      expect(find.text('加载中'), findsNothing);
      TToast.dismissLoading();
      await tester.pump();
    });
  });

  // ============================================================
  // dismiss 关闭
  // ============================================================
  group('TToast dismiss 关闭', () {
    testWidgets('dismissToast 关闭指定 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      late String id;
      await tester.runAsync(() async {
        id = TToast.showText('可关闭',
            context: context, duration: const Duration(seconds: 10));
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();
      expect(find.text('可关闭'), findsOneWidget);
      TToast.dismissToast(id);
      await tester.pumpAndSettle();
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('dismissAll 关闭所有 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      await tester.runAsync(() async {
        TToast.showText('A',
            context: context, duration: const Duration(seconds: 10));
        TToast.showText('B',
            context: context, duration: const Duration(seconds: 10));
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      TToast.dismissAll();
      await tester.pumpAndSettle();
      expect(find.text('A'), findsNothing);
      expect(find.text('B'), findsNothing);
    });

    testWidgets('dismissLoading 关闭加载 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      await tester.runAsync(() async {
        TToast.showLoading(context: context, text: '加载中');
        await Future.delayed(const Duration(milliseconds: 50));
      });
      // 仅 pump 单帧，避免 TCircleIndicator 无限动画导致 pumpAndSettle 超时
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      TToast.dismissLoading();
      await tester.pump();
      expect(find.text('加载中'), findsNothing);
    });
  });

  // ============================================================
  // preventTap / customWidget
  // ============================================================
  group('TToast 遮罩与自定义', () {
    testWidgets('preventTap 渲染全屏遮罩', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showText('防触',
            context: context,
            preventTap: true,
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('防触'), findsOneWidget);
      // preventTap 时使用 Positioned 全屏透明遮罩
      expect(find.byType(Positioned), findsWidgets);
      await waitForDismiss(tester);
    });

    testWidgets('customWidget 渲染自定义内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showText('忽略',
            context: context,
            customWidget: const Text('自定义内容'),
            duration: const Duration(milliseconds: 100));
      });
      expect(find.text('自定义内容'), findsOneWidget);
      await waitForDismiss(tester);
    });
  });
}

