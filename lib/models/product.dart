import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String storeName;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.storeName,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      storeName: json['storeName'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }

  factory Product.manual({
    required String id,
    required String name,
    required String description,
    required String storeName,
    required double price,
    required String imageUrl,
    bool isFavorite = false,
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      storeName: storeName,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
  }

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      _toggleFavorite();
      final response = await http.put(
        Uri.parse(
          '${Constants.userFavoritesUrl}/$userId/$id.json?auth=$token',
        ),
        body: jsonEncode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}
