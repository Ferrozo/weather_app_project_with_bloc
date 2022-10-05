import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'src/assets/error.png',
          width: 100,
        ),
        const SizedBox(height: 20),
        const Text(
          'Something went wrong. \nTry again',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
