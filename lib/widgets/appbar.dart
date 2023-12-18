
import 'package:flutter/material.dart';
import 'package:studygether/helper/helper_function.dart';
import 'package:studygether/pages/ProfilePage.dart';
import 'package:studygether/pages/SearchPage.dart';

import 'package:studygether/widgets/widgets.dart';
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;
  const MyAppBar({super.key,required this.appBar});
  
  @override
  State<MyAppBar> createState() => _MyAppBarState();
  
@override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height*1.7);

}

class _MyAppBarState extends State<MyAppBar> {
    @override
  void initState() {
    super.initState();
    gettingUserData();
  }

     String userName = "";
    String email = "";

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

  }
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 10,
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.notifications_active))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,

              ),
              const SizedBox(height: 5,),
/*             IconButton(
              iconSize:55 ,
              onPressed: (){
                nextScreen(context, ProfilePage());
              },
              icon:Icon(Icons.account_circle_outlined,
  
              color: Colors.grey[700],)
            ),
 */            Text( 
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'work sans'),
            ),
          ]));
  }
}