import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCollapse V1.0 Widget 测试
///
/// 覆盖 mode 两档（multiple/accordion）、展开/折叠交互、
/// onExpansionChanged/onChanged 回调、TCollapsePanel 参数、
/// Theme 注入、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TCollapseThemeData? collapseTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (collapseTheme != null) collapseTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      // MergeableMaterial(RenderListBody) 需要主轴方向无限空间，
      // 直接用 Scaffold(body:) 会被限制高度导致断言失败，故包裹滚动视图。
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  /// 读取第 index 个面板对应 AnimatedCrossFade 的折叠状态
  /// （TCollapse 折叠时 body 仍以 opacity:0 形式保留在树中，
  /// 故不能靠 find.text(...).findsNothing 判断，应检查 crossFadeState）
  CrossFadeState panelCrossFadeState(WidgetTester tester, int index) {
    final crossFades =
        tester.widgetList<AnimatedCrossFade>(find.byType(AnimatedCrossFade));
    return crossFades.elementAt(index).crossFadeState;
  }

  /// 构建一个简单的面板
  TCollapsePanel buildPanel({
    required String title,
    required String bodyText,
    bool isExpanded = false,
    Object? value,
    TCollapseIconTextBuilder? expandIconTextBuilder,
  }) {
    return TCollapsePanel(
      headerBuilder: (context, expanded) => Text(title),
      body: Text(bodyText),
      isExpanded: isExpanded,
      value: value,
      expandIconTextBuilder: expandIconTextBuilder,
    );
  }

  group('TCollapse 基础渲染', () {
    testWidgets('multiple 模式渲染单个面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [buildPanel(title: '标题1', bodyText: '内容1')],
        ),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
      expect(find.text('标题1'), findsOneWidget);
    });

    testWidgets('multiple 模式渲染多个面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [
            buildPanel(title: '标题A', bodyText: '内容A'),
            buildPanel(title: '标题B', bodyText: '内容B'),
          ],
        ),
      ));
      expect(find.text('标题A'), findsOneWidget);
      expect(find.text('标题B'), findsOneWidget);
    });

    testWidgets('accordion 模式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          mode: TCollapseMode.accordion,
          value: 'v1',
          children: [
            buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
            buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
          ],
        ),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
      expect(find.text('面板1'), findsOneWidget);
      expect(find.text('面板2'), findsOneWidget);
    });
  });

  group('TCollapse 展开折叠交互', () {
    testWidgets('multiple 模式点击展开面板', (tester) async {
      // multiple 模式为受控组件：点击仅通过 onExpansionChanged 通知当前状态，
      // 由父级取反后回写 isExpanded 完成展开/折叠。
      var expanded = false;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(builder: (context, setState) {
          return TCollapse(
            onExpansionChanged: (index, isExpanded) =>
                setState(() => expanded = !isExpanded),
            children: [
              buildPanel(title: '标题', bodyText: '展开内容', isExpanded: expanded),
            ],
          );
        }),
      ));
      // 初始折叠，内容不可见（AnimatedCrossFade 处于 showFirst）
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);

      // 点击标题展开
      await tester.tap(find.text('标题'));
      await tester.pumpAndSettle();

      // 展开后 crossFade 处于 showSecond
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);
    });

    testWidgets('multiple 模式点击折叠已展开面板', (tester) async {
      var expanded = true;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(builder: (context, setState) {
          return TCollapse(
            onExpansionChanged: (index, isExpanded) =>
                setState(() => expanded = !isExpanded),
            children: [
              buildPanel(title: '标题', bodyText: '展开内容', isExpanded: expanded),
            ],
          );
        }),
      ));
      // 初始展开
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);

      // 点击标题折叠
      await tester.tap(find.text('标题'));
      await tester.pumpAndSettle();

      // 折叠后 crossFade 处于 showFirst
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
    });

    testWidgets('onExpansionChanged 回调被调用', (tester) async {
      int? calledIndex;
      bool? calledIsExpanded;

      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [buildPanel(title: '标题', bodyText: '内容')],
          onExpansionChanged: (index, isExpanded) {
            calledIndex = index;
            calledIsExpanded = isExpanded;
          },
        ),
      ));

      await tester.tap(find.text('标题'));
      await tester.pumpAndSettle();

      expect(calledIndex, 0);
      expect(calledIsExpanded, false); // 点击时是折叠状态，回调传 false
    });

    testWidgets('accordion 模式切换面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          mode: TCollapseMode.accordion,
          value: 'v1',
          children: [
            buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
            buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
          ],
        ),
      ));
      // 初始 v1 展开
      expect(find.text('内容1'), findsOneWidget);

      // 点击面板2
      await tester.tap(find.text('面板2'));
      await tester.pumpAndSettle();

      // 面板1折叠，面板2展开
      expect(find.text('内容2'), findsOneWidget);
    });

    testWidgets('accordion 模式 onChanged 回调被调用', (tester) async {
      Object? changedValue;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => wrapWithTheme(
            TCollapse(
              mode: TCollapseMode.accordion,
              value: changedValue,
              onChanged: (val) {
                changedValue = val;
              },
              children: [
                buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
                buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('面板1'));
      await tester.pumpAndSettle();

      expect(changedValue, 'v1');
    });
  });

  group('TCollapsePanel 参数', () {
    testWidgets('expandIconTextBuilder 自定义展开文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [
            buildPanel(
              title: '标题',
              bodyText: '内容',
              expandIconTextBuilder: (context, isExpanded) =>
                  isExpanded ? '收起' : '展开',
            ),
          ],
        ),
      ));
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('expandIconTextBuilder 展开后文案变为收起', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [
            buildPanel(
              title: '标题',
              bodyText: '内容',
              isExpanded: true,
              expandIconTextBuilder: (context, isExpanded) =>
                  isExpanded ? '收起' : '展开',
            ),
          ],
        ),
      ));
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('backgroundColor 自定义面板背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [
            TCollapsePanel(
              headerBuilder: (context, expanded) => const Text('标题'),
              body: const Text('内容'),
              backgroundColor: Colors.blue.shade100,
            ),
          ],
        ),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
    });

    testWidgets('多个面板初始混合展开状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [
            buildPanel(title: '面板1', bodyText: '内容1', isExpanded: true),
            buildPanel(title: '面板2', bodyText: '内容2', isExpanded: false),
            buildPanel(title: '面板3', bodyText: '内容3', isExpanded: true),
          ],
        ),
      ));
      expect(find.text('内容1'), findsOneWidget);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
      expect(find.text('内容3'), findsOneWidget);
    });
  });

  group('TCollapse Theme 注入', () {
    testWidgets('TCollapseThemeData.style=card 渲染卡片风格', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [buildPanel(title: '标题', bodyText: '内容')],
        ),
        collapseTheme: const TCollapseThemeData(style: 'card'),
      ));
      // card 风格会包裹 ClipRRect
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('TCollapseThemeData.style=block（默认）无 ClipRRect', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [buildPanel(title: '标题', bodyText: '内容')],
        ),
      ));
      expect(find.byType(ClipRRect), findsNothing);
    });

    testWidgets('TCollapseThemeData.backgroundColor 覆盖面板背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          children: [buildPanel(title: '标题', bodyText: '内容')],
        ),
        collapseTheme: const TCollapseThemeData(backgroundColor: Colors.green),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
    });

    test('TCollapseThemeData.copyWith 正确合并', () {
      const base = TCollapseThemeData(style: 'card', elevation: 2);
      final merged = base.copyWith(backgroundColor: Colors.red);
      expect(merged.style, 'card');
      expect(merged.elevation, 2);
      expect(merged.backgroundColor, Colors.red);
    });

    test('TCollapseThemeData.lerp 插值正确', () {
      const a = TCollapseThemeData(elevation: 0, style: 'block');
      const b = TCollapseThemeData(elevation: 4, style: 'card');
      final mid = a.lerp(b, 0.5);
      expect(mid.elevation, 4); // t<0.5 取 a，t>=0.5 取 b，0.5 取 b
    });
  });

  group('TCollapse 边界情况', () {
    testWidgets('空 children 列表不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCollapse(children: []),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
    });

    testWidgets('animationDuration 自定义动画时长', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          animationDuration: const Duration(milliseconds: 100),
          children: [buildPanel(title: '标题', bodyText: '内容')],
        ),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
    });

    testWidgets('elevation 参数渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          elevation: 4,
          children: [buildPanel(title: '标题', bodyText: '内容')],
        ),
      ));
      expect(find.byType(TCollapse), findsOneWidget);
    });

    testWidgets('accordion 模式初始 value 为 null 时不展开任何面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCollapse(
          mode: TCollapseMode.accordion,
          children: [
            buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
            buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
          ],
        ),
      ));
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
    });
  });
}
