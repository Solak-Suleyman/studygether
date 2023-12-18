import 'package:flutter/material.dart';
import 'package:studygether/pages/LoginPage.dart';
import 'package:studygether/widgets/widgets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: AlignmentDirectional.topCenter,
            margin: const EdgeInsets.only(top: 100.0),
            child: Column(
              children: [
                Stack(
                  fit: StackFit.passthrough,
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Image.asset(
                      "lib/assets/images/image1.png",
                      fit: BoxFit.fitHeight,
                    ),
                    const Positioned(
                      top: 390,
                      child: Text(
                        'StudyGether Brings Students together',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    const Positioned(
                        top: 340,
                        child: Column(
                          children: [
                            Text(
                              'WELCOME',
                              style: TextStyle(
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF4CE14),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.fromLTRB(90, 20, 90, 20)),
                  child: const Text(
                    'Sign-up',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      nextScreen(context, const LoginPage());
                    },
                    child:const  Text(
                      "I have an account",
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ))
              ],
            ))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
