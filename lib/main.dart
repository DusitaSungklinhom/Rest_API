import 'package:flutter/material.dart';
import 'package:my_project_ii/screen/todo_list.dart';


void main() {
  runApp(MyApp());
  // final file = File('/path/to/file.txt');
  // final contents = file.readAsStringSync();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TodoListPage(),
    );
  }
}