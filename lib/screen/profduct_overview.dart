import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/products_provider.dart';
import 'package:shopping_app/screen/cart_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/cart_badge.dart';
import '../provider/cart.dart';
import '../widgets/product_grid.dart';

enum Options { favourite, all }

class ProductOverView extends StatefulWidget {
  static const routename = '/productoverview';
  const ProductOverView({super.key});

  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var _showonlyfav = false;
  bool isinit = true;
  bool isloadindg = false;
  Future<void> pulltorefresh(BuildContext ctx) async {
    try {
      await Provider.of<Products>(ctx, listen: false).fetchingdata();
    } catch (error) {
      // print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
          actions: [
            PopupMenuButton(
                onSelected: (Options value) {
                  setState(() {
                    if (value == Options.favourite) {
                      _showonlyfav = true;
                    } else {
                      _showonlyfav = false;
                    }
                  });
                },
                itemBuilder: ((context) => [
                      const PopupMenuItem(
                        value: Options.favourite,
                        child: Text('Favourite'),
                      ),
                      const PopupMenuItem(
                        value: Options.all,
                        child: Text('All product'),
                      )
                    ])),
            Consumer<Cart>(
              builder: (_, cartitem, ch) {
                // print(cartitem.itemcount.toString());
                return InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(CartScreen.routename),
                  child: Badge(
                      value: cartitem.itemcount.toString(),
                      child: const Icon(Icons.shopping_bag)),
                );
              },
            )
          ],
        ),
        drawer: const AppDrawer(),
        body: isloadindg
            ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : FutureBuilder(
                future: pulltorefresh(context),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () {
                              return pulltorefresh(context);
                            },
                            child: ProductGrid(fav: _showonlyfav, ctx: context),
                          ),
              ));
  }
}
