import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String unit;
  final String areaCode;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.unit,
    @required this.areaCode,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(String token,String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://myshopapp-1caec.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    print(url);
    try {

      final response =   await http.put(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if(response.statusCode >= 400){
        print(response.statusCode);
        isFavorite = oldStatus;
        notifyListeners();
      }
      //notifyListeners();
    } catch (err){
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

