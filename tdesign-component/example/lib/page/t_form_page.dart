import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TFormPage extends StatefulWidget {
  const TFormPage({Key? key}) : super(key: key);

  @override
  _TFormPageState createState() => _TFormPageState();
}

class _TFormPageState extends State<TFormPage> {
  /// 文本输入控制器列表（与 form 字段一一对应）
  final List<TextEditingController> _textControllers = [];
  final FormController _formController = FormController();
  final StreamController<TStepperEventType> _stepController =
      StreamController.broadcast();
  String _selected_1 = '';
  String _selected_2 = '';
  String? _initLocalData;

  /// form 禁用的状态
  bool _formDisableState = false;

  /// form 排列方式是否为水平
  bool _isFormHorizontal = true;

  /// 展示日期选择器弹窗
  void _showDatePicker(BuildContext context, {
    required Function(List selected) onConfirm,
    List<int>? initialDate,
  }) {
    // 生成年/月/日数据
    final year = initialDate?[0] ?? 2012;
    final month = initialDate?[1] ?? 1;
    final day = initialDate?[2] ?? 1;

    final yearItems = List.generate(52, (i) => TPickerOption(label: '${1999 + i}年', value: 1999 + i));
    final monthItems = List.generate(12, (i) => TPickerOption(label: '${i + 1}月', value: i + 1));
    final daysInMonth = DateTime(year, month + 1).subtract(const Duration(days: 1)).day;
    final dayItems = List.generate(daysInMonth, (i) => TPickerOption(label: '${i + 1}日', value: i + 1));

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.tTheme.bgColorContainer,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.tTheme.radiusExtraLarge),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题栏
              Padding(
                padding: EdgeInsets.all(context.tTheme.spacer16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: context.tTheme.textColorSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '选择时间',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: context.tTheme.textColorPrimary,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '确认',
                        style: TextStyle(
                          color: context.tTheme.brandNormalColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 选择器
              TPicker(
                items: TPickerColumns([yearItems, monthItems, dayItems]),
                initialValue: [year, month, day],
                // onChanged 签名: (int col, TPickerValue value)
                // col 为本次触发的列索引,这里不关心;value.values 是各列 value 列表
                onChanged: (_, v) => onConfirm(
                  [for (final x in v.values) x as int],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 设置按钮是否可点击状态
  /// true 表示处于 active 状态
  bool horizontalButton = false;
  bool verticalButton = true;

  Color defaultButtonColor = Color(0xFFE5E5E5);
  Color activeButtonColor = Color(0xFFF0F1FD);

  Color verticalTextColor = Color(0xFF1A1A1A);
  Color horizontalTextColor = Color(0xFF0A58D9);
  Color verticalButtonColor = Color(0xFFE5E5E5);
  Color horizontalButtonColor = Color(0xFFF0F1FD);

  /// radios 传入参数
  final Map<String, String> _radios = {'0': '男', '1': '女', '3': '保密'};

  /// 级联选择器 传入参数
  static const List<Map> _data = [
    {
      'label': '北京市',
      'value': '110000',
      'children': [
        {
          'value': '110100',
          'label': '北京市',
          'children': [
            {'value': '110101', 'label': '东城区'},
            {'value': '1101022', 'label': '东区'},
            {'value': '110102', 'label': '西城区'},
            {'value': '110105', 'label': '朝阳区'},
            {'value': '110106', 'label': '丰台区'},
            {'value': '110107', 'label': '石景山区'},
            {'value': '110108', 'label': '海淀区'},
            {'value': '110109', 'label': '门头沟区'},
          ],
        },
      ],
    },
    {
      'label': '天津市',
      'value': '120000',
      'children': [
        {
          'value': '120100',
          'label': '天津市',
          'children': [
            {
              'value': '120101',
              'label': '和平区',
            },
            {
              'value': '120102',
              'label': '河东区',
            },
            {
              'value': '120103',
              'label': '河西区',
            },
            {
              'value': '120104',
              'label': '南开区',
            },
            {
              'value': '120105',
              'label': '河北区',
            },
            {
              'value': '120106',
              'label': '红桥区',
            },
            {
              'value': '120110',
              'label': '东丽区',
            },
            {
              'value': '120111',
              'label': '西青区',
            },
            {
              'value': '120112',
              'label': '津南区',
            },
          ],
        },
      ],
    },
  ];
  List<TUploadFile> files = [];

  ///密码是否浏览
  bool browseOn = false;
  final TCheckboxGroupController _genderCheckboxGroupController =
      TCheckboxGroupController();

  /// 整个表单存放的数据
  Map<String, dynamic> _formData = {
    'name': '',
    'password': '',
    'gender': '',
    'birth': '',
    'place': '',
    'age': '2',
    'description': '2',
    'resume': '',
    'photo': '',
  };
  final Map<String, dynamic> _itemNotifier = {
    'name': '',
    'password': '',
    'gender': '',
    'birth': '',
    'place': '',
    'age': '2',
    'description': '',
    'resume': '',
    'photo': '',
  };

  @override
  void initState() {
    /// 四个文本型的表格单元（用户名、密码、个人简介 + 备用）
    for (var i = 0; i < 4; i++) {
      _textControllers.add(TextEditingController());
    }
    _formData.forEach((key, value) {
      _itemNotifier[key] = FormItemNotifier();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stepController.close();
  }

  /// 提交按钮钮点击事件：
  /// 改变 _validate 值，从而触发校验
  /// 获取表单的数据
  void _onSubmit() {
    _formController.submit();
  }

  /// 定义整个校验规则
  final Map<String, TFormValidation> _validationRules = {
    'name': TFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '输入不能为空',
      type: TFormItemType.input,
    ),
    'password': TFormValidation(
      validate: (value) =>
          RegExp(r'^[a-zA-Z]{8}$').hasMatch(value ?? '') ? null : 'invalid',
      errorMessage: '只能输入8个字符英文',
      type: TFormItemType.input,
    ),
    'gender': TFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '不能为空',
      type: TFormItemType.radios,
    ),
    'birth': TFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '不能为空',
      type: TFormItemType.dateTimePicker,
    ),
    'place': TFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '不能为空',
      type: TFormItemType.cascader,
    ),
    'age': TFormValidation(
      validate: (value) {
        if (value == null || value.isEmpty) {
          return 'empty';
        } else if (int.parse(value) < 3) {
          return 'empty';
        }
        return null;
      },
      errorMessage: '输入的数字不能大于用户所填生日对应的年龄',
      type: TFormItemType.stepper,
    ),
    'description': TFormValidation(
      validate: (value) {
        if (value == null || value.isEmpty) {
          return 'empty';
        } else if (double.parse(value) < 4) {
          return 'empty';
        }
        return null;
      },
      errorMessage: '分数过低会影响整体评价',
      type: TFormItemType.rate,
    ),
    'resume': TFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '不能为空',
      type: TFormItemType.textarea,
    ),
    'photo': TFormValidation(
      validate: (value) => value == null || value.isEmpty ? 'empty' : null,
      errorMessage: '不能为空',
      type: TFormItemType.upLoadImg,
    ),
  };

  ///表单提交数据
  onSubmit(Map<String, dynamic> formData, isValidateSuc) {}

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'form',
      desc: '用以收集、校验和提交数据，一般由输入框、单选框、复选框、选择器等控件组成。',
      children: [
        ExampleModule(title: '基础类型', children: [
          ExampleItem(
              ignoreCode: true, desc: '基础表单', builder: _buildArrangementSwitch),
          ExampleItem(
              ignoreCode: true, desc: '', builder: _buildSwitchWithBase),
          ExampleItem(
              ignoreCode: true,
              builder: (BuildContext context) {
                return CodeWrapper(builder: _buildForm);
              }),
        ]),
      ],
      test: [
        ExampleItem(
            ignoreCode: true,
            desc: '自定义背景表单',
            builder: _buildArrangementSwitch),
        ExampleItem(ignoreCode: true, desc: '', builder: _buildSwitchWithBase),
        ExampleItem(
            ignoreCode: true,
            builder: (BuildContext context) {
              return CodeWrapper(builder: _buildCustomForm);
            }),
      ],
    );
  }

