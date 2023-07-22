import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/custom_image_builder.dart';
import 'package:store/components/product_detail_card.dart';
import 'package:store/models/product.dart';
import 'package:store/providers/cart.dart';
import 'package:store/components/gradient_colors.dart';

//for when the user clicks on the item in products overview page
// showing a larger picture name description and price of that product

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientColors(),
        title: Text(
          product.name,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 300,
              width: double.infinity,
              child: CustomImageBuilder(
                fit: BoxFit.cover,
                image: product.imageUrl,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    '€ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 8),
              child: Card(
                surfaceTintColor: Colors.transparent,
                elevation: 8,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Row(
                    children: [
                      Flexible(
                        // For Add ellipsis (...) if the text exceeds the max lines
                        // lines to display
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 3,
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis (...) if the text exceeds the max lines
                              product.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              product.description,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.storeName,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Consumer<Cart>(
              builder: (ctx, cart, _) {
                return Column(
                  children: [
                    Card(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.color),
                          onPressed: () async {
                            await cart.removeSingleItem(context, product.id);
                          },
                        ),
                        FutureBuilder<void>(
                          future:
                              Future.delayed(const Duration(milliseconds: 500))
                                  .then((_) => cart.loadProducts(context)),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.5, vertical: 8),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Icon(
                                Icons.error,
                              );
                            } else {
                              final int itemCount = cart.itemCount(product.id);
                              return Text(
                                '$itemCount',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add,
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.color),
                          onPressed: () async {
                            await cart.addItem(context, product);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Product Added to Cart!'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () async {
                                    await cart.removeSingleItem(
                                        context, product.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: ProductDetailCard(onTap: () async {
                        await cart.addItem(context, product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Product Added to Cart!'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                await cart.removeSingleItem(
                                    context, product.id);
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
