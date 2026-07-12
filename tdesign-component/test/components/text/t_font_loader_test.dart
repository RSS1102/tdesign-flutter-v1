import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TFontLoaderWidget] 的 build/initState，以及 [TFontLoader.load] 的异常分支。
///
/// 说明：真正的网络字体下载（FontLoader + NetworkAssetBundle）属平台/网络依赖，
/// 在测试环境不可达，标记为已知例外；本测试覆盖非网络路径与失败回退分支。
void main() {
  Widget wrap(Widget child) => Theme(
        data: ThemeData(extensions: [TThemeData.defaultData()]),
        child: MaterialApp(home: Scaffold(body: child)),
      );

  group('TFontLoader', () {
    test('load 传入非法 URL 进入 catch 分支并返回 false', () async {
      // 非法 URI 触发 Uri.parse 抛异常 -> 被 catch 捕获 -> 返回 false
      final result =
          await TFontLoader.load(name: 'bad', fontFamilyUrl: '::invalid::');
      expect(result, isFalse);
    });
  });

  group('TFontLoaderWidget', () {
    testWidgets('TText 设置 fontFamilyUrl 触发懒加载 Widget（不实际下载）',
        (tester) async {
      // fontFamily 为 null，loadFont 内部 if 为 false，跳过网络请求，仅构建
      await tester.pumpWidget(wrap(
        const TText('加载字体',
            fontFamilyUrl: 'http://example.com/font.ttf'),
      ));
      // 内部回退渲染出一个 TText
      expect(find.byType(TText), findsWidgets);
    });
  });
}
