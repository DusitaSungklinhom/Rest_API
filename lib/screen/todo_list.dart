import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_project_ii/screen/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo:item),
    );
    Navigator.push(context, route);
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  final String url = 'https://www.melivecode.com/api/users/delete';
  Future<void> deleteById(id) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User with ID = $id not found');
    } else {
      throw Exception('Failed to delete user');
    }
  }
  //   final uri = Uri.parse(url);
  //   final response = await http.delete(uri);
  //   if (response.statusCode == 200) {
  //     final filtered = items.where((element) => element['id'] != id).toList();
  //     setState(() {
  //       items = filtered;
  //     });
  //   } else {
  //     showErrorMessage('error'); // handle the error
  //   }
  // }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    final url = 'https://www.melivecode.com/api/users';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      final result = json as List;
      setState(() {
        items = result;
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("REST-API")),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item['id'];
              return ListTile(
                // leading: CircleAvatar(
                //   child: Text('${index + 1}'),
                // ),
                leading: CircleAvatar(
                  radius: 25,
                  child: Image.network(
                    item['avatar'].toString(),
                    // width: 1,
                    // height: 150,
                  ),
                ),
                title: Text(
                  item['fname'].toString() + '\t\t' + item['lname'].toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  item['username'].toString() +
                      '\n' +
                      'ID :' +
                      item['id'].toString(),
                ),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateToEditPage(item);
                    } else if (value == 'delete') {
                      deleteById(item['id'].toString());
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Edit'), value: 'edit'),
                      PopupMenuItem(
                        child: Text('delete'),
                        value: 'delete',
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text("Add")),
    );
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
