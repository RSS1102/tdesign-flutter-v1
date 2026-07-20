import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarCustomPage演示
///
class TSideBarCustomPage extends StatefulWidget {
  const TSideBarCustomPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarCustomPageState();
  }
}

class TSideBarCustomPageState extends State<TSideBarCustomPage> {
  var currentValue = 1;
  final _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: 'SideBar 自定义样式',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildCustomSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildCustomSideBar(BuildContext context) {
    // 自定义样式
    final list = <TSideBarItem>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(TSideBarItem(
        label: '选项 $i',
        value: i,
        textStyle: TextStyle(color: context.tTheme.brandLightColor),
      ));
      pages.add(getPageDemo(i));
    }

    list[1] = TSideBarItem(
      label: list[1].label,
      value: list[1].value,
      icon: list[1].icon,
      textStyle: list[1].textStyle,
      badge: const TBadge(variant: TBadgeVariant.dot),
    );
    list[2] = TSideBarItem(
      label: list[2].label,
      value: list[2].value,
      icon: list[2].icon,
      textStyle: list[2].textStyle,
      badge: const TBadge(count: 8),
    );
    list[1] = TSideBarItem(
      label: list[1].label,
      value: list[1].value,
      icon: list[1].icon,
      badge: list[1].badge,
      textStyle: const TextStyle(color: Colors.green),
    );

    void setCurrentValue(int value) {
      _pageController.jumpToPage(value);
      if (currentValue != value) {
        setState(() {
          currentValue = value;
        });
      }
    }

    return Row(
      children: [
        SizedBox(
          width: 106,
          child: TSideBar(
            style: TSideBarVariant.normal,
            value: currentValue,
            children: list
                .map((ele) => TSideBarItem(
                    label: ele.label,
                    badge: ele.badge,
                    value: ele.value,
                    textStyle: ele.textStyle,
                    icon: ele.icon))
                .toList(),
            selectedTextStyle: const TextStyle(color: Colors.red),
            onChanged: setCurrentValue,
            contentPadding:
                const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            selectedBgColor: Colors.blue,
            unSelectedBgColor: Colors.yellow,
          ),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: pages,
            physics: const NeverScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }

  Widget getPageDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
            child: TText('标题 $index', style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(height: 16),
          displayImageList()
        ],
      ),
    );
  }

  Widget getAnchorDemo(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 16,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 2, right: 9),
          child: TText('标题$index', style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 16),
        displayImageList()
      ],
    );
  }

  Widget displayImageList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(
          12,
          (index) => displayImageItem('${index}最多六个字'),
        ),
      ),
    );
  }

  Widget displayImageItem(String title) {
    return SizedBox(
      width: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TImage(
            src: 'assets/img/empty.png',
            variant: TImageVariant.roundedSquare,
          ),
          const SizedBox(height: 4),
          TText(title, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