  @Demo(group: 'form')
  Widget _buildForm(BuildContext context) {
    return TForm(
        controller: _formController,
        disabled: _formDisableState,
        data: _formData,
        layout: _isFormHorizontal,
        rules: _validationRules,
        formContentAlign: TextAlign.left,
        requiredMark: true,

        /// 确定整个表单是否展示提示信息
        showErrorMessage: true,
        onSubmit: onSubmit,
        items: [
          TFormItem(
            label: '用户名',
            name: 'name',
            type: TFormItemType.input,
            help: '请输入用户名',
            labelWidth: 82.0,
            itemNotifier: _itemNotifier['name'],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            requiredMark: true,
            child: TInput(
                inputDecoration: const InputDecoration(
                  hintText: '请输入用户名',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                  ),
                ),
                controller: _textControllers[0],
                additionInfoColor: context.tTheme.errorColor6,
                showBottomDivider: false,
                readOnly: _formDisableState,
                onChanged: (val) {
                  _itemNotifier['name']?.upDataForm(val);
                },
                onClearTap: () {
                  _textControllers[0].clear();
                  _itemNotifier['name']?.upDataForm('');
                }),
          ),
          TFormItem(
            label: '密码',
            name: 'password',
            type: TFormItemType.input,
            labelWidth: 82.0,
            itemNotifier: _itemNotifier['password'],
            showErrorMessage: true,
            child: TInput(
                inputDecoration: const InputDecoration(
                  hintText: '请输入密码',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                  ),
                ),
                layout: TInputLayout.normal,
                controller: _textControllers[1],
                obscureText: !browseOn,
                showClearButton: false,
                readOnly: _formDisableState,
                showBottomDivider: false,
                onChanged: (val) {
                  _itemNotifier['password']?.upDataForm(val);
                },
                onClearTap: () {
                  _textControllers[1].clear();
                  _itemNotifier['password']?.upDataForm('');
                }),
          ),
          TFormItem(
            label: '性别',
            name: 'gender',
            type: TFormItemType.radios,
            labelWidth: 82.0,
            showErrorMessage: true,
            itemNotifier: _itemNotifier['gender'],
            child: TRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              controller: _genderCheckboxGroupController,
              directionalTdRadios: _radios.entries.map((entry) {
                return TRadio(
                  id: entry.key,
                  title: entry.value,
                  radioStyle: TRadioStyle.circle,
                  showDivider: false,
                  spacing: 4,
                  checkBoxLeftSpace: 0,
                  customSpace: const EdgeInsets.all(0),
                  enabled: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (selectedId) {
                _itemNotifier['gender']?.upDataForm(selectedId);
              },
            ),
          ),
          TFormItem(
            label: '生日',
            name: 'birth',
            labelWidth: 82.0,
            type: TFormItemType.dateTimePicker,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            itemNotifier: _itemNotifier['birth'],
            hintText: '请输入内容',
            select: _selected_1,
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
              _showDatePicker(
                context,
                initialDate: [2012, 1, 1],
                onConfirm: (selected) {
                  setState(() {
                    _selected_1 =
                        '${selected[0].toString().padLeft(4, '0')}-${selected[1].toString().padLeft(2, '0')}-${selected[2].toString().padLeft(2, '0')}';
                    _itemNotifier['birth']?.upDataForm(_selected_1);
                  });
                },
              );
            },
          ),
          TFormItem(
            label: '籍贯',
            name: 'place',
            type: TFormItemType.cascader,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            labelWidth: 82.0,
            hintText: '请输入内容',
            select: _selected_2,
            itemNotifier: _itemNotifier['place'],
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
              TCascader.showMultiCascader(context,
                  title: '选择地址',
                  data: _data,
                  initialData: _initLocalData,
                  theme: 'step',
                  onChanged: (List<MultiCascaderListModel> selectData) {
                setState(() {
                  var result = [];
                  var len = selectData.length;
                  _initLocalData = selectData[len - 1].value!;
                  selectData.forEach((element) {
                    result.add(element.label);
                  });
                  _selected_2 = result.join('/');
                  _itemNotifier['place']?.upDataForm(_selected_2);
                });
              }, onClose: () {
                Navigator.of(context).pop();
              });
            },
          ),
          TFormItem(
              label: '年限',
              name: 'age',
              labelWidth: 82.0,
              type: TFormItemType.stepper,
              itemNotifier: _itemNotifier['age'],
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: TStepper(
                  theme: TStepperColorScheme.filled,
                  disabled: _formDisableState,
                  eventController: _stepController!,
                  value: int.parse(_formData['age']),
                  onChanged: (value) {
                    _itemNotifier['age']?.upDataForm('$value');
                  },
                ),
              )),
          TFormItem(
            label: '自我评价',
            name: 'description',
            tipAlign: TextAlign.left,
            type: TFormItemType.rate,
            labelWidth: 82.0,
            itemNotifier: _itemNotifier['description'],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: TRate(
                    count: 5,
                    value: double.parse(_formData['description']),
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChanged: (value) {
                      setState(() {
                        _formData['description'] = '$value';
                      });
                      _itemNotifier['description']?.upDataForm('$value');
                    },
                  )),
            ),
          ),
          TFormItem(
              label: '个人简介',
              labelWidth: 82.0,
              name: 'resume',
              type: TFormItemType.textarea,
              itemNotifier: _itemNotifier['resume'],
              child: Padding(
                padding:
                    EdgeInsets.only(top: _isFormHorizontal ? 0 : 8, bottom: 4),
                child: TTextarea(
                  hintText: '请输入个人简介',
                  maxLength: 500,
                  indicator: true,
                  readOnly: _formDisableState,
                  layout: TTextareaLayout.vertical,
                  controller: _textControllers[2],
                  showBottomDivider: false,
                  onChanged: (value) {
                    _itemNotifier['resume']?.upDataForm(value);
                  },
                ),
              )),
          TFormItem(
              label: '上传图片',
              name: 'photo',
              labelWidth: 82.0,
              type: TFormItemType.upLoadImg,
              itemNotifier: _itemNotifier['photo'],
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: TUpload(
                  files: files,
                  multiple: true,
                  max: 6,
                  onError: print,
                  onValidate: print,
                  disabled: _formDisableState,
                  onChanged: ((imgList, type) {
                    if (_formDisableState) {
                      return;
                    }
                    files = _onValueChanged(files, imgList, type);
                    List imgs =
                        files.map((e) => e.remotePath ?? e.assetPath).toList();
                    setState(() {
                      _itemNotifier['photo'].upDataForm(imgs.join(','));
                    });
                  }),
                ),
              ))
        ],
        btnGroup: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                      child: TButton(
                    child: const Text('重置'),
                    size: TButtonSize.large,
                    variant: TButtonVariant.fill,
                    colorScheme: TButtonColorScheme.light,
                    onPressed: _formDisableState
                        ? null
                        : () {
                            //用户名称
                            _textControllers[0].clear();
                            //密码
                            _textControllers[1].clear();
                            // 性别
                            _genderCheckboxGroupController.toggle('', false);
                            //个人简介
                            _textControllers[2].clear();
                            //生日
                            _selected_1 = '';
                            //籍贯
                            _selected_2 = '';
                            //年限
                            _stepController.add(TStepperEventType.cleanValue);
                            //上传图片
                            files.clear();
                            _formData = {
                              'name': '',
                              'password': '',
                              'gender': '',
                              'birth': '',
                              'place': '',
                              'age': '0',
                              'description': '2',
                              'resume': '',
                              'photo': ''
                            };
                            _formData.forEach((key, value) {
                              _itemNotifier[key].upDataForm(value);
                            });
                            _formController.reset(_formData);
                            setState(() {});
                          },
                  )),
                  const SizedBox(
                  ),
                  Expanded(
                      child: TButton(
                          child: const Text('提交'),
                          size: TButtonSize.large,
                          variant: TButtonVariant.fill,
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: _formDisableState ? null : _onSubmit)),
                ],
              ))
        ]);
  }

  @Demo(group: 'form')
  Widget _buildCustomForm(BuildContext context) {
    return TForm(
        controller: _formController,
        disabled: _formDisableState,
        data: _formData,
        layout: _isFormHorizontal,
        rules: _validationRules,
        formContentAlign: TextAlign.left,
        requiredMark: true,

        /// 确定整个表单是否展示提示信息
        showErrorMessage: true,
        onSubmit: onSubmit,
        items: [
          TFormItem(
            backgroundColor: context.tTheme.brandNormalColor,
            label: '用户名',
            name: 'name',
            type: TFormItemType.input,
            help: '请输入用户名',
            labelWidth: 82.0,
            itemNotifier: _itemNotifier['name'],

            /// 控制单个 item 是否展示错误提醒
            showErrorMessage: true,
            requiredMark: true,
            child: TInput(
                inputDecoration: InputDecoration(
                    hintText: '请输入用户名',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(0),
                    hintStyle: TextStyle(
                        color:
                            context.tTheme.fontGyColor3.withOpacity(0.4))),
                controller: _textControllers[0],
                backgroundColor: context.tTheme.brandNormalColor,
                additionInfoColor: context.tTheme.errorColor6,
                showBottomDivider: false,
                readOnly: _formDisableState,
                onChanged: (val) {
                  _itemNotifier['name']?.upDataForm(val);
                },
                onClearTap: () {
                  _textControllers[0].clear();
                  _itemNotifier['name']?.upDataForm('');
                }),
          ),
          TFormItem(
            label: '密码',
            backgroundColor: context.tTheme.brandNormalColor,
            name: 'password',
            type: TFormItemType.input,
            labelWidth: 82.0,
            itemNotifier: _itemNotifier['password'],
            showErrorMessage: true,
            child: TInput(
                inputDecoration: InputDecoration(
                    hintText: '请输入密码',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color:
                            context.tTheme.fontGyColor3.withOpacity(0.4))),
                layout: TInputLayout.normal,
                controller: _textControllers[1],
                obscureText: !browseOn,
                backgroundColor: context.tTheme.brandNormalColor,
                showClearButton: false,
                readOnly: _formDisableState,
                showBottomDivider: false,
                onChanged: (val) {
                  _itemNotifier['password']?.upDataForm(val);
                },
                onClearTap: () {
                  _textControllers[1].clear();
                  _itemNotifier['password']?.upDataForm('');
                }),
          ),
          TFormItem(
            label: '性别',
            name: 'gender',
            backgroundColor: context.tTheme.brandNormalColor,
            type: TFormItemType.radios,
            labelWidth: 82.0,
            showErrorMessage: true,
            itemNotifier: _itemNotifier['gender'],
            child: TRadioGroup(
              spacing: 0,
              direction: Axis.horizontal,
              controller: _genderCheckboxGroupController,
              directionalTdRadios: _radios.entries.map((entry) {
                return TRadio(
                  id: entry.key,
                  title: entry.value,
                  backgroundColor: context.tTheme.brandNormalColor,
                  selectColor: context.tTheme.brandFocusColor,
                  radioStyle: TRadioStyle.circle,
                  showDivider: false,
                  spacing: 4,
                  checkBoxLeftSpace: 0,
                  customSpace: const EdgeInsets.all(0),
                  enabled: !_formDisableState,
                );
              }).toList(),
              onRadioGroupChange: (selectedId) {
                _itemNotifier['gender']?.upDataForm(selectedId);
              },
            ),
          ),
          TFormItem(
            label: '生日',
            name: 'birth',
            backgroundColor: context.tTheme.brandNormalColor,
            labelWidth: 82.0,
            type: TFormItemType.dateTimePicker,
            contentAlign: TextAlign.left,
            tipAlign: TextAlign.left,
            itemNotifier: _itemNotifier['birth'],
            hintText: '请输入内容',
            select: _selected_1,
            selectFn: (BuildContext context) {
              if (_formDisableState) {
                return;
              }
              _showDatePicker(
                context,
                initialDate: [2012, 1, 1],
                onConfirm: (selected) {
                  setState(() {
                    _selected_1 =
                        '${selected[0].toString().padLeft(4, '0')}-${selected[1].toString().padLeft(2, '0')}-${selected[2].toString().padLeft(2, '0')}';
                    _itemNotifier['birth']?.upDataForm(_selected_1);
                  });
                },
              );
            },
          ),
          TFormItem(
              label: '年限',
              name: 'age',
              labelWidth: 82.0,
              backgroundColor: context.tTheme.brandNormalColor,
              type: TFormItemType.stepper,
              itemNotifier: _itemNotifier['age'],
              child: Padding(
                padding: const EdgeInsets.only(right: 18),
                child: TStepper(
                  theme: TStepperColorScheme.filled,
                  disabled: _formDisableState,
                  eventController: _stepController!,
                  value: int.parse(_formData['age']),
                  onChanged: (value) {
                    _itemNotifier['age']?.upDataForm('$value');
                  },
                ),
              )),
          TFormItem(
            label: '自我评价',
            name: 'description',
            tipAlign: TextAlign.left,
            type: TFormItemType.rate,
            labelWidth: 82.0,
            backgroundColor: context.tTheme.brandNormalColor,
            itemNotifier: _itemNotifier['description'],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: TRate(
                    count: 5,
                    value: double.parse(_formData['description']),
                    allowHalf: false,
                    disabled: _formDisableState,
                    onChanged: (value) {
                      setState(() {
                        _formData['description'] = '$value';
                      });
                      _itemNotifier['description']?.upDataForm('$value');
                    },
                  )),
            ),
          ),
          TFormItem(
              label: '个人简介',
              labelWidth: 82.0,
              name: 'resume',
              type: TFormItemType.textarea,
              backgroundColor: context.tTheme.brandNormalColor,
              itemNotifier: _itemNotifier['resume'],
              child: Padding(
                padding:
                    EdgeInsets.only(top: _isFormHorizontal ? 0 : 8, bottom: 4),
                child: TTextarea(
                  padding: const EdgeInsets.all(0),
                  hintText: '请输入个人简介',
                  maxLength: 500,
                  indicator: true,
                  readOnly: _formDisableState,
                  layout: TTextareaLayout.vertical,
                  controller: _textControllers[2],
                  showBottomDivider: false,
                  onChanged: (value) {
                    _itemNotifier['resume']?.upDataForm(value);
                  },
                ),
              )),
          TFormItem(
              label: '上传图片',
              name: 'photo',
              labelWidth: 82.0,
              backgroundColor: context.tTheme.brandNormalColor,
              type: TFormItemType.upLoadImg,
              itemNotifier: _itemNotifier['photo'],
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: TUpload(
                  files: files,
                  multiple: true,
                  max: 6,
                  onError: print,
                  onValidate: print,
                  disabled: _formDisableState,
                  onChanged: ((imgList, type) {
                    if (_formDisableState) {
                      return;
                    }
                    files = _onValueChanged(files, imgList, type);
                    List imgs =
                        files.map((e) => e.remotePath ?? e.assetPath).toList();
                    setState(() {
                      _itemNotifier['photo'].upDataForm(imgs.join(','));
                    });
                  }),
                ),
              ))
        ],
        btnGroup: null);
  }

  List<TUploadFile> _onValueChanged(List<TUploadFile> fileList,
      List<TUploadFile> value, TUploadAction event) {
    switch (event) {
      case TUploadAction.add:
        fileList.addAll(value);
        break;
      case TUploadAction.remove:
        fileList.removeWhere((element) => element.key == value[0].key);
        break;
      case TUploadAction.replace:
        final firstReplaceFile = value.first;
        final index =
            fileList.indexWhere((file) => file.key == firstReplaceFile.key);
        if (index != -1) {
          fileList[index] = firstReplaceFile;
        }
        break;
    }
    return fileList;
  }

  /// todo
  /// 横 竖 排版模式切换按钮
  Widget _buildArrangementSwitch(BuildContext buildContext) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TButton(
                child: const Text('水平排布'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(horizontalButtonColor),
                ),
                onPressed: () {
                  setState(() {
                    if (horizontalButton) {
                      /// 置换按钮状态
                      horizontalButton = false;
                      verticalButton = true;

                      /// 置换按钮颜色
                      final currentVerticalColor = verticalButtonColor;
                      verticalButtonColor = horizontalButtonColor;
                      horizontalButtonColor = currentVerticalColor;

                      /// 置换文字颜色
                      final currentTextColor = verticalTextColor;
                      verticalTextColor = horizontalTextColor;
                      horizontalTextColor = currentTextColor;
                      _isFormHorizontal = true;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TButton(
                child: const Text('竖直排布'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(verticalButtonColor),
                ),
                onPressed: () {
                  setState(() {
                    if (verticalButton) {
                      /// 置换按钮状态
                      horizontalButton = true;
                      verticalButton = false;

                      /// 置换按钮颜色
                      final currentVerticalColor = verticalButtonColor;
                      verticalButtonColor = horizontalButtonColor;
                      horizontalButtonColor = currentVerticalColor;

                      /// 置换文字颜色
                      final currentTextColor = verticalTextColor;
                      verticalTextColor = horizontalTextColor;
                      horizontalTextColor = currentTextColor;

                      _isFormHorizontal = false;
                    }
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildSwitchWithBase(BuildContext context) {
    return TCell(
      title: '禁用态',
      rightIconWidget: TSwitch(
        value: _formDisableState,
        onChanged: (value) {
          setState(() {
            _formDisableState = value;
          });
        },
      ),
    );
  }
}
