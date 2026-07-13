import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TTagPage extends StatelessWidget {
  const TTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(context),
        desc: '用于表明主体的类目，属性或状态',
        exampleCodeGroup: 'tag',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '基础标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildSimpleFillTag),
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildSimpleOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '圆弧标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildCircleFillTag),
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildCircleOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: 'Mark标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildMarkFillTag),
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildMarkOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '带图标的标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildIconFillTag),
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildIconOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '可关闭的标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildCloseFillTag),
                      const SizedBox(width: 16),
                      CodeWrapper(builder: _buildCloseOutlineTag),
                    ],
                  );
                }),
          ]),
          ExampleModule(title: '组件状态（主题）', children: [
            ExampleItem(
                desc: '填充型各主题',
                ignoreCode: true,
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: Wrap(
                      spacing: 8,
                      direction: Axis.vertical,
                      children: [
                        CodeWrapper(builder: _buildDarkShowTags),
                        CodeWrapper(builder: _buildLightShowTags),
                      ],
                    ),
                  );
                }),
            ExampleItem(
                desc: '描边型各主题',
                ignoreCode: true,
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: Wrap(
                      spacing: 8,
                      direction: Axis.vertical,
                      children: [
                        CodeWrapper(builder: _buildOutlineShowTags),
                        CodeWrapper(builder: _buildLightOutlineShowTags),
                      ],
                    ),
                  );
                }),
          ]),
          ExampleModule(title: '组件尺寸', children: [
            ExampleItem(
                ignoreCode: true,
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: Wrap(spacing: 8, direction: Axis.vertical, children: [
                      CodeWrapper(builder: _buildAllSizeTags),
                    ]),
                  );
                })
          ]),
        ],
        test: [
          ExampleItem(
              desc: '禁用状态',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      _buildDisabledTag(context),
                    ],
                  ),
                );
              }),
        ]);
  }

  // ============ 组件类型 ============

  @Demo(group: 'tag')
  Widget _buildSimpleFillTag(BuildContext context) {
    // 基础填充标签（默认 defaultTheme 语义色）
    return const TTag('标签文字');
  }

  @Demo(group: 'tag')
  Widget _buildSimpleOutlineTag(BuildContext context) {
    // 描边标签：通过 TTagThemeData(isOutline: true) 子树注入
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(isOutline: true)),
      child: const TTag('标签文字'),
    );
  }

  @Demo(group: 'tag')
  Widget _buildCircleFillTag(BuildContext context) {
    // 圆弧标签：通过 TTagThemeData(shape: TTagShape.round) 子树注入
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(shape: TTagShape.round)),
      child: const TTag('标签文字'),
    );
  }

  @Demo(group: 'tag')
  Widget _buildCircleOutlineTag(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(shape: TTagShape.round, isOutline: true)),
      child: const TTag('标签文字'),
    );
  }

  @Demo(group: 'tag')
  Widget _buildMarkFillTag(BuildContext context) {
    // Mark 标签：左圆角右直角
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(shape: TTagShape.mark)),
      child: const TTag('标签文字'),
    );
  }

  @Demo(group: 'tag')
  Widget _buildMarkOutlineTag(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(shape: TTagShape.mark, isOutline: true)),
      child: const TTag('标签文字'),
    );
  }

  @Demo(group: 'tag')
  Widget _buildIconFillTag(BuildContext context) {
    // 带图标的标签：通过构造器 icon 参数传入 IconData
    return const TTag('标签文字', icon: TIcons.discount);
  }

  @Demo(group: 'tag')
  Widget _buildIconOutlineTag(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(isOutline: true)),
      child: const TTag('标签文字', icon: TIcons.discount),
    );
  }

  @Demo(group: 'tag')
  Widget _buildCloseFillTag(BuildContext context) {
    // 可关闭的标签：通过 TTagThemeData(needCloseIcon: true) 注入 + onCloseTap 回调
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(needCloseIcon: true)),
      child: TTag('标签文字', onCloseTap: () {}),
    );
  }

  @Demo(group: 'tag')
  Widget _buildCloseOutlineTag(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(isOutline: true, needCloseIcon: true)),
      child: TTag('标签文字', onCloseTap: () {}),
    );
  }

  // ============ 组件状态（主题） ============

  @Demo(group: 'tag')
  Widget _buildDarkShowTags(BuildContext context) {
    // 非浅色填充各主题
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
        TTag('主要', colorScheme: TTagColorScheme.primary),
        TTag('警告', colorScheme: TTagColorScheme.warning),
        TTag('危险', colorScheme: TTagColorScheme.danger),
        TTag('成功', colorScheme: TTagColorScheme.success),
      ],
    );
  }

  @Demo(group: 'tag')
  Widget _buildLightShowTags(BuildContext context) {
    // 浅色填充各主题
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(isLight: true)),
      child: const Wrap(
        spacing: 8,
        children: [
          TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
          TTag('主要', colorScheme: TTagColorScheme.primary),
          TTag('警告', colorScheme: TTagColorScheme.warning),
          TTag('危险', colorScheme: TTagColorScheme.danger),
          TTag('成功', colorScheme: TTagColorScheme.success),
        ],
      ),
    );
  }

  @Demo(group: 'tag')
  Widget _buildOutlineShowTags(BuildContext context) {
    // 非浅色描边各主题
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(isOutline: true)),
      child: const Wrap(
        spacing: 8,
        children: [
          TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
          TTag('主要', colorScheme: TTagColorScheme.primary),
          TTag('警告', colorScheme: TTagColorScheme.warning),
          TTag('危险', colorScheme: TTagColorScheme.danger),
          TTag('成功', colorScheme: TTagColorScheme.success),
        ],
      ),
    );
  }

  @Demo(group: 'tag')
  Widget _buildLightOutlineShowTags(BuildContext context) {
    // 浅色描边各主题
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(isOutline: true, isLight: true)),
      child: const Wrap(
        spacing: 8,
        children: [
          TTag('默认', colorScheme: TTagColorScheme.defaultTheme),
          TTag('主要', colorScheme: TTagColorScheme.primary),
          TTag('警告', colorScheme: TTagColorScheme.warning),
          TTag('危险', colorScheme: TTagColorScheme.danger),
          TTag('成功', colorScheme: TTagColorScheme.success),
        ],
      ),
    );
  }

  // ============ 组件尺寸 ============

  @Demo(group: 'tag')
  Widget _buildAllSizeTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      direction: Axis.vertical,
      children: [
        TTag('超大标签', size: TTagSize.extraLarge),
        TTag('大型标签', size: TTagSize.large),
        TTag('中等标签', size: TTagSize.medium),
        TTag('小型标签', size: TTagSize.small),
      ],
    );
  }

  // ============ 测试 ============

  Widget _buildDisabledTag(BuildContext context) {
    // 禁用状态：通过 TTagThemeData(disable: true) 注入
    return Theme(
      data: Theme.of(context).mergeExtension(const TTagThemeData(disable: true)),
      child: const Wrap(
        spacing: 8,
        children: [
          TTag('禁用', colorScheme: TTagColorScheme.defaultTheme),
          TTag('禁用', colorScheme: TTagColorScheme.primary),
          TTag('禁用', colorScheme: TTagColorScheme.danger),
        ],
      ),
    );
  }
}
