import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../loading/t_loading.dart';
import '../loading/t_loading_theme_data.dart';
import '../text/t_text.dart';
import 't_refresh_theme_data.dart';

/// TDesign刷新头部
/// 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
class TRefreshHeader extends Header {
  TRefreshHeader({
    this.key,
    double? extent,
    double? triggerDistance,
    bool? clamping,
    bool? float,
    Duration? processedDuration,
    Duration? completeDuration,
    bool? hapticFeedback,
    this.enableHapticFeedback = true,
    double? infiniteOffset,
    this.enableInfiniteRefresh = false,
    bool? infiniteHitOver,
    bool? overScroll,
    TLoadingIcon? loadingIcon,
    Color? backgroundColor,
    super.spring,
    super.horizontalSpring,
    super.readySpringBuilder,
    super.horizontalReadySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.safeArea = false,
    super.hitOver,
    super.position,
    super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.notifyWhenInvisible,
    super.listenable,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.triggerWhenReleaseNoWait,
    super.maxOverOffset,
  })  : finalExtent = extent ?? 48.0,
        finalTriggerDistance = triggerDistance ?? 48.0,
        finalFloat = float ?? false,
        finalCompleteDuration = completeDuration,
        finalOverScroll = overScroll ?? true,
        finalLoadingIcon = loadingIcon,
        finalBackgroundColor = backgroundColor,
        assert((triggerDistance ?? 48.0) > 0.0),
        assert((extent ?? 48.0) >= 0.0,
            'extent must be non-negative'),
        assert(
            (clamping ?? float ?? false) ||
                (triggerDistance ?? 48.0) >= (extent ?? 48.0),
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(
          triggerOffset: triggerDistance ?? 48.0,
          clamping: clamping ?? float ?? false,
          processedDuration: processedDuration ??
              completeDuration ??
              const Duration(seconds: 1),
          hapticFeedback: hapticFeedback ?? enableHapticFeedback,
          infiniteOffset: enableInfiniteRefresh
              ? infiniteOffset
              : null,
          infiniteHitOver: infiniteHitOver ?? overScroll ?? true,
        );

  /// Key
  final Key? key;

  /// Header 容器高度
  final double finalExtent;

  /// 触发刷新任务的偏移量
  final double finalTriggerDistance;

  /// 是否悬浮
  final bool finalFloat;

  /// 完成延时
  final Duration? finalCompleteDuration;

  /// 越界滚动
  final bool finalOverScroll;

  /// loading 样式
  final TLoadingIcon? finalLoadingIcon;

  /// 背景颜色
  final Color? finalBackgroundColor;

  /// 开启震动反馈（保留实例，≠ 禁用）
  final bool enableHapticFeedback;

  /// 是否开启无限刷新（保留实例，≠ 禁用）
  final bool enableInfiniteRefresh;

  @override
  Widget build(BuildContext context, IndicatorState state) {
    // 不能为水平方向
    assert(
      state.axisDirection == AxisDirection.down ||
          state.axisDirection == AxisDirection.up, // coverage:ignore-line
      'Widget cannot be horizontal',
    );
    final theme = Theme.of(context).extension<TRefreshThemeData>();
    return TGIconHeaderWidget(
      key: key,
      loadingIcon: finalLoadingIcon ?? theme?.loadingIcon ?? TLoadingIcon.circle,
      backgroundColor: finalBackgroundColor ?? theme?.backgroundColor,
      state: state,
      refreshIndicatorExtent: finalExtent,
    );
  }
}

/// 刷新头部组件
class TGIconHeaderWidget extends StatefulWidget {
  /// loading样式
  final TLoadingIcon loadingIcon;

  /// 背景颜色
  final Color? backgroundColor;

  /// Indicator properties and state.
  final IndicatorState state;

  /// header高度
  final double refreshIndicatorExtent;

  const TGIconHeaderWidget({
    Key? key,
    this.backgroundColor,
    required this.state,
    required this.refreshIndicatorExtent,
    required this.loadingIcon,
  }) : super(key: key);

  @override
  TGIconHeaderWidgetState createState() {
    return TGIconHeaderWidgetState();
  }
}

class TGIconHeaderWidgetState extends State<TGIconHeaderWidget>
    with TickerProviderStateMixin {
  IndicatorMode get _refreshState => widget.state.mode;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  bool get _reverse => widget.state.reverse;

  double get _safeOffset => widget.state.safeOffset;

  Widget _buildLoading() => Theme(
        data: Theme.of(context).mergeExtension(
          TLoadingThemeData(
            iconColor: context.tTheme.brandNormalColor,
            axis: Axis.horizontal,
            textColor: context.tTheme.textColorPlaceholder,
          ),
        ),
        child: TLoading(
          size: TLoadingSize.medium,
          icon: widget.loadingIcon,
          text: context.resource.refreshing,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _offset,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: _offset < _actualTriggerOffset
                ? -(_actualTriggerOffset -
                        _offset +
                        (_reverse ? _safeOffset : -_safeOffset)) /
                    2
                : (!_reverse ? _safeOffset : 0), // coverage:ignore-line
            bottom: _offset < _actualTriggerOffset
                ? null
                : (_reverse ? _safeOffset : 0), // coverage:ignore-line
            height:
                _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Container(
              alignment: Alignment.center,
              height: widget.refreshIndicatorExtent,
              color: widget.backgroundColor,
              child: Visibility(
                child: Container(
                  child: _buildLoading(),
                ),
                visible: _refreshState == IndicatorMode.processing ||
                    _refreshState == IndicatorMode.ready,
                replacement: Visibility(
                  visible: _refreshState != IndicatorMode.inactive,
                  child: TText(
                    _refreshState == IndicatorMode.drag
                        ? context.resource.pullToRefresh // coverage:ignore-line
                        : _refreshState == IndicatorMode.processed ||
                                _refreshState == IndicatorMode.done
                            ? context.resource.completeRefresh // coverage:ignore-line
                            : context.resource.releaseRefresh,
                    font: context.tTheme.fontBodyMedium,
                    textColor: context.tTheme.textColorPlaceholder,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
