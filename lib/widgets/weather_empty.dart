import 'package:flutter/material.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'src/assets/sun.png',
            width: 150,
          ),
          const SizedBox(
            height: 70,
          ),
          const Text(
            'Click search button to',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'search a location or city',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
