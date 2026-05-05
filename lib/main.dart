import 'package:flutter/material.dart';
import 'task_repository.dart';
import '/services/task_api_service.dart';
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


class MainScreenApp extends StatefulWidget{
  @override
    State<MainScreenApp> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreenApp>{
  String selectedFilter = "wszystkie";
  @override
  Widget build(BuildContext context) {
    final taskCountDone = TaskRepository.tasks.where((task) => task.done).length;

    List<Task> filteredTasks = TaskRepository.tasks;
    if (selectedFilter == "wykonane") {
      filteredTasks = TaskRepository.tasks
          .where((task) => task.done)
          .toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks
          .where((task) => !task.done)
          .toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter_ToDo"),
          actions: [
            IconButton(
                onPressed: TaskRepository.tasks.isEmpty
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Center(child: Text("Lista zadań jest już pusta!") ,)),
                  );
                }
                    : () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Potwierdzenie"),
                        content: const Text("Czy na pewno chcesz usunąć WSZYSTKIE zadania?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Anuluj"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                TaskRepository.tasks.clear();
                              });
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Center(child: Text("Usunięto wszystkie zadania"),)),
                              );
                            },
                            child: const Text("Usuń", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },

              icon: Icon(
                Icons.delete,
              ),
            )
          ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "wszystkie";
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: selectedFilter == "wszystkie" ? Colors.blue : Colors.grey,

                      ),
                      child: Text("Wszystkie"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "do zrobienia";
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: selectedFilter == "do zrobienia" ? Colors.blue : Colors.grey,

                      ),
                      child: Text("Do zrobienia"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = "wykonane";
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: selectedFilter == "wykonane" ? Colors.blue : Colors.grey,

                      ),
                      child: Text("Wykonane"),
                    ),
                  ],
                ),

                Expanded(
                  //ZADANIE 2
                  child: FutureBuilder<List<Task>>(

                    future: TaskApiService.fetchTasks(),
                    builder: (context, snapshot) {
                      //ZADANIE 3
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }


                      if (snapshot.hasError) {
                        return Center(child: Text("Błąd: ${snapshot.error}"));
                      }


                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Brak zadań."));
                      }

                      final tasksFromApi = snapshot.data!;

                      return ListView.builder(
                        itemCount: tasksFromApi.length,
                        itemBuilder: (context, index) {
                          final task = tasksFromApi[index];

                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: ValueKey(task.title),
                            onDismissed: (direction) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Center(child: Text('Zadanie usunięte: ${task.title}'))),
                              );
                            },

                            child: TaskCard(
                              title: task.title,
                              subtitle: 'termin: ${task.daeadline} | priorytet: ${task.priority}',
                              done: task.done,
                              onChanged: (value) {

                                setState(() {
                                  task.done = value!;
                                });
                              },
                              onTap: () async {
                                final Task? updatedTask = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTaskScreen(task: task),
                                  ),
                                );
                                if (updatedTask != null) {
                                  setState(() {
                                    tasksFromApi[index] = updatedTask;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                )


              ]

          ),)
          ,
        ),



      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final Task? newTask = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AddTaskScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
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
              child: Center(child: Text("Zapisz")),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final Task task;
  final TextEditingController titleController;
  final TextEditingController deadlineController;
  final TextEditingController priorityController;

  EditTaskScreen({super.key, required this.task})
      : titleController = TextEditingController(text: task.title),
        deadlineController = TextEditingController(text: task.daeadline),
        priorityController = TextEditingController(text: task.priority);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edytuj zadanie")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Tytuł")),
            TextField(controller: deadlineController, decoration: const InputDecoration(labelText: "Termin")),
            TextField(controller: priorityController, decoration: const InputDecoration(labelText: "Priorytet")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Task(
                  title: titleController.text,
                  daeadline: deadlineController.text,
                  priority: priorityController.text,
                  done: task.done,
                );
                Navigator.pop(context, updatedTask);
              },
              child: const Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}


class TaskCard extends StatelessWidget {
  final bool done;
  final String title;
  final String subtitle;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;
  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),child: Card(
    child: ListTile(
    onTap: onTap,
    leading: Checkbox(value: done, onChanged: onChanged),
    title: Text(
      title,
      style: TextStyle(
        decoration: done
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
    ),
    subtitle: Text(subtitle),
    ),
    ));
  }
}
