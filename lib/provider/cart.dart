// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String id;
  final String tittle;
  final int quandity;
  final double price;
  final String imgurl;
  CartItem({
    required this.imgurl,
    required this.id,
    required this.tittle,
    required this.quandity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  String token;
  Cart(this.token, this._items);

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    print(_items);
    return _items.length;
  }

  double get totalprice {
    var total = 0.0;
    _items.forEach((key, cart) {
      total = total + (cart.price * cart.quandity);
      // notifyListeners();
    });
    return total;
  }

  Future<void> fetchingdata() async {
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Cart.json?auth=$token');
    final fetchresponce = await http.get(url);
    final extrateddata = jsonDecode(fetchresponce.body) as Map<String, CartItem>;
    final Map<String, CartItem> loadedproduct = {};
    print(extrateddata);
    if (extrateddata.isEmpty) {
      return;
    }
    _items = extrateddata;
    // extrateddata.forEach((proid, cart) {
    //   loadedproduct['$proid'] = CartItem(
    //     id: proid,
    //     tittle: cart['tittle'],
    //     imgurl: cart['imgurl'],
    //     price: cart['price'],
    //     quandity: cart['quandity'],
    //   );
    // });
    // _items = loadedproduct;
    notifyListeners();

    // print(jsonDecode(fetchresponce.body));
  }

  Future<void> addItem(
      String productid, String tittle, double price, String url) async {
    if (_items.containsKey(productid)) {
      print(productid);
      _items.update(productid, (value) {
        final date = DateTime.now();
        final url = Uri.parse(
            'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Cart/$productid.json?auth=$token');
        http
            .post(url,
                body: json.encode({
                  'id': value.id,
                  'tittle': value.tittle,
                  'price': value.price,
                  'imgurl': value.imgurl,
                  'quandity': value.quandity + 1,
                  'date': date,
                }))
            .then(
          (value) {
            print('zzzzzzzzzzzzzzzzzzz$value.body');
          },
        );
        return CartItem(
            imgurl: value.imgurl,
            id: value.id,
            tittle: value.tittle,
            quandity: value.quandity + 1,
            price: value.price);
      });
      notifyListeners();
    } else {
      _items.putIfAbsent(
          productid,
          () => CartItem(
              imgurl: url,
              id: DateTime.now().toString(),
              tittle: tittle,
              quandity: 1,
              price: price));
      final date = DateTime.now();
      final urls = Uri.parse(
          'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Cart.json?auth=$token');
      await http.post(urls,
          body: json.encode({
            'id': productid,
            'tittlt': tittle,
            'price': price,
            'date': date.toIso8601String(),
            'quandity': 1,
            'imgurl': url,
          }));
      notifyListeners();
    }
  }

  Future<void> deletecartitem(String id) async {
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Cart/$id.json?auth=$token');
    _items.remove(id);

    await http.delete(url);
    notifyListeners();
  }

  Future<void> clearcart() async {
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/Cart.json?auth=$token');
    await http.delete(url);
    notifyListeners();
    _items.clear();
    notifyListeners();
  }

  void snackbarundo(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quandity > 1) {
      _items.update(
          id,
          (value) => CartItem(
              imgurl: value.imgurl,
              id: value.id,
              tittle: value.tittle,
              quandity: value.quandity - 1,
              price: value.price));
    } else if (_items[id]!.quandity == 1) {
      _items.remove(id);
    }
    notifyListeners();
  }
}
