import 'package:flutter/material.dart';
import 'categories_menu.dart'; // Importa el archivo correctamente

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          CategoriesMenu(), // Incluye el menú de categorías aquí
          Expanded(
            child: Center(
              child: Text('Products Screen Content'),
            ),
          ),
        ],
      ),
    );
  }
}
