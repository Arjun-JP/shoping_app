import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screen/add_product.dart';

import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String url;
  const UserProductItem(
      {super.key, required this.title, required this.url, required this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddProducts.routename, arguments: id);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .deleteproduct(id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Product Deleated.'),
                  ));
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
