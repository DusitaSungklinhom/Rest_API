import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateUserPage extends StatefulWidget {
  final int userId;

  UpdateUserPage({Key? key, required this.userId}) : super(key: key);

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final TextEditingController _lnameController = TextEditingController();

  Future<void> _updateUser() async {
    final url = Uri.parse('https://www.melivecode.com/api/users/update');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': widget.userId,
        'lname': _lnameController.text,
      }),
    );

    if (response.statusCode == 200) {
      final userJson = jsonDecode(response.body)['user'];
      final user = User.fromJson(userJson);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User with ID ${user.id} is updated')),
      );
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User with ID ${widget.userId} not found')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update User')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Name'),
            TextField(controller: _lnameController),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUser,
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final int id;
  final String fname;
  final String lname;
  final String username;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.username,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
