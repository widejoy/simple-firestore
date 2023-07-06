import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class deeplink {
  Future handledynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handledeeplink(data);
    FirebaseDynamicLinks.instance.onLink;
  }

  void _handledeeplink(PendingDynamicLinkData? data) {
    final Uri? deeplink = data?.link;
    if (deeplink != null) {}
  }
}
