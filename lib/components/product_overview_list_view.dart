import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/product_overview_list_tile_item.dart';
import 'package:store/models/product.dart';
import 'package:store/providers/product_list.dart';

class ProductOverviewListView extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductOverviewListView(this.showFavoriteOnly, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        key: ValueKey(loadedProducts[i].id),
        child: const ProductOverviewListTileItem(),
      ),
    );
  }
}
