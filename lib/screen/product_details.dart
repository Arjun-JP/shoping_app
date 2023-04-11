import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/cart.dart';
import 'package:shopping_app/provider/orders.dart';
import 'package:shopping_app/provider/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/Product_Details_Screen';

  const ProductDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findbyID(productid);
    final order = Provider.of<Order>(context);
    final cart = Provider.of<Cart>(context);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(loadedProduct.tittle),
                  background: Hero(
                    tag: loadedProduct.productID,
                    child: Image.network(
                      loadedProduct.imgurl,
                      fit: BoxFit.fill,
                    ),
                  ),
                )),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loadedProduct.tittle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loadedProduct.discription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '₹ ${loadedProduct.price.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    order.addorders(
                      loadedProduct.price,
                      cart.items.values.toList(),
                      loadedProduct.tittle,
                      1.toString(),
                      loadedProduct.imgurl,
                    );
                  },
                  child: const Text('BUY')),
              SizedBox(
                height: 800,
              )
            ]))
          ],
        ),
      ),
    );
  }
}
