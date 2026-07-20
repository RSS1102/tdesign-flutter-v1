import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarPaginationPage演示
///
class TSideBarPaginationPage extends StatefulWidget {
  const TSideBarPaginationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarPaginationPageState();
  }
}

class TSideBarPaginationPageState extends State<TSideBarPaginationPage> {
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
        title: 'SideBar 切页用法',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildPaginationSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildPaginationSideBar(BuildContext context) {
    // 切页用法
    final list = <TSideBarItem>[];
    final pages = <Widget>[];

    for (var i = 0; i < 100; i++) {
      list.add(TSideBarItem(
        label: '选项 ${i}',
        value: i,
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
                    icon: ele.icon))
                .toList(),
            onChanged: setCurrentValue,
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
      decoration: BoxDecoration(color: context.tTheme.bgColorContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spacing: 16,
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
    return Column(
      // spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TImage(
          src: 'assets/img/empty.png',
          variant: TImageVariant.roundedSquare,
        ),
        const SizedBox(height: 8),
        TText('$title', style: const TextStyle(fontSize: 12))
      ],
    );
  }
}
