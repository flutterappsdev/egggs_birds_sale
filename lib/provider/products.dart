import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import '../constant/constants.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // var _showFavoritesOnly = false;
  final String authToken='';
  final String userId='';
  //Products(this.authToken,this._items,this.userId);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }



  Future<void> addProduct(Product product) async {

    final URL = 'https://eggsale-66fcd-default-rtdb.firebaseio.com/products.json';
    print(product.title);
    try {
      final response = await http.post(
        URL,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'unit': product.unit,
            'areacode': AreaCode
            // 'isFavorite': product.isFavorite
          },
        ),
      );
      print(response.body);
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        unit: product.unit,
        id: json.decode(response.body)['name'],
      );
      //_items.add(newProduct);
      _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (err) {
      print('saving error'+err);
      throw err;
    }


  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        final URL = 'https://eggsale-66fcd-default-rtdb.firebaseio.com/products/$id.json';
        await http.patch(URL, body: json.encode(
            { 'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'unit': newProduct.unit,
            }
        ),);
        _items[prodIndex]= newProduct;
        notifyListeners();
      }
      catch(e) {

      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://eggsale-66fcd-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      //throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }


  Future<void> fetchAndSetProducts() async {
    print('fetch data');
    try {
      var URL = 'https://eggsale-66fcd-default-rtdb.firebaseio.com/products.json';
      final response = await http.get(URL);
      print(json.decode(response.body));
      final List<Product> loadedProds = [];
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if(extractedData == null) {
        return;
      }

      //URL = 'https://mshopapp-1caecy.firebaseio.com/userFavourite/$userId.json?auth=$authToken';
      //final favoriteResponse = await http.get(URL);
      //final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((prodId, prodData) {
        //_items.
        loadedProds.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          //isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
          unit: prodData['unit'],
        ),);
        _items = loadedProds;
        notifyListeners();
      });

    }
    catch(err){
      throw(err);
    }


  }
}
