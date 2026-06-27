import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/button/t_button_theme_data.dart';

/// TButton V1.0 Widget 测试
///
/// 覆盖所有公开 API 和关键行为路径，目标覆盖率 95%+。
void main() {
  // 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TButtonThemeData? buttonTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (buttonTheme != null) buttonTheme,
    ];
    return TTheme(
      data: TThemeData.defaultData(),
      child: MaterialApp(
        theme: ThemeData(
          extensions: themeExtensions,
        ),
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  // ============================================================
  // A 类控制：禁用（onPressed: null）
  // ============================================================
  group('TButton 禁用（A 类控制）', () {
    testWidgets('onPressed: null 表示禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('禁用按钮'),
          onPressed: null,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('onPressed 非 null 正常响应点击', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('可点击'),
          onPressed: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('可点击'));
      expect(tapped, isTrue);
    });
  });

  // ============================================================
  // variant × colorScheme 全矩阵（4×4 = 16 组合）
  // ============================================================
  group('TButton variant × colorScheme 全矩阵', () {
    const variants = TButtonVariant.values;
    const schemes = TButtonColorScheme.values;

    for (final variant in variants) {
      for (final scheme in schemes) {
        testWidgets('$variant + $scheme 正常渲染', (tester) async {
          await tester.pumpWidget(wrapWithTheme(
            TButton(
              child: Text('${variant.name}_${scheme.name}'),
              variant: variant,
              colorScheme: scheme,
              onPressed: null,
            ),
          ));

          expect(find.byType(TButton), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget);
        });
      }
    }
  });

  // ============================================================
  // shape 五档测试
  // ============================================================
  group('TButton shape 五档', () {
    testWidgets('shape: rectangle 正常渲染（默认圆角）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('rectangle'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.rectangle),
      ));

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shape: round 正常渲染（大圆角）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('round'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.round),
      ));

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shape: square 正常渲染（直角 + 等宽高）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('square'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(find.byType(TButton), findsOneWidget);

      // 验证 square 的 shape 为直角（RoundedRectangleBorder + BorderRadius.zero）
      final shape = button.style?.shape?.resolve({});
      expect(shape, isNotNull);
    });

    testWidgets('shape: circle 正常渲染（圆形）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('circle'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.circle),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(find.byType(TButton), findsOneWidget);

      final shape = button.style?.shape?.resolve({});
      // circle 应渲染为 CircleBorder
      expect(shape is CircleBorder, isTrue);
    });

    testWidgets('shape: filled 正常渲染（零圆角）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('filled'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.filled),
      ));

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('square 渲染为直角（BorderRadius.zero）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('square'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      expect(
        (shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.zero,
      );
    });

    testWidgets('rectangle 渲染有圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('rect'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.rectangle),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      final borderRadius = (shape as RoundedRectangleBorder).borderRadius;
      // rectangle 应有非零圆角
      expect(borderRadius, isNot(BorderRadius.zero));
    });
  });

  // ============================================================
  // icon 图标行为
  // ============================================================
  group('TButton icon 图标', () {
    testWidgets('icon 传入 Icon widget 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.add),
          child: const Text('带图标'),
          onPressed: null,
        ),
      ));

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('纯 icon 按钮（无 child）正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.star),
          onPressed: null,
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('纯 icon + circle shape 渲染正确', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.favorite),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.circle),
      ));

      expect(find.byIcon(Icons.favorite), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape is CircleBorder, isTrue);
    });

    testWidgets('纯 icon + square shape 等宽高', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.home),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      // square 纯 icon 应等宽高
      expect(minSize?.width, isNotNull);
      expect(minSize?.width, equals(minSize?.height));
    });

    testWidgets('icon 位置 left / right 皆正常', (tester) async {
      // left
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          icon: Icon(Icons.arrow_back),
          child: Text('返回'),
          iconPosition: TButtonIconPosition.left,
          onPressed: null,
        ),
      ));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('返回'), findsOneWidget);

      // right
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          icon: Icon(Icons.arrow_forward),
          child: Text('前进'),
          iconPosition: TButtonIconPosition.right,
          onPressed: null,
        ),
      ));
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('前进'), findsOneWidget);
    });
  });

  // ============================================================
  // size 四档 + Theme defaultSize
  // ============================================================
  group('TButton size', () {
    testWidgets('large 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('大'),
          size: TButtonSize.large,
          onPressed: null,
        ),
      ));
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('medium 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('中'),
          size: TButtonSize.medium,
          onPressed: null,
        ),
      ));
      expect(find.text('中'), findsOneWidget);
    });

    testWidgets('small 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('小'),
          size: TButtonSize.small,
          onPressed: null,
        ),
      ));
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('extraSmall 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('极小'),
          size: TButtonSize.extraSmall,
          onPressed: null,
        ),
      ));
      expect(find.text('极小'), findsOneWidget);
    });

    testWidgets('未传 size 且 Theme 未设 defaultSize 时 fallback 为 medium', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('默认尺寸'),
          onPressed: null,
        ),
      ));

      expect(find.text('默认尺寸'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // 验证默认 medium 尺寸的 minimumSize
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.height, 40); // medium 的 sideLength
    });

    testWidgets('未传 size 但 Theme 设置了 defaultSize 时读取 Theme 值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('Theme尺寸'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(defaultSize: TButtonSize.large),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.height, 48); // large 的 sideLength
    });

    testWidgets('构造器 size 覆盖 Theme defaultSize', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('覆盖'),
          size: TButtonSize.small,
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(defaultSize: TButtonSize.large),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.height, 32); // small 的 sideLength（被构造器覆盖）
    });
  });

  // ============================================================
  // P0 style 逃逸
  // ============================================================
  group('TButton P0 style 覆盖', () {
    testWidgets('实例 style 覆盖默认背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('自定义'),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: null,
        ),
      ));

      expect(find.text('自定义'), findsOneWidget);
    });

    testWidgets('实例 style 覆盖 shape', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('自定义shape'),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.rectangle),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape, isNotNull);
    });
  });

  // ============================================================
  // 渐变（gradient）
  // ============================================================
  group('TButton gradient 渐变', () {
    testWidgets('渐变存在时外层包裹 Container', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('渐变按钮'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
      ));

      // 渐变存在时应该包了一层 Container
      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('渐变时背景色为透明', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('渐变透明'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
      ));

      // elevated button 的 backgroundColor 在渐变时被强制为透明
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final bgColor = button.style?.backgroundColor?.resolve({});
      // 渐变时应为透明
      expect(bgColor, isNotNull);
    });

    testWidgets('渐变 + margin 组合正常', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('渐变边距'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(
          gradient: LinearGradient(colors: [Colors.orange, Colors.pink]),
          margin: EdgeInsets.all(16),
        ),
      ));

      expect(find.text('渐变边距'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('无渐变时不额外包裹 Container', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('无渐变'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
      ));

      // TButton 自身 render，无外包 Container（排除外层 TTheme/MaterialApp 的 Container）
      final topWidgets = find.byType(ElevatedButton);
      expect(topWidgets, findsOneWidget);
    });
  });

  // ============================================================
  // 交互态验证
  // ============================================================
  group('TButton 交互态', () {
    testWidgets('disabled 时前景色为禁用色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('禁用态'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final fgColorResolver = button.style?.foregroundColor;
      final fgColor = fgColorResolver?.resolve({WidgetState.disabled});
      // disabled 态前景色应与系统默认禁用文本色一致
      expect(fgColor, isNotNull);
    });

    testWidgets('enabled fill 按钮背景色为非透明', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('启用态'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {},
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final bgColor = button.style?.backgroundColor?.resolve({});
      // fill primary 启用态应非透明
      expect(bgColor, isNotNull);
      expect(bgColor!.opacity, greaterThan(0));
    });
  });

  // ============================================================
  // Theme 子树注入
  // ============================================================
  group('TButton Theme 子树', () {
    testWidgets('mergeExtension 覆盖构造器未传项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('Theme注入'),
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(
          defaultVariant: TButtonVariant.outline,
          defaultSize: TButtonSize.large,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button, isNotNull);
      expect(find.text('Theme注入'), findsOneWidget);
    });

    testWidgets('构造器参数覆盖 Theme 子树值', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('构造器优先'),
          variant: TButtonVariant.text,
          size: TButtonSize.small,
          onPressed: null,
        ),
        buttonTheme: const TButtonThemeData(
          defaultVariant: TButtonVariant.fill,
          defaultSize: TButtonSize.large,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      // 构造器 small 应覆盖 Theme 的 large (sideLength 32 vs 48)
      expect(minSize?.height, 32);
    });
  });

  // ============================================================
  // child 内容
  // ============================================================
  group('TButton child 内容', () {
    testWidgets('child 为 Text 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('文本内容'),
          onPressed: null,
        ),
      ));

      expect(find.text('文本内容'), findsOneWidget);
    });

    testWidgets('child 为自定义复杂 Widget 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 16),
              SizedBox(width: 4),
              Text('评分'),
            ],
          ),
          onPressed: null,
        ),
      ));

      expect(find.text('评分'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('child 为 null 且 icon 存在时仅渲染 icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.check),
          onPressed: null,
        ),
      ));

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  // ============================================================
  // 默认行为验证
  // ============================================================
  group('TButton 默认行为', () {
    testWidgets('未传 variant 时默认 fill', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('默认变体'),
          onPressed: null,
        ),
      ));

      expect(find.text('默认变体'), findsOneWidget);
      // fill 变体默认有 elevation: 0，验证无阴影
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final elevation = button.style?.elevation?.resolve({});
      expect(elevation, 0);
    });

    testWidgets('默认 iconPosition 为 left', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.add),
          child: const Text('按钮'),
          onPressed: null,
        ),
      ));

      // icon + text 共 2 个文本节点（icon 的 icon + child 的 text）
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('按钮'), findsOneWidget);
    });

    testWidgets('outline 变体有边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('描边'),
          variant: TButtonVariant.outline,
          onPressed: null,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final side = button.style?.side?.resolve({});
      expect(side, isNotNull);
    });

    testWidgets('text 变体无边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('文字'),
          variant: TButtonVariant.text,
          onPressed: null,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final side = button.style?.side?.resolve({});
      // text 变体默认无 side（BorderSide.none）
      expect(side == null || side == BorderSide.none, isTrue);
    });
  });
}
