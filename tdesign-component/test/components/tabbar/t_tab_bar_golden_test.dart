import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [TThemeData.defaultData()]),
      home: Scaffold(body: Center(child: child)),
    );
  }

  List<TTabBarItemConfig> textTabs() {
    return List.generate(
      4,
      (index) => TTabBarItemConfig(
        tabText: '标签${index + 1}',
        onTap: () {},
      ),
    );
  }

  testWidgets('TTabBar current API smoke rendering for visual baseline',
      (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TTabBar(
        variant: TTabBarVariant.text,
        value: 0,
        navigationTabs: textTabs(),
        onChanged: (_) {},
      ),
    ));

    expect(find.byType(TTabBar), findsOneWidget);
    expect(find.text('标签1'), findsOneWidget);
  });
}
