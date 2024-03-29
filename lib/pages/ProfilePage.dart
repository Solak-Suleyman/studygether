import 'dart:typed_data';
import 'package:studygether/helper/helper_function.dart';
import 'package:studygether/pages/LoginPage.dart';
//import 'package:studygether/pages/HomePage.dart';
// import 'package:studygether/pages/search_page.dart';
import 'package:studygether/service/auth_service.dart';
import 'package:studygether/service/database_service.dart';
import 'package:studygether/widgets/bottomAppbBar.dart';
//import 'package:studygether/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studygether/service/media_service.dart';

//import 'package:cloud_firestore/cloud_fWirestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String userName = "";
  String email = "";
  String about = "";
  AuthService authService = AuthService();
  Stream? groups;
  String groupName = "";
  String searchQuery = "";
  Uint8List? file;
  String profilePic = "";
 
  callback(String newValue,String col){
    setState(() {
      if(col == "fullName"){userName = newValue;}
      if(col == "email"){email = newValue;}
      if(col == "about"){about = newValue;}
    });
  }
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    // getting list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });

    await DatabaseService().getUserAbout(uid).then((value) {
      about = value;
    });

    await DatabaseService().getProfilePic(uid).then((value) {
      profilePic = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 10,
          actions: [
            IconButton(
                onPressed: () {
                  // nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.notifications_active))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(""),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 6,
              // padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: [
                      profilePic != ""
                          ? CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: NetworkImage(profilePic))
                          : CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey.shade800,
                              ),
                            ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape:
                                    const CircleBorder(side: BorderSide.none)),
                            child: Icon(Icons.edit),
                            onPressed: () {
                              selectImage();
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SettingsItem(callback: this.callback, title: userName, col: "fullName"),
            SettingsItem(callback: this.callback, title: email, col: "email"),
            SettingsItem(callback: this.callback, title: about, col: "about"),
            const SizedBox(height: 10),
            InkWell(
              child: const Text(
                "Logout",
                textAlign: TextAlign.center,
              ),
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });
              },
            )
          ],
        ),
        bottomNavigationBar: const MyBottomAppBar());
  }

  Future<void> selectImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      //DatabaseService().editUserImage(uid, file!);
      DatabaseService().editUserImage(uid, file!).then((value) => setState(() {
            profilePic = value;
          }));
    }
  }
}

class SettingsItem extends StatefulWidget {
  final String title;
  final String col;
  final Function callback;
  const SettingsItem({required this.callback,required this.title, required this.col});

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  String temp = "";
  DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Edit"),
                content: TextFormField(
                  initialValue: widget.title,
                  onChanged: (value) {
                    setState(() {
                      temp = value;
                    });
                  },
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          databaseService.editUserData(temp, widget.col);
                          widget.callback(temp,widget.col);
                          Navigator.pop(context);
                          
                        });
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )),
                ],
              );
            });
      },
    );
  }
}
