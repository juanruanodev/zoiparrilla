// server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const app = express();
const port = 52045; // Usa el mismo puerto que en tu código Flutter

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Mock Data (Puedes reemplazar esto con una base de datos real)
const products = [
  //////////ENTRADAS
  { description: 'Choripán', price: 13000, category: 'ENTRADAS' },
  { description: 'Chinchulín', price: 26000, category: 'ENTRADAS' },
  { description: 'Crepe de carne molida', price: 16000, category: 'ENTRADAS' },
  { description: 'Crema de pollo o champiñones', price: 16000, category: 'ENTRADAS' },
  { description: 'Empanada Argentina', price: 6000, category: 'ENTRADAS' },

  //////////RES
  { description: 'Baby Beef', price: 45000, category: 'RES' },
  { description: 'Cañon', price: 45000, category: 'RES' },
  { description: 'Filet mignon', price: 50000, category: 'RES' },
  { description: 'Punta de anca', price: 45000, category: 'RES' },
  { description: 'Churrasco', price: 44000, category: 'RES' },
  { description: 'Bife de chorizo', price: 45000, category: 'RES' },
  { description: 'Ojo de bife', price: 45000, category: 'RES' },
  { description: 'Lomo a la pimienta', price: 46000, category: 'RES' },
  { description: 'T bone', price: 60000, category: 'RES' },
  { description: 'Vacio', price: 36000, category: 'RES' },
  { description: 'Parrillada(2 personas)', price: 56000, category: 'RES' },
  { description: 'Picada(2 personas)', price: 50000, category: 'RES' },
  { description: 'Hamburguesa', price: 23000, category: 'RES' },
  { description: 'Entraña', price: 100000, category: 'RES' },
  { description: 'New York steak', price: 100000, category: 'RES' },
  { description: 'Picanha', price: 80000, category: 'RES' },
  { description: 'Rib eye', price: 100000, category: 'RES' },
  { description: 'Tomahawk', price: 120000, category: 'RES' },
  { description: 'Asado de tira', price: 75000, category: 'RES' },
  ///////// CERDO 
  { description: 'Costilla San Luis', price: 50000, category: 'CERDO' },
  { description: 'Milanesa de Cerdo', price: 32000, category: 'CERDO' },
  { description: 'Lomo(BBQ,Champiñones,Frutas)', price: 33000, category: 'CERDO' },
  { description: 'Suprema gratinada de Cerdo', price: 38000, category: 'CERDO' },
  { description: 'Costilla Ahumada', price: 40000, category: 'CERDO' },
  { description: 'Pechito ahumado', price: 37000, category: 'CERDO' },
  { description: 'Chuletón', price: 37000, category: 'CERDO' },
  //////// POLLO
  { description: 'Pechuga Grille(BBQ,Champiñones,Frutas)', price: 32000, category: 'POLLO' },
  { description: 'Milanesa de Pollo', price: 30000, category: 'POLLO' },
  { description: 'Suprema gratinada de  Pollo', price: 36000, category: 'POLLO' },
  { description: 'Hamburguesa de pollo', price: 23000, category: 'POLLO' },
  //////// PASTA
  { description: 'Fettuccine carbonata', price: 29000, category: 'PASTA' },
  { description: 'Fettuccine bolognese', price: 34000, category: 'PASTA' },
  { description: 'Raviols rellenos de trucha y queso', price: 42000, category: 'PASTA' },
  { description: 'Lasagna mixta', price: 38000, category: 'PASTA'},
  { description: 'Canelones vegetarianos', price: 25000, category: 'PASTA' },
  //////// PESCADO Y MARISCOS
  { description: 'Trucha al ajillo', price: 40000, category: 'PESCADO Y MARISCOS' },
  { description: 'Trucha al Escabeche', price: 42000, category: 'PESCADO Y MARISCOS'},
  { description: 'Trucha a la plancha', price: 38000, category: 'PESCADO Y MARISCOS' },
  { description: 'Trucha en papillote', price: 52000, category: 'PESCADO Y MARISCOS'},
  { description: 'Salmón ', price: 56000, category: 'PESCADO Y MARISCOS'},
  { description: 'Cazuela de mariscos', price: 59000, category: 'PESCADO Y MARISCOS' },
  { description: 'Camarones apanados', price: 39000, category: 'PESCADO Y MARISCOS'},
  //////// CAJITA FELIZ
  { description: 'Nuggets', price: 25000, category: 'CAJITA FELIZ'},
  { description: 'Salchipapa', price: 25000, category: 'CAJITA FELIZ'},
  { description: 'Miniburger', price: 25000, category: 'CAJITA FELIZ'},
  //////// POSTRES
  { description: 'Tiramisú', price: 12000, category: 'POSTRES'},
  { description: 'Crepe suzette', price: 12000, category: 'POSTRES'},
  { description: 'De limón', price: 12000, category: 'POSTRES'},
  //////// BEBIDAS
  { description: 'Jugo natural', price: 5000, category: 'BEBIDAS'},
  { description: 'Limonada', price: 8000, category: 'BEBIDAS'},
  { description: 'Coca cola', price: 6000, category: 'BEBIDAS'},
  { description: 'Soda', price: 8000, category: 'BEBIDAS'},
  { description: 'Cerveza nacional', price: 8000, category: 'BEBIDAS'},
  { description: 'Cerveza importada', price: 12000, category: 'BEBIDAS'},
  { description: 'Vino', price: 95000, category: 'BEBIDAS'},
  { description: 'Vino importado', price: 110000, category: 'BEBIDAS'},
  { description: 'Hervido', price: 6000, category: 'BEBIDAS'},
];

// Ruta para obtener productos
app.get('/products', (req, res) => {
  const category = req.query.category;
  if (!category) {
    return res.status(400).json({ error: 'Category is required' });
  }
  const filteredProducts = products.filter(
    (product) => product.category === category
  );
  res.json(filteredProducts);
});

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
