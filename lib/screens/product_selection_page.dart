import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'models/product.dart';

class ProductSelectionPage extends StatefulWidget {
  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  final List<Product> selectedProducts = [];
  final Map<Product, int> selectedProductQuantities = {};
  final FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    testConnection(); // Llama al método para probar la conexión al iniciar la página
    isLoading = true;
  }

  Future<void> testConnection() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('producto');
      final collectionSnapshot = await collectionRef.get();

      if (collectionSnapshot.size > 0) {
        final List<Product> products = [];
        for (final docSnapshot in collectionSnapshot.docs) {
          final data = docSnapshot.data();
          final product = Product(data['nombre'], data['imagePath']);
          products.add(product);
        }
        setState(() {
          isLoading = true; // Antes de cargar los datos
          // Actualiza la lista de productos con los productos de Firebase
          updateSelectedProducts(products);
          isLoading = false; // Después de cargar los datos
        });
      } else {
        print('No se encontraron documentos en la colección "producto".');
      }
    } catch (error) {
      print('Error al conectar con Firebase Firestore: $error');
    }
  }

  void updateSelectedProducts(List<Product> products) {
    selectedProducts.clear();
    selectedProductQuantities.clear();
    selectedProducts.addAll(products);
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
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              children: selectedProducts.map((product) {
                final isSelected = selectedProducts.contains(product);
                final quantity = selectedProductQuantities[product] ?? 0;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedProducts.remove(product);
                        selectedProductQuantities.remove(product);
                      } else {
                        selectedProducts.add(product);
                        selectedProductQuantities[product] = 1;
                      }
                    });
                  },
                  child: Card(
                    color: isSelected ? Colors.green[100] : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(product.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 0) {
                                      selectedProductQuantities[product] =
                                          quantity - 1;
                                    }
                                  });
                                },
                              ),
                              Text(quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    selectedProductQuantities[product] =
                                        quantity + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
                'Número de productos seleccionados: ${selectedProducts.length}',
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

}
