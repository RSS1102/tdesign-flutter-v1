import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarOutlinePage演示
///
class TSideBarOutlinePage extends StatefulWidget {
  const TSideBarOutlinePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarOutlinePageState();
  }
}

class TSideBarOutlinePageState extends State<TSideBarOutlinePage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  static const threshold = 50;
  var lock = false;

  @override
  void initState() {
    super.initState();

    _demoScroller.addListener(() {
      if (lock) {
        return;
      }

      var scrollTop = _demoScroller.offset;
      var index = (scrollTop + threshold) ~/ itemHeight;

      if (currentValue != index) {
        setState(() {
          currentValue = index;
        });
      }
    });
  }

  Future<void> handleSidebarChange(int value) async {
    if (currentValue != value) {
      setState(() {
        currentValue = value;
      });

      lock = true;
      await _demoScroller.animateTo(value.toDouble() * itemHeight,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      lock = false;
    }
  }

  void onChanged(int value) {
    setState(() {
      currentValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: 'SideBar 非通栏选项样式',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildOutlineSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildOutlineSideBar(BuildContext context) {
    // 非通栏选项样式
    final list = <TSideBarItem>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(TSideBarItem(
        label: '选项${i}',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: BoxDecoration(color: context.tTheme.bgColorContainer),
    ));

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

    return Row(
      children: [
        SizedBox(
          width: 106,
          child: TSideBar(
            style: TSideBarVariant.outline,
            value: currentValue,
            children: list
                .map((ele) => TSideBarItem(
                    label: ele.label,
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: handleSidebarChange,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        )
      ],
    );
  }

  Widget getAnchorDemo(int index) {
    return Container(
      decoration: BoxDecoration(color: context.tTheme.bgColorContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
            child: TText('标题 $index',
                style: const TextStyle(
                  fontSize: 14,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: displayImageList(),
          ),
        ],
      ),
    );
  }

  Widget displayImageList() {
    return Column(
      children: [
        displayImageItem(),
        const TDivider(),
        displayImageItem(),
        const TDivider(),
        displayImageItem(),
        const TDivider(),
      ],
    );
  }

  Widget displayImageItem() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        // spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TImage(
            src: 'assets/img/empty.png',
            variant: TImageVariant.roundedSquare,
          ),
          SizedBox(width: 16),
          TText('标题', style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
