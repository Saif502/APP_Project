import 'package:QuickFix/pages/select_service.dart';
import 'package:QuickFix/pages/start.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:QuickFix/pages/home.dart';
import 'package:QuickFix/login_page.dart';
import 'package:QuickFix/register_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDJ0HmpzagLQnaNZQ96a6PkAV0wgJAQhSw',
      appId: '1:747193360827:android:f08b9f658f765c365b249e',
      messagingSenderId: '747193360827',
      projectId: 'quickfix-10675',
      databaseURL: 'https://quickfix-10675.firebaseio.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/start', // Set the initial route
      routes: {
        '/service': (context) => SelectService(),
        '/home': (context) => HomePage(),
        '/start': (context) => StartPage(),
        '/register': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(), // Define the home route
      },
    );
  }
}

