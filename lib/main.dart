import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/auth.dart';
import 'package:shopping_app/provider/cart.dart';
import 'package:shopping_app/provider/orders.dart';
import 'package:shopping_app/provider/products_provider.dart';
import 'package:shopping_app/screen/add_product.dart';
import 'package:shopping_app/screen/auth_screen.dart';
import 'package:shopping_app/screen/cart_screen.dart';
import 'package:shopping_app/screen/order_screen.dart';
import 'package:shopping_app/screen/product_details.dart';
import 'package:shopping_app/screen/profduct_overview.dart';
import 'package:shopping_app/screen/splash_screen.dart';
import 'package:shopping_app/screen/user_products.dart';

import 'Routeanimation/routeanimation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products('', [], ''),
            update: (context, auth, previousproducts) => Products(
                auth.token,
                previousproducts!.items == null ? [] : previousproducts.items,
                auth.userid),
          ),
          ChangeNotifierProxyProvider<Auth, Cart>(
            create: (context) => Cart('', {}),
            update: (context, auth, previouscart) => Cart(auth.token,
                previouscart!.items == null ? {} : previouscart.items),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order(
              '',
              '',
              [],
            ),
            update: (context, auth, previousorder) => Order(
                auth.token,
                auth.userid,
                previousorder!.orders == null ? [] : previousorder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CoustomPageroutebuilder(),
                    TargetPlatform.iOS: CoustomPageroutebuilder()
                  })),
              home: auth.isauth
                  ? const ProductOverView()
                  : FutureBuilder(
                      future: auth.autologin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen()),
              routes: {
                AuthScreen.routename: (context) => const AuthScreen(),
                ProductDetailsScreen.routeName: (context) =>
                    const ProductDetailsScreen(),
                CartScreen.routename: (context) => const CartScreen(),
                OrderScreen.routename: (context) => const OrderScreen(),
                ProductOverView.routename: (context) => const ProductOverView(),
                UserProduct.routename: (context) => const UserProduct(),
                AddProducts.routename: (context) => const AddProducts(),
              },
            );
          },
        ));
  }
}
