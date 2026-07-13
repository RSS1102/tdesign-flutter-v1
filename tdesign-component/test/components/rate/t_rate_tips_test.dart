import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/rate/t_rate_tips.dart';

/// TRateTips 评分提示组件测试
///
/// 覆盖 allowHalf / isClick 组合下的展示分支与点击回调。
void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: Center(child: child)),
    );
  }

  const icon = Icons.star;

  Color defaultColor({double? value, bool? isActive}) => Colors.grey;

  testWidgets('allowHalf=false / isClick=false 渲染', (tester) async {
    Size? captured;
    await tester.pumpWidget(wrap(TRateTips(
      allowHalf: false,
      activeValue: 2,
      icon: icon,
      getIconColor: defaultColor,
      sizeCall: (s) => captured = s,
      isClick: false,
      tipClick: (_) {},
    )));
    await tester.pumpAndSettle();
    expect(find.byType(TRateTips), findsOneWidget);
    expect(captured, isNotNull);
  });

  testWidgets('allowHalf=false / isClick=true 渲染', (tester) async {
    await tester.pumpWidget(wrap(TRateTips(
      allowHalf: false,
      activeValue: 2,
      icon: icon,
      getIconColor: defaultColor,
      sizeCall: (_) {},
      isClick: true,
      tipClick: (_) {},
    )));
    await tester.pumpAndSettle();
    expect(find.byType(TRateTips), findsOneWidget);
  });

  testWidgets('allowHalf=true / isClick=false 渲染（第二个图标走 value 分支）',
      (tester) async {
    await tester.pumpWidget(wrap(TRateTips(
      allowHalf: true,
      activeValue: 1.5,
      icon: icon,
      getIconColor: defaultColor,
      sizeCall: (_) {},
      isClick: false,
      tipClick: (_) {},
    )));
    await tester.pumpAndSettle();
    expect(find.byType(TRateTips), findsOneWidget);
  });

  testWidgets('allowHalf=true / isClick=true 渲染并触发两个点击回调',
      (tester) async {
    double? halfTip;
    double? fullTip;
    await tester.pumpWidget(wrap(TRateTips(
      allowHalf: true,
      activeValue: 1.5,
      icon: icon,
      getIconColor: defaultColor,
      sizeCall: (_) {},
      isClick: true,
      tipClick: (v) {
        // 半星点击返回 index+0.5=1.5，全星点击返回 index+1.0=2.0
        if (v == 1.5) {
          halfTip = v;
        } else {
          fullTip = v;
        }
      },
    )));
    await tester.pumpAndSettle();
    // 直接调用两个 GestureDetector 的 onTap 覆盖回调主体
    final detectors = tester
        .widgetList(find.byType(GestureDetector))
        .whereType<GestureDetector>()
        .toList();
    expect(detectors.length, 2);
    detectors[0].onTap?.call();
    detectors[1].onTap?.call();
    expect(halfTip, 1.5);
    expect(fullTip, 2.0);
  });

  testWidgets('activeValue 为整数时半星高亮分支', (tester) async {
    await tester.pumpWidget(wrap(TRateTips(
      allowHalf: true,
      activeValue: 2.0,
      icon: icon,
      getIconColor: defaultColor,
      sizeCall: (_) {},
      isClick: true,
      tipClick: (_) {},
    )));
    await tester.pumpAndSettle();
    expect(find.byType(TRateTips), findsOneWidget);
  });
}
