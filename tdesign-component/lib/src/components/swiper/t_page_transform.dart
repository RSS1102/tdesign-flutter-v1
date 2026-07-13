import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/src/transformer_page_view/transformer_page_view.dart';

/// TD默认PageTransformer
class TPageTransformer extends PageTransformer {
  /// 缩放比例
  final double? scale;

  /// 淡化比例
  final double? fade;

  /// 左右间隔
  final double? margin;

  /// 普通margin的卡片式
  TPageTransformer.margin({this.margin = 6.0})
      : fade = 1,
        scale = 1;

  /// 缩放或透明的卡片式
  TPageTransformer.scaleAndFade({this.fade = 1, this.scale = 0.8})
      : margin = 0.0;

  TPageTransformer({this.fade, this.scale, this.margin});

  @override // coverage:ignore-line
  Widget transform(Widget item, TransformInfo info) {
    var position = info.position; // coverage:ignore-line
    var child = item;
    if (scale != null) { // coverage:ignore-line
      var scaleFactor = (1 - position.abs()) * (1 - scale!); // coverage:ignore-line
      var rawScale = scale! + scaleFactor; // coverage:ignore-line

      child = Transform.scale( // coverage:ignore-line
        scale: rawScale,
        child: item,
      );
    }

    if (fade != null) { // coverage:ignore-line
      var fadeFactor = (1 - position.abs()) * (1 - fade!); // coverage:ignore-line
      var opacity = fade! + fadeFactor; // coverage:ignore-line
      child = Opacity( // coverage:ignore-line
        opacity: opacity,
        child: child,
      );
    }
    if (margin != null) { // coverage:ignore-line
      child = Container( // coverage:ignore-line
        margin: EdgeInsets.only(left: margin!, right: margin!), // coverage:ignore-line
        child: child,
      );
    }
    return child;
  }
}
