import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/basicmodel.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'home.dart';

// ignore: camel_case_types
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? _linkMessage;
  bool _isCreatingLink = false;
  final String DynamicLink = 'https://test-app/helloworld';
  final String Link = 'https://reactnativefirebase.page.link/bFkn';

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {});
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cruddomain.page.link',
      longDynamicLink: Uri.parse(
        'https://reactnativefirebase.page.link/?efr=0&ibi=io.invertase.testing&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Ftest-app%2Fhelloworld&ofl=https://ofl-example.com',
      ),
      link: Uri.parse(DynamicLink),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.crud',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('item');
    fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String clickAction = message.data['clickAction'];

      if (clickAction == 'page_2') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      } else if (clickAction == 'page_1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<User>> readusers() {
      return FirebaseFirestore.instance.collection('data').snapshots().map(
            (event) => event.docs
                .map(
                  (e) => User.fromjson(
                    e.data(),
                  ),
                )
                .toList(),
          );
    }

    return Scaffold(
      body: StreamBuilder(
        stream: readusers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
                children: users.map(
              (e) {
                return Dismissible(
                  key: ValueKey(e.id),
                  onDismissed: (direction) {
                    final deleteuser =
                        FirebaseFirestore.instance.collection('data').doc(e.id);
                    deleteuser.delete();
                  },
                  child: ListTile(
                    onTap: () {
                      final updateuser = FirebaseFirestore.instance
                          .collection('data')
                          .doc(e.id);
                      updateuser.delete();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const Home();
                        },
                      ));
                    },
                    leading: CircleAvatar(
                      child: Text(e.age.toString()),
                    ),
                    title: Text(e.name),
                    subtitle: Text(e.birthday),
                  ),
                );
              },
            ).toList());
          } else if (snapshot.hasError) {
            return const Text('something went wrong');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
