import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:studygether/pages/ChatPage.dart';
import 'package:studygether/service/database_service.dart';

class NotificationService {
  final databaseService=DatabaseService();
  static const key =
      "AAAAhN3VGz0:APA91bE7KWZp0hVxbNkmqBzqO5T0BXsnN_ibb3iEiksjtnbEcv6zSZlk71XfHHz9zX6Pd-rjsBjKZHJMmQL1yhMo3S41qnjgVylbYKD2SeYwCPBjFCp71x9x8K7LghlVgolzC8Kbvjfp";

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestCriticalPermission: true,
        requestSoundPermission: true);
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint(response.payload.toString());
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
        'com.example.studygether', 'mychannelid',
        importance: Importance.max,
        styleInformation: styleInformation,
        priority: Priority.max);
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );
    final notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data['body']);
  }

  Future<void> requestPermission() async {
    final messaging=FirebaseMessaging.instance;
    final settings= await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus==AuthorizationStatus.authorized) {
      debugPrint('User granted Permission');
      
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      debugPrint('User granted provisional permission');
    }else{
      debugPrint(
        'User declined or has not accepted permission'
      );
    }


  }
  Future<void> _saveToken(String token) async=>
      await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({'token':token},SetOptions(merge: true));
    
    Future<void> getToken() async{
      final token=await FirebaseMessaging.instance.getToken(); 
      _saveToken(token!);

    }

List<String> receiverTokens = [];

    Future<void> getRecieverTokens(String?groupId) async{
      print(databaseService.getGroupUsers(groupId));
      print(receiverTokens);
    }
 void firebaseNotification(context) {
    _initLocalNotification();

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {
          
    });

    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });
  }


   Future<void> sendNotification(
      {required String body,
      required String senderId,
      required String groupId}) async {
    try {
      getRecieverTokens(senderId);
      receiverTokens.map((receiverToken) => {
        debugPrint("selam"),
       http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(<String, dynamic>{
          "to": receiverToken,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': body,
            'title': 'New Message !',
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': senderId,
          }
        }),
      )

      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

