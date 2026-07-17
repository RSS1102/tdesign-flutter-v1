import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/binding.dart';

import '../../../tdesign_flutter.dart';

/// 链接设置
class TMessageLink {
  TMessageLink({
    required this.name,
    required this.uri,
    this.color,
  });

  /// 名称
  final String name;

  /// 资源链接
  final Uri? uri;

  /// 颜色
  final Color? color;
}

/// 跑马灯配置
class TMessageMarquee {
  TMessageMarquee({this.speed, this.loop, this.delay});

  /// 速度
  final int? speed;

  /// 循环次数
  final int? loop;

  /// 延迟时间(毫秒)
  final int? delay;
}

/// TMessage 组件
class TMessage extends StatefulWidget {
  const TMessage({
    Key? key,
    this.closeBtn,
    this.content,
    this.duration = 3000,
    this.icon = true,
    this.link,
    this.marquee,
    this.offset,
    this.variant = TMessageVariant.info,
    this.visible = true,
    this.onCloseBtnClick,
    this.onDurationEnd,
    this.onLinkClick,
  }) : super(key: key);

  /// 通知内容
  final String? content;

  /// 消息内置计时器
  final int? duration;

  /// 是否显示
  final bool? visible;

  /// 自定义消息前面的图标
  final dynamic icon;

  /// 链接名称
  final dynamic link;

  /// 关闭按钮
  final dynamic closeBtn;

  /// 跑马灯效果
  final TMessageMarquee? marquee;

  /// 相对于 placement 的偏移量
  final List<double>? offset;

  /// 消息组件风格 info/success/warning/error
  final TMessageVariant? variant;

  /// 点击关闭按钮触发
  final VoidCallback? onCloseBtnClick;

  /// 计时结束后触发
  final VoidCallback? onDurationEnd;

  /// 点击链接文本时触发
  final VoidCallback? onLinkClick;

  @override
  _TMessageState createState() => _TMessageState();

  static void showMessage({
    required BuildContext context,
    String? content,
    bool? visible,
    int? duration,
    dynamic closeBtn,
    dynamic icon,
    dynamic link,
    TMessageMarquee? marquee,
    List<double>? offset,
    TMessageVariant? theme,
    VoidCallback? onCloseBtnClick,
    VoidCallback? onDurationEnd,
    VoidCallback? onLinkClick,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    var dismissed = false;

    void dismissOverlay() {
      if (dismissed) {
        return;
      }
      dismissed = true;
      overlayEntry.remove();
    }

    overlayEntry = OverlayEntry(
      builder: (context) => TMessage(
        content: content,
        visible: visible,
        duration: duration,
        closeBtn: closeBtn,
        icon: icon,
        link: link,
        marquee: marquee,
        offset: offset,
        variant: theme,
        onDurationEnd: () {
          onDurationEnd?.call(); // coverage:ignore-line
          dismissOverlay(); // coverage:ignore-line
        },
        onCloseBtnClick: () {
          onCloseBtnClick?.call(); // coverage:ignore-line
          dismissOverlay(); // coverage:ignore-line
        },
        onLinkClick: onLinkClick,
      ),
    );
    overlay.insert(overlayEntry);
  }
}

class _TMessageState extends State<TMessage> with TickerProviderStateMixin {
  bool _isVisible = true;
  double _topOffset = 0;
  double initTopOffset = 80;
  double totalWidth = 343;
  AnimationController? animationController;
  bool _isAnimationRunning = false;
  Timer? _durationTimer;
  Timer? _closeTimer;
  Timer? _marqueeDelayTimer;

