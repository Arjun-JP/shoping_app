import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/auth.dart';
import 'package:shopping_app/provider/cart.dart';
import 'package:shopping_app/provider/product.dart';

import '../screen/product_details.dart';

// ignore: must_be_immutable
class ProductItem extends StatelessWidget {
  BuildContext ctx;
  ProductItem({super.key, required this.ctx});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: true);
    final cart = Provider.of<Cart>(context);
    final authdata = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, value, _) => IconButton(
                  onPressed: () {
                    value.updateFav(ctx, authdata.token, authdata.userid);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: product.favorite ? Colors.red : Colors.white,
                  )),
            ),
            subtitle: Text(
              product.tittle,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black54,
            trailing: IconButton(
                onPressed: () {
                  cart.addItem(
                    product.productID,
                    product.tittle,
                    product.price,
                    product.imgurl,
                  );
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Item Added to cart!'),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.snackbarundo(product.productID);
                        }),
                  ));
                },
                icon: const Icon(Icons.shopping_bag)),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                  arguments: product.productID);
            },
            child: Hero(
              tag: product.productID,
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(
                  product.imgurl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }
}
