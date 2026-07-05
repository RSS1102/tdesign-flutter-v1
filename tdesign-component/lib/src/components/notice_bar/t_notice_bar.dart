import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../tdesign_flutter.dart';
import 't_notice_bar_theme_data.dart';

/// 公告栏
class TNoticeBar extends StatefulWidget {
  const TNoticeBar({
    super.key,
    this.content,
    this.left,
    this.right,
    this.direction = Axis.horizontal,
    this.maxLines = 1,
    this.onPressed,
    this.themeData,
  })  : assert(content == null || content is String || content is List<String>,
            'content must be String or List<String>');

  /// 文本内容（字符串或字符串数组等）
  final dynamic content;

  /// 左侧内容（自定义左侧内容，优先级高于prefixIcon）
  final Widget? left;

  /// 右侧内容（自定义右侧内容，优先级高于suffixIcon）
  final Widget? right;

  /// 滚动方向
  final Axis? direction;

  /// 文本行数（仅静态有效）
  final int? maxLines;

  /// 点击事件
  final ValueChanged? onPressed;

  /// 组件级主题配置，优先级高于 Theme Extension
  final TNoticeBarThemeData? themeData;

  @override
  State<StatefulWidget> createState() => _TNoticeBarState();
}

class _TNoticeBarState extends State<TNoticeBar> {
  ScrollController? _scrollController;
  Timer? _timer;

  Size? _size;
  late TNoticeBarThemeData _resolved;

  final GlobalKey _key = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  dynamic _content;

