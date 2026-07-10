import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDropdownMenu 组件 Widget 测试
///
/// 覆盖菜单渲染、方向、禁用、选项选择、多选、回调等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TDropdownThemeData? dropdownTheme}) {
    final themeExtensions = <ThemeExtension>[
      TThemeData.defaultData(),
      if (dropdownTheme != null) dropdownTheme,
    ];
    return MaterialApp(
      theme: ThemeData(extensions: themeExtensions),
      home: Scaffold(body: child),
    );
  }

  /// 基础选项
  List<TDropdownItemOption> baseOptions() => [
        TDropdownItemOption(value: '1', label: '选项一'),
        TDropdownItemOption(value: '2', label: '选项二'),
        TDropdownItemOption(value: '3', label: '选项三'),
      ];

  // ============================================================
  // TDropdownItemOption 单元测试
  // ============================================================
  group('TDropdownItemOption', () {
    test('默认值', () {
      final opt = TDropdownItemOption(value: 'v', label: '标签');
      expect(opt.value, 'v');
      expect(opt.label, '标签');
      expect(opt.disabled, isFalse);
      expect(opt.selected, isFalse);
    });

    test('selected: true 设置选中', () {
      final opt = TDropdownItemOption(value: 'v', label: '标签', selected: true);
      expect(opt.selected, isTrue);
    });
  });

  // ============================================================
  // 枚举验证
  // ============================================================
  group('枚举', () {
    test('TDropdownMenuDirection 有三个值', () {
      expect(TDropdownMenuDirection.values.length, 3);
      expect(TDropdownMenuDirection.values, contains(TDropdownMenuDirection.down));
      expect(TDropdownMenuDirection.values, contains(TDropdownMenuDirection.up));
      expect(TDropdownMenuDirection.values, contains(TDropdownMenuDirection.auto));
    });
  });

  // ============================================================
  // 菜单渲染
  // ============================================================
  group('TDropdownMenu 基础渲染', () {
    testWidgets('渲染多个下拉项标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '排序', options: baseOptions()),
            TDropdownItem(label: '筛选', options: baseOptions()),
          ],
        ),
      ));

      expect(find.byType(TDropdownMenu), findsOneWidget);
      expect(find.text('排序'), findsOneWidget);
      expect(find.text('筛选'), findsOneWidget);
    });

    testWidgets('使用 builder 构建下拉项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          builder: (context) => [
            TDropdownItem(label: '构建器项', options: baseOptions()),
          ],
        ),
      ));

      expect(find.text('构建器项'), findsOneWidget);
    });

    testWidgets('空 items 列表渲染空菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDropdownMenu(items: []),
      ));
      expect(find.byType(TDropdownMenu), findsOneWidget);
    });

    testWidgets('direction: down 向下展开', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.down,
          items: [
            TDropdownItem(label: '向下', options: baseOptions()),
          ],
        ),
      ));
      expect(find.text('向下'), findsOneWidget);
    });

    testWidgets('direction: up 向上展开', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.up,
          items: [
            TDropdownItem(label: '向上', options: baseOptions()),
          ],
        ),
      ));
      expect(find.text('向上'), findsOneWidget);
    });

    testWidgets('isScrollable: true 横向滚动菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TDropdownMenu(
            isScrollable: true,
            items: List.generate(
              5,
              (i) => TDropdownItem(
                label: '菜单项$i',
                options: baseOptions(),
                tabBarWidth: 80,
              ),
            ),
          ),
        ),
      ));
      expect(find.byType(TDropdownMenu), findsOneWidget);
    });
  });

  // ============================================================
  // 禁用状态
  // ============================================================
  group('TDropdownMenu 禁用', () {
    testWidgets('disabled 项不响应点击', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '禁用项', options: baseOptions(), disabled: true),
            TDropdownItem(label: '可用项', options: baseOptions()),
          ],
        ),
      ));

      // 点击禁用项不应弹出
      await tester.tap(find.text('禁用项'));
      await tester.pumpAndSettle();

      // 选项不应出现
      expect(find.text('选项一'), findsNothing);
    });
  });

  // ============================================================
  // 选项选择
  // ============================================================
  group('TDropdownMenu 选项选择', () {
    testWidgets('点击菜单项打开下拉面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '排序', options: baseOptions()),
          ],
        ),
      ));

      await tester.tap(find.text('排序'));
      await tester.pumpAndSettle();

      // 选项应出现
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('单选模式选择后触发 onChanged 并关闭', (tester) async {
      String? selectedValue;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '排序',
              options: baseOptions(),
              onChanged: (dynamic value) {
                selectedValue = value;
              },
            ),
          ],
        ),
      ));

      await tester.tap(find.text('排序'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(selectedValue, isNotNull);
    });

    testWidgets('预选中选项 label 显示在菜单栏', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '排序',
              options: [
                TDropdownItemOption(value: '1', label: '选项一'),
                TDropdownItemOption(value: '2', label: '选项二', selected: true),
              ],
            ),
          ],
        ),
      ));

      // 选中项的 label 应显示在菜单
      expect(find.text('选项二'), findsOneWidget);
    });
  });

  // ============================================================
  // 多选模式
  // ============================================================
  group('TDropdownMenu 多选', () {
    testWidgets('multiple: true 渲染确认/重置按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '多选',
              multiple: true,
              options: baseOptions(),
            ),
          ],
        ),
      ));

      await tester.tap(find.text('多选'));
      await tester.pumpAndSettle();

      // 多选模式应显示确认和重置按钮
      expect(find.text('确定'), findsOneWidget);
      expect(find.text('重置'), findsOneWidget);
    });

    testWidgets('多选确认触发 onConfirm', (tester) async {
      dynamic confirmedValues;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '多选',
              multiple: true,
              options: baseOptions(),
              onConfirm: (value) {
                confirmedValues = value;
              },
            ),
          ],
        ),
      ));

      await tester.tap(find.text('多选'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('选项一'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();

      expect(confirmedValues, isNotNull);
    });
  });

  // ============================================================
  // 选项分栏
  // ============================================================
  group('TDropdownMenu 选项分栏', () {
    testWidgets('optionsColumns: 2 双列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '分栏',
              optionsColumns: 2,
              options: [
                TDropdownItemOption(value: '1', label: 'A'),
                TDropdownItemOption(value: '2', label: 'B'),
                TDropdownItemOption(value: '3', label: 'C'),
                TDropdownItemOption(value: '4', label: 'D'),
              ],
            ),
          ],
        ),
      ));

      await tester.tap(find.text('分栏'));
      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义标签
  // ============================================================
  group('TDropdownMenu 自定义标签', () {
    testWidgets('labelBuilder 自定义标签内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '自定义', options: baseOptions()),
          ],
          labelBuilder: (context, label, isOpened, index) {
            return Text('[$label]');
          },
        ),
      ));

      expect(find.text('[自定义]'), findsOneWidget);
    });

    testWidgets('自定义箭头图标和颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          arrowIcon: Icons.arrow_drop_down,
          arrowColor: Colors.red,
          items: [
            TDropdownItem(label: '箭头', options: baseOptions()),
          ],
        ),
      ));
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TDropdownMenu 主题覆盖', () {
    testWidgets('TDropdownThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '主题', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          height: 60,
          isScrollable: false,
        ),
      ));
      expect(find.text('主题'), findsOneWidget);
    });

    test('TDropdownThemeData merge 合并', () {
      const base = TDropdownThemeData(height: 48, width: 200);
      const override = TDropdownThemeData(height: 60);
      final merged = base.merge(override);
      expect(merged.height, 60);
      expect(merged.width, 200);
    });

    test('TDropdownItemController reset 方法', () {
      final controller = TDropdownItemController();
      // 不绑定 state 时调用 reset 不应崩溃
      controller.reset();
    });

    test('TDropdownItem getLabel 返回选中项 label', () {
      final item = TDropdownItem(
        label: '默认',
        options: [
          TDropdownItemOption(value: '1', label: '选项一'),
          TDropdownItemOption(value: '2', label: '选项二', selected: true),
        ],
      );
      expect(item.getLabel(), '选项二');
    });

    test('TDropdownItem getLabel 无选中时返回 label', () {
      final item = TDropdownItem(
        label: '默认标签',
        options: baseOptions(),
      );
      expect(item.getLabel(), '默认标签');
    });
  });
}
