import 'package:amazon/src/feature/home/widget/product_card.dart';
import 'package:amazon/src/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final List<ProductModel> products;
  const ProductList({super.key, required this.products});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65, // ← taller card, more room for content
      ),
      padding: const EdgeInsets.all(12),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return ProductCard(product: product);
      },
    );
  }
}
