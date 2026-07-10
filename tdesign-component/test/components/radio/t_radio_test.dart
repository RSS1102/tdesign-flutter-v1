import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TRadio / TRadioGroup V1.0 Widget 测试
///
/// TRadio 继承自 TCheckbox，但无 onChanged 参数，通过 TRadioGroup 管理。
/// TRadioGroup 继承自 TCheckboxGroup，通过 selectId + onRadioGroupChange 控制。
/// 覆盖：构造器、四种 radioStyle、disabled、Theme 覆盖、Group 切换、
/// strictMode、卡片模式、自定义 icon/content、contentDirection、size。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TRadio 基础渲染', () {
    testWidgets('TRadio 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(id: 'r1', title: '单选项'),
      ));
      expect(find.byType(TRadio), findsOneWidget);
      expect(find.text('单选项'), findsOneWidget);
    });

    testWidgets('TRadio 带副标题渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '主标题',
          subTitle: '副标题'),
      ));
      expect(find.text('主标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });

    testWidgets('TRadio 带 id 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(id: 'r1', title: '带id'),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });
  });

  // ============================================================
  // 四种 radioStyle 枚举变体
  // ============================================================
  group('TRadio radioStyle 枚举变体', () {
    testWidgets('radioStyle=circle（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '圆形',
          radioStyle: TRadioVariant.circle),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });

    testWidgets('radioStyle=square 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '方形',
          radioStyle: TRadioVariant.square),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });

    testWidgets('radioStyle=check 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '勾选',
          radioStyle: TRadioVariant.check),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });

    testWidgets('radioStyle=hollowCircle 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '镂空圆',
          radioStyle: TRadioVariant.hollowCircle),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });
  });

  // ============================================================
  // disabled / enabled=false
  // ============================================================
  group('TRadio 禁用状态', () {
    testWidgets('enabled=false 时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '禁用项',
          enabled: false),
      ));
      expect(find.byType(TRadio), findsOneWidget);
      expect(find.text('禁用项'), findsOneWidget);
    });
  });

  // ============================================================
  // Theme 覆盖（TRadioThemeData）
  // ============================================================
  group('TRadio Theme 覆盖', () {
    testWidgets('TRadioThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            const TRadioThemeData(
              radioStyle: TRadioVariant.square,
              selectColor: Color(0xFFFF0000),
              titleColor: Color(0xFF00FF00),
            ),
          ]),
          home: const Scaffold(
            body: Center(
              child: TRadio(id: 'r1', title: '主题覆盖'),
            ),
          ),
        ),
      );
      expect(find.byType(TRadio), findsOneWidget);
      expect(find.text('主题覆盖'), findsOneWidget);
    });
  });

  // ============================================================
  // TRadioGroup 基础渲染
  // ============================================================
  group('TRadioGroup 基础渲染', () {
    testWidgets('垂直方向 RadioGroup 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          direction: Axis.vertical,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '选项一'),
            TRadio(id: 'r2', title: '选项二'),
            TRadio(id: 'r3', title: '选项三'),
          ],
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项三'), findsOneWidget);
    });

    testWidgets('使用 child 方式渲染 RadioGroup', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          child: const Column(
            children: [
              TRadio(id: 'r1', title: '子选项A'),
              TRadio(id: 'r2', title: '子选项B'),
            ],
          ),
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
      expect(find.text('子选项A'), findsOneWidget);
      expect(find.text('子选项B'), findsOneWidget);
    });
  });

  // ============================================================
  // TRadioGroup 切换行为
  // ============================================================
  group('TRadioGroup 切换行为', () {
    testWidgets('点击另一个 Radio 触发 onRadioGroupChange', (tester) async {
      String? selectedId;
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          direction: Axis.vertical,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '选项一'),
            TRadio(id: 'r2', title: '选项二'),
          ],
          onRadioGroupChange: (id) => selectedId = id,
        ),
      ));

      // 点击第二个 Radio
      await tester.tap(find.text('选项二'), warnIfMissed: false);
      await tester.pump();
      expect(selectedId, 'r2');
    });

    testWidgets('strictMode=true 时点击已选项不取消也不触发回调', (tester) async {
      String? selectedId;
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          strictMode: true,
          direction: Axis.vertical,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '选项一'),
            TRadio(id: 'r2', title: '选项二'),
          ],
          onRadioGroupChange: (id) => selectedId = id,
        ),
      ));

      // strictMode 下点击当前已选项，GestureDetector 不响应，onRadioGroupChange 不触发
      await tester.tap(find.text('选项一'), warnIfMissed: false);
      await tester.pump();
      // 回调未被调用，selectedId 仍为 null
      expect(selectedId, isNull);
    });

    testWidgets('strictMode=false 时可取消已选项', (tester) async {
      String? selectedId;
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          strictMode: false,
          direction: Axis.vertical,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '选项一'),
            TRadio(id: 'r2', title: '选项二'),
          ],
          onRadioGroupChange: (id) => selectedId = id,
        ),
      ));

      // 点击当前已选项，应取消（非严格模式）
      await tester.tap(find.text('选项一'), warnIfMissed: false);
      await tester.pump();
      // 取消后 onRadioGroupChange 传入 null
      expect(selectedId, isNull);
    });
  });

  // ============================================================
  // TRadioGroup 水平方向 + radioCheckStyle
  // ============================================================
  group('TRadioGroup 水平方向', () {
    testWidgets('水平方向 RadioGroup 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一'),
            TRadio(id: 'r2', title: '二'),
          ],
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
      expect(find.text('一'), findsOneWidget);
      expect(find.text('二'), findsOneWidget);
    });

    testWidgets('radioCheckStyle 统一设置组内 Radio 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          radioCheckStyle: TRadioVariant.square,
          direction: Axis.vertical,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '方形一'),
            TRadio(id: 'r2', title: '方形二'),
          ],
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
    });
  });

  // ============================================================
  // contentDirection
  // ============================================================
  group('TRadio contentDirection', () {
    testWidgets('contentDirection=left 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '左方向',
          contentDirection: TContentDirection.left),
      ));
      expect(find.byType(TRadio), findsOneWidget);
      expect(find.text('左方向'), findsOneWidget);
    });

    testWidgets('contentDirection=right（默认）正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '右方向',
          contentDirection: TContentDirection.right),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });
  });

  // ============================================================
  // 卡片模式 + 自定义 icon/content
  // ============================================================
  group('TRadio 卡片模式与自定义', () {
    testWidgets('cardMode=true 水平卡片渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          cardMode: true,
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '卡一', cardMode: true),
            TRadio(id: 'r2', title: '卡二', cardMode: true),
          ],
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
      expect(find.text('卡一'), findsOneWidget);
      expect(find.text('卡二'), findsOneWidget);
    });

    testWidgets('customIconBuilder 自定义图标渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadio(
          id: 'r1',
          title: '自定义图标',
          customIconBuilder: (context, checked) =>
              const Icon(Icons.star, size: 24),
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('customContentBuilder 自定义内容渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadio(
          id: 'r1',
          customContentBuilder: (context, checked, content) =>
              const Text('自定义内容'),
        ),
      ));
      expect(find.text('自定义内容'), findsOneWidget);
    });
  });

  // ============================================================
  // size 变体
  // ============================================================
  group('TRadio size 尺寸', () {
    testWidgets('size=small 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '小尺寸',
          size: TCheckBoxSize.small),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });

    testWidgets('size=large 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '大尺寸',
          size: TCheckBoxSize.large),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });
  });

  group('TRadio 高级分支', () {
    testWidgets('passThrough + vertical 应用圆角与边距', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          passThrough: true,
          direction: Axis.vertical,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一'),
            TRadio(id: 'r2', title: '二'),
          ],
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
    });

    testWidgets('rowCount=2 横向分两行排列', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TRadioGroup(
          selectId: 'r1',
          direction: Axis.horizontal,
          rowCount: 2,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一'),
            TRadio(id: 'r2', title: '二'),
            TRadio(id: 'r3', title: '三'),
          ],
          onRadioGroupChange: (id) {},
        ),
      ));
      expect(find.byType(TRadioGroup), findsOneWidget);
    });

    testWidgets('disabled + hollowCircle + 选中 应用 disableColor/selectColor',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '禁用选中',
          enabled: false,
          radioStyle: TRadioVariant.hollowCircle,
          selectColor: Colors.blue,
          disableColor: Colors.grey,
        ),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });

    testWidgets('选中 + square + selectColor 应用主题色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TRadio(
          id: 'r1',
          title: '选中',
          radioStyle: TRadioVariant.square,
          selectColor: Colors.blue,
        ),
      ));
      expect(find.byType(TRadio), findsOneWidget);
    });
  });

  group('TRadioGroup 校验断言', () {
    test('direction 设置但缺少 directionalTdRadios 抛错', () {
      expect(
        () => TRadioGroup(
          direction: Axis.horizontal,
          onRadioGroupChange: (id) {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('direction 与 child 均为 null 抛错', () {
      expect(
        () => TRadioGroup(
          onRadioGroupChange: (id) {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('横向 radio 含 subTitle 抛错', () {
      expect(
        () => TRadioGroup(
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一', subTitle: '副'),
          ],
          onRadioGroupChange: (id) {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('横向 radio 标题超长抛错', () {
      expect(
        () => TRadioGroup(
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一二三四五'),
          ],
          onRadioGroupChange: (id) {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('cardMode 下存在未设置 cardMode 的 radio 抛错', () {
      expect(
        () => TRadioGroup(
          cardMode: true,
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一', cardMode: false),
          ],
          onRadioGroupChange: (id) {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });

    test('cardMode 横向含 subTitle 抛错', () {
      expect(
        () => TRadioGroup(
          cardMode: true,
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'r1', title: '一', cardMode: true, subTitle: '副'),
          ],
          onRadioGroupChange: (id) {},
        ),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
