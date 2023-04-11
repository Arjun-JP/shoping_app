import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/order_item.dart';
import '../provider/orders.dart';

class OrderScreen extends StatelessWidget {
  static const routename = '/orderscreen';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        body: FutureBuilder(
            future: Provider.of<Order>(context, listen: false).fechorder(),
            builder: (context, datasnapshot) {
              if (datasnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              } else {
                if (datasnapshot.error != null) {
                  return const Center(child: Text('No orders!'));
                } else {
                  return Consumer<Order>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItemz(order: value.orders[index]),
                      );
                    },
                  );
                }
              }
            }));
  }
}
