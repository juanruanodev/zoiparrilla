import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key})
      : super(key: key); // Añadido el parámetro key

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.blueGrey[100],
      child: Column(
        children: [
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              // Acción para Home
            },
          ),
          ListTile(
            title: Text('Products'),
            leading: Icon(Icons.shopping_cart),
            onTap: () {
              // Acción para Products
            },
          ),
          ListTile(
            title: Text('Print'),
            leading: Icon(Icons.print),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Esto es una notificación SnackBar'),
                  duration: Duration(seconds: 2),
                ),
              );
              // Acción para Print
            },
          ),
        ],
      ),
    );
  }
}
