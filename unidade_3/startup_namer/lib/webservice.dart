// https://docs.flutter.dev/cookbook/navigation/named-routes

import 'package:flutter/material.dart';

class WebService extends StatelessWidget {
  const WebService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webservice'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            createButton(context, "User", "/user"),
            createButton(context, "Todo", "/todo"),
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
