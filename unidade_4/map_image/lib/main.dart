import 'package:flutter/material.dart';
import 'package:map_image/picker.dart';

import 'gallery.dart';
import 'map.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/map': (context) => const MapScreen(),
        '/gallery': (context) => const Gallery(),
        '/picker': (context) => const Picker(),
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
        title: const Text('Trabalho 04'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // createButton(context, "Map", "/map"),
            createButton(context, "Gallery", "/gallery"),
            createButton(context, "Picker", "/picker"),
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
