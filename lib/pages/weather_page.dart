import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_with_bloc/search/search.dart';
import 'package:weather_app_with_bloc/settings/settings.dart';
import 'package:weather_app_with_bloc/widgets/weather_empty.dart';
import 'package:weather_app_with_bloc/widgets/weather_populated.dart';
import 'package:weather_repository/weather_repository.dart';

import '../theme/cubit/theme_cubit.dart';
import '../weather/cubit/weather_cubit.dart';
import '../widgets/weather_error.dart';
import '../widgets/weather_loading.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(context.read<WeatherRepository>()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('WeatherApp'),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.indigo.withOpacity(0.15),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.of(context).push<void>(
                    SettingsPage.route(
                      context.read<WeatherCubit>(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state.status.isSucess) {
              context.read<ThemeCubit>().updateTheme(state.weather);
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.sucess:
                return WeatherPopulated(
                    weather: state.weather,
                    units: state.temperatureUnits,
                    onRefresh: () {
                      return context.read<WeatherCubit>().refreshWeather();
                    });
              case WeatherStatus.failure:
                return const WeatherError();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        child: const Icon(
          CupertinoIcons.search,
          color: Colors.black,
        ),
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
          if (!mounted) return;
          await context.read<WeatherCubit>().fetchWeather(city);
        },
      ),
    );
  }
}
