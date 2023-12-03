
// Widget reutilizable que muestra la cantidad de productos seleccionados.
import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class SelectedProductCountWidget extends StatelessWidget {
  final Map<Product, int> selectedProductQuantities;

  SelectedProductCountWidget({required this.selectedProductQuantities});

  @override
  Widget build(BuildContext context) {
    final selectedProductCount =
        selectedProductQuantities.values.where((quantity) => quantity > 0).length;

    return Text(
      'Número de productos seleccionados: $selectedProductCount',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }
}
