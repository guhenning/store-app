import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipPath(
                        clipper: WaveClipperTwo(flip: true),
                        child: const SizedBox(
                            height: 260,
                            width: 360,
                            child: GradientColors(
                              opacity: 0.5,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipPath(
                        clipper: WaveClipperTwo(),
                        child: const SizedBox(
                            height: 271,
                            width: 320,
                            child: GradientColors(
                              opacity: 0.4,
                            )),
                      ),
                    ],
                  ),
                  ClipPath(
                    clipper: WaveClipperTwo(),
                    child: const SizedBox(height: 270, child: GradientColors()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 230,
                          height: 230,
                          child: Image.asset(
                            'assets/images/cart_logo.webp',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthForm(),
                  ],
                ),
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Image.asset('assets/images/form2.webp', height: 150),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
