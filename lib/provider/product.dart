import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String productID;
  final String tittle;
  final String discription;
  final double price;
  final String imgurl;
  bool favorite;
  Product(
      {required this.productID,
      required this.tittle,
      required this.discription,
      required this.imgurl,
      required this.price,
      this.favorite = false});

  void updateFav(BuildContext ctx, String token, String userid) async {
    final oldstatus = favorite;
    favorite = !favorite;
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/UserFav/$userid/$productID.json?auth=$token');
    try {
      final responce = await http.put(url, body: json.encode(favorite));
      if (responce.statusCode >= 400) {
        favorite = oldstatus;
       
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Add to favorite faild! ')));
        notifyListeners();
      }
    } catch (error) {
      favorite = oldstatus;
      ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Add to favorite faild! ')));
      notifyListeners();
    }

    notifyListeners();
  }
}
