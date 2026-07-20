import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarAnchorPage演示
///
class TSideBarAnchorPage extends StatefulWidget {
  const TSideBarAnchorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarAnchorPageState();
  }
}

class TSideBarAnchorPageState extends State<TSideBarAnchorPage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  var titleBarHeight = 44;
  var testButtonHeight = 80.0;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  static const threshold = 50;
  var lock = false;
  var list = <TSideBarItem>[];
  final pages = <Widget>[];

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

    for (var i = 0; i < 20; i++) {
      list.add(TSideBarItem(
        label: '选项$i',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    list[1] = TSideBarItem(
      label: list[1].label,
      value: list[1].value,
      icon: list[1].icon,
      textStyle: list[1].textStyle,
      badge: const TBadge(TBadgeVariant.redPoint),
    );
    list[2] = TSideBarItem(
      label: list[2].label,
      value: list[2].value,
      icon: list[2].icon,
      textStyle: list[2].textStyle,
      badge: const TBadge(TBadgeVariant.message, count: '8'),
    );

  }

  Future<void> handleSidebarChange(int value) async {
    if (currentValue == value) {
      return;
    }
    setState(() {
      currentValue = value;
    });

    lock = true;
    await _demoScroller.animateTo(
      value.toDouble() * itemHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    lock = false;
  }

  void onChanged(int value) {
    if (mounted) {
      setState(() {
        currentValue = value;
      });
    }
  }

  @override
  void dispose() {
    _demoScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'SideBar 锚点用法',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: CodeWrapper(
        isCenter: false,
        builder: _buildAnchorSideBar,
      ),
    );
  }

  @Demo(group: 'sideBar')
  Widget _buildAnchorSideBar(BuildContext context) {
    var demoHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        titleBarHeight -
        testButtonHeight;

    return Column(
      children: [
        Container(
          height: testButtonHeight,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: TButton(
              child: const Text('更新children'),
              onPressed: () {
                setState(() {
                  final children = list
                      .asMap()
                      .entries
                      .map((entry) => TSideBarItem(
                            label: '变更${entry.key}',
                            badge: entry.value.badge,
                            value: entry.value.value,
                            icon: entry.value.icon,
                          ))
                      .toList();
                  list = children;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 106,
                child: TSideBar(
                  style: TSideBarVariant.normal,
                  value: currentValue,
                        onChanged: handleSidebarChange,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    controller: _demoScroller,
                    child: Container(
                      color: context.tTheme.bgColorContainer,
                      child: Column(
                        children: [
                          ...pages,
                          Container(height: demoHeight - itemHeight)
                        ],
                      ),
                    )),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getAnchorDemo(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
          child: TText('标题$index',
              style: const TextStyle(
                fontSize: 14,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: displayImageList(),
        ),
      ],
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
        crossAxisAlignment: CrossAxisAlignment.center,
        // spacing: 16,
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
