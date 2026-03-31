import 'package:flutter/material.dart';
import 'task_repository.dart';
void main() {
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  MainScreenApp()
    );
  }
}

//ZADANIE 2
class MainScreenApp extends StatefulWidget{
  @override
    State<MainScreenApp> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreenApp>{
  @override
  Widget build(BuildContext context) {
    final taskCountDone = TaskRepository.tasks.where((task) => task.done).length;
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter_ToDo"),
        ),

        body:
        Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Column(
              children: [
                Text("Masz dziś ${TaskRepository.tasks.length} zadania",style: TextStyle(
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
                Expanded(child:  ListView.builder(itemCount: TaskRepository.tasks.length,

                    itemBuilder: (context, index) {
                      final task = TaskRepository.tasks[index];
                      return TaskCard(title: task.title, subtitle: 'termin: ${task.daeadline} | priorytet: ${task.priority}', icon: task.done ? Icons.check_circle : Icons.radio_button_unchecked);
                    }
                ) )


              ]

          ),)
          ,
        ),

        //ZADANIE 1

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );


          if(newTask != null){
            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },
        child: Icon(Icons.add),
      ),

    );
  }

}

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(16) , child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),),
            Padding(padding: EdgeInsets.all(16) , child: TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),),
            Padding(padding: EdgeInsets.all(16) , child: TextField(
              controller: priorityController,
              decoration: InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  daeadline: deadlineController.text,
                  priority: priorityController.text,
                  done: false,
                );
                Navigator.pop(context, newTask);
              },
              child: Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
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