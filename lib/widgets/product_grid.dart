// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/products_provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  var fav;
  var ctx;
  ProductGrid({super.key, required this.fav,required this.ctx});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = fav ? productsData.favouriteproducts : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: ((ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child:  ProductItem(ctx:ctx),
            )));
  }
}
