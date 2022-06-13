// https://docs.flutter.dev/cookbook/networking/fetch-data
// https://docs.flutter.dev/cookbook/persistence/key-value

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

class UserWebService extends StatefulWidget {
  const UserWebService({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<UserWebService> {
  TextEditingController inputId = TextEditingController();
  TextEditingController inputName = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputGender = TextEditingController();
  TextEditingController inputStatus = TextEditingController();

  @override
  void initState() {
    super.initState();
    setInitialTextValues();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch User Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch User Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                createTextField('id'),
                createTextField('name'),
                createTextField('email'),
                createTextField('gender'),
                createTextField('status'),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        getOnClickHandler();
                      });
                    },
                    child: const Text('Get')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        postOnClickHandler();
                      });
                    },
                    child: const Text('Post')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        deleteOnClickHandler();
                      });
                    },
                    child: const Text('Delete')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        putOnClickHandler();
                      });
                    },
                    child: const Text('Put')),
              ]),
        ),
      ),
    );
  }

  TextField createTextField(identifier) {
    return TextField(
      controller: getTextController(identifier),
      decoration: getDefaultInputDecoration(identifier),
      onChanged: (value) {
        setState(() {
          saveData(identifier, value);
        });
      },
    );
  }

  InputDecoration getDefaultInputDecoration(identifier) {
    String s = identifier.toString();
    return InputDecoration(
      labelText: s[0].toUpperCase() + s.substring(1),
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding:
          const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
    );
  }

  TextEditingController? getTextController(identifier) {
    switch (identifier) {
      case 'id':
        return inputId;
      case 'name':
        return inputName;
      case 'email':
        return inputEmail;
      case 'gender':
        return inputGender;
      case 'status':
        return inputStatus;
      default:
        return TextEditingController();
    }
  }

  setInitialTextValues() {
    getData('userId').then((data) {
      inputId.text = data;
    });
    getData('userName').then((data) {
      inputName.text = data;
    });
    getData('userEmail').then((data) {
      inputEmail.text = data;
    });
    getData('userGender').then((data) {
      inputGender.text = data;
    });
    getData('userStatus').then((data) {
      inputStatus.text = data;
    });
  }

  getOnClickHandler() {
    User.get(inputId.text).then((user) => {
          if (user.runtimeType == User)
            {syncInputs(user), saveInputs(user)}
          else
            {showAlert("User not found.")}
        });
  }

  postOnClickHandler() {
    User user = User(
        id: 01,
        name: inputName.text,
        email: inputEmail.text,
        gender: inputGender.text,
        status: inputStatus.text);
    User.post(user).then((response) => {showAlert(response), saveInputs(user)});
  }

  deleteOnClickHandler() {
    User.delete(inputId.text).then((response) => {
          {showAlert(response), clearData()}
        });
  }

  putOnClickHandler() {
    User user = User(
        id: int.parse(inputId.text),
        name: inputName.text,
        email: inputEmail.text,
        gender: inputGender.text,
        status: inputStatus.text);
    User.put(user).then((response) => {showAlert(response), saveInputs(user)});
  }

  void showAlert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text(message));
      },
    );
  }

  syncInputs(user) {
    inputId.text = user.id.toString();
    inputName.text = user.name;
    inputEmail.text = user.email;
    inputGender.text = user.gender;
    inputStatus.text = user.status;
  }

  saveInputs(user) {
    saveData('userId', user.id.toString());
    saveData('userName', user.name);
    saveData('userEmail', user.email);
    saveData('userGender', user.gender);
    saveData('userStatus', user.status);
  }

  clearData() {
    inputId.text = "";
    inputName.text = "";
    inputEmail.text = "";
    inputGender.text = "";
    inputStatus.text = "";

    saveData('userId', "");
    saveData('userName', "");
    saveData('userEmail', "");
    saveData('userGender', "");
    saveData('userStatus', "");
  }

  Future<String> getData(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "notfound";
  }

  saveData(key, data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }

  removeData(key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
