import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController fnameControll = TextEditingController();
  TextEditingController lnameControll = TextEditingController();
  TextEditingController usernameControll = TextEditingController();
  TextEditingController passwordControll = TextEditingController();
  TextEditingController emailControll = TextEditingController();
  TextEditingController avatarControll = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit' : "Add"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: fnameControll,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: lnameControll,
            decoration: InputDecoration(hintText: 'Last name'),
          ),
          TextField(
            controller: usernameControll,
            decoration: InputDecoration(hintText: 'username'),
          ),
          TextField(
            controller: passwordControll,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'password',
              //border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: emailControll,
            decoration: InputDecoration(hintText: 'email'),
          ),
          TextField(
            controller: avatarControll,
            decoration: InputDecoration(hintText: 'image'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final url = Uri.parse('https://www.melivecode.com/api/users/update');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': widget.todo?['id'],
        'fname': fnameControll.text,
        'lname': lnameControll.text,
        'username': usernameControll.text,
        'password': passwordControll.text,
        'email': emailControll.text,
        'avatar': avatarControll.text,
      }),
    );

    if (response.statusCode == 200) {
      final userJson = jsonDecode(response.body)['user'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User with ID ${userJson['id']} is updated')),
      );
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User with ID ${widget.todo?['id']} not found')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user')),
      );
    }
  }

  Future<void> submitData() async {
    final fname = fnameControll.text;
    final lname = lnameControll.text;
    final username = usernameControll.text;
    final password = passwordControll.text;
    final email = emailControll.text;
    final avatar = avatarControll.text;
    final body = {
      "fname": fname,
      "lname": lname,
      "username": username,
      "password": password,
      "email": email,
      "avatar": avatar
    };
    final url = 'https://www.melivecode.com/api/users/create';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      fnameControll.text = '';
      lnameControll.text = '';
      usernameControll.text = '';
      passwordControll.text = '';
      emailControll.text = '';
      avatarControll.text = '';
      showSuccessMessage('Creation Success');
    } else {
      showErrorMessage('Creation Failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      backgroundColor: Color.fromRGBO(255, 0, 0, 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
