import 'package:flutter/cupertino.dart';
import 'package:mercado_fresco/widgets/product_card.dart';

import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> selectedProducts;
  final Map<Product, int> selectedProductQuantities;
  final Function(Product) onProductSelected;
  final Function(Product) onProductQuantityDecreased;
  final Function(Product) onProductQuantityIncreased;

  const ProductGrid({
    required this.selectedProducts,
    required this.selectedProductQuantities,
    required this.onProductSelected,
    required this.onProductQuantityDecreased,
    required this.onProductQuantityIncreased,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      children: selectedProducts.map((product) {
        final isSelected = selectedProductQuantities.containsKey(product) && selectedProductQuantities[product]! > 0;
        final quantity = selectedProductQuantities[product] ?? 0;

        return GestureDetector(
          onTap: () => onProductSelected(product),
          child: ProductCard(
            product: product,
            isSelected: isSelected,
            quantity: quantity,
            onQuantityDecreased: onProductQuantityDecreased,
            onQuantityIncreased: onProductQuantityIncreased,
          ),
        );
      }).toList(),
    );
  }
}