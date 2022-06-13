// https://www.fluttercampus.com/guide/273/add-action-button-on-local-notification-flutter/

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    AwesomeNotifications().actionStream.listen((action) {
      if(action.buttonKeyPressed == "open"){
        print("Open button is pressed");
      }else if(action.buttonKeyPressed == "delete"){
        print("Delete button is pressed.");
      }else{
        print(action.payload); //notification was pressed
      }
    });

    return MaterialApp(
        home: Home()
    );
  }
}

class Home extends  StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Notification in Flutter"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  bool isallowed = await AwesomeNotifications().isNotificationAllowed();
                  if (!isallowed) {
                    //no permission of local notification
                    AwesomeNotifications().requestPermissionToSendNotifications();
                  }else{
                    //show notification
                    AwesomeNotifications().createNotification(
                        content: NotificationContent( //simgple notification
                          id: 123,
                          channelKey: 'basic', //set configuration wuth key "basic"
                          title: 'Welcome to FlutterCampus.com',
                          body: 'This simple notification with action buttons in Flutter App',
                          payload: {"name":"FlutterCampus"},
                          autoDismissible: false,
                        ),

                        actionButtons: [
                          NotificationActionButton(
                            key: "open",
                            label: "Open File",
                          ),

                          NotificationActionButton(
                            key: "delete",
                            label: "Delete File",
                          )
                        ]
                    );
                  }
                },
                child: Text("Show Notification With Button")
            ),

          ],
        ),
      ),
    );
  }
}