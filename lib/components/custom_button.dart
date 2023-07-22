import 'package:flutter/material.dart';
import 'package:store/components/gradient_colors.dart';

class PersonalizedButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const PersonalizedButton(
      {Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GradientColors(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 18,
                color: Theme.of(context).textTheme.headlineSmall?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
