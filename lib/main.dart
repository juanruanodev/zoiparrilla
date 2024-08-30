import 'package:flutter/material.dart';
import 'main_screen.dart'; // Asegúrate de que este import esté presente

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zoiParrilla',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          MainScreen(), // Asegúrate de que el widget MainScreen esté definido e importado correctamente
    );
  }
}
