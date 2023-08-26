import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import '../models/basicmodel.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();

    Future<void> createUser(String name, String age, String data) async {
      final docUser = FirebaseFirestore.instance.collection('data').doc();
      final user = User(id: docUser.id, name: name, age: age, birthday: data);
      final json = user.toJson();
      await docUser.set(json);
    }

    void copyLink() async {
      await Clipboard.setData(
          const ClipboardData(text: "https://roger.bhagyaj.co.in/id"));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied'),
        ),
      );
    }

    void shareLink() {
      Share.share("Check out this link: https://roger.bhagyaj.co.in/id");
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 160),
          TextField(
            decoration: const InputDecoration(prefixText: 'Name:'),
            controller: nameController,
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(prefixText: 'Age:'),
            controller: ageController,
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(prefixText: 'Birthday:'),
            controller: birthdayController,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final age = ageController.text;
              final birthday = birthdayController.text;
              createUser(name, age, birthday);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data added'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save Items'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: copyLink,
            child: const Text('Copy Link'),
          ),
          ElevatedButton(
            onPressed: shareLink,
            child: const Text('Share Link'),
          ),
        ],
      ),
    );
  }
}
