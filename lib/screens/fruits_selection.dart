import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';
import '../widgets/product_grid.dart';
import '../widgets/selected_product_count_widget.dart';

class FruitsSelectionPage extends StatefulWidget {
  @override
  _FruitsSelectionPageState createState() => _FruitsSelectionPageState();
}

class _FruitsSelectionPageState extends State<FruitsSelectionPage> {
  final List<Product> selectedProducts = []; // Lista de productos seleccionados
  final Map<Product, int> selectedProductQuantities = {}; // Mapa que almacena los productos seleccionados junto con su cantidad
  final FirebaseService firebaseService = FirebaseService(); // Servicio de Firebase
  bool isLoading = true; // Variable para controlar si se está cargando la página

  @override
  void initState() {
    super.initState();
    testConnection(); // Llama al método para probar la conexión al iniciar la página
    isLoading = true;
  }

  // Método que prueba la conexión con Firebase Firestore y carga los datos iniciales
  Future<void> testConnection() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('frutas'); // Referencia a la colección "producto" en Firestore
      if (category == 'Verduras') {
        final collectionRef = FirebaseFirestore.instance.collection('verduras');
        // Resto del código para la categoría "Verduras"
      }

      final collectionSnapshot = await collectionRef.get(); // Obtiene un snapshot de los documentos en la colección

      if (collectionSnapshot.size > 0) { // Si hay documentos en la colección
        final List<Product> products = [];
        for (final docSnapshot in collectionSnapshot.docs) {
          final data = docSnapshot.data();
          final product = Product(data['nombre'], data['imagePath']); // Crea una instancia de Product a partir de los datos del documento
          products.add(product); // Agrega el producto a la lista de productos
        }
        setState(() {
          isLoading = true; // Antes de cargar los datos
          updateSelectedProducts(products); // Actualiza la lista de productos con los productos de Firebase
          isLoading = false; // Después de cargar los datos
        });
      } else {
        print('No se encontraron documentos en la colección "producto".');
      }
    } catch (error) {
      print('Error al conectar con Firebase Firestore: $error');
    }
  }

  // Método que actualiza la lista de productos seleccionados y sus cantidades
  void updateSelectedProducts(List<Product> products) {
    selectedProducts.clear(); // Limpia la lista de productos seleccionados
    selectedProductQuantities.clear(); // Limpia el mapa de cantidades de productos seleccionados
    selectedProducts.addAll(products); // Agrega los nuevos productos a la lista de productos seleccionados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un Producto'),
      ),
      body: Stack(
        children: [
          if (!isLoading)
            ProductGrid(
              selectedProducts: selectedProducts,
              selectedProductQuantities: selectedProductQuantities,
              onProductSelected: _handleProductSelected,
              onProductQuantityDecreased: _handleProductQuantityDecreased,
              onProductQuantityIncreased: _handleProductQuantityIncreased,
            ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Número de productos seleccionados: ${selectedProductQuantities.values.where((quantity) => quantity > 0).length}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Acción al hacer clic en el botón
                  // Puedes usar las listas selectedProducts y selectedProductQuantities para realizar alguna acción
                },
                child: Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Maneja la selección/deselección de un producto
  void _handleProductSelected(Product product) {
    setState(() {
      if (selectedProductQuantities.containsKey(product) && selectedProductQuantities[product]! > 0) {
        selectedProductQuantities[product] = 0; // Establecer la cantidad a 0 para deseleccionar el producto
      } else {
        selectedProductQuantities[product] = 1; // Establecer la cantidad a 1 para seleccionar el producto
      }
    });
  }

  // Maneja la disminución de la cantidad de un producto
  void _handleProductQuantityDecreased(Product product) {
    setState(() {
      final quantity = selectedProductQuantities[product] ?? 0;
      if (quantity > 0) {
        selectedProductQuantities[product] = quantity - 1; // Disminuye la cantidad del producto en 1
      }
    });
  }

  // Maneja el aumento de la cantidad de un producto
  void _handleProductQuantityIncreased(Product product) {
    setState(() {
      final quantity = selectedProductQuantities[product] ?? 0;
      selectedProductQuantities[product] = quantity + 1; // Aumenta la cantidad del producto en 1
    });
  }
}
