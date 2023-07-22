import 'package:crud/screens/home.dart';
import 'package:crud/screens/homepage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const Homepage(),
          );
        } else if (settings.name!.startsWith('/id')) {
          return MaterialPageRoute(
            builder: (context) => const Home(),
          );
        }
        return MaterialPageRoute(
          builder: (context) => const Homepage(),
        );
      },
    ),
  );
}
