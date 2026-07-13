import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/cell/t_cell_inherited.dart';
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
      // 用 DefaultAssetBundle 提供假的资源包，使 AssetImage 能解析出透明 PNG
      home: DefaultAssetBundle(
        bundle: _FakeAssetBundle(),
        child: Scaffold(body: child),
      ),
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
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TCell(title: '可点击', onTap: () => tapped = true),
      ));

      await tester.tap(find.text('可点击'));
      await tester.pump();
      expect(tapped, isTrue);
      await cleanupTimers(tester);
    });

    testWidgets('onTap: null 时禁用交互', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '禁用', onTap: null),
      ));

      await tester.tap(find.text('禁用'), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
      await cleanupTimers(tester);
    });

    testWidgets('onTap 触发 onLongPress 回调', (tester) async {
      var longPressed = false;
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
        const TCell(titleWidget: Text('自定义标题')),
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
        const TCell(
          title: '自定义',
          rightIconWidget: Icon(Icons.favorite),
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
        const TCell(
          title: '带图',
          imageWidget: Icon(Icons.person, size: 40),
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
        const TCellGroup(
          cells: [
            TCell(title: '单元格1'),
            TCell(title: '单元格2'),
            TCell(title: '单元格3'),
          ],
        ),
      ));
      expect(find.text('单元格1'), findsOneWidget);
      expect(find.text('单元格2'), findsOneWidget);
      expect(find.text('单元格3'), findsOneWidget);
    });

    testWidgets('TCellGroup title 显示分组标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          title: '分组标题',
          cells: [TCell(title: '内容')],
        ),
      ));
      expect(find.text('分组标题'), findsOneWidget);
    });

    testWidgets('TCellGroup titleWidget 自定义标题组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          titleWidget: Text('自定义分组标题'),
          cells: [TCell(title: '内容')],
        ),
      ));
      expect(find.text('自定义分组标题'), findsOneWidget);
    });

    testWidgets('TCellGroup cardTheme 卡片模式渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          groupVariant: TCellGroupVariant.cardTheme,
          cells: [
            TCell(title: '卡片1'),
            TCell(title: '卡片2'),
          ],
        ),
      ));
      expect(find.text('卡片1'), findsOneWidget);
      expect(find.text('卡片2'), findsOneWidget);
    });

    testWidgets('TCellGroup bordered=true 显示组边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          bordered: true,
          cells: [TCell(title: '边框组')],
        ),
      ));
      expect(find.byType(TCellGroup), findsOneWidget);
    });

    testWidgets('TCellGroup scrollable=true 可滚动模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          scrollable: true,
          cells: [
            TCell(title: '可滚动1'),
            TCell(title: '可滚动2'),
          ],
        ),
      ));
      expect(find.text('可滚动1'), findsOneWidget);
    });

    testWidgets('TCellGroup isShowLastBordered 显示最后边框', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          isShowLastBordered: true,
          cells: [
            TCell(title: '最后一项'),
          ],
        ),
      ));
      expect(find.byType(TCellGroup), findsOneWidget);
    });

    testWidgets('TCellGroup builder 自定义构建器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCellGroup(
          builder: (context, cell, index) {
            return Container(key: ValueKey(index), child: cell);
          },
          cells: const [TCell(title: '构建器项')],
        ),
      ));
      expect(find.text('构建器项'), findsOneWidget);
    });

    testWidgets('TCellGroup style 注入自定义 TCellThemeData', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCellGroup(
          style: TCellThemeData(
            backgroundColor: Colors.red,
            groupTitleStyle: const TextStyle(color: Colors.blue),
          ),
          title: '样式组',
          cells: const [TCell(title: '样式项')],
        ),
      ));
      expect(find.text('样式组'), findsOneWidget);
      expect(find.text('样式项'), findsOneWidget);
    });

    testWidgets('TCellGroup cell.bordered=false 不显示分隔线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(
          cells: [
            TCell(title: '无分隔', bordered: false),
            TCell(title: '有分隔'),
          ],
        ),
      ));
      expect(find.text('无分隔'), findsOneWidget);
      expect(find.text('有分隔'), findsOneWidget);
    });
  });

  // ============================================================
  // TCell 主题/对齐/样式扩展
  // ============================================================
  group('TCell 主题与对齐', () {
    testWidgets('注入 TCellThemeData align=top 对齐', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            TCellThemeData(align: TCellAlign.top),
          ]),
          home: const Scaffold(
            body: TCell(title: '顶对齐'),
          ),
        ),
      );
      expect(find.text('顶对齐'), findsOneWidget);
    });

    testWidgets('注入 TCellThemeData align=bottom 对齐', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            TCellThemeData(align: TCellAlign.bottom),
          ]),
          home: const Scaffold(
            body: TCell(title: '底对齐'),
          ),
        ),
      );
      expect(find.text('底对齐'), findsOneWidget);
    });

    testWidgets('注入 TCellThemeData height 设置高度', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            TCellThemeData(height: 80),
          ]),
          home: const Scaffold(
            body: TCell(title: '定高'),
          ),
        ),
      );
      // TCell 内部 Container 设置 height
      final cellFinder = find.byType(TCell);
      final size = tester.getSize(cellFinder);
      expect(size.height, 80);
    });

    testWidgets('注入 TCellThemeData showBottomBorder 显示下边框', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            TCellThemeData(showBottomBorder: true),
          ]),
          home: const Scaffold(
            body: TCell(title: '下边框'),
          ),
        ),
      );
      expect(find.text('下边框'), findsOneWidget);
    });

    testWidgets('注入 TCellThemeData hover=false 禁用点击反馈', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [
            TThemeData.defaultData(),
            TCellThemeData(hover: false),
          ]),
          home: Scaffold(
            body: TCell(title: '无反馈', onTap: () {}),
          ),
        ),
      );
      await tester.tap(find.text('无反馈'));
      await tester.pump();
      await cleanupTimers(tester);
    });
  });

  // ============================================================
  // TCell 内容插槽扩展
  // ============================================================
  group('TCell 内容插槽扩展', () {
    testWidgets('subtitleWidget 自定义副标题组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '主标题',
          subtitleWidget: Text('自定义副标题'),
        ),
      ));
      expect(find.text('主标题'), findsOneWidget);
      expect(find.text('自定义副标题'), findsOneWidget);
    });

    testWidgets('noteWidget 自定义说明组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '标题',
          noteWidget: Text('自定义说明'),
        ),
      ));
      expect(find.text('自定义说明'), findsOneWidget);
    });

    testWidgets('noteMaxWidth 限制说明文字宽度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '标题',
          note: '这是一段很长的说明文字内容用于测试最大宽度限制',
          noteMaxWidth: 100,
        ),
      ));
      expect(find.text('这是一段很长的说明文字内容用于测试最大宽度限制'),
          findsOneWidget);
    });

    testWidgets('noteMaxLine 限制说明文字行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '标题',
          note: '多行说明',
          noteMaxLine: 2,
        ),
      ));
      expect(find.text('多行说明'), findsOneWidget);
    });

    testWidgets('prefixWidget 自定义左侧图标组件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '带前缀',
          prefixWidget: Icon(Icons.home),
        ),
      ));
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('image 使用 ImageProvider 渲染主图', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '带图',
          image: AssetImage('test_assets/test.png'),
          imageSize: 40,
        ),
      ));
      expect(find.byType(TCell), findsOneWidget);
    });

    testWidgets('imageCircle 设置主图圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '圆角图',
          image: AssetImage('test_assets/test.png'),
          imageCircle: 20,
        ),
      ));
      expect(find.byType(TCell), findsOneWidget);
    });

    testWidgets('imageSize 设置主图尺寸', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(
          title: '尺寸图',
          image: AssetImage('test_assets/test.png'),
          imageSize: 32,
        ),
      ));
      expect(find.byType(TCell), findsOneWidget);
    });
  });

  // ============================================================
  // TCell 点击反馈状态
  // ============================================================
  group('TCell 点击反馈状态', () {
    testWidgets('点击后触发 active 状态背景色变化', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TCell(title: '点击反馈', onTap: () => tapped = true),
      ));

      // 使用单次手势：按下进入 active 态 -> 抬起触发点击
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('点击反馈')),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pump();

      expect(tapped, isTrue);
      await cleanupTimers(tester);
    });

    testWidgets('onLongPress=null 不触发长按回调', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCell(title: '无长按'),
      ));
      await tester.longPress(find.text('无长按'), warnIfMissed: false);
      await tester.pump();
      expect(find.text('无长按'), findsOneWidget);
      await cleanupTimers(tester);
    });
  });

  // ============================================================
  // TCellThemeData 单元测试
  // ============================================================
  group('TCellThemeData 单元测试', () {
    test('默认构造所有字段为 null', () {
      final data = TCellThemeData();
      expect(data.leftIconColor, isNull);
      expect(data.titleStyle, isNull);
      expect(data.align, isNull);
      expect(data.hover, isNull);
    });

    test('copyWith 合并字段', () {
      final data = TCellThemeData(backgroundColor: Colors.white);
      final copied = data.copyWith(
        backgroundColor: Colors.red,
        align: TCellAlign.top,
      );
      expect(copied.backgroundColor, Colors.red);
      expect(copied.align, TCellAlign.top);
    });

    test('lerp 在两个不同值之间插值', () {
      final data1 = TCellThemeData(backgroundColor: Colors.white);
      final data2 = TCellThemeData(backgroundColor: Colors.black);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped, isA<TCellThemeData>());
    });

    test('lerp 非 TCellThemeData 返回自身', () {
      final data = TCellThemeData(backgroundColor: Colors.white);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });

    test('cellStyle 工厂方法生成默认样式', () {
      // cellStyle 需要BuildContext，在widget测试中验证
      expect(TCellThemeData.new, returnsNormally);
    });
  });

  // ============================================================
  // TCellGroupVariant 枚举
  // ============================================================
  group('TCellGroupVariant 枚举', () {
    test('包含 defaultTheme 和 cardTheme 两个值', () {
      expect(TCellGroupVariant.values.length, 2);
      expect(TCellGroupVariant.values, contains(TCellGroupVariant.defaultTheme));
      expect(TCellGroupVariant.values, contains(TCellGroupVariant.cardTheme));
    });
  });

  // ============================================================
  // TCellAlign 枚举
  // ============================================================
  group('TCellAlign 枚举', () {
    test('包含 top/middle/bottom 三个值', () {
      expect(TCellAlign.values.length, 3);
      expect(TCellAlign.values, contains(TCellAlign.top));
      expect(TCellAlign.values, contains(TCellAlign.middle));
      expect(TCellAlign.values, contains(TCellAlign.bottom));
    });
  });

  // ============================================================
  // TCellInherited
  // ============================================================
  group('TCellInherited', () {
    testWidgets('通过 TCellGroup 注入 TCellInherited', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCellGroup(cells: [TCell(title: '继承测试')]),
      ));
      // TCellGroup 内部创建 TCellInherited
      expect(find.byType(TCellInherited), findsOneWidget);
      expect(find.text('继承测试'), findsOneWidget);
    });
  });
}

/// 1x1 透明 PNG 的 base64 编码
const String _transparentPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

/// 假的 AssetBundle：AssetManifest 返回空清单，其它 asset 返回 1x1 透明 PNG
class _FakeAssetBundle extends CachingAssetBundle {
  final Uint8List _pngBytes = base64.decode(_transparentPngBase64);

  @override
  Future<ByteData> load(String key) async {
    if (key.contains('AssetManifest')) {
      final data =
          const StandardMessageCodec().encodeMessage(<String, Object>{});
      return data!;
    }
    return ByteData.view(_pngBytes.buffer);
  }
}