  @override
  void initState() {
    super.initState();
    _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.marquee?.speed ?? 10000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _topOffset = widget.offset?[1] ?? initTopOffset;
        });
      }
    });

    _scheduleDurationClose();
    _scheduleMarqueeStart();
  }

  @override
  void didUpdateWidget(covariant TMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.marquee?.speed != widget.marquee?.speed) {
      animationController?.duration =
          Duration(milliseconds: widget.marquee?.speed ?? 10000);
    }
    if (oldWidget.duration != widget.duration) {
      _scheduleDurationClose();
    }
    if (oldWidget.marquee != widget.marquee) {
      _scheduleMarqueeStart();
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _closeTimer?.cancel();
    _marqueeDelayTimer?.cancel();
    animationController?.stop();
    animationController?.dispose();
    animationController = null;
    super.dispose();
  }

  void _scheduleDurationClose() {
    _durationTimer?.cancel();
    if (widget.duration != null && widget.duration! > 0) {
      _durationTimer =
          Timer(Duration(milliseconds: widget.duration!), _closeMessage);
    }
  }

  void _scheduleMarqueeStart() {
    _marqueeDelayTimer?.cancel();
    if (widget.marquee == null) {
      return;
    }
    final delay = widget.marquee!.delay ?? 0;
    if (delay > 0) {
      _marqueeDelayTimer = Timer(Duration(milliseconds: delay), startAnimation);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => startAnimation());
    }
  }

  void _closeMessage() {
    if (mounted) {
      animationController?.stop();
      setState(() {
        _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
        _isAnimationRunning = false;
      });
      _closeTimer?.cancel();
      _closeTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
          widget.onDurationEnd?.call();
        }
      });
    }
  }

  void startAnimation() {
    if (mounted && animationController != null && !_isAnimationRunning) {
      setState(() {
        _isAnimationRunning = true;
      });
      if (widget.marquee!.loop == 0) {
        animationController!.forward(); // coverage:ignore-line
      } else if (widget.marquee!.loop == 1) {
        animationController!.repeat(); // coverage:ignore-line
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visible == false) {
      return const SizedBox.shrink();
    }
    var _leftOffset = widget.offset?[0] ??
        (MediaQuery.of(context).size.width - totalWidth) / 2;

    Widget getText(BuildContext context) {
      if (widget.marquee == null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.content ?? '',
            style: TextStyle(color: context.tTheme.textColorPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
              text: widget.content ?? '',
              style: TextStyle(color: context.tTheme.textColorPrimary)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity);
        final textWidth = textPainter.width;

        final containerWidth = calculateTextWidth();

        final tween = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-textWidth, 0),
        );

        return Align(
            alignment: Alignment.center,
            child: ClipRect(
              child: SizedBox(
                width: containerWidth,
                child: AnimatedBuilder(
                  animation:
                      animationController ?? const AlwaysStoppedAnimation(0),
                  builder: (context, child) {
                    final offset = tween.evaluate(
                        animationController ?? const AlwaysStoppedAnimation(0));
                    return OverflowBox(
                      minWidth: 0,
                      maxWidth: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: offset,
                        child: SizedBox(
                          child: Text(
                            widget.content ?? '',
                            style: TextStyle(
                                color: context.tTheme.textColorPrimary),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ));
      }
    }

    Widget getIcon(BuildContext context) {
      if (widget.icon is Widget) {
        return widget.icon;
      } else {
        switch (widget.variant) {
          case TMessageVariant.info:
            return Icon(
              TIcons.error_circle_filled,
              color: context.tTheme.brandNormalColor,
            );
          case TMessageVariant.success:
            return Icon(
              TIcons.check_circle_filled,
              color: context.tTheme.successNormalColor,
            );
          case TMessageVariant.warning:
            return Icon(
              TIcons.error_circle_filled,
              color: context.tTheme.warningNormalColor,
            );
          case TMessageVariant.error:
            return Icon(
              TIcons.error_circle_filled,
              color: context.tTheme.errorNormalColor,
            );
          case null:
            return const SizedBox.shrink();
        }
      }
    }

    void clickCloseButton() {
      _closeMessage();
      widget.onCloseBtnClick?.call();
    }

    Widget getCloseBtn(BuildContext context) {
      if (widget.closeBtn is Widget) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: widget.closeBtn!,
        );
      } else if (widget.closeBtn == true) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: Icon(
            TIcons.close,
            color: context.tTheme.textColorPlaceholder,
          ),
        );
      } else if (widget.closeBtn is String) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: Text(widget.closeBtn),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    void clickLink() {
      widget.onLinkClick?.call();
    }

    Widget getLink(BuildContext context) {
      if (widget.link is TMessageLink) {
        final linkColor = widget.link.color;
        final linkWidget = TLink(
          child: Text(widget.link.name),
          colorScheme: TLinkColorScheme.primary,
          variant: TLinkVariant.basic,
          uri: widget.link.uri,
          size: TLinkSize.medium,
          onPressed: clickLink,
        );
        // 自定义链接颜色通过 TLinkThemeData 注入
        if (linkColor != null) {
          return Align(
            alignment: Alignment.center,
            child: Theme(
              data: Theme.of(context).mergeExtension(
                TLinkThemeData(color: linkColor),
              ),
              child: linkWidget,
            ),
          );
        }
        return Align(alignment: Alignment.center, child: linkWidget);
      } else if (widget.link is String) {
        return Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: clickLink,
              child: Text(
                widget.link ?? '',
                style: TextStyle(
                  color: context.tTheme.brandNormalColor,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ));
      } else {
        return const SizedBox.shrink();
      }
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _topOffset,
      left: _leftOffset,
      child: _isVisible
          ? Material(
              color: Colors.transparent,
              child: Container(
                width: totalWidth,
                height: 48,
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                decoration: BoxDecoration(
                    color: context.tTheme.bgColorContainer,
                    borderRadius:
                        BorderRadius.circular(context.tTheme.radiusDefault),
                    boxShadow: context.tTheme.shadowsMiddle),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.icon != false)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 20,
                            height: 22,
                            child: getIcon(context),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: getText(context),
                            flex: 3,
                          ),
                          if (widget.link != null)
                            Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 40,
                                height: 22,
                                child: getLink(context)),
                          if (widget.closeBtn != null)
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: getCloseBtn(context),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  double calculateTextWidth() {
    var width = totalWidth - 32;
    if (widget.icon != null && widget.icon != false) {
      width -= 30;
    }
    if (widget.link != null) {
      width -= 36;
    }
    if (widget.closeBtn != null) {
      width -= 34;
    }
    return width;
  }
}
