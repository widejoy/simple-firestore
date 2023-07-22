import 'package:flutter/widgets.dart';

class AppStateHandler with WidgetsBindingObserver {
  static bool isAppInForeground = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      isAppInForeground = true;
    } else {
      isAppInForeground = false;
    }
  }
}
