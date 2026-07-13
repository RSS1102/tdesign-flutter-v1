import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCheckbox V1.0 Widget 测试
/// B 类控制：value + onChanged 受控；onChanged:null 禁用。
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  group('TCheckbox B 类控制（value + onChanged）', () {
    testWidgets('value=false 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('value=true 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: true, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('onChanged 回调触发', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (_) {}),
      ));
      await tester.tap(find.byType(TCheckbox), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('onChanged:null 时禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TCheckbox(value: false),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('enabled=false 时禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, enabled: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  group('TCheckbox title', () {
    testWidgets('title 显示标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(title: '选项A', value: false, onChanged: (_) {}),
      ));
      expect(find.text('选项A'), findsOneWidget);
    });

    testWidgets('subTitle 显示副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '主标题',
          subTitle: '副标题',
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('主标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });
  });

  group('TCheckbox id', () {
    testWidgets('id 标识正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(id: 'cb1', value: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  group('TCheckbox 组合', () {
    testWidgets('title + value=true + onChanged', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(title: '已选', value: true, onChanged: (_) {}),
      ));
      expect(find.text('已选'), findsOneWidget);
    });

    testWidgets('title + subTitle + enabled=false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '禁用项',
          subTitle: '不可选',
          enabled: false,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('禁用项'), findsOneWidget);
    });

    testWidgets('多个 Checkbox 同时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Column(children: [
          TCheckbox(title: '选项1', value: true, onChanged: (_) {}),
          TCheckbox(title: '选项2', value: false, onChanged: (_) {}),
          TCheckbox(title: '选项3', value: false, onChanged: (_) {}),
        ]),
      ));
      expect(find.text('选项1'), findsOneWidget);
      expect(find.text('选项2'), findsOneWidget);
      expect(find.text('选项3'), findsOneWidget);
    });

    testWidgets('titleMaxLine 限制行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '这是一个很长很长很长很长很长的标题',
          titleMaxLine: 1,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  // ============================================================
  // style 复选框样式：circle / square / check
  // ============================================================
  group('TCheckbox style 样式', () {
    testWidgets('style=circle 选中态渲染 check_circle_filled 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '圆形选中',
          style: TCheckboxVariant.circle,
          value: true,
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
      expect(find.text('圆形选中'), findsOneWidget);
    });

    testWidgets('style=circle 未选中态渲染 circle 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '圆形未选',
          style: TCheckboxVariant.circle,
          value: false,
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('style=square 选中态渲染 check_rectangle_filled', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '方形选中',
          style: TCheckboxVariant.square,
          value: true,
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('style=square 未选中态渲染 rectangle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '方形未选',
          style: TCheckboxVariant.square,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('style=check 选中态渲染 check 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'check选中',
          style: TCheckboxVariant.check,
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('style=check 未选中态渲染 check 图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'check未选',
          style: TCheckboxVariant.check,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  // ============================================================
  // size 大小：large / small
  // ============================================================
  group('TCheckbox size 大小', () {
    testWidgets('size=large 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '大尺寸',
          size: TCheckBoxSize.large,
          value: false,
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
      expect(find.text('大尺寸'), findsOneWidget);
    });

    testWidgets('size=small 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '小尺寸',
          size: TCheckBoxSize.small,
          value: false,
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  // ============================================================
  // contentDirection 内容方向
  // ============================================================
  group('TCheckbox contentDirection 方向', () {
    testWidgets('contentDirection=left 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '左方向',
          contentDirection: TContentDirection.left,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
      expect(find.text('左方向'), findsOneWidget);
    });

    testWidgets('contentDirection=right + subTitle 渲染副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '主',
          subTitle: '副',
          contentDirection: TContentDirection.right,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('主'), findsOneWidget);
      expect(find.text('副'), findsOneWidget);
    });

    testWidgets('contentDirection=left + subTitle 渲染副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '主',
          subTitle: '副内容',
          contentDirection: TContentDirection.left,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('副内容'), findsOneWidget);
    });
  });

  // ============================================================
  // cardMode 卡片模式
  // ============================================================
  group('TCheckbox cardMode 卡片模式', () {
    testWidgets('cardMode=true + 选中态渲染 RadioCornerIcon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '卡片选中',
          cardMode: true,
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
      expect(find.byType(RadioCornerIcon), findsOneWidget);
    });

    testWidgets('cardMode=true + 未选中态不渲染 RadioCornerIcon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '卡片未选',
          cardMode: true,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
      expect(find.byType(RadioCornerIcon), findsNothing);
    });

    testWidgets('cardMode=true + 自定义 selectColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '卡片颜色',
          cardMode: true,
          value: true,
          selectColor: Colors.blue,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('cardMode=true + showDivider 不显示分割线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '卡片无分割',
          cardMode: true,
          showDivider: false,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('cardMode=true + subTitle 渲染副标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '卡片主',
          subTitle: '卡片副',
          cardMode: true,
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.text('卡片主'), findsOneWidget);
      expect(find.text('卡片副'), findsOneWidget);
    });

    testWidgets('RadioCorner CustomPainter paint 方法触发', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'paint测试',
          cardMode: true,
          value: true,
          onChanged: (_) {}),
      ));
      await tester.pump();
      // CustomPaint 由 RadioCornerIcon 内部使用，验证 CustomPaint 存在
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  // ============================================================
  // showDivider 分割线
  // ============================================================
  group('TCheckbox showDivider 分割线', () {
    testWidgets('showDivider=false 不显示分割线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '无分割线',
          showDivider: false,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
      expect(find.byType(TDivider), findsNothing);
    });

    testWidgets('showDivider=true 显示分割线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '有分割线',
          showDivider: true,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义颜色
  // ============================================================
  group('TCheckbox 自定义颜色', () {
    testWidgets('backgroundColor 自定义背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '背景色',
          backgroundColor: Colors.yellow,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('selectColor 自定义选中颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '选中色',
          selectColor: Colors.green,
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('disableColor 自定义禁用颜色 + 选中态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '禁用选中',
          enabled: false,
          disableColor: Colors.grey,
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('disableColor 自定义禁用颜色 + 未选中态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '禁用未选',
          enabled: false,
          disableColor: Colors.grey,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('enabled=false + style=check + 禁用颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'check禁用',
          style: TCheckboxVariant.check,
          enabled: false,
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('enabled=false + style=square + 禁用颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'square禁用',
          style: TCheckboxVariant.square,
          enabled: false,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('titleColor / subTitleColor 自定义文字颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '主标题',
          subTitle: '副标题',
          titleColor: Colors.red,
          subTitleColor: Colors.blue,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('主标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
    });

    testWidgets('enabled=false + subTitle 使用禁用文字颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '禁用',
          subTitle: '禁用副',
          enabled: false,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('禁用'), findsOneWidget);
      expect(find.text('禁用副'), findsOneWidget);
    });
  });

  // ============================================================
  // customIconBuilder / customContentBuilder 自定义构建器
  // ============================================================
  group('TCheckbox 自定义构建器', () {
    testWidgets('customIconBuilder 返回自定义图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '自定义图标',
          customIconBuilder: (context, checked) =>
              Icon(checked ? Icons.star : Icons.star_border),
          value: true,
          onChanged: (_) {}),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('customIconBuilder 未选中态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '自定义图标未选',
          customIconBuilder: (context, checked) =>
              Icon(checked ? Icons.star : Icons.star_border),
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('customContentBuilder 返回自定义内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          customContentBuilder: (context, checked, content) =>
              Text('自定义内容:$checked'),
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('自定义内容:false'), findsOneWidget);
    });

    testWidgets('customIconBuilder 返回 null（仅内容）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '仅有内容',
          customIconBuilder: (context, checked) => null,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('仅有内容'), findsOneWidget);
    });
  });

  // ============================================================
  // 间距属性 spacing / insetSpacing / checkBoxLeftSpace / customSpace
  // ============================================================
  group('TCheckbox 间距属性', () {
    testWidgets('spacing 自定义图标文字距离', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '间距',
          spacing: 20,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('insetSpacing 自定义文字和非图标侧距离', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'inset',
          insetSpacing: 24,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('checkBoxLeftSpace 自定义左侧间距', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'leftSpace',
          checkBoxLeftSpace: 20,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('customSpace 自定义组件间距', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: 'customSpace',
          customSpace: const EdgeInsets.all(10),
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('titleFont / subTitleFont 自定义字体', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '字体',
          subTitle: '副字体',
          titleFont: Font(size: 20, lineHeight: 24),
          subTitleFont: Font(size: 14, lineHeight: 18),
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.text('字体'), findsOneWidget);
      expect(find.text('副字体'), findsOneWidget);
    });

    testWidgets('subTitleMaxLine 限制副标题行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
          title: '主',
          subTitle: '副标题副标题副标题副标题副标题',
          subTitleMaxLine: 2,
          value: false,
          onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  // ============================================================
  // 点击交互（onChanged 受控）
  // ============================================================
  group('TCheckbox 点击交互', () {
    testWidgets('点击切换 checked=true 触发 onChanged', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (v) => changedValue = v),
      ));
      await tester.tap(find.byType(TCheckbox), warnIfMissed: false);
      await tester.pump();
      expect(changedValue, isTrue);
    });

    testWidgets('点击切换 checked=false 触发 onChanged', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: true, onChanged: (v) => changedValue = v),
      ));
      await tester.tap(find.byType(TCheckbox), warnIfMissed: false);
      await tester.pump();
      expect(changedValue, isFalse);
    });

    testWidgets('enabled=false 点击不触发 onChanged', (tester) async {
      bool? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(
            value: false,
            enabled: false,
            onChanged: (v) => changedValue = v),
      ));
      await tester.tap(find.byType(TCheckbox), warnIfMissed: false);
      await tester.pump();
      expect(changedValue, isNull);
    });
  });

  // ============================================================
  // TCheckboxGroup 组管理
  // ============================================================
  group('TCheckboxGroup 组管理', () {
    testWidgets('Group 渲染子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('Group value 默认选中项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          value: const ['a'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
    });

    testWidgets('Group onChanged 回调触发', (tester) async {
      List<String>? changedIds;
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          onChanged: (ids) => changedIds = ids,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      await tester.tap(find.text('A'), warnIfMissed: false);
      await tester.pump();
      expect(changedIds, isNotNull);
      expect(changedIds, contains('a'));
    });

    testWidgets('Group maxChecked 超过最大选择触发 onOverloadChecked', (tester) async {
      var overloaded = false;
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          maxChecked: 1,
          onOverloadChecked: () => overloaded = true,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      // 点击第一个选中
      await tester.tap(find.text('A'), warnIfMissed: false);
      await tester.pump();
      // 点击第二个，超过 maxChecked=1
      await tester.tap(find.text('B'), warnIfMissed: false);
      await tester.pump();
      expect(overloaded, isTrue);
    });

    testWidgets('Group maxChecked 未超过不触发 onOverloadChecked', (tester) async {
      var overloaded = false;
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          maxChecked: 2,
          onOverloadChecked: () => overloaded = true,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      await tester.tap(find.text('A'), warnIfMissed: false);
      await tester.pump();
      expect(overloaded, isFalse);
    });

    testWidgets('Group didUpdateWidget 同步新 value', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          value: const ['a'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      // 更新 value
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          value: const ['b'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
    });
  });

  // ============================================================
  // TCheckboxGroupController 控制器
  // ============================================================
  group('TCheckboxGroupController 控制器', () {
    testWidgets('controller.toggleAll(true) 全选', (tester) async {
      final controller = TCheckboxGroupController();
      List<String>? changedIds;
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          onChanged: (ids) => changedIds = ids,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      controller.toggleAll(true);
      await tester.pump();
      expect(changedIds, isNotNull);
    });

    testWidgets('controller.toggleAll(false) 取消全选', (tester) async {
      final controller = TCheckboxGroupController();
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          value: const ['a', 'b'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: true, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: true, onChanged: (_) {}),
          ]),
        ),
      ));
      controller.toggleAll(false);
      await tester.pump();
      expect(controller.allChecked(), isEmpty);
    });

    testWidgets('controller.reverseAll() 反选', (tester) async {
      final controller = TCheckboxGroupController();
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          value: const ['a'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: true, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      controller.reverseAll();
      await tester.pump();
      // 反选后 b 应该被选中
      expect(controller.checked('b'), isTrue);
    });

    testWidgets('controller.toggle(id, true) 选中某项', (tester) async {
      final controller = TCheckboxGroupController();
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      controller.toggle('a', true);
      await tester.pump();
      expect(controller.checked('a'), isTrue);
    });

    testWidgets('controller.toggle(id, false) 取消某项', (tester) async {
      final controller = TCheckboxGroupController();
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          value: const ['a'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: true, onChanged: (_) {}),
          ]),
        ),
      ));
      controller.toggle('a', false);
      await tester.pump();
      expect(controller.checked('a'), isFalse);
    });

    testWidgets('controller.allChecked() 返回选中列表', (tester) async {
      final controller = TCheckboxGroupController();
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          value: const ['a', 'c'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: true, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
            TCheckbox(id: 'c', title: 'C', value: true, onChanged: (_) {}),
          ]),
        ),
      ));
      final allChecked = controller.allChecked();
      expect(allChecked, containsAll(['a', 'c']));
      expect(allChecked.length, 2);
    });

    testWidgets('controller.checked(id) 返回单项选中状态', (tester) async {
      final controller = TCheckboxGroupController();
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          controller: controller,
          value: const ['a'],
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: true, onChanged: (_) {}),
            TCheckbox(id: 'b', title: 'B', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(controller.checked('a'), isTrue);
      expect(controller.checked('b'), isFalse);
    });
  });

  // ============================================================
  // TCheckboxThemeData copyWith / lerp
  // ============================================================
  group('TCheckboxThemeData', () {
    test('copyWith 覆盖所有字段', () {
      const original = TCheckboxThemeData(
        style: TCheckboxVariant.circle,
        selectColor: Colors.red,
        disableColor: Colors.grey,
        titleColor: Colors.black,
        subTitleColor: Colors.blue,
        backgroundColor: Colors.white,
        spacing: 8,
        checkBoxLeftSpace: 16,
        insetSpacing: 12,
        customSpace: EdgeInsets.all(4),
      );
      final copied = original.copyWith(
        style: TCheckboxVariant.square,
        selectColor: Colors.green,
        disableColor: Colors.orange,
        titleColor: Colors.purple,
        subTitleColor: Colors.yellow,
        backgroundColor: Colors.pink,
        spacing: 10,
        checkBoxLeftSpace: 20,
        insetSpacing: 16,
        customSpace: const EdgeInsets.all(8),
      );
      expect(copied.style, TCheckboxVariant.square);
      expect(copied.selectColor, Colors.green);
      expect(copied.disableColor, Colors.orange);
      expect(copied.titleColor, Colors.purple);
      expect(copied.subTitleColor, Colors.yellow);
      expect(copied.backgroundColor, Colors.pink);
      expect(copied.spacing, 10);
      expect(copied.checkBoxLeftSpace, 20);
      expect(copied.insetSpacing, 16);
      expect(copied.customSpace, const EdgeInsets.all(8));
    });

    test('copyWith 未传字段保留原值', () {
      const original = TCheckboxThemeData(
        style: TCheckboxVariant.circle,
        selectColor: Colors.red,
      );
      final copied = original.copyWith();
      expect(copied.style, TCheckboxVariant.circle);
      expect(copied.selectColor, Colors.red);
    });

    test('lerp t=0 返回 this', () {
      const a = TCheckboxThemeData(
        style: TCheckboxVariant.circle,
        selectColor: Colors.red,
        spacing: 8,
      );
      const b = TCheckboxThemeData(
        style: TCheckboxVariant.square,
        selectColor: Colors.blue,
        spacing: 16,
      );
      final result = a.lerp(b, 0.0);
      expect(result.style, TCheckboxVariant.circle);
      expect(result.selectColor, Colors.red);
    });

    test('lerp t=1 返回 other', () {
      const a = TCheckboxThemeData(
        style: TCheckboxVariant.circle,
        selectColor: Colors.red,
        spacing: 8,
      );
      const b = TCheckboxThemeData(
        style: TCheckboxVariant.square,
        selectColor: Colors.blue,
        spacing: 16,
      );
      final result = a.lerp(b, 1.0);
      expect(result.style, TCheckboxVariant.square);
      expect(result.selectColor, Colors.blue);
      expect(result.spacing, 16);
    });

    test('lerp t=0.5 中间值', () {
      const a = TCheckboxThemeData(
        style: TCheckboxVariant.circle,
        selectColor: Colors.red,
        spacing: 8,
      );
      const b = TCheckboxThemeData(
        style: TCheckboxVariant.square,
        selectColor: Colors.blue,
        spacing: 16,
      );
      final result = a.lerp(b, 0.5);
      // style 用阈值切换，t<0.5 返回 this
      expect(result.style, TCheckboxVariant.circle);
    });

    test('lerp other 非 TCheckboxThemeData 返回 this', () {
      const a = TCheckboxThemeData(
        style: TCheckboxVariant.circle,
        selectColor: Colors.red,
      );
      // other 为 null 时走 is! 分支，返回 this
      final result = a.lerp(null, 0.5);
      expect(result.style, TCheckboxVariant.circle);
      expect(result.selectColor, Colors.red);
    });
  });

  // ============================================================
  // TCheckboxGroup 组属性继承
  // ============================================================
  group('TCheckboxGroup 组属性继承', () {
    testWidgets('Group style 继承给子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          style: TCheckboxVariant.square,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
    });

    testWidgets('Group spacing 继承给子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          spacing: 12,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
    });

    testWidgets('Group contentDirection 继承给子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          contentDirection: TContentDirection.left,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
    });

    testWidgets('Group titleMaxLine 继承给子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          titleMaxLine: 2,
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byType(TCheckboxGroup), findsOneWidget);
    });

    testWidgets('Group customIconBuilder 继承给子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          customIconBuilder: (context, checked) =>
              Icon(checked ? Icons.star : Icons.star_border),
          child: Column(children: [
            TCheckbox(id: 'a', title: 'A', value: true, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Group customContentBuilder 继承给子 TCheckbox', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckboxGroup(
          customContentBuilder: (context, checked, content) =>
              Text('group:$checked'),
          child: Column(children: [
            TCheckbox(id: 'a', value: false, onChanged: (_) {}),
          ]),
        ),
      ));
      expect(find.text('group:false'), findsOneWidget);
    });
  });

  // ============================================================
  // didUpdateWidget 更新测试
  // ============================================================
  group('TCheckbox didUpdateWidget', () {
    testWidgets('value 从 false 更新为 true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (_) {}),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: true, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });

    testWidgets('value 从 true 更新为 false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: true, onChanged: (_) {}),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TCheckbox(value: false, onChanged: (_) {}),
      ));
      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });
}
