import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping_app/provider/cart.dart';

class OrderItem {
  final String id;
  final String title;
  final DateTime date;
  final List<CartItem> products;
  final String quandity;
  final double total;
  final String imgurl;
  OrderItem({
    required this.imgurl,
    required this.products,
    required this.id,
    required this.title,
    required this.date,
    required this.total,
    required this.quandity,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  String token;
  String _userid;
  Order(this.token, this._userid, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fechorder() async {
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Orders/$_userid.json?auth=$token');
    final responce = await http.get(url);
    // if (kDebugMode) {
    //   print('datas ${jsonDecode(responce.body)}');
    // }
    final extracteddata = jsonDecode(responce.body) as Map<String, dynamic>;
    final List<OrderItem> loadeddata = [];
    if (extracteddata.isEmpty) {
      return;
    }
    extracteddata.forEach((key, value) {
      loadeddata.add(OrderItem(
          id: key,
          title: value['title'] ?? '',
          quandity: value['quandity'] ?? '',
          total: value['total'],
          date: DateTime.parse(value['date']),
          imgurl: value['imgurl'] ?? '',
          products: ((value['products'] as List<dynamic>))
              .map((item) => CartItem(
                  imgurl: item['imgurl'],
                  id: item['id'],
                  tittle: item['title'],
                  quandity: item['quandity'],
                  price: item['price']))
              .toList()));
    });
    _orders = loadeddata;
    notifyListeners();
  }

  Future<void> addorders(double total, List<CartItem> cartitems, String title,
      String quandity, String imgurl) async {
    final date = DateTime.now();
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Orders/$_userid.json?auth=$token');
    await http.post(url,
        body: json.encode({
          'price': total,
          'date': date.toIso8601String(),
          'title': 'order',
          'quandity': quandity,
          'total': total,
          'imgurl': imgurl,
          'products': cartitems
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.tittle,
                    'price': cp.price,
                    'quandity': cp.quandity,
                    'imgurl': cp.imgurl,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          title: title,
          date: date,
          total: total,
          quandity: quandity,
          products: cartitems,
          imgurl: '',
        ));

    notifyListeners();
  }
}
