import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TInputViewPage extends StatefulWidget {
  const TInputViewPage({Key? key}) : super(key: key);

  @override
  _TInputViewPageState createState() => _TInputViewPageState();
}

class _TInputViewPageState extends State<TInputViewPage> {
  String inputText = '请输入...';
  var controller = [];
  var browseOn = false;
  var confirmText = '发送验证码';
  var countDownText = '重发';
  Timer? _timer;
  int _countdownTime = 0;

  @override
  void initState() {
    for (var i = 0; i < 30; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer?.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  Widget build(BuildContext context) {
    var childBuilder = (context) {
      return ExamplePage(
        title: tTitle(),
        desc: '用于在预设的一组选项中执行单项选择，并呈现选择结果。',
        exampleCodeGroup: 'input',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(desc: '基础输入框', builder: _basicTypeBasic),
              ExampleItem(builder: _basicTypeRequire),
              ExampleItem(builder: _basicTypeOptional),
              ExampleItem(builder: _basicTypePureInput),
              ExampleItem(builder: _basicTypeAdditionalDesc),
              ExampleItem(desc: '带字数限制输入框', builder: _basicTypeTextLimit),
              ExampleItem(builder: _basicTypeTextLimitChinese2),
              ExampleItem(desc: '带操作输入框', builder: _basicTypeWithHandleIconOne),
              ExampleItem(builder: _basicTypeWithHandleIconTwo),
              ExampleItem(builder: _basicTypeWithHandleIconThree),
              ExampleItem(
                  desc: '带图标输入框', builder: _basicTypeWithLeftIconLeftLabel),
              ExampleItem(builder: _basicTypeWithLeftIcon),
              ExampleItem(desc: '特定类型输入框', builder: _specialTypePassword),
              ExampleItem(builder: _specialTypeVerifyCode),
              ExampleItem(builder: _specialTypePhoneNumber),
              ExampleItem(builder: _specialTypePrice),
              ExampleItem(builder: _specialTypeNumber),
              ExampleItem(desc: '自适应高度输入框', builder: _autoHeightInput),
              ExampleItem(builder: _specialTypeNumber),
              ExampleItem(builder: _specialTypePasswordWithPaste),
              ExampleItem(builder: (context) {
                return Container();
              }),
            ],
          ),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '输入框状态', builder: _inputStatusAdditionInfo),
            ExampleItem(builder: _inputStatusReadOnly),
            ExampleItem(desc: '信息超长状态', builder: _inputStatusLongLabel),
            ExampleItem(builder: _inputStatusLongInput),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '内容位置', builder: _contentLeft),
            ExampleItem(builder: _contentCenter),
            ExampleItem(builder: _contentRight),
            ExampleItem(desc: '竖排样式', builder: _verticalStyle),
            ExampleItem(desc: '非通栏样式', builder: _cardStyle),
            ExampleItem(desc: '标签外置样式', builder: _labelOutStyle),
            ExampleItem(desc: '自定义样式输入框', builder: _customStyle),
          ]),
        ],
        test: [
          ExampleItem(desc: '长文本样式', builder: _customLongTextStyle),
          ExampleItem(desc: '隐藏底部分割线', builder: _hideBottomDivider),
          ExampleItem(desc: '自定义高度-使用SizeBox', builder: _customHeight),
          ExampleItem(
              desc: '获取焦点时点击外部区域事件响应-onTapOutside', builder: _onTapOutside),
          ExampleItem(
              desc: '设置contentPadding内容与分割线对齐', builder: _contentPadding)
        ],
      );
    };
    if (PlatformUtil.isWeb) {
      return FutureBuilder(
          future: awaitFontLoad(),
          builder: (context, s) {
            if (s.data == null) {
              return Container();
            }
            return childBuilder.call(context);
          });
    }
    return childBuilder.call(context);
  }

  @Demo(group: 'input')
  Widget _basicTypeBasic(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: 'Label Text',
          controller: controller[0],
          hintText: 'Please enter text',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[0].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeRequire(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '标签文字',
          required: true,
          controller: controller[1],
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[1].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeOptional(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '标签文字',
          controller: controller[2],
          hintText: '请输入文字(选填)',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[2].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypePureInput(BuildContext context) {
    return Column(
      children: [
        TInput(
          controller: controller[3],
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[3].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeAdditionalDesc(BuildContext context) {
    return TInput(
      layout: TInputLayout.normal,
      label: '标签文字',
      controller: controller[4],
      hintText: '请输入文字',
      additionInfo: '辅助说明',
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[4].clear();
        setState(() {});
      },
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeTextLimit(BuildContext context) {
    return Column(
      children: [
        TInput(
          layout: TInputLayout.normal,
          label: '标签文字',
          controller: controller[5],
          hintText: '请输入文字',
          maxLength: 10,
          additionInfo: '最大输入10个字符',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[5].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeTextLimitChinese2(BuildContext context) {
    return TInput(
      layout: TInputLayout.normal,
      label: '标签文字',
      controller: controller[6],
      hintText: '请输入文字',
      inputFormatters: [Chinese2Formatter(10)],
      additionInfo: '最大输入10个字符，汉字算两个',
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[6].clear();
        setState(() {});
      },
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithHandleIconOne(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '标签文字',
          controller: controller[7],
          hintText: '请输入文字',
          rightBtn: Icon(
            TIcons.error_circle_filled,
            color: context.tTheme.textColorPlaceholder,
          ),
          onBtnTap: () {
            TToast.showText('点击右侧按钮', context: context);
          },
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[7].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithHandleIconTwo(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '标签文字',
          controller: controller[8],
          hintText: '请输入文字',
          rightBtn: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: context.tTheme.brandNormalColor,
            ),
            child: const TButton(
              child: Text('操作按钮'),
              size: TButtonSize.extraSmall,
              colorScheme: TButtonColorScheme.primary,
            ),
          ),
          onBtnTap: () {
            TToast.showText('点击操作按钮', context: context);
          },
          showClearButton: false,
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithHandleIconThree(BuildContext context) {
    return TInput(
      label: '标签文字',
      controller: controller[9],
      hintText: '请输入文字',
      rightBtn: Icon(
        TIcons.user_avatar,
        color: context.tTheme.textColorPlaceholder,
      ),
      onBtnTap: () {
        TToast.showText('点击操作按钮', context: context);
      },
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[9].clear();
        setState(() {});
      },
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithLeftIconLeftLabel(BuildContext context) {
    return Column(
      children: [
        TInput(
          prefix: const Icon(TIcons.app),
          label: '标签文字',
          controller: controller[10],
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[10].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithLeftIcon(BuildContext context) {
    return Column(
      children: [
        TInput(
          prefix: const Icon(TIcons.app),
          controller: controller[11],
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[11].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePassword(BuildContext context) {
    return Column(
      children: [
        TInput(
          layout: TInputLayout.normal,
          controller: controller[12],
          obscureText: !browseOn,
          label: '输入密码',
          hintText: '请输入密码',
          rightBtn: browseOn
              ? Icon(
                  TIcons.browse,
                  color: context.tTheme.textColorPlaceholder,
                )
              : Icon(
                  TIcons.browse_off,
                  color: context.tTheme.textColorPlaceholder,
                ),
          onBtnTap: () {
            setState(() {
              browseOn = !browseOn;
            });
          },
          showClearButton: false,
        ),
        const SizedBox(),
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePasswordWithPaste(BuildContext context) {
    return Column(
      children: [
        TInput(
          layout: TInputLayout.normal,
          controller: controller[27],
          obscureText: true,
          enableInteractiveSelection: true,
          label: '密码复制粘贴',
          hintText: '此密码框允许长按复制粘贴',
          contextMenuBuilder: (context, editableTextState) {
            final buttonItems = editableTextState.contextMenuButtonItems;
            if (!buttonItems
                .any((item) => item.type == ContextMenuButtonType.copy)) {
              buttonItems.insert(
                  0,
                  ContextMenuButtonItem(
                    onPressed: () {
                      final selection =
                          editableTextState.textEditingValue.selection;
                      final text = editableTextState.textEditingValue.text;
                      if (selection.isValid && !selection.isCollapsed) {
                        final selectedText =
                            text.substring(selection.start, selection.end);
                        Clipboard.setData(ClipboardData(text: selectedText));
                      } else {
                        // 如果没有选中文本，则复制全部
                        Clipboard.setData(ClipboardData(text: text));
                      }
                      editableTextState.hideToolbar();
                    },
                    type: ContextMenuButtonType.copy,
                  ));
            }
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems: buttonItems,
            );
          },
        ),
        const SizedBox(),
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypeVerifyCode(BuildContext context) {
    return Column(
      children: [
        TInput(
          layout: TInputLayout.normal,
          size: TInputSize.small,
          controller: controller[13],
          label: '验证码',
          hintText: '输入验证码',
          rightBtn: SizedBox(
            width: 104,
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 0.5,
                  height: 24,
                  color: context.tTheme.componentBorderColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      'https://img2018.cnblogs.com/blog/736399/202001/736399-20200108170302307-1377487770.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          showClearButton: false,
          onBtnTap: () {
            TToast.showText('点击更换验证码', context: context);
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePhoneNumber(BuildContext context) {
    return Column(
      children: [
        TInput(
          layout: TInputLayout.normal,
          controller: controller[14],
          label: '手机号',
          hintText: '输入手机号',
          rightBtn: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 0.5,
                    color: context.tTheme.componentBorderColor,
                  ),
                ),
                _countdownTime > 0
                    ? TText(
                        '${countDownText}(${_countdownTime}秒)',
                        textColor: context.tTheme.textDisabledColor,
                      )
                    : TText(confirmText,
                        textColor: context.tTheme.brandNormalColor),
              ],
            ),
          ),
          showClearButton: false,
          onBtnTap: () {
            if (_countdownTime == 0) {
              TToast.showText('点击了发送验证码', context: context);
              setState(() {
                _countdownTime = 60;
              });
              startCountdownTimer();
            }
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePrice(BuildContext context) {
    return Column(
      children: [
        TInput(
          layout: TInputLayout.special,
          controller: controller[15],
          label: '价格',
          hintText: '0.00',
          textAlign: TextAlign.end,
          suffix: TText('元', textColor: context.tTheme.textColorPrimary),
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypeNumber(BuildContext context) {
    return TInput(
      layout: TInputLayout.special,
      controller: controller[16],
      label: '数量',
      hintText: '填写个数',
      textAlign: TextAlign.end,
      suffix: TText('个', textColor: context.tTheme.textColorPrimary),
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusAdditionInfo(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '标签文字',
          controller: controller[17],
          hintText: '请输入文字',
          additionInfo: '错误提示说明',
          additionInfoColor: context.tTheme.errorColor6,
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[17].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusReadOnly(BuildContext context) {
    return const TInput(
      label: '标签文字',
      readOnly: true,
      // 不可编辑文字 则不必带入controller
      hintText: '不可编辑文字',
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusLongLabel(BuildContext context) {
    return Column(
      children: [
        TInput(
          leftInfoWidth: 80,
          spacer: const TInputSpacer(iconLabelSpace: 4),
          label: '标签超长时最多十个字',
          controller: controller[18],
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[18].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusLongInput(BuildContext context) {
    return TInput(
      layout: TInputLayout.normal,
      label: '标签文字',
      controller: controller[19],
      hintText: '输入文字超长不超过两行输入文字超长不超过两行',
      hintTextStyle: TextStyle(
        color: context.tTheme.textColorPrimary,
      ),
      maxLines: 2,
    );
  }

  @Demo(group: 'input')
  Widget _verticalStyle(BuildContext context) {
    return TInput(
      spacer: const TInputSpacer(iconLabelSpace: 0),
      layout: TInputLayout.twoLine,
      label: '标签文字',
      controller: controller[20],
      hintText: '请输入文字',
      rightBtn: Icon(
        TIcons.error_circle_filled,
        color: context.tTheme.textColorPlaceholder,
      ),
      onBtnTap: () {
        TToast.showText('点击右侧按钮', context: context);
      },
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[20].clear();
        setState(() {});
      },
    );
  }

  @Demo(group: 'input')
  Widget _cardStyle(BuildContext context) {
    return TInput(
      layout: TInputLayout.cardStyle,
      width: MediaQuery.of(context).size.width - 32,
      label: '标签文字',
      controller: controller[21],
      hintText: '请输入文字',
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[21].clear();
        setState(() {});
      },
    );
  }

  @Demo(group: 'input')
  Widget _labelOutStyle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: TInput(
        layout: TInputLayout.cardStyle,
        width: MediaQuery.of(context).size.width - 32,
        cardStyleTopText: '标签文字',
        controller: controller[22],
        hintText: '请输入文字',
        rightBtn: Icon(
          TIcons.error_circle_filled,
          color: context.tTheme.textColorPlaceholder,
        ),
        onBtnTap: () {
          TToast.showText('点击右侧按钮', context: context);
        },
        onChanged: (text) {
          setState(() {});
        },
        onClearTap: () {
          controller[22].clear();
          setState(() {});
        },
      ),
    );
  }

  @Demo(group: 'input')
  Widget _contentLeft(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '左对齐',
          controller: controller[23],
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[23].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _contentCenter(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '居中',
          controller: controller[24],
          contentAlignment: TextAlign.center,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[24].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _contentRight(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '右对齐',
          controller: controller[25],
          contentAlignment: TextAlign.end,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[25].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  @Demo(group: 'input')
  Widget _customStyle(BuildContext context) {
    return TInput(
      label: '标签文字',
      controller: controller[26],
      backgroundColor: context.tTheme.grayColor12,
      labelStyle: TextStyle(color: context.tTheme.fontWhColor1),
      textStyle: TextStyle(color: context.tTheme.fontWhColor1),
      hintText: '请输入文字',
      hintTextStyle: TextStyle(color: context.tTheme.fontWhColor3),
      onChanged: (text) {
        setState(() {});
      },
      clearBtnColor: context.tTheme.fontWhColor3,
      onClearTap: () {
        controller[26].clear();
        setState(() {});
      },
    );
  }

  @Demo(group: 'input')
  Widget _customLongTextStyle(BuildContext context) {
    var controller = TextEditingController();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      width: MediaQuery.of(context).size.width,
      child: TInput(
          layout: TInputLayout.longText,
          width: MediaQuery.of(context).size.width - 32,
          cardStyleTopText: '标签文字',
          controller: controller,
          hintText: '请输入文字',
          rightBtn: Icon(
            TIcons.error_circle_filled,
            color: context.tTheme.textColorPlaceholder,
          ),
          onBtnTap: () {
            TToast.showText('点击右侧按钮', context: context);
          }),
    );
  }

  @Demo(group: 'input')
  Widget _hideBottomDivider(BuildContext context) {
    var controller = TextEditingController();
    return TInput(
      label: '标签文字',
      controller: controller,
      hintText: '请输入文字',
      showBottomDivider: false,
    );
  }

  @Demo(group: 'input')
  Widget _customHeight(BuildContext context) {
    var controller = TextEditingController();
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        child: TInput(
            size: TInputSize.small,
            label: '标签文字',
            controller: controller,
            hintText: '请输入文字'),
      ),
    );
  }

  @Demo(group: 'input')
  Widget _onTapOutside(BuildContext context) {
    var controller = TextEditingController();
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        child: TInput(
          size: TInputSize.small,
          label: '标签文字',
          controller: controller,
          hintText: '请输入文字',
          onTapOutside: (event) {
            TToast.showText('点击输入框外部区域', context: context);
            print('on tap outside ${event}');
          },
        ),
      ),
    );
  }

  @Demo(group: 'input')
  Widget _contentPadding(BuildContext context) {
    var controller = TextEditingController();
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          TInput(
            size: TInputSize.small,
            controller: controller,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: '请输入文字',
          ),
          TInput(
            layout: TInputLayout.twoLine,
            size: TInputSize.small,
            controller: controller,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            hintText: '请输入文字',
          ),
          TInput(
            layout: TInputLayout.normalMaxTwoLine,
            size: TInputSize.small,
            controller: controller,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
            hintText: '请输入文字',
          ),
        ],
      ),
    );
  }

  @Demo(group: 'input')
  Widget _autoHeightInput(BuildContext context) {
    return Column(
      children: [
        TInput(
          label: '地址',
          controller: controller[27],
          hintText: '请输入地址，高度自适应',
          maxLines: null,
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[27].clear();
            setState(() {});
          },
        ),
        const SizedBox()
      ],
    );
  }

  Future<bool> awaitFontLoad() async {
    // 等待500ms，让字体加载完成
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}
