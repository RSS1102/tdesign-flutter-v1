import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'image_widget.dart';
import 't_image_theme_data.dart';

/// 图片形态
enum TImageVariant {
  /// 裁剪
  clip,

  /// 适应高
  fitHeight,

  /// 适应宽
  fitWidth,

  /// 拉伸
  stretch,

  /// 方形
  square,

  /// 圆角方形
  roundedSquare,

  /// 圆形
  circle,
}

class TImage extends StatefulWidget {
  const TImage({
    this.src,
    Key? key,
    this.variant = TImageVariant.roundedSquare,
    this.errorWidget,
    this.loadingWidget,
    this.width,
    this.fit,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.filterQuality = FilterQuality.low,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.imageFile,
  }) : super(key: key);

  /// 图片地址（网络 URL 或本地 asset 路径）
  final String? src;

  /// 图片文件路径
  final File? imageFile;

  /// 图片形态
  final TImageVariant variant;

  /// 加载自定义提示
  final Widget? loadingWidget;

  /// 失败自定义提示
  final Widget? errorWidget;

  /// 自定义宽
  final double? width;

  /// 适配样式
  final BoxFit? fit;

  /// 以下系统 Image 属性，释义请参考系统 [Image] 中注释
  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final FilterQuality filterQuality;

  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final String? semanticLabel;

  @override
  State<StatefulWidget> createState() => _TImageState();
}

class _TImageState extends State<TImage> {
  /// 从 Theme 子树读取 L4 默认值
  TImageThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TImageThemeData>();

  /// 解析高度：实例无 height 参数，从 Theme 读取
  double get _height => _theme(context)?.height ?? 72;

  /// 解析宽度：实例 width 优先，否则 Theme 无 width 时取 72
  double get _width => widget.width ?? 72;

  /// 根据 variant 返回默认 BoxFit
  BoxFit _defaultFit(TImageVariant variant) {
    switch (variant) {
      case TImageVariant.clip:
        return BoxFit.none;
      case TImageVariant.fitHeight:
        return BoxFit.fitHeight;
      case TImageVariant.fitWidth:
        return BoxFit.fitWidth;
      case TImageVariant.stretch:
        return BoxFit.fill;
      case TImageVariant.square:
      case TImageVariant.roundedSquare:
      case TImageVariant.circle:
        return BoxFit.cover;
    }
  }

  /// 构建内部 ImageWidget（统一参数来源，消除重复代码）
  ImageWidget _buildImageWidget(BoxFit fit) {
    final theme = _theme(context);
    return widget.imageFile == null
        ? (widget.src == null || widget.src!.startsWith('http')
            ? ImageWidget.network(
                widget.src,
                height: _height,
                width: _width,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: fit,
                color: theme?.color,
                frameBuilder: widget.frameBuilder,
                loadingBuilder: widget.loadingBuilder,
                errorBuilder: widget.errorBuilder,
                semanticLabel: widget.semanticLabel,
                excludeFromSemantics: theme?.excludeFromSemantics ?? false,
                opacity: theme?.opacity,
                colorBlendMode: theme?.colorBlendMode,
                alignment: widget.alignment,
                repeat: widget.repeat,
                centerSlice: theme?.centerSlice,
                matchTextDirection: theme?.matchTextDirection ?? false,
                gaplessPlayback: theme?.gaplessPlayback ?? false,
                filterQuality: widget.filterQuality,
                isAntiAlias: theme?.isAntiAlias ?? false,
                cacheHeight: theme?.cacheHeight,
                cacheWidth: theme?.cacheWidth,
              )
            : ImageWidget.asset(
                widget.src!,
                width: _width,
                height: _height,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: fit,
                color: theme?.color,
                frameBuilder: widget.frameBuilder,
                errorBuilder: widget.errorBuilder,
                semanticLabel: widget.semanticLabel,
                excludeFromSemantics: theme?.excludeFromSemantics ?? false,
                opacity: theme?.opacity,
                colorBlendMode: theme?.colorBlendMode,
                alignment: widget.alignment,
                repeat: widget.repeat,
                centerSlice: theme?.centerSlice,
                matchTextDirection: theme?.matchTextDirection ?? false,
                gaplessPlayback: theme?.gaplessPlayback ?? false,
                filterQuality: widget.filterQuality,
                isAntiAlias: theme?.isAntiAlias ?? false,
                cacheHeight: theme?.cacheHeight,
                cacheWidth: theme?.cacheWidth,
              ))
        : ImageWidget.file(
            widget.imageFile,
            width: _width,
            height: _height,
            fit: fit,
            color: theme?.color,
            frameBuilder: widget.frameBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: theme?.excludeFromSemantics ?? false,
            colorBlendMode: theme?.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: theme?.centerSlice,
            matchTextDirection: theme?.matchTextDirection ?? false,
            gaplessPlayback: theme?.gaplessPlayback ?? false,
            filterQuality: widget.filterQuality,
            isAntiAlias: theme?.isAntiAlias ?? false,
            cacheWidth: theme?.cacheWidth,
            cacheHeight: theme?.cacheHeight,
          );
  }

  @override
  Widget build(BuildContext context) {
    final fit = widget.fit ?? _defaultFit(widget.variant);

    switch (widget.variant) {
      case TImageVariant.clip:
      case TImageVariant.fitHeight:
      case TImageVariant.fitWidth:
      case TImageVariant.square:
        return _buildImageWidget(fit);
      case TImageVariant.stretch:
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: _height, maxWidth: _width),
          child: _buildImageWidget(fit),
        );
      case TImageVariant.roundedSquare:
        return Container(
          height: _height,
          width: _width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(context.tTheme.radiusDefault)),
          child: _buildImageWidget(fit),
        );
      case TImageVariant.circle:
        return Container(
          height: _height,
          width: _width,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: _buildImageWidget(fit),
        );
    }
  }
}
