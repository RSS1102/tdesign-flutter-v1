import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import 't_empty_theme_data.dart';

/// 空态形态
enum TEmptyVariant { plain, operation }

class TEmpty extends StatelessWidget {
  const TEmpty({
    this.variant = TEmptyVariant.plain,
    this.icon = TIcons.info_circle_filled,
    this.image,
    this.emptyText,
    this.operationText,
    this.onPressed,
    this.customOperationWidget,
    Key? key,
  }) : super(key: key);

  /// 空态形态
  final TEmptyVariant variant;

  /// 图标
  final IconData? icon;

  /// 展示图片
  final Widget? image;

  /// 描述文字
  final String? emptyText;

  /// 操作按钮文案
  final String? operationText;

  /// 点击事件
  final VoidCallback? onPressed;

  /// 自定义操作按钮
  final Widget? customOperationWidget;

  /// 从 Theme 子树读取 L4 默认值
  TEmptyThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TEmptyThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final emptyTextColor = theme?.emptyTextColor;
    final emptyTextFont = theme?.emptyTextFont;
    final operationTheme = theme?.operationTheme ?? TButtonColorScheme.primary;

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ??
              Icon(
                icon ?? TIcons.info_circle_filled,
                size: 96,
                color: TTheme.of(context).textColorPlaceholder,
              ),
          Padding(padding: EdgeInsets.only(top: image == null ? 22 : 16)),
          TText(
            emptyText ?? '',
            fontWeight: FontWeight.w400,
            font: emptyTextFont ?? TTheme.of(context).fontBodyMedium,
            textColor: emptyTextColor ?? TTheme.of(context).textColorPlaceholder,
          ),
          (variant == TEmptyVariant.operation)
              ? customOperationWidget ??
                  Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: TButton(
                        child: Text(operationText ?? ''),
                        size: TButtonSize.large,
                        colorScheme: operationTheme,
                        onPressed: onPressed,
                      ))
              : Container()
        ],
      ),
    );
  }
}
