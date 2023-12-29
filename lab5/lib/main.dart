import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab3/log-in/welcome_screen.dart';

Future main() async {
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(channelKey: "basic_channel",
            channelName: "Basic notifications",
            channelDescription: "Basic notifications channel",
        channelGroupKey: "basic_channel_group",
        importance: NotificationImportance.Max,)
      ],
  channelGroups: [
      NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "Basic group")
      ]);
  bool isAllowedToSendNotifications = await AwesomeNotifications().isNotificationAllowed();
  if (isAllowedToSendNotifications){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDLXQ-WMUqDWu_3aN_KfQw_vh3bvs8ojZs",
      appId: "1:595819926407:android:a01f71e62e29ceaf09f922",
      messagingSenderId: "595819926407",
      projectId: "mishw-1dd22",
    )) : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}