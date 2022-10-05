import 'package:flutter/material.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'Loading Weather',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
