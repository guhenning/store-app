import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/components/cart_item_widget.dart';
import 'package:store/providers/cart.dart';
import 'package:store/providers/order_list.dart';
import 'package:store/utils/constants.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Cart>(context, listen: false)
        .loadProducts(context)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: const GradientColors(),
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: GradientColors(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          child: Text(
                            '€${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              //change
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartBuyButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) => CartItemWidget(
                  cartItem: items[i],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartBuyButton extends StatefulWidget {
  const CartBuyButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CartBuyButton> createState() => _CartBuyButtonState();
}

class _CartBuyButtonState extends State<CartBuyButton> {
  bool _isLoading = false;
  int itemsCount = 0;

  @override
  void initState() {
    super.initState();
    final cart = Provider.of<Cart>(context, listen: false);
    cart.getItemsCount(context).then((count) {
      setState(() {
        itemsCount = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: widget.cart.getItemsCount(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasData) {
          itemsCount = snapshot.data!;
          return TextButton(
            onPressed: itemsCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await Provider.of<OrderList>(
                      context,
                      listen: false,
                    ).addOrder(widget.cart);

                    await _clearFirebaseCart();
                    widget.cart.clear(context);
                    setState(() => _isLoading = false);
                  },
            child: Text(
              'Buy',
              style: TextStyle(
                color:
                    itemsCount == 0 ? Colors.grey : Theme.of(context).hintColor,
                fontSize: 18,
              ),
            ),
          );
        } else {
          return const Text('-');
        }
      },
    );
  }

  Future<void> _clearFirebaseCart() async {
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final String token = cart.token;
    final String userId = cart.userId;

    // Update the Firebase cart with an empty cart item list
    final url = '${Constants.cartBaseUrl}/$userId.json?auth=$token';
    await http.put(Uri.parse(url), body: '[]');
  }
}
