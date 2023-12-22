import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/dashboard/admin_screen.dart';
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
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 10, 0),
                      ),
                      Image.asset(
                        'assets/Scissors-image-remove.png',
                        width: 100,
                        height: 100,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminScreen()));
                        },
                        fillColor: Colors.brown[900],
                        constraints: BoxConstraints(maxHeight: 100),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Admin',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: .6,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 17.0)),
                    Text(
                      "Scissor's",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Services",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
