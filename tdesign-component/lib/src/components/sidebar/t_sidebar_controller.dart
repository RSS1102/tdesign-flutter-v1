import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TSideBarController extends ChangeNotifier {
  int _currentValue = 0;
  List<SideItemProps> _children = [];
  bool _loading = false;

  /// 当前选中值
  int get currentValue => _currentValue;

  /// 动态选项数据
  List<SideItemProps> get children => List.unmodifiable(_children);

  /// 是否加载中
  bool get loading => _loading;

  /// 更新加载态
  set loading(bool value) => setLoading(value);

  /// 更新动态选项数据
  set children(List<SideItemProps> value) => setChildren(value);

  /// 选中指定值
  void selectTo(int value) {
    if (_currentValue == value) {
      return;
    }
    _currentValue = value;
    notifyListeners();
  }

  /// 初始化动态选项数据
  void init(List<SideItemProps> data) {
    setChildren(data, needNotify: false);
    _loading = false;
    notifyListeners();
  }

  /// 更新动态选项数据
  void setChildren(List<SideItemProps> data, {bool needNotify = true}) {
    _children = List<SideItemProps>.of(data);
    if (needNotify) {
      notifyListeners();
    }
  }

  /// 更新加载态
  void setLoading(bool load, {bool needNotify = true}) {
    if (_loading == load) {
      return;
    }
    _loading = load;
    if (needNotify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _currentValue = 0;
    _children = [];
    _loading = false;
    super.dispose();
  }
}
