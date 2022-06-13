import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:async';

class Todo {
  final int id;
  final int userId;
  final String title;
  final String dueOn;
  final String status;

  const Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.dueOn,
    required this.status,
  });

  static Future<Object> get(id) async {
    final response = await http
        .get(Uri.parse('https://gorest.co.in/public/v2/todos/' + id), headers: {
      "Authorization":
      "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9"
    });
    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  static Future<String> post(Todo todo) async {
    final response = await http.post(
        Uri.parse('https://gorest.co.in/public/v2/todos'),
        body: jsonEncode(todo.toJson()),
        headers: {
          "Authorization":
          "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 201) {
      return "Created: " +
          Todo.fromJson(jsonDecode(response.body)).id.toString();
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  static Future<String> delete(id) async {
    final response = await http
        .delete(Uri.parse('https://gorest.co.in/public/v2/todos/' + id), headers: {
      "Authorization":
      "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9"
    });
    if (response.statusCode == 204) {
      return "Deleted";
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  static Future<String> put(Todo todo) async {
    final response = await http.put(
        Uri.parse('https://gorest.co.in/public/v2/todos/' + todo.id.toString()),
        body: todo.toJson(),
        headers: {
          "Authorization":
          "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9"
        });
    if (response.statusCode == 200) {
      return "Updated: " +
          Todo.fromJson(jsonDecode(response.body)).id.toString();
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      dueOn: json['due_on'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'user_id': userId.toString(),
    'title': title,
    'due_on': dueOn,
    'status': status
  };

}

