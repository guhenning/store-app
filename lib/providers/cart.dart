import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:store/models/cart_item.dart';
import 'package:store/models/product.dart';
import 'package:store/utils/constants.dart';

class Cart with ChangeNotifier {
  final String token;
  final String userId;
  Map<String, CartItem> _items = {};

  Cart(this.token, this.userId);

  Map<String, CartItem> get items {
    return {..._items};
  }

  Future<int> getItemsCount(BuildContext context) async {
    await loadProducts(context);
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> addItem(BuildContext context, Product product) async {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
          storeName: existingItem.storeName,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
          imageUrl: product.imageUrl,
          storeName: product.storeName,
        ),
      );
    }
    notifyListeners();

    await _updateCartOnFirebase(context);
  }

  Future<void> removeAllItems(BuildContext context, String productId) async {
    _items.remove(productId);
    notifyListeners();

    await _updateCartOnFirebase(context);
  }

  Future<void> removeSingleItem(BuildContext context, String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
          storeName: existingItem.storeName,
        ),
      );
    }
    notifyListeners();

    await _updateCartOnFirebase(context);
  }

  Future<void> clear(BuildContext context) async {
    _items = {};
    notifyListeners();

    await _updateCartOnFirebase(context);
  }

  int itemCount(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId]!.quantity;
    }
    return 0;
  }

  Future<void> _updateCartOnFirebase(BuildContext context) async {
    try {
      final url = '${Constants.cartBaseUrl}/$userId.json?auth=$token';

      final List<Map<String, dynamic>> cartItemsData =
          _items.values.map((cartItem) {
        return {
          'id': cartItem.id,
          'productId': cartItem.productId,
          'name': cartItem.name,
          'quantity': cartItem.quantity,
          'price': cartItem.price,
          'imageUrl': cartItem.imageUrl,
          'storeName': cartItem.storeName,
        };
      }).toList();

      // print('Updating cart on Firebase: $cartItemsData');

      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(cartItemsData),
      );

      //   // print('Firebase response: ${response.body}');
      // } catch (error) {
      //   // print('Error updating cart on Firebase: $error');
    } catch (error) {
      if (error == true) {
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
              'An error occurred while loading products in cart.',
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

        error == false;
      }
    }
  }

  Future<void> loadProducts(BuildContext context) async {
    _items.clear();

    try {
      final url = '${Constants.cartBaseUrl}/$userId.json?auth=$token';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>?;

        if (data != null) {
          for (final cartItemData in data) {
            final cartItem = CartItem(
              id: cartItemData['id'],
              productId: cartItemData['productId'],
              name: cartItemData['name'],
              quantity: cartItemData['quantity'],
              price: cartItemData['price'],
              imageUrl: cartItemData['imageUrl'],
              storeName: cartItemData['storeName'],
            );

            _items.putIfAbsent(cartItem.productId, () => cartItem);
          }
        }
      }
    } catch (error) {
      // print('Error loading cart products: $error');
      if (error == true) {
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
              'An error occurred while loading products in cart.',
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

        error == false;
      }
    }
  }
}
