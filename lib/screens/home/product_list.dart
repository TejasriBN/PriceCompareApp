import 'package:pricecompare/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_tile.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {

    final products = Provider.of<List<ProductData>>(context) ?? [];

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(product: products[index]);
      },
    );
  }
}