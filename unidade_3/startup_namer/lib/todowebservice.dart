// https://docs.flutter.dev/cookbook/networking/fetch-data
// https://docs.flutter.dev/cookbook/persistence/key-value

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/todo.dart';
import 'models/user.dart';

class TodoWebService extends StatefulWidget {
  const TodoWebService({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TodoWebService> {
  TextEditingController inputId = TextEditingController();
  TextEditingController inputUserId = TextEditingController();
  TextEditingController inputTitle = TextEditingController();
  TextEditingController inputDueOn = TextEditingController();
  TextEditingController inputStatus = TextEditingController();

  @override
  void initState() {
    super.initState();
    setInitialTextValues();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Todo Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Todo Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                createTextField('id'),
                createTextField('userId'),
                createTextField('title'),
                createTextField('dueOn'),
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
      case 'userId':
        return inputUserId;
      case 'title':
        return inputTitle;
      case 'dueOn':
        return inputDueOn;
      case 'status':
        return inputStatus;
      default:
        return TextEditingController();
    }
  }

  setInitialTextValues() {
    getData('todoId').then((data) {
      inputId.text = data;
    });
    getData('todoUserId').then((data) {
      inputUserId.text = data;
    });
    getData('todoTitle').then((data) {
      inputTitle.text = data;
    });
    getData('todoDueOn').then((data) {
      inputDueOn.text = data;
    });
    getData('todoStatus').then((data) {
      inputStatus.text = data;
    });
  }

  getOnClickHandler() {
    Todo.get(inputId.text).then((user) => {
          if (user.runtimeType == Todo)
            {syncInputs(user), saveInputs(user)}
          else
            {showAlert("Todo not found.")}
        });
  }

  postOnClickHandler() {
    Todo todo = Todo(
        id: 01,
        userId: int.parse(inputUserId.text),
        title: inputTitle.text,
        dueOn: inputDueOn.text,
        status: inputStatus.text);
    Todo.post(todo).then((response) => {showAlert(response), saveInputs(todo)});
  }

  deleteOnClickHandler() {
    Todo.delete(inputId.text).then((response) => {
          {showAlert(response), clearData()}
        });
  }

  putOnClickHandler() {
    Todo todo = Todo(
        id: int.parse(inputId.text),
        userId: int.parse(inputUserId.text),
        title: inputTitle.text,
        dueOn: inputDueOn.text,
        status: inputStatus.text);
    Todo.put(todo).then((response) => {showAlert(response), saveInputs(todo)});
  }

  void showAlert(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text(message));
      },
    );
  }

  syncInputs(todo) {
    inputId.text = todo.id.toString();
    inputUserId.text = todo.userId.toString();
    inputTitle.text = todo.title;
    inputDueOn.text = todo.dueOn;
    inputStatus.text = todo.status;
  }

  saveInputs(todo) {
    saveData('todoId', todo.id.toString());
    saveData('todoUserId', todo.userId.toString());
    saveData('todoTitle', todo.title);
    saveData('todoDueOn', todo.dueOn);
    saveData('todoStatus', todo.status);
  }

  clearData() {
    inputId.text = "";
    inputUserId.text = "";
    inputTitle.text = "";
    inputDueOn.text = "";
    inputStatus.text = "";

    saveData('todoId', "");
    saveData('todoUserId', "");
    saveData('todoTitle', "");
    saveData('todoDueOn', "");
    saveData('todoStatus', "");
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
