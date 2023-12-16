import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff45474B),
      appBar: AppBar(
        backgroundColor: const Color(0xff45474B),
        leading: IconButton(
          icon:const  Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const  Text(
          "Login",
          style: TextStyle(
              fontFamily: "roboto", fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: Column(children: <Widget>[
          Image.asset(
            "lib/assets/images/image1.png",
            scale: 2.5,
          ),
          SizedBox(height: MediaQuery.of(context).size.height/10,),
          const SizedBox(
            width: 340,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          const SizedBox(height: 20,),
          const SizedBox(
            width: 340,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
