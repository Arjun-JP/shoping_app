import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartItemz extends StatelessWidget {
  static const routename = '/cart_item';
  final String id;
  final String productID;
  final String title;
  final double price;
  final int qty;
  final String imageurl;

  const CartItemz({
    super.key,
    required this.id,
    required this.productID,
    required this.title,
    required this.price,
    required this.qty,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.all(5),
        color: Colors.red,
        child: const Center(
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.delete),
                ))),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Delete ? '),
                  content: const Text(
                      'Are you sure to remove this product ffrom your cart. '),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx, rootNavigator: true).pop(true);
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx, rootNavigator: true).pop(false);
                        },
                        child: const Text('No'))
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deletecartitem(productID);
        throw () {
          if (kDebugMode) {
            print('error');
          }
        };
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.purple, width: 2)),
        margin: const EdgeInsets.all(5),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  image: DecorationImage(
                      image: NetworkImage(imageurl), fit: BoxFit.cover)),
            ),
            Text(title),
            SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity'),
                  Text(qty.toString()),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Price'),
                  Text(price.toString()),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Total'),
                  Text((price * qty).toString()),
                ],
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('BUY'))
          ],
        ),
      ),
    );
  }
}
