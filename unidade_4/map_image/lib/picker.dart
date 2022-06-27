import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:map_image/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Picker extends StatefulWidget {
  const Picker({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Picker> {
  late File result;

  String latitude = '';
  String longitude = '';

  @override
  void initState() {
    super.initState();
  }

  getMetadata() async {
    getFile().then((file) => {
          readMetadata(file).then((metadata) => {
                readExif(metadata).then((values) => {
                      setLatitude(values["GPS GPSLatitude"],
                          values["GPS GPSLatitudeRef"]),
                      setLongitude(values["GPS GPSLongitude"],
                          values["GPS GPSLongitudeRef"]),
                      Navigator.pushNamed(context, '/map',
                          arguments: ScreenArguments(
                              File(file!.path).readAsBytesSync()))
                    })
              })
        });
  }

  setLatitude(l, lRef) {
    var value = l.values.ratios[0].numerator;
    var decimalValue = (l.values.ratios[1].numerator / 60) +
        ((l.values.ratios[2].numerator / l.values.ratios[2].denominator) /
            3600);
    var finalValue = value + decimalValue;
    if ((lRef.printable) == "S") {
      finalValue = finalValue * -1;
    }
    saveData('latitude', finalValue);
  }

  setLongitude(l, lRef) {
    var value = l.values.ratios[0].numerator;
    var decimalValue = (l.values.ratios[1].numerator / 60) +
        ((l.values.ratios[2].numerator / l.values.ratios[2].denominator) /
            3600);
    var finalValue = value + decimalValue;
    if ((lRef.printable) == "W") {
      finalValue = finalValue * -1;
    }
    saveData('longitude', finalValue);
  }

  saveData(key, data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, data);
  }

  readExif(metadata) async {
    return readExifFromBytes(metadata);
  }

  Future<Uint8List> readMetadata(value) async {
    Uint8List result = File(value!.path).readAsBytesSync();
    readExifFromBytes(result).then((v) => {});
    return result;
  }

  Future<XFile?> getFile() async {
    final ImagePicker picker = ImagePicker();
    Future<XFile?> file = picker.pickImage(source: ImageSource.gallery);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trabalho 04'),
        ),
        body: Center(
            child: RaisedButton(
          onPressed: getMetadata,
          child: const Text("Get Image"),
        )),
      ),
    );
  }
}
