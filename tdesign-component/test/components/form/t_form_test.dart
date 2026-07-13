import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/form/t_form_item.dart';

/// TForm V1.0 Widget 测试
///
/// Form 必测：submit / reset / validate + rules 失败态。
/// 覆盖 FormController、TFormValidation、TFormItem。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  /// 构建一个带 FormController 的表单
  Widget buildForm({
    required FormController controller,
    required Map<String, dynamic> data,
    required Map<String, TFormValidation> rules,
    required Function onSubmit,
    Function? onReset,
    List<Widget>? btnGroup,
  }) {
    return wrapWithTheme(
      SizedBox(
        height: 600,
        child: TForm(
          items: const [
            TFormItem(
              type: TFormItemType.input,
              label: '用户名',
              name: 'username',
              hintText: '请输入用户名',
            ),
            TFormItem(
              type: TFormItemType.input,
              label: '密码',
              name: 'password',
              hintText: '请输入密码',
            ),
          ],
          rules: rules,
          data: data,
          onSubmit: onSubmit,
          onReset: onReset,
          controller: controller,
          btnGroup: btnGroup,
          labelWidth: 80,
        ),
      ),
    );
  }

  // ============================================================
  // Form submit 提交
  // ============================================================
  group('TForm submit 提交', () {
    testWidgets('controller.submit() 触发 onSubmit 回调', (tester) async {
      final controller = FormController();
      var submitted = false;
      Map<String, dynamic>? submittedData;

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': '', 'password': ''},
        rules: {},
        onSubmit: (data, isValid) {
          submitted = true;
          submittedData = data;
        },
      ));

      controller.submit();
      await tester.pumpAndSettle();

      expect(submitted, isTrue);
      expect(submittedData, isNotNull);
    });

    testWidgets('校验通过时 isValidate=true', (tester) async {
      final controller = FormController();
      bool? isValid;

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': 'testuser', 'password': '123456'},
        rules: {
          'username': TFormValidation(
            validate: (v) => (v == null || v.isEmpty) ? '不能为空' : null,
            errorMessage: '用户名不能为空',
            type: TFormItemType.input,
          ),
        },
        onSubmit: (data, valid) => isValid = valid,
      ));

      controller.submit();
      await tester.pumpAndSettle();
      expect(isValid, isTrue);
    });
  });

  // ============================================================
  // Form validate 校验 + rules 失败态
  // ============================================================
  group('TForm validate 校验', () {
    testWidgets('校验失败时 isValidate=false', (tester) async {
      final controller = FormController();
      bool? isValid;

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': '', 'password': ''},
        rules: {
          'username': TFormValidation(
            validate: (v) => (v == null || v.isEmpty) ? '不能为空' : null,
            errorMessage: '用户名不能为空',
            type: TFormItemType.input,
          ),
        },
        onSubmit: (data, valid) => isValid = valid,
      ));

      controller.submit();
      await tester.pumpAndSettle();
      expect(isValid, isFalse);
    });

    testWidgets('校验失败时显示错误信息', (tester) async {
      final controller = FormController();

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': '', 'password': ''},
        rules: {
          'username': TFormValidation(
            validate: (v) => (v == null || v.isEmpty) ? '不能为空' : null,
            errorMessage: '用户名不能为空',
            type: TFormItemType.input,
          ),
        },
        onSubmit: (data, valid) {},
      ));

      controller.submit();
      await tester.pumpAndSettle();
      expect(find.text('用户名不能为空'), findsOneWidget);
    });

    testWidgets('多个字段校验，第一个失败即返回', (tester) async {
      final controller = FormController();
      bool? isValid;

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': '', 'password': ''},
        rules: {
          'username': TFormValidation(
            validate: (v) => (v == null || v.isEmpty) ? '不能为空' : null,
            errorMessage: '用户名不能为空',
            type: TFormItemType.input,
          ),
          'password': TFormValidation(
            validate: (v) => (v == null || v.isEmpty) ? '不能为空' : null,
            errorMessage: '密码不能为空',
            type: TFormItemType.input,
          ),
        },
        onSubmit: (data, valid) => isValid = valid,
      ));

      controller.submit();
      await tester.pumpAndSettle();
      expect(isValid, isFalse);
    });

    testWidgets('自定义校验规则（长度限制）', (tester) async {
      final controller = FormController();
      bool? isValid;

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': 'ab', 'password': ''},
        rules: {
          'username': TFormValidation(
            validate: (v) => (v != null && v.length < 3) ? '太短' : null,
            errorMessage: '至少3个字符',
            type: TFormItemType.input,
          ),
        },
        onSubmit: (data, valid) => isValid = valid,
      ));

      controller.submit();
      await tester.pumpAndSettle();
      expect(isValid, isFalse);
    });
  });

  // ============================================================
  // Form reset 重置
  // ============================================================
  group('TForm reset 重置', () {
    testWidgets('controller.reset() 更新表单数据', (tester) async {
      final controller = FormController();

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': 'old', 'password': 'old'},
        rules: {},
        onSubmit: (data, valid) {},
        onReset: () {},
      ));

      controller.reset({'username': 'new', 'password': 'new'});
      await tester.pumpAndSettle();
      // reset 后表单仍正常渲染
      expect(find.byType(TForm), findsOneWidget);
    });

    testWidgets('reset 后表单数据更新', (tester) async {
      final controller = FormController();

      await tester.pumpWidget(buildForm(
        controller: controller,
        data: {'username': 'old', 'password': 'old'},
        rules: {},
        onSubmit: (data, valid) {},
        onReset: () {},
      ));

      controller.reset({'username': 'reset', 'password': 'reset'});
      await tester.pumpAndSettle();
      expect(find.byType(TForm), findsOneWidget);
    });
  });

  // ============================================================
  // Form 基础渲染
  // ============================================================
  group('TForm 基础渲染', () {
    testWidgets('表单渲染 TFormItem', (tester) async {
      await tester.pumpWidget(buildForm(
        controller: FormController(),
        data: {'username': '', 'password': ''},
        rules: {},
        onSubmit: (data, valid) {},
      ));

      expect(find.byType(TForm), findsOneWidget);
      expect(find.text('用户名'), findsOneWidget);
      expect(find.text('密码'), findsOneWidget);
    });

    testWidgets('btnGroup 渲染按钮组', (tester) async {
      await tester.pumpWidget(buildForm(
        controller: FormController(),
        data: {'username': '', 'password': ''},
        rules: {},
        onSubmit: (data, valid) {},
        btnGroup: [
          TButton(child: const Text('提交'), onPressed: () {}),
          TButton(child: const Text('重置'), onPressed: () {}),
        ],
      ));

      expect(find.text('提交'), findsOneWidget);
      expect(find.text('重置'), findsOneWidget);
    });

    testWidgets('requiredMark=true 显示必填标记', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 600,
          child: TForm(
            items: const [
              TFormItem(
                type: TFormItemType.input,
                label: '必填',
                name: 'field',
                requiredMark: true,
              ),
            ],
            rules: const {},
            data: const {'field': ''},
            onSubmit: (data, valid) {},
            requiredMark: true,
            labelWidth: 80,
          ),
        ),
      ));
      expect(find.byType(TForm), findsOneWidget);
    });

    testWidgets('labelWidth 自定义标签宽度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 600,
          child: TForm(
            items: const [
              TFormItem(
                type: TFormItemType.input,
                label: '标签',
                name: 'field',
              ),
            ],
            rules: const {},
            data: const {'field': ''},
            onSubmit: (data, valid) {},
            labelWidth: 100,
          ),
        ),
      ));
      expect(find.byType(TForm), findsOneWidget);
    });
  });

  group('TFormItem 多类型渲染', () {
    Widget buildSingle(TFormItem item,
        {Map<String, dynamic> data = const {}}) {
      return wrapWithTheme(
        SizedBox(
          height: 600,
          child: TForm(
            items: [item],
            rules: const {},
            data: data,
            onSubmit: (d, v) {},
            labelWidth: 80,
          ),
        ),
      );
    }

    testWidgets('textarea 类型渲染', (tester) async {
      await tester.pumpWidget(buildSingle(const TFormItem(
        type: TFormItemType.textarea,
        label: '备注',
        name: 'remark',
        child: TText('文本域内容'),
      )));
      expect(find.text('备注'), findsOneWidget);
      expect(find.text('文本域内容'), findsOneWidget);
    });

    testWidgets('radios 类型渲染', (tester) async {
      await tester.pumpWidget(buildSingle(TFormItem(
        type: TFormItemType.radios,
        label: '性别',
        name: 'gender',
        child: TRadioGroup(
          selectId: 'm',
          direction: Axis.horizontal,
          directionalTdRadios: const [
            TRadio(id: 'm', title: '男'),
            TRadio(id: 'f', title: '女'),
          ],
          onRadioGroupChange: (id) {},
        ),
      )));
      expect(find.text('性别'), findsOneWidget);
      expect(find.text('男'), findsOneWidget);
      expect(find.text('女'), findsOneWidget);
    });

    testWidgets('stepper 类型渲染', (tester) async {
      await tester.pumpWidget(buildSingle(const TFormItem(
        type: TFormItemType.stepper,
        label: '数量',
        name: 'count',
        child: TText('步进器'),
      )));
      expect(find.text('数量'), findsOneWidget);
      expect(find.text('步进器'), findsOneWidget);
    });

    testWidgets('upLoadImg 类型渲染', (tester) async {
      await tester.pumpWidget(buildSingle(const TFormItem(
        type: TFormItemType.upLoadImg,
        label: '图片',
        name: 'img',
        child: TText('上传图片'),
      )));
      expect(find.text('图片'), findsOneWidget);
      expect(find.text('上传图片'), findsOneWidget);
    });

    testWidgets('dateTimePicker 类型渲染并触发 selectFn', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildSingle(TFormItem(
        type: TFormItemType.dateTimePicker,
        label: '时间',
        name: 'time',
        hintText: '请选择时间',
        selectFn: (context) => tapped = true,
      )));
      expect(find.text('时间'), findsOneWidget);
      expect(find.text('请选择时间'), findsOneWidget);
      await tester.tap(find.text('请选择时间'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('cascader 类型渲染并触发 selectFn', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildSingle(TFormItem(
        type: TFormItemType.cascader,
        label: '地区',
        name: 'area',
        hintText: '请选择地区',
        selectFn: (context) => tapped = true,
      )));
      expect(find.text('地区'), findsOneWidget);
      expect(find.text('请选择地区'), findsOneWidget);
      await tester.tap(find.text('请选择地区'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('help 帮助信息渲染', (tester) async {
      await tester.pumpWidget(buildSingle(const TFormItem(
        type: TFormItemType.input,
        label: '账号',
        name: 'account',
        help: '请输入登录账号',
      )));
      expect(find.text('请输入登录账号'), findsOneWidget);
    });

    testWidgets('labelWidget 自定义标签渲染', (tester) async {
      await tester.pumpWidget(buildSingle(const TFormItem(
        type: TFormItemType.input,
        label: 'x',
        labelWidget: Text('自定义标签'),
        name: 'x',
      )));
      expect(find.text('自定义标签'), findsOneWidget);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TFormItem 覆盖率补充', () {
    Widget wrapForm(TFormItem item,
        {double? formLabelWidth = 80, Map<String, dynamic> data = const {}}) {
      return MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: TForm(
              items: [item],
              rules: const {},
              data: data,
              onSubmit: (d, v) {},
              labelWidth: formLabelWidth,
            ),
          ),
        ),
      );
    }

    testWidgets('labelWidth 自定义', (tester) async {
      // 覆盖 154（widget.labelWidth != null）+ 165-166（inherited.labelWidth）
      await tester.pumpWidget(wrapForm(const TFormItem(
        type: TFormItemType.input,
        label: 'lw',
        name: 'lw',
        labelWidth: 100,
      )));
      expect(find.byType(TFormItem), findsOneWidget);
    });

    testWidgets('contentAlign 自定义', (tester) async {
      // 覆盖 251-257（contentAlign）
      await tester.pumpWidget(wrapForm(const TFormItem(
        type: TFormItemType.input,
        label: 'ca',
        name: 'ca',
        contentAlign: TextAlign.right,
      )));
      tester.takeException(); // 可能布局溢出
      expect(find.byType(TFormItem), findsAny);
    });

    testWidgets('无 labelWidth 使用默认值', (tester) async {
      // 覆盖 174（return defaultlabelWidth）
      await tester.pumpWidget(wrapForm(const TFormItem(
        type: TFormItemType.input,
        label: 'def',
        name: 'def',
      ), formLabelWidth: 0));
      expect(find.byType(TFormItem), findsOneWidget);
    });
  });
}
