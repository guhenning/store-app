import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/providers/auth.dart';
import 'package:store/utils/app_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        SizedBox(
            height: 120,
            child: Stack(
              children: [
                const GradientColors(),
                SafeArea(
                  child: Center(
                    child: Text(
                      'SUPER CART',
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.headlineSmall?.color,
                          fontSize: 25),
                    ),
                  ),
                ),
              ],
            )),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Store'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.authOrHome,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.orders,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Manage Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.productsManager,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About Us'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.aboutUs,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('How to use'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.howToUse,
            );
          },
        ),
        const Spacer(),
        ListTile(
          leading: const Icon(Icons.exit_to_app_rounded),
          title: const Text('Logout'),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
            //Navegate to auth or home to check if user is logged or not false = show AuthPage
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.authOrHome,
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    ));
  }
}
