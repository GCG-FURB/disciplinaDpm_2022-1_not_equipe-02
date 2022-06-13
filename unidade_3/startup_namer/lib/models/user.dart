import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:async';

class User {
  final int id;
  final String name;
  final String email;
  final String gender;
  final String status;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  static Future<Object> get(id) async {
    final response = await http
        .get(Uri.parse('https://gorest.co.in/public/v2/users/' + id), headers: {
      "Authorization":
          "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9"
    });
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  static Future<String> post(User user) async {
    final response = await http.post(
        Uri.parse('https://gorest.co.in/public/v2/users'),
        body: jsonEncode(user.toJson()),
        headers: {
          "Authorization":
              "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 201) {
      return "Created: " +
          User.fromJson(jsonDecode(response.body)).id.toString();
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  static Future<String> delete(id) async {
    final response = await http
        .delete(Uri.parse('https://gorest.co.in/public/v2/users/' + id), headers: {
      "Authorization":
          "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9"
    });
    if (response.statusCode == 204) {
      return "Deleted";
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  static Future<String> put(User user) async {
    final response = await http.put(
        Uri.parse('https://gorest.co.in/public/v2/users/' + user.id.toString()),
        body: user.toJson(),
        headers: {
          "Authorization":
              "Bearer f5626862b7e18f7780ae9bd504e9082e4b51c6600ac228d201b1cc51ab2394c9"
        });
    if (response.statusCode == 200) {
      return "Updated: " +
          User.fromJson(jsonDecode(response.body)).id.toString();
    } else {
      return "Response: " + response.statusCode.toString();
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
        'email': email,
        'gender': gender,
        'status': status
      };
}
