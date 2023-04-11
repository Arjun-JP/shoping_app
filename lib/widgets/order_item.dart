import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/provider/orders.dart';

class OrderItemz extends StatefulWidget {
  final OrderItem order;
  const OrderItemz({
    super.key,
    required this.order,
  });

  @override
  State<OrderItemz> createState() => _OrderItemzState();
}

class _OrderItemzState extends State<OrderItemz> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text('total Price  :  ${widget.order.total}'),
            subtitle:
                Text(DateFormat.yMEd().add_jm().format(widget.order.date)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more)),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
            constraints: BoxConstraints(
                minHeight:
                    expanded ? widget.order.products.length * 40 + 30 : 0,
                maxHeight:
                    expanded ? widget.order.products.length * 40 + 30 : 0),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: min(widget.order.products.length * 40 + 30, 300),
            child: ListView(
                children: widget.order.products
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 219, 184, 200),
                                borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.all(2.5),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.network(e.imgurl),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(e.tittle),
                                const Spacer(),
                                Text('x ${e.quandity.toString()}'),
                                const Spacer(),
                                Text('x ${e.price.toString()}'),
                              ],
                            ),
                          ),
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}
