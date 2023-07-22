import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:store/models/cart_item.dart';
import 'package:store/models/order.dart';

import 'package:store/providers/cart.dart';
import 'package:store/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await http.get(
      Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      if (orderData['products'] != null) {
        items.add(
          Order(
            id: orderId,
            date: DateTime.parse(orderData['date']),
            total: orderData['total'],
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quantity: item['quantity'],
                price: item['price'],
                imageUrl: item['imageUrl'],
                storeName: item['storeName'],
              );
            }).toList(),
          ),
        );
      }
    });
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'name': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                    'imageUrl': cartItem.imageUrl,
                    'storeName': cartItem.storeName,
                  })
              .toList(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final firebaseId = jsonDecode(response.body)['name'];
      final newOrder = Order(
        id: firebaseId,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      );
      _items.insert(0, newOrder);
      notifyListeners();
    } else {
      throw Exception('Failed to add order.');
    }
  }
}
