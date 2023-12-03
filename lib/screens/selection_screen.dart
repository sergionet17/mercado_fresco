import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercado_fresco/screens/product_selection_page.dart';

import '../widgets/category_card.dart';

class SelectionScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final String category; // Agrega el parámetro 'category' al constructor
    void _navigateToProductSelection(String category) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductSelectionPage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una categoría'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CategoryCard(
                      category: 'Frutas',
                      icon: Icons.local_florist,
                      onPressed: () {
                        // Acción al seleccionar la categoría de frutas
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CategoryCard(
                      category: 'Verduras',
                      icon: Icons.local_grocery_store,
                      onPressed: () {
                        // Acción al seleccionar la categoría de verduras
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CategoryCard(
                      category: 'Hojas',
                      icon: Icons.eco,
                      onPressed: () {
                        _navigateToProductSelection('Otros'); // Reemplaza 'Otros' con la variable correspondiente a la categoría
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CategoryCard(
                      category: 'Otros',
                      icon: Icons.category,
                      onPressed: () {
                        // Acción al seleccionar la categoría de otros
                      },
                    ),
                  ),
                ),
              ],
              
            ),
          ),
        ],
      ),
    );
  }
}
