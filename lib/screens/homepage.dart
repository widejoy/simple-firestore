import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/basicmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'home.dart';

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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

      if (clickAction == 'PAGE1') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const home()),
        );
      } else if (clickAction == 'PAGE2') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const homepage()),
        );
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

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
                          return const home();
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
                    builder: (context) => const home(),
                  ));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
