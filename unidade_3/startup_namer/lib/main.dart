// https://docs.flutter.dev/cookbook/navigation/named-routes

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/helloworld.dart';
import 'package:startup_namer/map.dart';
import 'package:startup_namer/notification.dart';
import 'package:startup_namer/social.dart';
import 'package:startup_namer/todowebservice.dart';
import 'package:startup_namer/userwebservice.dart';

import 'bluetooth.dart';
import 'camera.dart';
import 'gyro.dart';
import 'webservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      'resource://drawable/notification_icon',
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: 'basic',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
        ),

      ]
  );

  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/hello_world': (context) => const HelloWorld(),
        '/camera': (context) => TakePictureScreen(camera: firstCamera),
        '/map': (context) => MapScreen(),
        '/gyro': (context) => const Gyro(),
        '/webservice': (context) => const WebService(),
        '/user': (context) => const UserWebService(),
        '/todo': (context) => const TodoWebService(),
        '/bluetooth': (context) => FlutterBlueApp(),
        '/notification': (context) => NotificationScreen(),
        '/social': (context) => Social(),
      },
    ),
  );
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabalho 03'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            createButton(context, "Hello World", "/hello_world"),
            createButton(context, "Camera", "/camera"),
            createButton(context, "Map", "/map"),
            createButton(context, "Gyroscope", "/gyro"),
            createButton(context, "Webservice", "/webservice"),
            createButton(context, "Bluetooth", "/bluetooth"),
            createButton(context, "Notification", "/notification"),
            createButton(context, "Social Media", "/social"),
          ]),
    );
  }

  ElevatedButton createButton(context, text, route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(text),
    );
  }
}
