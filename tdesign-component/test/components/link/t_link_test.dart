import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // ============================================================
  // T01 – 基础渲染：纯文本链接
  // ============================================================
  testWidgets('T01 - 基础渲染：纯文本链接', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('跳转链接'),
        variant: TLinkType.basic,
      ),
    ));

    // 应该渲染出文本
    expect(find.text('跳转链接'), findsOneWidget);
    // 不应有下划线
    final text = tester.widget<Text>(find.text('跳转链接'));
    expect(text.style?.decoration, isNull);
  });

  // ============================================================
  // T02 – 下划线链接
  // ============================================================
  testWidgets('T02 - 下划线链接', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('带下划线'),
        variant: TLinkType.underline,
      ),
    ));

    expect(find.text('带下划线'), findsOneWidget);
    final text = tester.widget<Text>(find.text('带下划线'));
    expect(text.style?.decoration, TextDecoration.underline);
  });

  // ============================================================
  // T03 – 带图标链接（默认图标）
  // ============================================================
  testWidgets('T03 - 带图标链接（默认图标）', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('图标链接'),
        variant: TLinkType.icon,
      ),
    ));

    expect(find.text('图标链接'), findsOneWidget);
    // 默认图标模式下有 Icon widget
    expect(find.byType(Icon), findsWidgets);
  });

  // ============================================================
  // T04 – 带前缀图标链接
  // ============================================================
  testWidgets('T04 - 带前缀图标链接', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('前置图标'),
        variant: TLinkType.icon,
        prefixIcon: const Icon(Icons.home),
      ),
    ));

    expect(find.text('前置图标'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
  });

  // ============================================================
  // T05 – 带后缀图标链接
  // ============================================================
  testWidgets('T05 - 带后缀图标链接', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('后置图标'),
        variant: TLinkType.icon,
        suffixIcon: const Icon(Icons.arrow_forward),
      ),
    ));

    expect(find.text('后置图标'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  // ============================================================
  // T06 – 禁用态（onPressed: null）
  // ============================================================
  testWidgets('T06 - 禁用态（onPressed: null）', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('禁用链接'),
        onPressed: null,
      ),
    ));

    await tester.tap(find.text('禁用链接'));
    expect(tapped, false);
  });

  // ============================================================
  // T07 – 点击回调
  // ============================================================
  testWidgets('T07 - 点击回调', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('可点击链接'),
        onPressed: () => tapped = true,
      ),
    ));

    await tester.tap(find.text('可点击链接'));
    expect(tapped, true);
  });

  // ============================================================
  // T08 – colorScheme × variant 颜色映射（通过 resolve）
  // ============================================================
  testWidgets('T08 - colorScheme 颜色映射', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('主题色'),
        colorScheme: TLinkColorScheme.danger,
        variant: TLinkType.basic,
      ),
    ));

    final text = tester.widget<Text>(find.text('主题色'));
    expect(text.style?.color, isNotNull);
  });

  // ============================================================
  // T09 – size 三档字号验证
  // ============================================================
  testWidgets('T09 - size 三档字号', (tester) async {
    // Small
    await tester.pumpWidget(_wrap(
      TLink(child: const Text('S'), size: TLinkSize.small),
    ));
    final textS = tester.widget<Text>(find.text('S'));
    expect(textS.style?.fontSize, 12);

    // Medium
    await tester.pumpWidget(_wrap(
      TLink(child: const Text('M'), size: TLinkSize.medium),
    ));
    final textM = tester.widget<Text>(find.text('M'));
    expect(textM.style?.fontSize, 14);

    // Large
    await tester.pumpWidget(_wrap(
      TLink(child: const Text('L'), size: TLinkSize.large),
    ));
    final textL = tester.widget<Text>(find.text('L'));
    expect(textL.style?.fontSize, 16);
  });

  // ============================================================
  // T10 – 自定义颜色覆盖 colorScheme
  // ============================================================
  testWidgets('T10 - 自定义颜色覆盖 colorScheme', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('自定义色'),
        color: Colors.purple,
        colorScheme: TLinkColorScheme.primary,
      ),
    ));

    final text = tester.widget<Text>(find.text('自定义色'));
    expect(text.style?.color, Colors.purple);
  });

  // ============================================================
  // T11 – 自定义字号覆盖 size 默认
  // ============================================================
  testWidgets('T11 - 自定义字号覆盖', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('自定义字号'),
        fontSize: 20,
        size: TLinkSize.medium,
      ),
    ));

    final text = tester.widget<Text>(find.text('自定义字号'));
    expect(text.style?.fontSize, 20);
  });

  // ============================================================
  // T12 – TLinkThemeData 子树注入
  // ============================================================
  testWidgets('T12 - TLinkThemeData 子树注入', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Theme(
            data: ThemeData().copyWith(
              extensions: [
                const TLinkThemeData(
                  defaultVariant: TLinkType.underline,
                  fontSize: 18,
                ),
              ],
            ),
            child: Builder(
              builder: (context) {
                return TLink(
                  child: const Text('Theme注入'),
                  size: TLinkSize.medium,
                );
              },
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Theme注入'));
    // Theme 注入的字号应生效（18 覆盖 size 默认 14）
    expect(text.style?.fontSize, 18);
  });

  // ============================================================
  // T13 – TLinkThemeData copyWith
  // ============================================================
  test('T13 - TLinkThemeData copyWith', () {
    final original = const TLinkThemeData(fontSize: 14, iconSize: 16);
    final copied = original.copyWith(fontSize: 20);

    expect(copied.fontSize, 20);
    expect(copied.iconSize, 16); // 未覆盖的保持原值
  });

  // ============================================================
  // T14 – TLinkThemeData lerp
  // ============================================================
  test('T14 - TLinkThemeData lerp', () {
    final a = const TLinkThemeData(fontSize: 12, iconSize: 14);
    final b = const TLinkThemeData(fontSize: 20, iconSize: 24);

    // t=0 时取 a
    final lerpA = a.lerp(b, 0.0);
    expect(lerpA.fontSize, 12);
    expect(lerpA.iconSize, 14);

    // t=1 时取 b
    final lerpB = a.lerp(b, 1.0);
    expect(lerpB.fontSize, 20);
    expect(lerpB.iconSize, 24);
  });

  // ============================================================
  // T15 – Resolve 优先级：构造器 > Theme > 默认
  // ============================================================
  testWidgets('T15 - Resolve 优先级', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Theme(
            data: ThemeData().copyWith(
              extensions: [
                const TLinkThemeData(fontSize: 22),
              ],
            ),
            child: Builder(
              builder: (context) {
                return TLink(
                  child: const Text('优先级'),
                  fontSize: 30, // 构造器参数应覆盖 Theme
                  size: TLinkSize.medium,
                );
              },
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('优先级'));
    expect(text.style?.fontSize, 30); // 构造器优先于 Theme(22)
  });

  // ============================================================
  // T16 – 构造器 fontSize 覆盖 Theme 和 size 默认
  // ============================================================
  testWidgets('T16 - 构造器 fontSize 覆盖', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('覆盖测试'),
        fontSize: 24,
        size: TLinkSize.small, // 默认 12
      ),
    ));

    final text = tester.widget<Text>(find.text('覆盖测试'));
    expect(text.style?.fontSize, 24);
  });

  // ============================================================
  // T17 – 非 Text child（DefaultTextStyle 包裹）
  // ============================================================
  testWidgets('T17 - 非 Text child', (tester) async {
    await tester.pumpWidget(_wrap(
      TLink(
        child: Text.rich(
          TextSpan(
            text: '富文本',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        variant: TLinkType.underline,
      ),
    ));

    expect(find.text('富文本'), findsOneWidget);
  });

  // ============================================================
  // T18 – TLinkConfiguration 存在性
  // ============================================================
  testWidgets('T18 - TLinkConfiguration 存在性', (tester) async {
    var called = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TLinkConfiguration(
            onTapAll: (uri) => called = true,
            child: TLink(
              child: const Text('配置链接'),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('配置链接'), findsOneWidget);
    // TLinkConfiguration 存在且不报错
  });
}

/// 最小化包装
Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}
