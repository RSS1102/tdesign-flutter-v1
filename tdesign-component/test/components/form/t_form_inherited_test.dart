import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/form/t_form_inherited.dart';

/// 覆盖 t_form_inherited.dart 的 updateShouldNotify 各字段比较分支
void main() {
  // 辅助函数：构造 TFormInherited，可覆盖单个字段
  TFormInherited makeInherited({
    Map<String, dynamic> formData = const <String, dynamic>{},
    double? labelWidth,
    bool layout = false,
    bool isValidate = false,
    Map<String, TFormValidation> rules = const <String, TFormValidation>{},
    bool? showErrorMessage,
    bool? requiredMark = false,
    TextAlign contentAlign = TextAlign.left,
    bool isReset = false,
    int updateCount = 0,
  }) {
    return TFormInherited(
      formData: formData,
      labelWidth: labelWidth,
      layout: layout,
      isValidate: isValidate,
      rules: rules,
      showErrorMessage: showErrorMessage,
      requiredMark: requiredMark,
      contentAlign: contentAlign,
      onFormDataChange: () {},
      isReset: isReset,
      updateCount: updateCount,
      onSubmit: () {},
      child: const SizedBox(),
    );
  }

  group('TFormInherited.updateShouldNotify', () {
    test('updateCount 变化返回 true', () {
      final w1 = makeInherited(updateCount: 0);
      final w2 = makeInherited(updateCount: 1);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('isReset 变化返回 true', () {
      final w1 = makeInherited(isReset: false);
      final w2 = makeInherited(isReset: true);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('labelWidth 变化返回 true', () {
      final w1 = makeInherited(labelWidth: 100);
      final w2 = makeInherited(labelWidth: 200);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('layout 变化返回 true', () {
      final w1 = makeInherited(layout: false);
      final w2 = makeInherited(layout: true);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('isValidate 变化返回 true', () {
      final w1 = makeInherited(isValidate: false);
      final w2 = makeInherited(isValidate: true);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('showErrorMessage 变化返回 true', () {
      final w1 = makeInherited(showErrorMessage: false);
      final w2 = makeInherited(showErrorMessage: true);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('contentAlign 变化返回 true', () {
      final w1 = makeInherited(contentAlign: TextAlign.left);
      final w2 = makeInherited(contentAlign: TextAlign.right);
      expect(w1.updateShouldNotify(w2), isTrue);
    });

    test('全部字段相同返回 false', () {
      final w1 = makeInherited();
      final w2 = makeInherited();
      expect(w1.updateShouldNotify(w2), isFalse);
    });
  });
}
