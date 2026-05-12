import 'package:hive_ce/hive.dart';
import '../task_repository.dart';
class TaskLocalDatabase {

  static Box get _box => Hive.box("tasks");
  static List<Task> getTasks() {

    return _box.values.map((item) {
      final Map<dynamic, dynamic> hiveMap = item as Map;

      final Map<String, dynamic> taskMap = hiveMap.map(
            (key, value) => MapEntry(key.toString(), value),
      );

      return Task.fromMap(taskMap);
    }).toList();
  }
  static Future<void> saveTasks(List<Task> tasks) async {
    await _box.clear();

    for (final task in tasks) {
      await _box.put(task.id, task.toMap());
    }
  }
  static Future<void> addTask(Task task) async {
    await _box.put(task.id, task.toMap());
  }

  static Future<void> updateTask(Task task) async {
    await _box.put(task.id, task.toMap());
  }

  static Future<void> deleteTask(int id) async {

    await _box.delete(id);
  }
  static Future<void> deleteAllTasks() async {
    await _box.clear();
  }
  static bool isEmpty() {
    return _box.isEmpty;
  }
}