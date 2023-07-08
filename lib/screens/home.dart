import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/basicmodel.dart';

// ignore: camel_case_types
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController namecontrolller = TextEditingController();
    TextEditingController agecontroller = TextEditingController();
    TextEditingController birthdaycontroller = TextEditingController();
    Future createuser(String name, String age, String data) async {
      final docuser = FirebaseFirestore.instance.collection('data').doc();
      final user = User(id: docuser.id, name: name, age: age, birthday: data);
      final json = user.toJson();
      await docuser.set(json);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 160,
          ),
          TextField(
            decoration: const InputDecoration(prefixText: 'name:'),
            controller: namecontrolller,
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(prefixText: 'age:'),
            controller: agecontroller,
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(prefixText: 'birthday:'),
            controller: birthdaycontroller,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              final name = namecontrolller.text;
              final age = agecontroller.text;
              final birthday = birthdaycontroller.text;
              createuser(name, age, birthday);
              const SnackBar(
                content: Text('data added'),
                duration: Duration(seconds: 2),
              );
              Navigator.pop(context);
            },
            child: const Text('save items'),
          ),
        ],
      ),
    );
  }
}
