
// ZADANIE 3
class Task{
  final String title;
  final String daeadline;
  bool done;
  final String priority;

  Task({required this.title, required this.daeadline, required this.done, required this.priority});

}
class TaskRepository {
  static List<Task> tasks = [
    Task(title: 'Zrobić obiad', daeadline: 'jutro', done: false, priority: 'wysoka'),
    Task(title: 'Posprzątać w domku', daeadline: 'dziś', done: true, priority: 'srednia'),
    Task(title: 'Wizyta u okulisty', daeadline: 'jutro', done: false, priority: 'wysoka'),
    Task(title: 'Spotkanie organizacyjne', daeadline: 'pojutrze', done: true, priority: 'niska')
  ];
}