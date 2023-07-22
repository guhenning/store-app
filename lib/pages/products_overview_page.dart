import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/app_drawer.dart';
import 'package:store/components/flotating_menu.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/components/product_overview_list_view.dart';

import 'package:store/providers/cart.dart';
import 'package:store/providers/product_list.dart';
import 'package:store/utils/app_route.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({
    super.key,
  });

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }

    Provider.of<ProductList>(context, listen: false)
        .loadProducts(context)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        Provider.of<ProductList>(context, listen: false)
            .searchProducts(context, '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: const GradientColors(),
        title: Text(
          'Super Cart',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
          PopupMenuButton(
            icon: _showFavoriteOnly
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border_outlined),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('All Products'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, _) {
              return FutureBuilder<int>(
                future: Future.delayed(const Duration(milliseconds: 500))
                    .then((_) => cart.getItemsCount(ctx)),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.cart);
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                        ));
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else {
                    final int totalItemsCount = snapshot.data ?? 0;
                    return Badge(
                      backgroundColor: Theme.of(context).hintColor,
                      isLabelVisible: true,
                      alignment: const AlignmentDirectional(0.3, -0.5),
                      label: Text(
                        totalItemsCount.toString(),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.cart);
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: _isSearching,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _searchController,
                onChanged: (query) {
                  Provider.of<ProductList>(context, listen: false)
                      .searchProducts(context, query);
                },
                decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder:
                        Theme.of(context).inputDecorationTheme.focusedBorder,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _toggleSearch();
                      },
                    )),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ProductOverviewListView(_showFavoriteOnly),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: const FlotatingMenu(),
    );
  }
}
