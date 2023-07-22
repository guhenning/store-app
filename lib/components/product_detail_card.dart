import 'package:flutter/material.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/models/product.dart';

class ProductDetailCard extends StatelessWidget {
  final Function()? onTap;
  const ProductDetailCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Card(
      elevation: 8,
      child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GradientColors(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    Text(
                      'ADD TO CART',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.headlineSmall?.color),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
