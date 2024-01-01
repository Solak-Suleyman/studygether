import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:studygether/firebase_options.dart';
import 'package:studygether/helper/helper_function.dart';
import 'package:studygether/pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:studygether/pages/WelcomePage.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // initialize all widgets and firebase
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color customColor = Color(0xffF4CE14);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Use ColorScheme.fromSeed to generate a color scheme based on your custom color
        colorScheme: ColorScheme.fromSeed(
            seedColor: customColor, brightness: Brightness.light),

        // Customizing icon theme
        iconTheme: const IconThemeData(color: customColor),

        // Customizing other UI elements like AppBar, Buttons etc.
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black), // AppBar icons
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18), // AppBar title
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: customColor,
        ),
        primaryColor: customColor, // Primary color for the app
        hintColor: customColor, // Secondary color for the app
      ),
      home: _isSignedIn ? const HomePage() : const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
