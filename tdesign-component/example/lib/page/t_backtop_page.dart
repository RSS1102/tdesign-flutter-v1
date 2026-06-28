import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TBackTopPage extends StatefulWidget {
  const TBackTopPage({Key? key}) : super(key: key);

  @override
  State<TBackTopPage> createState() => _TBackTopPageState();
}

class _TBackTopPageState extends State<TBackTopPage> {
  final ScrollController controller = ScrollController();
  TBackTopShape shape = TBackTopShape.circle;
  TBackTopColorScheme colorScheme = TBackTopColorScheme.light;

  @override
  void initState() {
    super.initState();
    // 根据当前亮暗主题自动适配 colorScheme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        colorScheme = Theme.of(context).brightness == Brightness.dark
            ? TBackTopColorScheme.dark
            : TBackTopColorScheme.light;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      scrollController: controller,
      title: tTitle(),
      desc: '用于当页面过长往下滑动时，帮助用户快速回到页面顶部。',
      exampleCodeGroup: 'backtop',
      floatingActionButton: shape == TBackTopShape.halfCircle
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: TBackTopThemeData().halfCircleRightInset ?? -16,
                  bottom: 10,
                  child: TBackTop(
                    controller: controller,
                    colorScheme: colorScheme,
                    showText: true,
                    shape: shape,
                    visibilityOffset: 100,
                  ),
                ),
              ],
            )
          : TBackTop(
              controller: controller,
              colorScheme: colorScheme,
              showText: true,
              shape: shape,
              visibilityOffset: 100,
            ),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '圆形返回顶部', builder: _buildCircleBackTop),
          ExampleItem(desc: '半圆形返回顶部', builder: _buildHalfCircleBackTop),
        ])
      ],
    );
  }

  @Demo(group: 'backtop')
  Widget _buildCircleBackTop(BuildContext context) {
    return getCustomButton(context, '圆形返回顶部', () {
      setState(() {
        if (controller.hasClients) {
          controller.jumpTo(500);
        }
        shape = TBackTopShape.circle;
      });
    });
  }

  @Demo(group: 'backtop')
  Widget _buildHalfCircleBackTop(BuildContext context) {
    return Column(
      children: [
        getCustomButton(context, '半圆形返回顶部', () {
          setState(() {
            if (controller.hasClients) {
              controller.jumpTo(500);
            }
            shape = TBackTopShape.halfCircle;
          });
        }),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Wrap(
            spacing: 16,
            runSpacing: 24,
            children: List.generate(6, (_) => getDemoBox(context)),
          ),
        ),
      ],
    );
  }

  Widget getCustomButton(
      BuildContext context, String text, void Function() onTap) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text(text),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onTap,
      ),
    );
  }

  Widget getDemoBox(BuildContext context) {
    final theme = TTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 163,
          height: 163,
          decoration: BoxDecoration(
            color: theme.bgColorContainer,
            borderRadius: BorderRadius.circular(theme.radiusExtraLarge),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 163,
          height: 16,
          decoration: BoxDecoration(
            color: theme.bgColorContainer,
            borderRadius: BorderRadius.circular(theme.radiusSmall),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: theme.bgColorContainer,
            borderRadius: BorderRadius.circular(theme.radiusSmall),
          ),
        ),
      ],
    );
  }
}
