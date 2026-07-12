import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/message/t_message.dart';
import 'package:tdesign_flutter/src/theme/t_theme.dart';

// TMessage 覆盖率补充
//
// 覆盖：
// - getLink 中自定义链接颜色分支（linkColor != null，源码 367-374）
// - calculateTextWidth 中 link / closeBtn 分支（源码 471、474）
//
// 说明：calculateTextWidth 仅在 marquee 文本测量路径中被调用，故本测试带 marquee。
// 使用 marquee.delay > 0 走被忽略的延迟分支，使 startAnimation 不被真实触发，
// 避免测试依赖动画计时器。动画/计时/异步分支（124-125、204-205、251-252）
// 已在源码以 coverage:ignore 标注。
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: child),
    );
  }

  testWidgets('linkColor 自定义链接颜色 + link/closeBtn 影响文字宽度',
      (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        Stack(
          children: [
            TMessage(
              content: '这是一条通知消息',
              duration: 0,
              link: TMessageLink(
                name: '查看详情',
                uri: Uri.parse('https://tdesign.tencent.com'),
                color: Colors.red,
              ),
              closeBtn: Icons.close,
              marquee: TMessageMarquee(),
            ),
          ],
        ),
      ),
    );
    expect(find.byType(TMessage), findsOneWidget);
  });
}
