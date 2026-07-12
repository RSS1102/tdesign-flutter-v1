import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/cell/t_cell_inherited.dart';
import 'package:tdesign_flutter/src/components/fab/t_fab_layout.dart';
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_enums.dart';
import 'package:tdesign_flutter/src/components/picker/picker_data.dart';
import 'package:tdesign_flutter/src/components/sidebar/t_sidebar_controller.dart';
import 'package:tdesign_flutter/src/components/swipe_cell/t_swipe_cell_inherited.dart';

/// 覆盖多个小文件的未覆盖行：TCellInherited updateShouldNotify、TFabBounds 构造器、
/// DateTimePickerSteps operator==、TSideBarController dispose/closeLoading
void main() {
  group('TCellInherited.updateShouldNotify', () {
    test('始终返回 true', () {
      final w1 = TCellInherited(
        style: TCellThemeData(),
        child: const SizedBox(),
      );
      final w2 = TCellInherited(
        style: TCellThemeData(),
        child: const SizedBox(),
      );
      expect(w1.updateShouldNotify(w2), isTrue);
    });
  });

  group('TFabBounds', () {
    test('构造器正确赋值', () {
      const bounds = TFabBounds(start: 10, end: 20);
      expect(bounds.start, 10);
      expect(bounds.end, 20);
    });

    test('const 构造器相同参数 identical', () {
      const a = TFabBounds(start: 0, end: 100);
      const b = TFabBounds(start: 0, end: 100);
      expect(identical(a, b), isTrue);
    });
  });

  group('DateTimePickerSteps operator ==', () {
    test('所有字段相同返回 true', () {
      const a = DateTimePickerSteps(
        year: 1, month: 1, day: 1,
        hour: 1, minute: 1, second: 1,
      );
      const b = DateTimePickerSteps(
        year: 1, month: 1, day: 1,
        hour: 1, minute: 1, second: 1,
      );
      expect(a == b, isTrue);
    });

    test('second 不同返回 false', () {
      const a = DateTimePickerSteps(
        year: 1, month: 1, day: 1,
        hour: 1, minute: 1, second: 1,
      );
      const b = DateTimePickerSteps(
        year: 1, month: 1, day: 1,
        hour: 1, minute: 1, second: 2,
      );
      expect(a == b, isFalse);
    });

    test('identical 返回 true', () {
      const a = DateTimePickerSteps(
        year: 1, month: 1, day: 1,
        hour: 1, minute: 1, second: 1,
      );
      expect(a == a, isTrue);
    });

    test('非同类型返回 false', () {
      const a = DateTimePickerSteps(
        year: 1, month: 1, day: 1,
        hour: 1, minute: 1, second: 1,
      );
      expect(a == 'string', isFalse);
    });
  });

  group('TSideBarController', () {
    test('closeLoading needNotify=true 触发通知', () {
      final controller = TSideBarController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.closeLoading(true);
      expect(notifyCount, greaterThan(0));
    });

    test('closeLoading needNotify=false 不触发通知', () {
      final controller = TSideBarController();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.closeLoading(false, needNotify: false);
      expect(notifyCount, 0);
    });

    test('dispose 后 currentValue 归零', () {
      final controller = TSideBarController();
      controller.dispose();
      expect(controller.currentValue, 0);
    });
  });

  group('TPickerLinked._childEqual 分支覆盖', () {
    // 覆盖 picker_data.dart 第 114-115 行：子节点为 Map 时递归 _treeEqual
    test('子节点为 Map 时 == 返回 true', () {
      final a = TPickerLinked.fromRaw({'a': {'b': ['1', '2']}});
      final b = TPickerLinked.fromRaw({'a': {'b': ['1', '2']}});
      expect(a == b, isTrue);
    });

    // 覆盖 picker_data.dart 第 117-118 行：子节点为 List 时用 listEquals
    test('子节点为 List 时 == 返回 true', () {
      final a = TPickerLinked.fromRaw({'a': ['1', '2', '3']});
      final b = TPickerLinked.fromRaw({'a': ['1', '2', '3']});
      expect(a == b, isTrue);
    });

    // 覆盖 picker_data.dart 第 120 行：子节点为非 Map/非 List 时用 ==
    test('子节点为裸值时 == 返回 true', () {
      final a = TPickerLinked({
        TPickerOption(label: 'a', value: 'a'): 'string_value',
      });
      final b = TPickerLinked({
        TPickerOption(label: 'a', value: 'a'): 'string_value',
      });
      expect(a == b, isTrue);
    });

    test('子节点为裸值但不同时 == 返回 false', () {
      final a = TPickerLinked({
        TPickerOption(label: 'a', value: 'a'): 'value1',
      });
      final b = TPickerLinked({
        TPickerOption(label: 'a', value: 'a'): 'value2',
      });
      expect(a == b, isFalse);
    });
  });
}
