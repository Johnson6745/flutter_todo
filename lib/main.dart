import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//ZADANIE 1
class Task{
  final String title;
  final String daeadline;
  final bool done;
  final String priority;

  Task({required this.title, required this.daeadline, required this.done, required this.priority});

}
//ZADANIE 2
List<Task> tasks = [
  Task(title: 'Zrobić obiad', daeadline: 'jutro', done: false, priority: 'wysoka'),
  Task(title: 'Posprzątać w domu', daeadline: 'dziś', done: true, priority: 'srednia'),
  Task(title: 'Wizyta u okulisty', daeadline: 'jutro', done: false, priority: 'wysoka'),
  Task(title: 'Spotkanie organizacyjne', daeadline: 'pojutrze', done: true, priority: 'niska')
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final taskCountDone = tasks.where((task) => task.done).length;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter_ToDo"),
        ),

        body:
        Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Column(
              children: [
                Text("Masz dziś ${tasks.length} zadania",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 16),
                Text("Wykonano ${taskCountDone} zadan",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 16),
                Text("Dzisiejsze zadania",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child:  ListView.builder(itemCount: tasks.length,

                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(title: task.title, subtitle: 'termin: ${task.daeadline} | priorytet: ${task.priority}', icon: task.done ? Icons.check_circle : Icons.radio_button_unchecked);
                    }
                ) )


              ]

          ),)
          ,
        )

        //ZADANIE 2


    ));
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),child: Card(
    child: ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
    ),
    ));
  }
}