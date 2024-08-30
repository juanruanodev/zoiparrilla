import 'package:flutter/material.dart';
import 'categories_menu.dart'; // Asegúrate de importar el archivo correcto

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoriesMenu(), // Muestra directamente el menú de categorías
    );
  }
}
