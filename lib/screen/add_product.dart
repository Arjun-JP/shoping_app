import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/product.dart';
import 'package:shopping_app/provider/products_provider.dart';

class AddProducts extends StatefulWidget {
  static const routename = '/add_products';
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _pricefocusnode = FocusNode();
  final _discriptionfocusnode = FocusNode();
  final _urlfocusnode = FocusNode();
  final _imagecontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var initialvalue = true;
  bool isloading = false;
  var _newproduct = Product(
      productID: 'null', tittle: '', discription: '', imgurl: '', price: 0);
  var _updateproduct = {
    'productid': 'null',
    'tittle': '',
    'discription': '',
    'imgurl': '',
    'price': '',
  };

  @override
  void dispose() {
    _discriptionfocusnode.dispose();
    _imagecontroller.dispose();
    _pricefocusnode.dispose();
    _urlfocusnode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (initialvalue) {
      var proid = ModalRoute.of(context)!.settings.arguments as String;
      // ignore: unnecessary_null_comparison
      if (proid == null || proid != 'newproduct') {
        _newproduct =
            Provider.of<Products>(context, listen: false).findbyID(proid);

        _updateproduct = {
          'productid': _newproduct.productID,
          'tittle': _newproduct.tittle,
          'discription': _newproduct.discription,
          'imgurl': '',
          'price': _newproduct.price.toString(),
        };
        _imagecontroller.text = _newproduct.imgurl;
      }
    }

    initialvalue = false;
    super.didChangeDependencies();
  }

  void _savefomrm() async {
    final validator = _form.currentState?.validate();
    if (!validator!) {
      return;
    }
    setState(() {
      isloading = true;
    });
    _form.currentState!.save();
    if (_updateproduct['productid'] != 'null') {
      if (kDebugMode) {
        print('Product updated');
      }
      await Provider.of<Products>(context, listen: false)
          .updateproduct(_newproduct.productID, _newproduct);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newproduct, context);
      } catch (error) {
        await showDialog(
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
      } finally {
        setState(() {
          isloading = false;
        });
        Navigator.of(context).pop();
      }

      if (kDebugMode) {
        print('add new product');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('product details'),
        actions: [
          IconButton(onPressed: _savefomrm, icon: const Icon(Icons.check))
        ],
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 74, 38),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _updateproduct['tittle'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_pricefocusnode);
                      },
                      onSaved: (newValue) {
                        _newproduct = Product(
                            productID: _newproduct.productID,
                            tittle: newValue!,
                            discription: _newproduct.discription,
                            imgurl: _newproduct.imgurl,
                            price: _newproduct.price);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Tittle';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _updateproduct['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _pricefocusnode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_discriptionfocusnode);
                      },
                      onSaved: (newValue) {
                        _newproduct = Product(
                            productID: _newproduct.productID,
                            tittle: _newproduct.tittle,
                            discription: _newproduct.discription,
                            imgurl: _newproduct.imgurl,
                            price: double.parse(newValue!));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Enter The price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valied price';
                        }
                        if (double.parse(value) <= 0) {
                          return "Ether value higher than zero";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _updateproduct['discription'],
                      decoration:
                          const InputDecoration(labelText: 'Discripction'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      focusNode: _discriptionfocusnode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_urlfocusnode);
                      },
                      onSaved: (newValue) {
                        _newproduct = Product(
                            productID: _newproduct.productID,
                            tittle: _newproduct.tittle,
                            discription: newValue!,
                            imgurl: _newproduct.imgurl,
                            price: _newproduct.price);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter the Discripction';
                        }
                        if (value.length < 10) {
                          return 'Min 10 letters needed';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          height: 90,
                          width: 90,
                          child: _imagecontroller.text.isEmpty
                              ? const Center(
                                  child: Text(('Enter a valied URL')))
                              : FittedBox(
                                  child: Image.network(_imagecontroller.text)),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            controller: _imagecontroller,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (newValue) {
                              _newproduct = Product(
                                  productID: _newproduct.productID,
                                  tittle: _newproduct.tittle,
                                  discription: _newproduct.discription,
                                  imgurl: newValue!,
                                  price: _newproduct.price);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter a valied url';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Enter a valied url';
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              _savefomrm();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
    );
  }
}
