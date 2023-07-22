import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store/models/product.dart';
import 'package:store/utils/constants.dart';
import 'package:store/exceptions/http_exception.dart';

import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts(BuildContext context) async {
    try {
      _items.clear();
      final response = await http.get(
        Uri.parse('${Constants.productBaseUrl}/$_userId.json?auth=$_token'),
      );
      if (response.body == 'null') return;

      final favResponse = await http.get(
        Uri.parse('${Constants.userFavoritesUrl}/$_userId.json?auth=$_token'),
      );

      Map<String, dynamic> favData =
          favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((productId, productData) {
        final isFavorite = favData[productId] ?? false;
        _items.add(
          Product(
            id: productId,
            name: productData['name'],
            description: productData['description'],
            storeName: productData['storeName'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: isFavorite,
          ),
        );
      });
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          content: const Text(
            'An error occurred while loading products.',
          ),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  // Reorder by Product Name A to Z
  Future<void> reorderProductsByNameAZ() async {
    _items.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  // Reorder by Product Name Z to A
  Future<void> reorderProductsByNameZA() async {
    _items.sort((a, b) => b.name.compareTo(a.name));
    notifyListeners();
  }

  // Reorder by Store Name A to Z
  Future<void> reorderProductsByStoreNameAZ() async {
    _items.sort((a, b) => a.storeName.compareTo(b.storeName));
    notifyListeners();
  }

  // Reorder by Store Name Z to A
  Future<void> reorderProductsByStoreNameZA() async {
    _items.sort((a, b) => b.storeName.compareTo(a.storeName));
    notifyListeners();
  }

  // Reorder by Price Low to High
  Future<void> reorderProductsByPriceLowToHigh() async {
    _items.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  // Reorder by Price Low to High
  Future<void> reorderProductsByPriceHighToLow() async {
    _items.sort((a, b) => b.price.compareTo(a.price));
    notifyListeners();
  }

  // Reset _items to original order
  Future<void> restoreOriginalOrder(BuildContext context) async {
    loadProducts(context);
    notifyListeners();
  }

  //Search Products By Name or Store Name and reset list if query is empty
  void searchProducts(BuildContext context, String query) {
    if (query.isEmpty) {
      // If the search query is empty, reset the list to show all items
      restoreOriginalOrder(context);
    } else {
      // Capitalize the first letter of the search query

      query.substring(0, 1).toUpperCase() + query.substring(1);

      // Filter the items based on a case-insensitive partial match of the search query
      _items = _items
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.storeName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      storeName: data['storeName'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'storeName': product.storeName,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );

    final firebaseId = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: firebaseId,
      name: product.name,
      description: product.description,
      storeName: product.storeName,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> loadProductsFromJsonUrl(String jsonUrl) async {
    final response = await http.get(Uri.parse(jsonUrl));
    //print('JSON Response: ${response.body}');

    final dynamic jsonData = jsonDecode(response.body);

    if (jsonData is Map && jsonData.containsKey('products')) {
      final List<dynamic> productsData = jsonData['products'];

      for (final productData in productsData) {
        final product = Product(
          id: productData['id'].toString(),
          name: productData['name'],
          description: productData['description'],
          storeName: productData['storeName'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
        );

        addProduct(product);
      }
    } else {
      throw Exception('Invalid JSON data');
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productBaseUrl}/$_userId/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'storeName': product.storeName,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.productBaseUrl}/$_userId/${product.id}.json?auth=$_token'),
      );

      //Error bigger or equal to 400 = server errors, get the product back and show message
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpRequestException(
          errorMessage: 'Error deleting the product, try again later.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
