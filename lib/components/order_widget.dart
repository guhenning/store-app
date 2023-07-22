import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store/models/order.dart';

//widget for each order in order page
// show user date total amount and expanding to see the products quantity name ands price

class OrderWidget extends StatelessWidget {
  final Order order;
  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 9.0,
          vertical: 2,
        ),
        child: Card(
          child: ExpansionTile(
            leading: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                DateFormat('dd/MM/yyyy').format(order.date),
                style: TextStyle(
                    color: Theme.of(context).textTheme.headlineSmall?.color),
              ),
            ),
            title: Text('Total: € ${order.total.toStringAsFixed(2)}'),
            children: order.products.map(
              (product) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).hintColor.withOpacity(0.2),
                        child: Text(
                          '${product.quantity}x',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //name max lenght 19
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              product.name.length > 19
                                  ? '${product.name.substring(0, 19)}...'
                                  : product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          //storeName max length 30
                          Row(
                            children: [
                              FittedBox(
                                child: Text(
                                  '€ ${product.price.toStringAsFixed(2)} per Unit.',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  product.storeName.length > 30
                                      ? '${product.storeName.substring(0, 30)}...'
                                      : product.storeName,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      const Spacer(),
                      FittedBox(
                        child: Text(
                          '€ ${(product.price * product.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ));
  }
}
