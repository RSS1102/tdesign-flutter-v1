import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart' show TSwipeCell;
import 't_swipe_cell.dart' show TSwipeCell;

/// TSwipeCell 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认滑动单元格样式。
/// 实例 TSwipeCell.themeData 优先于 Theme Extension。
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData> {
  /// 滑动组件的 Key
  final Key? slidableKey;

  /// 默认打开，[left, right]
  final List<bool>? opened;

  /// 组，配置后，[closeWhenOpened]、[closeWhenTapped]才起作用
  final Object? groupTag;

  /// 当同一组中的一个[TSwipeCell]打开时，是否关闭组中的所有其他[TSwipeCell]
  final bool? closeWhenOpened;

  /// 当同一组中的一个[TSwipeCell]被点击时，是否应该关闭组中的所有[TSwipeCell]
  final bool? closeWhenTapped;

  /// 处理拖动开始行为的方式
  final DragStartBehavior? dragStartBehavior;

  /// 打开关闭动画时长
  final Duration? duration;

  const TSwipeCellThemeData({
    this.slidableKey,
    this.opened,
    this.groupTag,
    this.closeWhenOpened,
    this.closeWhenTapped,
    this.dragStartBehavior,
    this.duration,
  });

  /// 合并两个 ThemeExtension，[other] 优先于 this
  TSwipeCellThemeData merge(TSwipeCellThemeData? other) {
    if (other == null) {
      return this;
    }
    return TSwipeCellThemeData(
      slidableKey: other.slidableKey ?? slidableKey,
      opened: other.opened ?? opened,
      groupTag: other.groupTag ?? groupTag,
      closeWhenOpened: other.closeWhenOpened ?? closeWhenOpened,
      closeWhenTapped: other.closeWhenTapped ?? closeWhenTapped,
      dragStartBehavior: other.dragStartBehavior ?? dragStartBehavior,
      duration: other.duration ?? duration,
    );
  }

  @override
  TSwipeCellThemeData copyWith({
    Key? slidableKey,
    List<bool>? opened,
    Object? groupTag,
    bool? closeWhenOpened,
    bool? closeWhenTapped,
    DragStartBehavior? dragStartBehavior,
    Duration? duration,
  }) {
    return TSwipeCellThemeData(
      slidableKey: slidableKey ?? this.slidableKey,
      opened: opened ?? this.opened,
      groupTag: groupTag ?? this.groupTag,
      closeWhenOpened: closeWhenOpened ?? this.closeWhenOpened,
      closeWhenTapped: closeWhenTapped ?? this.closeWhenTapped,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      duration: duration ?? this.duration,
    );
  }

  @override
  TSwipeCellThemeData lerp(ThemeExtension<TSwipeCellThemeData>? other, double t) {
    if (other is! TSwipeCellThemeData) {
      return this;
    }
    return TSwipeCellThemeData(
      slidableKey: t < 0.5 ? slidableKey : other.slidableKey,
      opened: t < 0.5 ? opened : other.opened,
      groupTag: t < 0.5 ? groupTag : other.groupTag,
      closeWhenOpened: t < 0.5 ? closeWhenOpened : other.closeWhenOpened,
      closeWhenTapped: t < 0.5 ? closeWhenTapped : other.closeWhenTapped,
      dragStartBehavior: t < 0.5 ? dragStartBehavior : other.dragStartBehavior,
      duration: t < 0.5 ? duration : other.duration,
    );
  }
}