  @override
  void initState() {
    _content = widget.content;
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      if (_effectiveMarquee == true) {
        _startTimer();
      }
    });
  }

  TNoticeBarThemeData get _theme {
    final ext = Theme.of(context).extension<TNoticeBarThemeData>();
    return (ext ?? const TNoticeBarThemeData()).merge(widget.themeData).resolve(context);
  }

  bool? get _effectiveMarquee => widget.themeData?.marquee ??
      Theme.of(context).extension<TNoticeBarThemeData>()?.marquee ??
      false;

  double get _effectiveSpeed => _theme.speed ?? 50;

  int get _effectiveInterval => _theme.interval ?? 3000;

  double get _effectiveHeight => _theme.height ?? 22;

  EdgeInsetsGeometry get _effectivePadding => _theme.padding ?? TNoticeBarThemeData.defaultPadding;

  void _init() {
    _resolved = _theme;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _scrollController?.dispose();
  }

  void _startTimer() {
    if (widget.direction == Axis.horizontal) {
      _scroll();
    } else if (widget.direction == Axis.vertical) {
      _step();
    }
  }

  void _scroll() {
    var scrollDistance =
        _getContextWidth() + (_size!.width - _effectivePadding.horizontal);
    var remainder = scrollDistance % _effectiveSpeed;
    _scrollController!.jumpTo(0);
    var offset = 0.0 + _effectiveSpeed;
    _scrollController!.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.linear);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (offset < scrollDistance - remainder) {
        offset += _effectiveSpeed;
        await _scrollController!.animateTo(offset,
            duration: const Duration(seconds: 1), curve: Curves.linear);
      } else {
        var time = (remainder / _effectiveSpeed * 1000).round();
        await _scrollController!.animateTo(scrollDistance,
            duration: Duration(milliseconds: time), curve: Curves.linear);
        _scrollController!.jumpTo(0);
        offset = _effectiveSpeed - remainder;
        remainder = (scrollDistance - offset) % _effectiveSpeed;
        await _scrollController!.animateTo(offset,
            duration: Duration(milliseconds: 1000 - time),
            curve: Curves.linear);
      }
    });
  }

  void _step() {
    var step = 0;
    var offset = 0.0;
    _timer = Timer.periodic(Duration(milliseconds: _effectiveInterval), (timer) {
      var time = (_effectiveHeight / _effectiveSpeed * 1000).round();
      if (step >= _content.length) {
        step = 0;
        offset = 0;
        _scrollController!.jumpTo(0);
      }
      step++;
      offset += _effectiveHeight;
      _scrollController!.animateTo(offset,
          duration: Duration(milliseconds: time), curve: Curves.linear);
    });
  }

  /// 获取文本内容尺寸消息
  Size _getFontSize() {
    var text = _content;
    if (_content is List<String>) {
      text = _content[0];
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: _resolved.textStyle,
      ),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
      maxLines: _effectiveMarquee == true ? 1 : widget.maxLines,
    )..layout(maxWidth: _size!.width);
    return textPainter.size;
  }

  /// 获取文本内容宽度
  double _getContextWidth() {
    var contextWidth =
        _key.currentContext?.findRenderObject()?.paintBounds.size.width ?? 0;
    if (contextWidth == 0) {
      contextWidth = _getFontSize().width;
    }
    return contextWidth;
  }

  /// 获取滚动区域宽度
  double _getEmptyWidth() {
    return _contentKey.currentContext
            ?.findRenderObject()
            ?.paintBounds
            .size
            .width ??
        (_size!.width - _effectivePadding.horizontal);
  }

  /// 获取文字高度
  double _getTextHeight() {
    return _getFontSize().height;
  }

  /// 内容区域
  Widget _contentWidget() {
    Widget? textWidget;

    String? displayText;
    if (_content is String) {
      displayText = _content as String;
    } else if (_content is List<String> && _content.isNotEmpty) {
      displayText = _content[0];
    }

    if (displayText != null) {
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TText(
            displayText,
            style: _resolved.textStyle,
            maxLines: _effectiveMarquee == true ? 1 : widget.maxLines,
            forceVerticalCenter: true,
          ),
        ),
      );
    } else {
      textWidget = const SizedBox.shrink();
    }

    if (_effectiveMarquee != true) {
      return textWidget;
    }

    Widget? child;
    switch (widget.direction) {
      case Axis.horizontal:
        final emptyWidth = _getEmptyWidth();
        final textHeight = _getTextHeight();
        final contextWidth = _getContextWidth();

        child = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(
                key: _key,
                height: textHeight,
                child: textWidget,
              ),
              SizedBox(width: emptyWidth),
              SizedBox(
                width: math.max(emptyWidth, contextWidth),
                height: textHeight,
                child: textWidget,
              )
            ],
          ),
        );
        break;
      case Axis.vertical:
        var content = _content as List<String>;
        child = SizedBox(
          height: _effectiveHeight,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < content.length; i++)
                    SizedBox(
                      height: _effectiveHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TText(
                          content[i],
                          style: _resolved.textStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  SizedBox(
                    key: _key,
                    height: _effectiveHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TText(
                        content[0],
                        style: _resolved.textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ]),
          ),
        );
        break;
      default:
        child = textWidget;
        break;
    }
    return child;
  }

  void _onTap(trigger) {
    if (widget.onPressed != null) {
      widget.onPressed!(trigger);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    _size = MediaQuery.of(context).size;
    final prefixIcon = _theme.prefixIcon;
    final suffixIcon = _theme.suffixIcon;
    return Container(
      padding: _effectivePadding,
      color: _resolved.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// 左侧widget
          if (widget.left != null)
            widget.left!
          else if (prefixIcon != null)
            GestureDetector(
              onTap: () => _onTap('prefix-icon'),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  prefixIcon,
                  color: _resolved.leftIconColor,
                  size: _effectiveHeight,
                ),
              ),
            ),

          /// 中间内容
          Expanded(
            key: _contentKey,
            child: GestureDetector(
              onTap: () => _onTap('context'),
              child: _contentWidget(),
            ),
          ),

          /// 右侧widget
          if (widget.right != null)
            widget.right!
          else if (suffixIcon != null)
            GestureDetector(
                onTap: () => _onTap('suffix-icon'),
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Icon(
                    suffixIcon,
                    color: _resolved.rightIconColor,
                    size: _effectiveHeight,
                  ),
                )),
        ],
      ),
    );
  }
}
