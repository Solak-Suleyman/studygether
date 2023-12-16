import 'package:flutter/material.dart';


import 'package:studygether/pages/LoginPage.dart';

import 'pages/WelcomePage.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn=false;
  // This widget is the root of your application.
  @override
  // void initState() {
  //   super.initState();
  //   getUserLoggedInStatus();
  // }
  

  // getUserLoggedInStatus() async {
  //   await HelperFunctios.getUserLoggedInStatus().then((value) {
  //     if (value!=null) {
  //       setState(() {
  //         _isSignedIn=value;
  //       });
  //     }
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      home: _isSignedIn ?  WelcomePage(title: 'Flutter Demo Home Page'):LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
