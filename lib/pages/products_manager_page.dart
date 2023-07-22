import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/app_drawer.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/components/product_manager_item.dart';
import 'package:store/providers/product_list.dart';
import 'package:store/utils/app_route.dart';

class ProductsManagerPage extends StatelessWidget {
  const ProductsManagerPage({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientColors(),
        centerTitle: true,
        title: Text(
          'Products Manager',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.productForm,
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListView.builder(
              itemCount: products.itemsCount,
              itemBuilder: (ctx, i) => Column(
                children: [
                  ProductManagerItem(products.items[i]),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
