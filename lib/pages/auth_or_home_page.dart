import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/pages/auth_page.dart';
import 'package:store/pages/products_overview_page.dart';
import 'package:store/providers/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          // print('Connection State: ${snapshot.connectionState}');
          // print('Has Error: ${snapshot.hasError}');
          // print('Error: ${snapshot.error}');
          return const Center(
            child: Text('An error occurred'),
          );
        } else {
          return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
        }
      },
    );
  }
}
