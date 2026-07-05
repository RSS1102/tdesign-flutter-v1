import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 't_refresh_theme_data.dart';

/// TDesign刷新头部
/// 结合EasyRefresh类实现下拉刷新,继承自Header类，字段含义与父类一致
class TRefreshHeader extends Header {
  TRefreshHeader({
    TRefreshThemeData? themeData,
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
  })  : finalExtent = extent ?? themeData?.extent ?? 48.0,
        finalTriggerDistance =
            triggerDistance ?? themeData?.triggerDistance ?? 48.0,
        finalFloat = float ?? themeData?.float ?? false,
        finalCompleteDuration =
            completeDuration ?? themeData?.completeDuration,
        finalOverScroll = overScroll ?? themeData?.overScroll ?? true,
        finalLoadingIcon =
            loadingIcon ?? themeData?.loadingIcon ?? TLoadingIcon.circle,
        finalBackgroundColor = backgroundColor ?? themeData?.backgroundColor,
        this.themeData = themeData,
        assert(
            (triggerDistance ?? themeData?.triggerDistance ?? 48.0) > 0.0),
        assert(
            (extent ?? themeData?.extent ?? 48.0) >= 0.0,
            'extent must be non-negative'),
        assert(
            (clamping ?? float ?? themeData?.float ?? false) ||
                (triggerDistance ?? themeData?.triggerDistance ?? 48.0) >=
                    (extent ?? themeData?.extent ?? 48.0),
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(
          triggerOffset:
              triggerDistance ?? themeData?.triggerDistance ?? 48.0,
          clamping: clamping ?? float ?? themeData?.float ?? false,
          processedDuration: processedDuration ??
              completeDuration ??
              themeData?.completeDuration ??
              const Duration(seconds: 1),
          hapticFeedback: hapticFeedback ?? enableHapticFeedback,
          infiniteOffset: enableInfiniteRefresh
              ? (infiniteOffset ?? themeData?.infiniteOffset)
              : null,
          infiniteHitOver:
              infiniteHitOver ?? overScroll ?? themeData?.overScroll ?? true,
        );

  /// Key
  final Key? key;

  /// 组件级主题配置，优先级高于 Theme Extension
  final TRefreshThemeData? themeData;

  /// Header容器高度（从 themeData 或参数合并后的最终值）
  final double finalExtent;

  /// 触发刷新任务的偏移量（从 themeData 或参数合并后的最终值）
  final double finalTriggerDistance;

  /// 是否悬浮（从 themeData 或参数合并后的最终值）
  final bool finalFloat;

  /// 完成延时（从 themeData 或参数合并后的最终值）
  final Duration? finalCompleteDuration;

  /// 越界滚动（从 themeData 或参数合并后的最终值）
  final bool finalOverScroll;

  /// loading样式（从 themeData 或参数合并后的最终值）
  final TLoadingIcon finalLoadingIcon;

  /// 背景颜色（从 themeData 或参数合并后的最终值）
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
          state.axisDirection == AxisDirection.up,
      'Widget cannot be horizontal',
    );
    return TGIconHeaderWidget(
      key: key,
      loadingIcon: finalLoadingIcon,
      backgroundColor: finalBackgroundColor,
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
                : (!_reverse ? _safeOffset : 0),
            bottom: _offset < _actualTriggerOffset
                ? null
                : (_reverse ? _safeOffset : 0),
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
                        ? context.resource.pullToRefresh
                        : _refreshState == IndicatorMode.processed ||
                                _refreshState == IndicatorMode.done
                            ? context.resource.completeRefresh
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
