import 'dart:typed_data';

//import 'package:studygether/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:studygether/pages/GroupInfo.dart';
import 'package:studygether/pages/HomePage.dart';
import 'package:studygether/service/auth_service.dart';
import 'package:studygether/service/database_service.dart';
import 'package:studygether/service/media_service.dart';
import 'package:studygether/service/notification_service.dart';
import 'package:studygether/widgets/appbar.dart';
//import 'package:studygether/widgets/widgets.dart';
//import 'package:studygether/widgets/appbar.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:studygether/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studygether/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {required this.groupId, required this.groupName, required this.userName});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final notificationsService = NotificationService();

  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  Uint8List? file;
  late ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = ScrollController();

    super.initState();
    getChatAndAdmin();
    notificationsService.firebaseNotification(context);
  }

  @override
  void dispose() {
    //_textEditingController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  scrollListToEnd() {
    _listScrollController
        .jumpTo(_listScrollController.position.maxScrollExtent + 90);
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      admin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 10,
        title: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container( 
              decoration: BoxDecoration(color: Colors.grey),
              width: 55,
              height: 55,
              alignment: AlignmentDirectional.center,
              child:Text(widget.groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 40,
                  color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
            ),)
          ),
          Text(widget.groupName),
          ]

        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      adminName: admin,
                    ));
              },
              icon: const Icon(Icons.info))
        ],
        
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          SizedBox(
            height: double.infinity,
            child: chatMessages(),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  onEditingComplete: () {
                    sendTextMessage();
                  },
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendTextMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendImageMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    )),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                controller: _listScrollController,
                itemCount: snapshot.data.docs.length,
                padding: EdgeInsets.only(bottom: 90),
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      isImage: snapshot.data.docs[index]['isImage'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container(
                child: Text("<NO MESSAGE>"),
              );
      },
    );
  }

  sendTextMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "isImage": false,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendTextMessage(widget.groupId, chatMessageMap);

      await notificationsService.sendNotification(
        body: messageController.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        groupId: widget.groupId,
      );
      setState(() {
        scrollListToEnd();
        messageController.clear();
      });
    }
  }

  Future<void> sendImageMessage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      Map<String, dynamic> chatMessageMap = {
        "message": "",
        "isImage": true,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendImageMessage(widget.groupId, chatMessageMap, file!);
      await notificationsService.sendNotification(
        body: messageController.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        groupId: widget.groupId,
      );
      scrollListToEnd();
    }
  }
}
