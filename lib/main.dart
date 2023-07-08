import 'package:crud/screens/homepage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      home: Homepage(),
    ),
  );
}
