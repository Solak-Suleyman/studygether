import 'dart:typed_data';

import 'package:studygether/helper/helper_function.dart';
import 'package:studygether/service/auth_service.dart';
import 'package:studygether/service/database_service.dart';
import 'package:studygether/service/media_service.dart';
import 'package:studygether/widgets/appbar.dart';
import 'package:studygether/widgets/widgets.dart';
import 'package:studygether/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studygether/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  Stream<QuerySnapshot>? chats; //bu olması lazım QuerySnapshot ne anlamadım
  TextEditingController messageController = TextEditingController();
  String admin = "";
  Uint8List? file;

  @override
  void initState() {
    super.initState();

    getChatAndAdmin();
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
      appBar: MyAppBar(
        appBar: AppBar(),
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
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
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: sendImageMessage,
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
                itemCount: snapshot.data.docs.length,
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

  sendTextMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "isImage": false,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendTextMessage(widget.groupId, chatMessageMap);
      setState(() {
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
    }
  }
}
