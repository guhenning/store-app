import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/pages/about_us_page.dart';
import 'package:store/pages/auth_or_home_page.dart';
import 'package:store/pages/how_to_use_page.dart';
import 'package:store/providers/auth.dart';
import 'package:store/pages/cart_page.dart';
import 'package:store/pages/orders_page.dart';
import 'package:store/pages/product_detail_page.dart';
import 'package:store/pages/product_form_page.dart';
import 'package:store/pages/products_manager_page.dart';
import 'package:store/providers/cart.dart';
import 'package:store/providers/order_list.dart';
import 'package:store/providers/product_list.dart';
import 'package:store/utils/app_route.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
            create: (_) => OrderList(),
            update: (ctx, auth, previous) {
              return OrderList(
                auth.token ?? '',
                auth.userId ?? '',
                previous?.items ?? [],
              );
            }),
        ChangeNotifierProxyProvider2<Auth, ProductList, Cart>(
          create: (_) => Cart('', ''),
          update: (ctx, auth, productList, previous) {
            return Cart(
              auth.token ?? '',
              auth.userId ?? '',
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          primaryColor: Colors.cyanAccent,
          hintColor: const Color.fromARGB(255, 0, 205,
              172), // used before const Color.fromARGB(255, 74, 212, 154), //lighter from gradient is Color.fromARGB(255, 0, 205,  172),
          useMaterial3: true,
          fontFamily: 'Lato',
          textTheme: TextTheme(
            headlineSmall: const TextStyle(color: Colors.white),
            headlineMedium: const TextStyle(color: Colors.grey),
            headlineLarge: const TextStyle(color: Colors.black),
            titleLarge: const TextStyle(color: Colors.blue),
            titleMedium:
                const TextStyle(color: Color.fromARGB(255, 61, 190, 172)),
            titleSmall: TextStyle(color: Colors.red[300]),
            bodyLarge: const TextStyle(
              color: Colors.black45,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color.fromARGB(255, 61, 190,
                  172)), // lighter from gradient is Color.fromARGB(255, 0, 205,  172),
          inputDecorationTheme: InputDecorationTheme(
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(90),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(90),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(90),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 61, 190,
                      172)), // lighter from gradient is Color.fromARGB(255, 0, 205,  172),
              borderRadius: BorderRadius.circular(90),
            ),
            labelStyle: const TextStyle(
                color: Color.fromARGB(255, 61, 190,
                    172)), // lighter from gradient is Color.fromARGB(255, 0, 205,  172),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => const Color.fromARGB(255, 61, 190,
                    172), // lighter from gradient is Color.fromARGB(255, 0, 205,  172),
              ),
            ),
          ),
        ),
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.productDetail: (ctx) => const ProductDetailPage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.productsManager: (ctx) => const ProductsManagerPage(),
          AppRoutes.productForm: (ctx) => const ProductFormPage(),
          AppRoutes.aboutUs: (ctx) => const AboutUsPage(),
          AppRoutes.howToUse: (ctx) => const HowToUsePage()
        },
      ),
    );
  }
}
