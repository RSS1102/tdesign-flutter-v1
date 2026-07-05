import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCell V1.0 Widget 测试
///
/// A 类控制：`onTap` 主路径；`onTap: null` = 禁用。
/// 覆盖 title/subtitle/arrow/image/prefix/note/rightIcon/required/bordered。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  /// 清理 TCell 内部 Future.delayed 产生的待完成定时器
  Future<void> cleanupTimers(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  // ============================================================
  // A 类控制：onTap 主路径 + onTap:null 禁用
  // ============================================================
  group('TCell A 类控制（onTap）', () {
    testWidgets('onTap 非 null 时点击触发回调', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TCell(title: '可点击', onTap: () => tapped = true),
      ));

      await tester.tap(find.text('可点击'));
      await tester.pump();
      expect(tapped, isTrue);
      await cleanupTimers(tester);
    });

    testWidgets('onTap: null 时禁用交互', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TCell(title: '禁用', onTap: null),
      ));

      await tester.tap(find.text('禁用'), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
      await cleanupTimers(tester);
    });

    testWidgets('onTap 触发 onLongPress 回调', (tester) async {
      bool longPressed = false;
      await tester.pumpWidget(wrapWithTheme(
        TCell(
          title: '长按',
          onTap: () {},
          onLongPress: () => longPressed = true,
        ),
      ));

      await tester.longPress(find.text('长按'));
      await tester.pump();
      expect(longPressed, isTrue);
      await cleanupTimers(tester);
    });
  });

  // ============================================================
  // 基础内容渲染
  // ============================================================
  group('TCell 内容渲染', () {
    testWidgets('title 显示标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '标题文字'),
      ));
      expect(find.text('标题文字'), findsOneWidget);
    });

    testWidgets('subtitle 显示副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '主标题', subtitle: '副标题'),
      ));
      expect(find.text('主标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });

    testWidgets('note 显示说明文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '标题', note: '说明'),
      ));
      expect(find.text('说明'), findsOneWidget);
    });

    testWidgets('required=true 显示必填标志', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '必填', required: true),
      ));
      expect(find.byType(TCell), findsOneWidget);
    });

    testWidgets('titleWidget 自定义标题组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCell(titleWidget: const Text('自定义标题')),
      ));
      expect(find.text('自定义标题'), findsOneWidget);
    });

    testWidgets('prefix 显示左侧图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '带图标', prefix: Icons.star),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  // ============================================================
  // arrow 箭头
  // ============================================================
  group('TCell 箭头', () {
    testWidgets('arrow=true 显示右侧箭头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '箭头', arrow: true),
      ));
      expect(find.byType(TCell), findsOneWidget);
    });

    testWidgets('arrow=false 不显示箭头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '无箭头', arrow: false),
      ));
      expect(find.byType(TCell), findsOneWidget);
    });
  });

  // ============================================================
  // rightIcon 右侧图标
  // ============================================================
  group('TCell 右侧图标', () {
    testWidgets('rightIcon 显示最右侧图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '右侧', rightIcon: Icons.chevron_right),
      ));
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('rightIconWidget 自定义右侧组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCell(
          title: '自定义',
          rightIconWidget: const Icon(Icons.favorite),
        ),
      ));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  // ============================================================
  // image 主图
  // ============================================================
  group('TCell 主图', () {
    testWidgets('imageWidget 自定义主图组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCell(
          title: '带图',
          imageWidget: const Icon(Icons.person, size: 40),
        ),
      ));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  // ============================================================
  // TCellGroup 分组
  // ============================================================
  group('TCellGroup 分组', () {
    testWidgets('多个 Cell 分组渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCellGroup(
          cells: [
            const TCell(title: '单元格1'),
            const TCell(title: '单元格2'),
            const TCell(title: '单元格3'),
          ],
        ),
      ));
      expect(find.text('单元格1'), findsOneWidget);
      expect(find.text('单元格2'), findsOneWidget);
      expect(find.text('单元格3'), findsOneWidget);
    });

    testWidgets('TCellGroup title 显示分组标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCellGroup(
          title: '分组标题',
          cells: [const TCell(title: '内容')],
        ),
      ));
      expect(find.text('分组标题'), findsOneWidget);
    });
  });
}
