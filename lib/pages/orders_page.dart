import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/app_drawer.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/components/order_widget.dart';
import 'package:store/providers/order_list.dart';
import 'package:store/utils/app_route.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientColors(),
        centerTitle: true,
        title: Text(
          'My Previews Orders',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: ((context, snapshot) {
          // print('Connection State: ${snapshot.connectionState}');
          // print('Has Error: ${snapshot.hasError}');
          // print('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return AlertDialog(
              backgroundColor: Theme.of(context).primaryColorLight,
              surfaceTintColor: Colors.white,
              title: Center(
                child: Text(
                  'Error',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                  ),
                ),
              ),
              content: const Text(
                'An error occurred while loading orders.',
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.authOrHome,
                    );
                  },
                ),
              ],
            );
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
