import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a class to hold product information
class Product {
  final String description;
  final double price;

  Product({
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      description: json['description'],
      price: (json['price'] as num)
          .toDouble(), // Asegurarse de que el precio sea un double
    );
  }
}

// Define a class for the shopping cart item
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CategoriesMenu extends StatefulWidget {
  @override
  _CategoriesMenuState createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends State<CategoriesMenu> {
  String _selectedCategory = 'RES';
  String _searchQuery = '';
  final List<CartItem> _cart = []; // Cart to hold the items added
  bool _isCartNotEmpty =
      false; // Estado para controlar si el carrito tiene productos
  bool _isCartEmpty = true; // Estado para controlar si el carrito está vacío

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset(
            'assets/icons/zoi.jpg', // Reemplaza con la ruta de tu ícono
            width: 80,
            height: 75,
          ),
          SizedBox(width: 8),
          Text('Zoi Parrilla'),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: _isCartEmpty
                ? Colors.red
                : Colors.green, // Cambia el color según el estado del carrito
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cart: _cart,
                    onCartUpdated: _updateCart, // Pasar la función de callback
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Contenedor para los botones de categoría y la barra de búsqueda
          Container(
            color: Colors.black26,
            width: 200, // Ajusta el ancho según sea necesario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      CategoryButton(
                          label: 'RES',
                          category: 'RES',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'CERDO',
                          category: 'CERDO',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'POLLO',
                          category: 'POLLO',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'PASTA',
                          category: 'PASTA',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'PESCADO Y MARISCOS',
                          category: 'PESCADO Y MARISCOS',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'POSTRES',
                          category: 'POSTRES',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'CAJITA FELIZ',
                          category: 'CAJITA FELIZ',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'BEBIDAS',
                          category: 'BEBIDAS',
                          onCategorySelected: _updateCategory),
                      CategoryButton(
                          label: 'ENTRADAS',
                          category: 'ENTRADAS',
                          onCategorySelected: _updateCategory),
                      // Espacio para separar la barra de búsqueda de los botones
                      SizedBox(height: 16),
                      // Barra de búsqueda
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: SearchBar(
                          onSearch: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Vista de productos a la derecha
          Expanded(
            child: ProductsList(
                category: _selectedCategory,
                searchQuery: _searchQuery,
                onAddToCart: (product) {
                  _addToCart(product);
                  setState(() {
                    _isCartNotEmpty = _cart
                        .isNotEmpty; // Actualiza el estado del ícono de carrito
                  });
                }),
          ),
        ],
      ),
    );
  }

  void _updateCart(List<CartItem> cart) {
    setState(() {
      _cart.clear();
      _cart.addAll(cart);
      _isCartEmpty = _cart.isEmpty; // Actualizar el estado del carrito
    });
  }

  void _updateCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      // Check if the product is already in the cart
      final existingItem = _cart.firstWhere(
        (item) => item.product.description == product.description,
        orElse: () => CartItem(product: product, quantity: 0),
      );

      if (existingItem.quantity > 0) {
        existingItem.quantity += 1;
      } else {
        _cart.add(CartItem(product: product, quantity: 1));
      }

      _isCartEmpty = _cart.isEmpty; // Actualizar el estado del carrito
    });
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final String category;
  final Function(String) onCategorySelected;

  CategoryButton({
    required this.label,
    required this.category,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton(
        onPressed: () {
          onCategorySelected(category);
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  SearchBar({required this.onSearch});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                widget.onSearch(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              widget.onSearch(_controller.text);
            },
          ),
        ],
      ),
    );
  }
}

// Función para obtener productos desde una API
Future<List<Product>> fetchProducts(String category) async {
  final response = await http.get(
    Uri.parse('http://localhost:52045/products?category=$category'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class ProductsList extends StatelessWidget {
  final String category;
  final String searchQuery;
  final Function(Product) onAddToCart;

  ProductsList({
    required this.category,
    required this.searchQuery,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          final products = snapshot.data!
              .where((product) => product.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 4.0,
                child: ListTile(
                  title: Text(product.description),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      onAddToCart(product);
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function(List<CartItem>) onCartUpdated;

  CartScreen({
    required this.cart,
    required this.onCartUpdated,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = widget.cart
        .fold(0, (sum, item) => sum + item.product.price * item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orden'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cart[index];
                return ListTile(
                  title: Text(cartItem.product.description),
                  subtitle: Text(
                      '\$${cartItem.product.price.toStringAsFixed(2)} x ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (cartItem.quantity > 1) {
                              cartItem.quantity -= 1;
                            } else {
                              // Create a new list without the removed item
                              widget.cart.removeAt(index);
                            }

                            // Notify the parent widget of the updated cart
                            widget.onCartUpdated(List.from(widget.cart));
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            cartItem.quantity += 1;
                            widget.onCartUpdated(List.from(widget.cart));
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
