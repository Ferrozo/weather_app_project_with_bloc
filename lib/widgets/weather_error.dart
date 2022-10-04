import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Error:', style: TextStyle(fontSize: 30)),
        Text('Error 404!', style: theme.textTheme.headline5),
      ],
    );
  }
}
