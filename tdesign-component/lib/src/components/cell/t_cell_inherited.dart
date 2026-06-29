import 'package:flutter/cupertino.dart';

import 't_cell_theme_data.dart';

class TCellInherited extends InheritedWidget {
  const TCellInherited({required Widget child, required this.style, Key? key})
      : super(child: child, key: key);

  final TCellThemeData style;

  @override
  bool updateShouldNotify(covariant TCellInherited oldWidget) {
    return true;
  }

  static TCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TCellInherited>();
  }
}
