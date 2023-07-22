import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/custom_image_builder.dart';
import 'package:store/models/product.dart';
import 'package:store/providers/auth.dart';
import 'package:store/providers/cart.dart';
import 'package:store/utils/app_route.dart';

class ProductOverviewListTileItem extends StatefulWidget {
  const ProductOverviewListTileItem({Key? key}) : super(key: key);

  @override
  State<ProductOverviewListTileItem> createState() =>
      _ProductOverviewListTileItemState();
}

class _ProductOverviewListTileItemState
    extends State<ProductOverviewListTileItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CustomImageBuilder(
            image: product.imageUrl,
          ),
        ),
      ),
      title: Text(
        product.name.length > 45
            ? '${product.name.substring(0, 45)}...'
            : product.name,
        style: TextStyle(
          color: Theme.of(context).textTheme.headlineLarge?.color,
        ),
        textAlign: TextAlign.start,
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    product.description,
                    maxLines: 2, // Maximum number of lines before truncation
                    overflow: TextOverflow
                        .ellipsis, // Truncate text with '...' if it exceeds the maximum lines
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                product.storeName.length > 20
                    ? '${product.storeName.substring(0, 20)}...'
                    : product.storeName,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '€${product.price.toStringAsFixed(2)} ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              color: Theme.of(context).hintColor,
              onPressed: () {
                product.toggleFavorite(
                  auth.token ?? '',
                  auth.userId ?? '',
                );
              },
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                size: 28,
              ),
            ),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, _) {
              return IconButton(
                color: Theme.of(context).hintColor,
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
                          await cart.removeSingleItem(context, product.id);
                        },
                      ),
                    ),
                  );
                },
                icon: FutureBuilder<void>(
                  future: Future.delayed(const Duration(milliseconds: 500))
                      .then((_) => cart.loadProducts(ctx)),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Icon(
                        Icons.add_shopping_cart,
                        size: 28,
                      );
                    } else if (snapshot.hasError) {
                      // to do show error
                      return const Icon(Icons.error);
                    } else {
                      final int itemCount = cart.itemCount(product.id);
                      return Badge(
                        backgroundColor: Theme.of(context).hintColor,
                        isLabelVisible: true,
                        alignment: const AlignmentDirectional(2.0, -2.0),
                        label: Text(
                          '$itemCount',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          size: 28,
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.productDetail,
          arguments: product,
        );
      },
    );
  }
}
