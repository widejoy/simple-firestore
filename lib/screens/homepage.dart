import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/basicmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('item');
    fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String notificationId = message.data['notificationId'];

      if (notificationId == 'page_2') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('item has been deleted'),
            content: Text(message.notification?.body ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigatorKey.currentState?.push(
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text('add an item'),
              ),
            ],
          ),
        );
      } else if (notificationId == 'page_1') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message.notification?.title ?? ''),
            content: const Text('item has been added'),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String notificationId = message.data['notificationId'];

      if (notificationId == 'page_2') {
        _navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      } else if (notificationId == 'page_1') {
        _navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );
      }
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
                  (e) => User.fromjson(e.data()),
                )
                .toList(),
          );
    }

    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
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
                              final deleteuser = FirebaseFirestore.instance
                                  .collection('data')
                                  .doc(e.id);
                              deleteuser.delete();
                            },
                            child: ListTile(
                              onTap: () {
                                final updateuser = FirebaseFirestore.instance
                                    .collection('data')
                                    .doc(e.id);
                                updateuser.delete();
                                _navigatorKey.currentState?.push(
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                child: Text(e.age.toString()),
                              ),
                              title: Text(e.name),
                              subtitle: Text(e.birthday),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      _navigatorKey.currentState?.push(
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
