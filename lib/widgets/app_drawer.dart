import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Routeanimation/routeanimation.dart';
import 'package:shopping_app/provider/auth.dart';
import 'package:shopping_app/screen/order_screen.dart';
import 'package:shopping_app/screen/profduct_overview.dart';
import 'package:shopping_app/screen/user_products.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('appname'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_rounded),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushNamed(OrderScreen.routename),
          ),
          ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Products'),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                    ProductOverView.routename,
                  )),
          ListTile(
            leading: const Icon(Icons.attach_money_rounded),
            title: const Text('User Products'),
            onTap: () => Navigator.of(context).pushNamed(UserProduct.routename),
            // onTap: () => Navigator.of(context).pushReplacement(Coustomroute(
            //   builder: (context) => const UserProduct(),
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed('/');
              }),
        ],
      ),
    );
  }
}
