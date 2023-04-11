import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/products_provider.dart';
import 'package:shopping_app/screen/add_product.dart';
import 'package:shopping_app/widgets/user_productitems.dart';

import '../widgets/app_drawer.dart';

class UserProduct extends StatelessWidget {
  static const routename = '/user_productr';
  const UserProduct({super.key});

  pulltorefresh(BuildContext ctx) async {
    try {
      await Provider.of<Products>(ctx, listen: false).fetchingdata(true);
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddProducts.routename, arguments: 'newproduct');
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: (() => pulltorefresh(context)),
        child: FutureBuilder(
          future: pulltorefresh(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<Products>(
                      builder: (context, productdata, child) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: productdata.items.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                UserProductItem(
                                    id: productdata.items[index].productID,
                                    title: productdata.items[index].tittle,
                                    url: productdata.items[index].imgurl),
                                const Divider()
                              ],
                            ),
                          )),
                    ),
        ),
      ),
    );
  }
}
