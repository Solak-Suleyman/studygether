import 'package:studygether/helper/helper_function.dart';
import 'package:studygether/pages/LoginPage.dart';
import 'package:studygether/pages/HomePage.dart';
// import 'package:studygether/pages/search_page.dart';
import 'package:studygether/service/auth_service.dart';
import 'package:studygether/service/database_service.dart';
import 'package:studygether/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  String groupName = "";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
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
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    const HomePage(
                      //buranın içi ne amk
                    ));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title:
                  const Text("Groups", style: TextStyle(color: Colors.black)),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title:
                  const Text("Profile", style: TextStyle(color: Colors.black)),
            ),
            ListTile(
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title:
                  const Text("Logout", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          UserHeader(),
          SettingsItem(title: 'NAME'),
          SettingsItem(title: 'SURNAME'),
          SettingsItem(title: 'EMAIL ADDRESS'),
          SettingsItem(title: 'ABOUT'),
        ],
      ),
      bottomNavigationBar:
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Your Lessons"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined),label: "Setting")
          ] 
        ),

    );
  }
}
class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'General Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // Add more widgets for additional info if needed
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Handle edit action
            },
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;

  const SettingsItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle item tap
      },
    );
  }
}