import 'package:flutter/material.dart';

class ContinueWithGoogle extends StatelessWidget {
  final Function()? onTapGoogle;
  final Function()? onTapFaceBook;
  const ContinueWithGoogle(
      {super.key, required this.onTapGoogle, required this.onTapFaceBook});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          //gooogle + apple sign in buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTapGoogle,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(-10, -10),
                      ),
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(10, -10),
                      ),
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(-10, 10),
                      ),
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(10, 10),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/google_icon.webp'),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: onTapFaceBook,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.withOpacity(0.8),
                          blurRadius: 20,
                          offset: Offset.zero),
                    ],
                  ),
                  child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/facebook_icon.webp')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
