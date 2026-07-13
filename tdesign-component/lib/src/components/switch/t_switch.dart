import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../loading/t_circle_indicator.dart';
import 't_cupertino_switch.dart';

/// TSwitch 开关组件
///
/// 基于 Material [Switch.adaptive] 薄包装。
/// B 类禁用：`enabled: false`。
class TSwitch extends StatefulWidget {
  const TSwitch({
    Key? key,
    this.enabled = true,
    this.value = false,
    this.size,
    this.variant,
    this.trackOnColor,
    this.trackOffColor,
    this.thumbContentOnColor,
    this.thumbContentOffColor,
    this.thumbContentOnFont,
    this.thumbContentOffFont,
    this.onChanged,
    this.openText,
    this.closeText,
  }) : super(key: key);

  /// 是否可用
  final bool enabled;

  /// 是否打开
  final bool value;

  /// 尺寸
  final TSwitchSize? size;

  /// 形态
  final TSwitchVariant? variant;

  /// 开启时轨道颜色
  final Color? trackOnColor;

  /// 关闭时轨道颜色
  final Color? trackOffColor;

  /// 开启时Thumb颜色
  final Color? thumbContentOnColor;

  /// 关闭时Thumb颜色
  final Color? thumbContentOffColor;

  /// 开启时字体样式
  final TextStyle? thumbContentOnFont;

  /// 关闭时字体样式
  final TextStyle? thumbContentOffFont;

  /// 改变事件
  final ValueChanged<bool>? onChanged;

  /// 打开文案
  final String? openText;

  /// 关闭文案
  final String? closeText;

  @override
  State<TSwitch> createState() => _TSwitchState();
}

class _TSwitchState extends State<TSwitch> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TSwitchThemeData>();
    final size = widget.size ?? theme?.defaultSize ?? TSwitchSize.medium;
    final variant = widget.variant ?? theme?.defaultVariant ?? TSwitchVariant.fill;
    final switchEnabled = widget.enabled && variant != TSwitchVariant.loading;

    final trackOnColor = TSwitchResolve.resolveTrackOnColor(
      context: context,
      theme: theme,
      instanceColor: widget.trackOnColor,
    );
    final trackOffColor = TSwitchResolve.resolveTrackOffColor(
      context: context,
      theme: theme,
      instanceColor: widget.trackOffColor,
    );
    final thumbOnColor = TSwitchResolve.resolveThumbOnColor(
      context: context,
      theme: theme,
      instanceColor: widget.thumbContentOnColor,
    );
    final thumbOffColor = TSwitchResolve.resolveThumbOffColor(
      context: context,
      theme: theme,
      instanceColor: widget.thumbContentOffColor,
    );
    final thumbOnFont = TSwitchResolve.resolveThumbOnFont(
      theme: theme,
      instanceFont: widget.thumbContentOnFont,
    );
    final thumbOffFont = TSwitchResolve.resolveThumbOffFont(
      theme: theme,
      instanceFont: widget.thumbContentOffFont,
    );
    final openText = widget.openText ?? theme?.openText;
    final closeText = widget.closeText ?? theme?.closeText;

    Widget current = TCupertinoSwitch(
      value: widget.value,
      activeColor: trackOnColor,
      trackColor: trackOffColor,
      onChanged: switchEnabled
          ? (value) {
              widget.onChanged?.call(value);
            }
          : null,
      thumbView: _getThumbView(
        thumbOnColor,
        thumbOffColor,
        thumbOnFont,
        thumbOffFont,
        variant,
        openText,
        closeText,
      ),
    );

    if (!switchEnabled) {
      current = Opacity(
        opacity: 0.4,
        child: IgnorePointer(
          ignoring: true,
          child: current,
        ),
      );
    }

    return SizedBox(
      width: TSwitchResolve.getWidth(size),
      height: TSwitchResolve.getHeight(size),
      child: FittedBox(
        child: current,
      ),
    );
  }

  Widget? _getThumbView(
    Color thumbOnColor,
    Color thumbOffColor,
    TextStyle thumbOnFont,
    TextStyle thumbOffFont,
    TSwitchVariant variant,
    String? openText,
    String? closeText,
  ) {
    switch (variant) {
      case TSwitchVariant.text:
        return Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: 16,
              child: TText(
                widget.value
                    ? (openText ?? '开')
                    : (closeText ?? '关'),
                textColor:
                    widget.value ? thumbOnColor : thumbOffColor,
                forceVerticalCenter: true,
                maxLines: 1,
                style: widget.value ? thumbOnFont : thumbOffFont,
              ),
            )
          ],
        );
      case TSwitchVariant.loading:
        return Container(
          alignment: Alignment.centerLeft,
          child: TCircleIndicator(
            color: thumbOnColor,
            size: 16,
            lineWidth: 3,
          ),
        );
      case TSwitchVariant.icon:
        return Container(
          alignment: Alignment.centerLeft,
          child: Icon(
            widget.value ? TIcons.check : TIcons.close,
            size: 16,
            color: widget.value ? thumbOnColor : thumbOffColor,
          ),
        );
      case TSwitchVariant.fill:
        return null;
    }
  }
}
