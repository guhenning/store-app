import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/custom_image_builder.dart';
import 'package:store/exceptions/http_exception.dart';
import 'package:store/models/product.dart';
import 'package:store/providers/product_list.dart';
import 'package:store/utils/app_route.dart';

class ProductManagerItem extends StatelessWidget {
  final Product product;
  const ProductManagerItem(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = ScaffoldMessenger.of(context);

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
      ),
      subtitle: Row(
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
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product,
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).hintColor,
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Center(
                      child: Text(
                        'Delete Product',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleMedium?.color),
                      ),
                    ),
                    content: const Text(
                      'Are you sure?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(
                          'No',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.color,
                              fontSize: 20),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductList>(
                        context,
                        listen: false,
                      ).removeProduct(product);
                    } on HttpRequestException catch (error) {
                      errorMessage.showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    }
                  }
                });
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).textTheme.titleSmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}
