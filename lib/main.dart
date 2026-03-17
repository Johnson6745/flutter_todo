import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // ZADANIE 1
          title: Text("KrakFlow"),
        ),

        body:
        // ZADANIE 2 I 3
        Center(child: Column(children: [Text("Krakflow"), Text("Organizacja Studiow"), Text("Dzisiejsze zadania")]),)


      ),

    );

  
  }
}
