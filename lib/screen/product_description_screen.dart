import 'package:flutter/material.dart';
import 'product.dart';

class ProductDescriptionScreen extends StatelessWidget {
  final Product product;

  ProductDescriptionScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(product.description),
      ),
    );
  }
}
