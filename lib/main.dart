import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scissors_project/welcomescreen.dart';
import 'Screens/dashboard/admin_screen.dart';
import 'Screens/dashboard/dashboard.dart';
import 'Screens/homescreen/list_screen.dart';
import 'firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyC73yH176_UGNTzXgJKRiVHDTvE_GEWAtM',
          authDomain: "saloonprojet-4b216.firebaseapp.com",
          projectId: 'saloonprojet-4b216',
          storageBucket: "saloonprojet-4b216.appspot.com",
          messagingSenderId: '757222958410',
          appId: "1:757222958410:web:62390eae4de62a28744db3",
          measurementId: "G-RZ5JKRM2HW"),
    );
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    runApp(MyApp());
  } catch (e) {
    print('error initializing Firebase: $e');
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: TextTheme()),
      themeMode: ThemeMode.system,
      home: WelcomeScreen(),
    );
  }
}

