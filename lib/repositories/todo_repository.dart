import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class TodoRepository {
  TodoRepository(){
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }
  late SharedPreferences sharedPreferences;

  void saveTodoList (List<Todo> todos) {
    final jsonString = jsonEncode(todos);
    sharedPreferences.setString('todo_list', jsonString);
  }

}