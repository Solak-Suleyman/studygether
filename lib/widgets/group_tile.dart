//import 'package:studygether/helper/helper_function.dart';
//import 'package:studygether/pages/LoginPage.dart';
//import 'package:studygether/pages/HomePage.dart';
//import 'package:studygether/pages/ProfilePage.dart';
import 'package:studygether/pages/ChatPage.dart';
import 'package:studygether/service/database_service.dart';
//import 'package:studygether/service/auth_service.dart';
//import 'package:studygether/service/database_service.dart';
import 'package:studygether/widgets/widgets.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  DatabaseService _databaseService = DatabaseService();
  //Map<String,String> recentMessage={};
  String sent="";
  String sender="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecentMessage();
    /* DatabaseService().getLastMessageInfo(widget.groupId); */ /*  */
  }
  getRecentMessage(){
    _databaseService.getGroupInfo(widget.groupId).then((value) =>setState(() {
      sent=value["recentMessage"];
      sender=value["recentMessageSender"];
    })
);

    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
                groupId: widget.groupId,
                groupName: widget.groupName,
                userName: widget.userName));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey),
                width: 50,
                alignment: AlignmentDirectional.center,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              )),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            sender+": "+sent,
            style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
