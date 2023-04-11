import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/orders.dart';
import 'package:shopping_app/widgets/cart_items.dart';

import '../provider/cart.dart';

class CartScreen extends StatefulWidget {
  static const routename = '/cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isinit = true;
  @override
  void didChangeDependencies() {
    if (isinit) {
      Provider.of<Cart>(context).fetchingdata();
    }
    setState(() {
      isinit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Products'),
                const Spacer(),
                Chip(
                  label: Text(
                    cart.totalprice.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                OrderBUtton(cart: cart)
              ],
            ),
          ),
          SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: cart.itemcount,
                itemBuilder: (context, i) {
                  return CartItemz(
                    imageurl: cart.items.values.toList()[i].imgurl,
                    productID: cart.items.keys.toList()[i],
                    id: cart.items.values.toList()[i].id,
                    title: cart.items.values.toList()[i].tittle,
                    price: cart.items.values.toList()[i].price,
                    qty: cart.items.values.toList()[i].quandity,
                  );
                },
              ))
        ],
      ),
    );
  }
}

class OrderBUtton extends StatefulWidget {
  final Cart cart;
  const OrderBUtton({super.key, required this.cart});

  @override
  State<OrderBUtton> createState() => _OrderBUttonState();
}

class _OrderBUttonState extends State<OrderBUtton> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ElevatedButton(
      onPressed: (widget.cart.totalprice <= 0 || isloading == true)
          ? null
          : () async {
              setState(() {
                isloading = true;
              });
              await Provider.of<Order>(context, listen: false).addorders(
                widget.cart.totalprice,
                widget.cart.items.values.toList(),
                widget.cart.items['tittle'].toString(),
                widget.cart.items['quandity'].toString(),
                widget.cart.items['imgurl'].toString(),
              );

              widget.cart.clearcart();
              setState(() {
                isloading = false;
              });
              scaffold.showSnackBar(
                  const SnackBar(content: Text('Order placed. ')));
            },
      child: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Text('ORDER NOW'),
    );
  }
}
