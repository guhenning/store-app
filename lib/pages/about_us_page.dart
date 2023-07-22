import 'package:flutter/material.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/utils/app_route.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientColors(),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(
              AppRoutes.authOrHome,
            );
          },
        ),
        title: Text(
          'About Us',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      // to do about us
      body: const Center(child: Text('ABOUT US')),
    );
  }
}
