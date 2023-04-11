import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //     productID: 'p1',
    //     tittle: 'shirt',
    //     discription: 'checked shirts for men',
    //     imgurl:
    //         'https://www.beyoung.in/api/cache/catalog/products/new_shirt_upload_21_10_2022/regent_green_sulphur_washed%20_shirt_for_men_base_400x533.jpg',
    //     price: 1500),
    // Product(
    //     productID: 'p2',
    //     tittle: 'shorts',
    //     discription: 'shorts for men',
    //     imgurl:
    //         'https://i.pinimg.com/550x/82/c2/75/82c275dacd6288e4d1effd45d986fcb5.jpg',
    //     price: 500),
    // Product(
    //     productID: 'p3',
    //     tittle: 'suit',
    //     discription: 'pink office suit for womens',
    //     imgurl:
    //         'https://i.pinimg.com/736x/d2/8b/be/d28bbe80c1b3a5c9083213ac0ddeb4d1.jpg',
    //     price: 1800),
    // Product(
    //     productID: 'p4',
    //     tittle: 'jumpsuit',
    //     discription: 'casualjumpsuit for womens',
    //     imgurl:
    //         'https://i.pinimg.com/736x/63/17/28/631728af3ee6ebafdd490d266fa6d9f2.jpg',
    //     price: 800),
  ];

  final String authtoken;
  final String userid;
  Products(this.authtoken, this._items, this.userid);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteproducts {
    return items.where((element) => element.favorite).toList();
  }

  Product findbyID(String id) {
    return _items.firstWhere((element) => element.productID == id);
  }

  Future<void> fetchingdata([bool filterproduct = false]) async {
    final filter = filterproduct ? 'orderBy="creatorID"&equalTo="$userid"' : '';

    var url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/products.json?auth=$authtoken&$filter');

    final fetchresponce = await http.get(url);
    final extrateddata = jsonDecode(fetchresponce.body) as Map<String, dynamic>;
    final List<Product> loadedproduct = [];

    if (extrateddata.isEmpty) {
      return;
    }
    url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/UserFav/$userid.json?auth=$authtoken');
    final favresponce = await http.get(url);
    final favdata = jsonDecode(favresponce.body);

    extrateddata.forEach((proid, product) {
      loadedproduct.add(Product(
          productID: proid,
          discription: product['discription'],
          imgurl: product['imgurl'],
          price: product['price'],
          tittle: product['tittle'],
          favorite: favdata == null ? false : favdata[proid] ?? false));
    });
    _items = loadedproduct;

    notifyListeners();
  }

  Future<void> addProduct(Product product, context) async {
    try {
      final url = Uri.parse(
          'https://shoppingapp-57d82-default-rtdb.firebaseio.com/products.json?auth=$authtoken');

      final responce = await http.post(url,
          body: jsonEncode({
            'tittle': product.tittle,
            'discription': product.discription,
            'imgurl': product.imgurl,
            'price': product.price,
            'favorite': product.favorite,
            'creatorID': userid
          }));

      final newproduct = Product(
        productID: jsonDecode(responce.body).toString(),
        tittle: product.tittle,
        discription: product.discription,
        imgurl: product.imgurl,
        price: product.price,
      );
      _items.add(newproduct);
    } catch (error) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ooops An Error Occurred!'),
          content: const Text('Someting Went wrong..'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Retry'))
          ],
        ),
      );
    }
    notifyListeners();
  }

  Future<void> updateproduct(String id, Product updatedProduct) async {
    var productindex = _items.indexWhere((product) => product.productID == id);

    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken');
    await http.patch(url,
        body: jsonEncode({
          'tittle': updatedProduct.tittle,
          'discription': updatedProduct.discription,
          'imgurl': updatedProduct.imgurl,
          'price': updatedProduct.price,
        }));
    _items[productindex] = updatedProduct;
    notifyListeners();
  }

  Future<void> deleteproduct(String id) async {
    final url = Uri.parse(
        'https://shoppingapp-57d82-default-rtdb.firebaseio.com/products/$id.json?auth=$authtoken');
    await http.delete(url);
    notifyListeners();
    _items.removeWhere((product) => product.productID == id);
    notifyListeners();
  }
}
