import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_todo/task_repository.dart';
class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/todos"),
    );
    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      log("Pobrano ${todos.length} zadań | Url: ${baseUrl}",
          name: "TaskApiService",
          error: response.statusCode);
      return todos.map((todo) {
        return Task(
          id: todo['id'].toString(),
          title: todo["todo"],
          daeadline: "brak",
          done: todo["completed"],
          priority: "średni",
        );
      }).toList();
    } else {
      log(
        "Nie udało się pobrać zadań",
        name: "TaskApiService",
        error: response.statusCode,
      );
      throw Exception("Błąd pobierania danych");


    }
  }
}
