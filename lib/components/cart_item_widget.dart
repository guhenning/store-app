import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/custom_image_builder.dart';
import 'package:store/models/cart_item.dart';
import 'package:store/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Dismissible(
        key: ValueKey(cartItem.id),
        background: Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.only(right: 20, left: 20),
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Theme.of(context).textTheme.titleSmall?.color,
                size: 40,
              ),
              const Spacer(),
              Icon(
                Icons.delete,
                color: Theme.of(context).textTheme.titleSmall?.color,
                size: 40,
              ),
            ],
          ),
        ),
        onDismissed: (_) {
          final cartProvider = Provider.of<Cart>(context, listen: false);
          cartProvider.removeAllItems(context, cartItem.productId);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: ListTile(
            leading: ClipOval(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CustomImageBuilder(
                  image: cartItem.imageUrl,
                ),
              ),
            ),
            title: Text(
              cartItem.name,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headlineLarge?.color),
              textAlign: TextAlign.start,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '€ ${(cartItem.price).toStringAsFixed(2)} per Unit',
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.headlineMedium?.color),
                ),
                Text(
                  'Total: € ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${cartItem.quantity}x'),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).textTheme.titleSmall?.color,
                    size: 20,
                  ),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeSingleItem(context, cartItem.productId);
                  },
                ),
              ],
            ),
          ),
        ),
        confirmDismiss: (_) {
          return showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Center(
                child: Text('Confirm Delete?',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color)),
              ),
              content: const Text(
                  'Do you want to remove this product from the cart?'),
              actions: [
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
