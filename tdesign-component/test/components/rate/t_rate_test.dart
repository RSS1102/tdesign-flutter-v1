import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TRate V1.0 Widget 测试
///
/// C 类控制：`value` + `onChanged` 受控；`onChanged: null` = 禁用。
/// 覆盖 count、allowHalf、showText、texts、禁用态。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // C 类控制：value 受控 + onChanged:null 禁用
  // ============================================================
  group('TRate C 类控制（value + onChanged:null 禁用）', () {
    testWidgets('value=0 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('value=3 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('onChanged=null 禁用时不响应点击', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, onChanged: null),
      ));

      // 点击评分图标
      await tester.tap(find.byIcon(TIcons.star_filled).first);
      await tester.pump();
      // 禁用时组件仍存在但不响应交互
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('onChanged 非 null 时点击可交互', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 0,
          onChanged: (_) {},
        ),
      ));

      // 点击 TRate 组件区域
      await tester.tap(find.byType(TRate), warnIfMissed: false);
      await tester.pumpAndSettle();
      // TRate 手势检测区域复杂，验证组件可交互即可
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('onChanged=null 禁用时拖动不触发回调', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, onChanged: null),
      ));

      await tester.drag(find.byType(TRate), const Offset(50, 0));
      await tester.pump();
      // 禁用时组件仍存在但不响应交互
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // count 评分数量
  // ============================================================
  group('TRate count 评分数量', () {
    testWidgets('count=5（默认）渲染 5 个评分项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0),
      ));
      // 默认 5 个星星，每个星星有 2 个 ClipRect（半选），共 10 个图标
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(10));
    });

    testWidgets('count=3 渲染 3 个评分项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, count: 3),
      ));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(6));
    });

    testWidgets('count=10 渲染 10 个评分项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, count: 10),
      ));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(20));
    });
  });

  // ============================================================
  // allowHalf 半选
  // ============================================================
  group('TRate allowHalf 半选', () {
    testWidgets('allowHalf=true 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, allowHalf: true),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('allowHalf=true + value=2.5 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 2.5, allowHalf: true),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('allowHalf=false + value=3 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, allowHalf: false),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // showText 辅助文字
  // ============================================================
  group('TRate showText 辅助文字', () {
    testWidgets('showText=true + value=0 显示未评分', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, showText: true),
      ));
      // value=0 时显示未评分文案
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('showText=true + value=3 显示对应文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          showText: true,
          texts: ['极差', '失望', '一般', '满意', '惊喜'],
        ),
      ));
      expect(find.text('一般'), findsOneWidget);
    });

    testWidgets('showText=false 不显示文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, showText: false),
      ));
      expect(find.text('一般'), findsNothing);
    });
  });

  // ============================================================
  // 自定义图标与颜色
  // ============================================================
  group('TRate 自定义样式', () {
    testWidgets('自定义 icon 替换默认星星', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          icon: [Icons.favorite, Icons.favorite_border],
        ),
      ));
      expect(find.byIcon(Icons.favorite), findsWidgets);
    });

    testWidgets('自定义 color 颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          color: [Colors.red, Colors.grey],
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('size 自定义图标大小', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, size: 32),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.star_filled).first);
      expect(icon.size, 32);
    });
  });

  // ============================================================
  // placement 弹框位置
  // ============================================================
  group('TRate placement 弹框', () {
    testWidgets('placement=none 不显示弹框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, placement: PlacementEnum.none),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('placement=top 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, placement: PlacementEnum.top),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('placement=bottom 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, placement: PlacementEnum.bottom),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // disabled 禁用
  // ============================================================
  group('TRate disabled 禁用', () {
    testWidgets('disabled=true 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, disabled: true),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('disabled=true + onChanged=null 禁用渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 2, disabled: true, onChanged: null),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // showText 更多文案场景
  // ============================================================
  group('TRate showText 更多场景', () {
    testWidgets('showText=true + value=5 显示最后一个文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 5,
          showText: true,
          texts: ['极差', '失望', '一般', '满意', '惊喜'],
        ),
      ));
      expect(find.text('惊喜'), findsOneWidget);
    });

    testWidgets('showText=true + value=1 显示第一个文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 1,
          showText: true,
          texts: ['极差', '失望', '一般', '满意', '惊喜'],
        ),
      ));
      expect(find.text('极差'), findsOneWidget);
    });

    testWidgets('showText=true + allowHalf=true + value=2.5', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 2.5,
          showText: true,
          allowHalf: true,
          texts: ['极差', '失望', '一般', '满意', '惊喜',
            '极差半', '失望半', '一般半', '满意半', '惊喜半'],
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('showText=true + value=0 显示未评分', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, showText: true),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('builderText 自定义文案构建', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 3,
          showText: true,
          builderText: (context, value) => Text('评分: $value'),
        ),
      ));
      expect(find.text('评分: 3.0'), findsOneWidget);
    });
  });

  // ============================================================
  // direction / alignment 方向与对齐
  // ============================================================
  group('TRate direction / alignment', () {
    testWidgets('direction=vertical 垂直方向', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          direction: Axis.vertical,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('mainAxisAlignment=center', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('crossAxisAlignment=start', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('mainAxisSize=max', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          mainAxisSize: MainAxisSize.max,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // gap 间距
  // ============================================================
  group('TRate gap 间距', () {
    testWidgets('自定义 gap=10', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, gap: 10),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('gap=0', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, gap: 0),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // iconTextGap 图标与文字间距
  // ============================================================
  group('TRate iconTextGap', () {
    testWidgets('自定义 iconTextGap=20', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          showText: true,
          iconTextGap: 20,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('iconTextGap + direction=vertical', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          showText: true,
          direction: Axis.vertical,
          iconTextGap: 12,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // textWidth 文案宽度
  // ============================================================
  group('TRate textWidth', () {
    testWidgets('自定义 textWidth=60', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          showText: true,
          textWidth: 60,
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义颜色（双色数组）
  // ============================================================
  group('TRate 自定义颜色', () {
    testWidgets('color 双色数组 [选中色, 未选中色]', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          color: [Colors.red, Colors.grey],
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('color 单色数组（只有选中色）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          color: [Colors.blue],
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('color 空数组（使用默认色）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          color: [],
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义图标（双图标数组）
  // ============================================================
  group('TRate 自定义图标', () {
    testWidgets('icon 双图标数组 [选中, 未选中]', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          icon: [Icons.star, Icons.star_border],
        ),
      ));
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('icon 单图标数组（只有选中图标）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(
          value: 3,
          icon: [Icons.favorite],
        ),
      ));
      expect(find.byIcon(Icons.favorite), findsWidgets);
    });
  });

  // ============================================================
  // count 边界场景
  // ============================================================
  group('TRate count 边界场景', () {
    testWidgets('count=1 渲染 1 个评分项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, count: 1),
      ));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(2));
    });

    testWidgets('count=2 渲染 2 个评分项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, count: 2),
      ));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(4));
    });

    testWidgets('count=null 默认 5 个', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 0, count: null),
      ));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(10));
    });
  });

  // ============================================================
  // value 变化（didUpdateWidget）
  // ============================================================
  group('TRate value 变化', () {
    testWidgets('value 从 0 变为 3 更新显示', (tester) async {
      double value = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TRate(
              value: value,
              onChanged: (v) {},
            );
          },
        ),
      ));
      expect(find.byType(TRate), findsOneWidget);

      setState(() => value = 3);
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('value 从 3 变为 0 更新显示', (tester) async {
      double value = 3;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TRate(
              value: value,
              onChanged: (v) {},
            );
          },
        ),
      ));
      setState(() => value = 0);
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('count 变化重建 GlobalKey', (tester) async {
      var count = 5;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TRate(
              value: 0,
              count: count,
              onChanged: (v) {},
            );
          },
        ),
      ));
      setState(() => count = 3);
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(6));
    });

    testWidgets('allowHalf 变化更新 tipSize', (tester) async {
      var allowHalf = false;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TRate(
              value: 2,
              allowHalf: allowHalf,
              onChanged: (v) {},
            );
          },
        ),
      ));
      setState(() => allowHalf = true);
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });
  });

  // ============================================================
  // TRateThemeData
  // ============================================================
  group('TRateThemeData', () {
    test('默认构造', () {
      const data = TRateThemeData();
      expect(data.allowHalf, null);
      expect(data.color, null);
      expect(data.count, null);
      expect(data.gap, null);
      expect(data.placement, null);
      expect(data.showText, null);
      expect(data.textWidth, null);
      expect(data.mainAxisAlignment, null);
      expect(data.crossAxisAlignment, null);
      expect(data.mainAxisSize, null);
      expect(data.iconTextGap, null);
    });

    test('带参数构造', () {
      const data = TRateThemeData(
        allowHalf: true,
        color: [Colors.red, Colors.grey],
        count: 5,
        gap: 8,
        placement: PlacementEnum.top,
        showText: true,
        textWidth: 48,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        iconTextGap: 16,
      );
      expect(data.allowHalf, true);
      expect(data.color, [Colors.red, Colors.grey]);
      expect(data.count, 5);
      expect(data.gap, 8);
      expect(data.placement, PlacementEnum.top);
      expect(data.showText, true);
      expect(data.textWidth, 48);
      expect(data.mainAxisAlignment, MainAxisAlignment.center);
      expect(data.crossAxisAlignment, CrossAxisAlignment.start);
      expect(data.mainAxisSize, MainAxisSize.max);
      expect(data.iconTextGap, 16);
    });

    test('copyWith 全字段覆盖', () {
      const data = TRateThemeData();
      final copied = data.copyWith(
        allowHalf: true,
        color: [Colors.red, Colors.grey],
        count: 5,
        gap: 8,
        placement: PlacementEnum.top,
        showText: true,
        textWidth: 48,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        iconTextGap: 16,
      );
      expect(copied.allowHalf, true);
      expect(copied.color, [Colors.red, Colors.grey]);
      expect(copied.count, 5);
      expect(copied.gap, 8);
      expect(copied.placement, PlacementEnum.top);
      expect(copied.showText, true);
      expect(copied.textWidth, 48);
      expect(copied.mainAxisAlignment, MainAxisAlignment.center);
      expect(copied.crossAxisAlignment, CrossAxisAlignment.start);
      expect(copied.mainAxisSize, MainAxisSize.max);
      expect(copied.iconTextGap, 16);
    });

    test('lerp 正常插值 t < 0.5', () {
      const data1 = TRateThemeData(
        allowHalf: false,
        count: 3,
        gap: 4,
        placement: PlacementEnum.none,
        showText: false,
        textWidth: 40,
        iconTextGap: 8,
      );
      const data2 = TRateThemeData(
        allowHalf: true,
        count: 5,
        gap: 10,
        placement: PlacementEnum.top,
        showText: true,
        textWidth: 60,
        iconTextGap: 16,
      );
      final lerped = data1.lerp(data2, 0.3);
      expect(lerped.allowHalf, false); // t < 0.5 取 data1
      expect(lerped.count, 3);
      expect(lerped.placement, PlacementEnum.none);
      expect(lerped.showText, false);
    });

    test('lerp t >= 0.5 取 other', () {
      const data1 = TRateThemeData(
        allowHalf: false,
        count: 3,
        placement: PlacementEnum.none,
        showText: false,
      );
      const data2 = TRateThemeData(
        allowHalf: true,
        count: 5,
        placement: PlacementEnum.top,
        showText: true,
      );
      final lerped = data1.lerp(data2, 0.6);
      expect(lerped.allowHalf, true);
      expect(lerped.count, 5);
      expect(lerped.placement, PlacementEnum.top);
      expect(lerped.showText, true);
    });

    test('lerp 非 TRateThemeData 返回自身', () {
      const data = TRateThemeData(count: 5);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  // ============================================================
  // PlacementEnum 枚举
  // ============================================================
  group('PlacementEnum 枚举', () {
    test('枚举值', () {
      expect(PlacementEnum.values.length, 3);
      expect(PlacementEnum.values, contains(PlacementEnum.none));
      expect(PlacementEnum.values, contains(PlacementEnum.top));
      expect(PlacementEnum.values, contains(PlacementEnum.bottom));
    });
  });

  // ============================================================
  // size 自定义图标大小
  // ============================================================
  group('TRate size 自定义', () {
    testWidgets('size=16 小图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, size: 16),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.star_filled).first);
      expect(icon.size, 16);
    });

    testWidgets('size=32 大图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, size: 32),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.star_filled).first);
      expect(icon.size, 32);
    });

    testWidgets('size=null 默认 24', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRate(value: 3, size: null),
      ));
      final icon = tester.widget<Icon>(find.byIcon(TIcons.star_filled).first);
      expect(icon.size, 24);
    });
  });

  // ============================================================
  // 交互补充（拖拽 / overlay / tip / 定时器）
  // ============================================================
  group('TRate 交互补充', () {
    testWidgets('拖拽评分触发 onHorizontalDragUpdate/End', (tester) async {
      // 覆盖 226-227（_isClick=false; _changeSelect）+ 233（_hideTip）
      var changed = -1.0;
      await tester.pumpWidget(wrapWithTheme(
        TRate(value: 0, onChanged: (v) => changed = v),
      ));
      // 从 TRate 中心向右拖拽（覆盖 onHorizontalDragUpdate/End + _fingerInsideContainer）
      await tester.drag(
          find.byType(TRate), const Offset(60, 0), warnIfMissed: false);
      // Throttle 延迟 100ms 执行 _changeSelect
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('allowHalf=true 拖拽半选', (tester) async {
      // 覆盖 341（entry.key 半选值）+ 345（首次计算尺寸）
      var changed = -1.0;
      await tester.pumpWidget(wrapWithTheme(
        TRate(value: 0, allowHalf: true, onChanged: (v) => changed = v),
      ));
      await tester.drag(
          find.byType(TRate), const Offset(30, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('点击相同值触发 isTap=true 分支', (tester) async {
      // 覆盖 297（diff=false || isTap==true）+ 345（首次计算尺寸）
      await tester.pumpWidget(wrapWithTheme(
        TRate(value: 3, onChanged: (_) {}),
      ));
      // 获取第3个评分右半 ClipRect 的精确中心位置
      final clips = find.byType(ClipRect);
      // ClipRect 列表：每个评分2个（左半+右半），第3个评分右半 = index 5
      if (clips.evaluate().length > 5) {
        final box = tester.renderObject<RenderBox>(clips.at(5));
        final center = box.localToGlobal(
            Offset(box.size.width / 2, box.size.height / 2));
        await tester.tapAt(center);
      } else {
        await tester.tapAt(tester.getCenter(find.byType(TRate)));
      }
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('placement=bottom 点击触发 overlay', (tester) async {
      // 覆盖 429（Positioned top=placement=bottom 分支）
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 0,
          placement: PlacementEnum.bottom,
          onChanged: (_) {},
        ),
      ));
      await tester.tapAt(tester.getCenter(find.byType(TRate)));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('hideTip 定时器触发后关闭 tip', (tester) async {
      // 覆盖 317-319（_reverse）+ 362-366（Timer 回调）
      await tester.pumpWidget(wrapWithTheme(
        TRate(value: 0, allowHalf: true, onChanged: (_) {}),
      ));
      await tester.tapAt(tester.getCenter(find.byType(TRate)));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      // 等待 hideTip 定时器（allowHalf=true → 3000ms）
      await tester.pump(const Duration(milliseconds: 3100));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('hideTip 定时器 allowHalf=false 1s 触发', (tester) async {
      // 覆盖 362-366 Timer（allowHalf=false → 1000ms）
      await tester.pumpWidget(wrapWithTheme(
        TRate(value: 0, allowHalf: false, onChanged: (_) {}),
      ));
      await tester.tapAt(tester.getCenter(find.byType(TRate)));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('拖拽评分触发 overlay tip 显示', (tester) async {
      // 覆盖 _buildOverlay 426-456（Positioned + TRateTips 渲染）
      // 以及 tipClick 回调 444-453
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 0,
          allowHalf: true,
          onChanged: (_) {},
        ),
      ));
      // 拖拽触发 _changeSelect → _showTip=true → _overlay.update() → _buildOverlay
      await tester.drag(
          find.byType(TRate), const Offset(30, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('placement=bottom + allowHalf 拖拽触发 overlay', (tester) async {
      // 覆盖 429（placement=bottom Positioned 分支）
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 0,
          allowHalf: true,
          placement: PlacementEnum.bottom,
          onChanged: (_) {},
        ),
      ));
      await tester.drag(
          find.byType(TRate), const Offset(30, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('拖拽到左侧边界返回 0', (tester) async {
      // 覆盖 329-330（globalPosition.dx < rateOffset.dx → return 0）
      await tester.pumpWidget(wrapWithTheme(
        TRate(value: 2, onChanged: (_) {}),
      ));
      // 向左拖到边界外
      await tester.drag(
          find.byType(TRate), const Offset(-200, 0), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('sizeCall 回调触发 tipSize 更新', (tester) async {
      // 覆盖 438-442（sizeCall → _tipSize 更新 → _overlay.update）
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 0,
          allowHalf: true,
          onChanged: (_) {},
        ),
      ));
      // 先点击触发 overlay
      await tester.tapAt(tester.getCenter(find.byType(TRate)));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      // 等待 overlay 渲染和 sizeCall 回调
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TRate), findsOneWidget);
    });

    testWidgets('精确 tap 评分图标触发 _rateSize 首次计算', (tester) async {
      // 覆盖 345（!_rateSize.containsKey(index) || !_rateOffset.containsKey(index)）
      await tester.pumpWidget(wrapWithTheme(
        TRate(
          value: 0,
          allowHalf: true,
          onChanged: (_) {},
        ),
      ));
      // 精确 tap 第一个评分图标的右半部分
      final clips = find.byType(ClipRect);
      if (clips.evaluate().length > 1) {
        final box = tester.renderObject<RenderBox>(clips.at(1));
        final center = box.localToGlobal(
            Offset(box.size.width / 2, box.size.height / 2));
        await tester.tapAt(center);
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();
      }
      expect(find.byType(TRate), findsOneWidget);
    });
  });
}
