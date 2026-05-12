
// ZADANIE 3
class Task {
  final int id;
  final String title;
  final String daeadline;
  final String priority;
  bool done;
  Task({
    required this.id,
    required this.title,
    required this.daeadline,
    required this.priority,
    required this.done,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": daeadline,
      "priority": priority,
      "done": done,
    };
  }
  factory Task.fromMap(Map map) {
    return Task(
      id: map["id"],
      title: map["title"],
      daeadline: map["deadline"],
      priority: map["priority"],
      done: map["done"],
    );
  }
}


class TaskRepository {
  static List<Task> tasks = [
    Task(id: DateTime.now().millisecondsSinceEpoch, title: 'Zrobić obiad', daeadline: 'jutro', done: false, priority: 'wysoka'),
    Task(id: DateTime.now().millisecondsSinceEpoch, title: 'Posprzątać w domku', daeadline: 'dziś', done: true, priority: 'srednia'),
    Task(id: DateTime.now().millisecondsSinceEpoch, title: 'Wizyta u okulisty', daeadline: 'jutro', done: false, priority: 'wysoka'),
    Task(id: DateTime.now().millisecondsSinceEpoch, title: 'Spotkanie organizacyjne', daeadline: 'pojutrze', done: true, priority: 'niska')
  ];
}