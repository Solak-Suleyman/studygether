import 'dart:async';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:studygether/helper/helper_function.dart';
import 'package:studygether/service/auth_service.dart';
import 'package:studygether/service/firebase_storage_service.dart';

class DatabaseService {
  final String? uid;
  AuthService authService = AuthService();

  DatabaseService({this.uid});

  // reference for collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "about": "",
      "uid": uid,
    });
  }

  Future editUserImage(String uid, Uint8List file) async {
    try {
      final formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      final storagePath = 'users/$uid/$formattedDate';
      print(storagePath);

      final image = await FirebaseStorageService.uploadImage(file, storagePath);

      userCollection.doc(uid).update({"profilePic": image});
      return image;
    } catch (e) {
      // Handle the exception
      print("Failed to upload image: $e");
    }
  }

  // edit user data for profile page
  Future editUserData(String value, String col) async {
    if (value == "") {
      return "";
    } else {
      await userCollection.doc(uid).update({
        col: value,
      });
      if (col == "fullName") {
        HelperFunctions.saveUserNameSF(value);
      }
      if (col == "email") {
        authService.updateUserEmail(value);
        HelperFunctions.saveUserEmailSF(value);
      }
    }
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future getProfilePic(String uid) async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['profilePic'];
  }

  Future getUserAbout(String uid) async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['about'];
  }
  Future getGroupInfo(String groupId) async{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await d.get();
    Map<String,String> recentMessage={
      "recentMessage" :documentSnapshot['recentMessage'],
      "recentMessageSender":documentSnapshot['recentMessageSender']
    };
    return recentMessage ;
  }
  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  getAllGroups() async {
    return groupCollection.snapshots();
  }

  // Creating a group
  Future createGroup(String userName, String id, String groupName,
      bool isPrivate, String password) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "isPrivate": isPrivate,
      "password": password,
    });

    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getTokens(String uid) async {
    if (uid != FirebaseAuth.instance.currentUser!.uid) {
      DocumentReference d = userCollection.doc(uid);
      DocumentSnapshot documentSnapshot = await d.get();
      return documentSnapshot['token'];
    }
    return "boş";
  }

  Future getGroupUsers(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['members'];
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search group
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool is user in the group
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has group -> then remove or rejoin
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  Future joinTheGroup(String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    //DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    //List<dynamic> groups = await documentSnapshot['groups'];

    // if user has group -> then remove or rejoin
    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"])
    });
  }

  Future leftTheGroup(String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    //DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    //List<dynamic> groups = await documentSnapshot['groups'];

    // if user has group -> then remove or rejoin
    await userDocumentReference.update({
      "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
    });
    await groupDocumentReference.update({
      "members": FieldValue.arrayRemove(["${uid}_$userName"])
    });
  }

  sendTextMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString()
    });
  }

  sendImageMessage(String groupId, Map<String, dynamic> chatMessageData,
      Uint8List file) async {
    try {
      final formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      final storagePath = 'groups/$groupId/$formattedDate';
      final image = await FirebaseStorageService.uploadImage(file, storagePath);

      chatMessageData["message"] = image;

      groupCollection.doc(groupId).collection("messages").add(chatMessageData);
      groupCollection.doc(groupId).update({
        "recentMessage": "IMAGE",
        "recentMessageSender": chatMessageData['sender'],
        "recentMessageTime": chatMessageData['time'].toString()
      });
    } catch (e) {
      // Handle the exception
      print("Failed to upload image: $e");
    }
  }

  // get recent sender
  Future getLastMessageInfo(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return {
      "recentMessage": documentSnapshot["recentMessage"],
      "recentMessageSender": documentSnapshot["recentMessageSender"],
    };
  }
}
