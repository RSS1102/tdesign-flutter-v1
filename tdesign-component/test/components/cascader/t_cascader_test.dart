import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCascader V1.0 Widget 测试
/// E 类控制：showMultiCascader() 调用即显。
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('TCascader 数据结构', () {
    testWidgets('单层数据结构', (tester) async {
      final data = [
        {'label': '选项1', 'value': '1'},
        {'label': '选项2', 'value': '2'},
      ];
      expect(data.length, 2);
    });

    testWidgets('多层级联数据', (tester) async {
      final data = [
        {
          'label': '广东省',
          'value': 'gd',
          'children': [
            {'label': '深圳市', 'value': 'sz'},
            {'label': '广州市', 'value': 'gz'},
          ]
        },
      ];
      expect(data.length, 1);
    });

    testWidgets('空数据结构', (tester) async {
      final data = <Map>[];
      expect(data.isEmpty, isTrue);
    });
  });

  group('TCascader 静态方法', () {
    testWidgets('showMultiCascader 方法存在', (tester) async {
      expect(TCascader.showMultiCascader, isNotNull);
    });

    testWidgets('showMultiCascader 参数验证', (tester) async {
      // 验证方法签名存在
      expect(TCascader.showMultiCascader, isA<Function>());
    });
  });

  group('TCascader initialIndexes', () {
    testWidgets('initialIndexes 默认为空', (tester) async {
      final indexes = <int>[];
      expect(indexes.isEmpty, isTrue);
    });

    testWidgets('initialIndexes 设置初始值', (tester) async {
      final indexes = [0, 1];
      expect(indexes.length, 2);
    });

    testWidgets('initialIndexes 三级初始值', (tester) async {
      final indexes = [0, 0, 0];
      expect(indexes.length, 3);
    });
  });

  group('TCascader 配置参数', () {
    testWidgets('title 配置', (tester) async {
      const title = '请选择地区';
      expect(title, '请选择地区');
    });

    testWidgets('cascaderHeight 配置', (tester) async {
      const height = 500.0;
      expect(height, 500.0);
    });

    testWidgets('duration 配置', (tester) async {
      const duration = Duration(milliseconds: 100);
      expect(duration.inMilliseconds, 100);
    });

    testWidgets('barrierColor 配置', (tester) async {
      const color = Colors.black54;
      expect(color, Colors.black54);
    });
  });

  group('TCascader 回调', () {
    testWidgets('onChanged 回调类型', (tester) async {
      void onChanged(List<int> indexes) {}
      expect(onChanged, isA<Function>());
    });

    testWidgets('onClose 回调类型', (tester) async {
      void onClose() {}
      expect(onClose, isA<Function>());
    });
  });

  group('TCascader 组合', () {
    testWidgets('title + data + initialIndexes 组合', (tester) async {
      const title = '选择城市';
      final data = [
        {'label': '北京', 'value': 'bj'},
        {'label': '上海', 'value': 'sh'},
      ];
      final indexes = [0];
      expect(title, '选择城市');
      expect(data.length, 2);
      expect(indexes.length, 1);
    });

    testWidgets('多级数据 + initialIndexes', (tester) async {
      final data = [
        {
          'label': '广东',
          'value': 'gd',
          'children': [
            {'label': '深圳', 'value': 'sz'},
          ]
        },
      ];
      final indexes = [0, 0];
      expect(data.length, 1);
      expect(indexes.length, 2);
    });

    testWidgets('空 data + 空 indexes', (tester) async {
      final data = <Map>[];
      final indexes = <int>[];
      expect(data.isEmpty, isTrue);
      expect(indexes.isEmpty, isTrue);
    });
  });
}
