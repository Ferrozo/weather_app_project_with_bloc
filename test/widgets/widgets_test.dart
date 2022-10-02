import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app_with_bloc/control_widget.dart';
import 'package:weather_app_with_bloc/theme/cubit/theme_cubit.dart';
import 'package:weather_app_with_bloc/weather/models/weather.dart';
import 'package:weather_app_with_bloc/weather/cubit/weather_cubit.dart';
import 'package:weather_app_with_bloc/pages/weather_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockThemeCubit extends MockCubit<Color> implements ThemeCubit {}

class MockWeatherCubit extends MockCubit<WeatherState> implements WeatherCubit {
}

void main() {
  group('WeatherPage', () {
    late WeatherRepository weatherRepository;

    // ignore: unused_element
    setUp() {
      weatherRepository = MockWeatherRepository();
    }

    testWidgets('renders WeatherView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: weatherRepository,
          child: const MaterialApp(home: WeatherPage()),
        ),
      );
      expect(find.byType(WeatherView), findsOneWidget);
    });
  });

  group('WeatherView', () {
    final weather = Weather(
      temperature: const Temperature(value: 4.2),
      condition: WeatherCondition.cloudy,
      lastUpdated: DateTime(2020),
      location: 'London',
    );
    late ThemeCubit themeCubit;
    late WeatherCubit weatherCubit;

    setUp(() {
      themeCubit = MockThemeCubit();
      weatherCubit = MockWeatherCubit();
    });

    testWidgets('renders WeatherEmpty for WeatherStatus.initial',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState());
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      expect(find.byType(WeatherEmpty), findsOneWidget);
    });

    testWidgets('renders WeatherLoading for WeatherStatus.loading',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(
        WeatherState(
          status: WeatherStatus.loading,
        ),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      expect(find.byType(WeatherLoading), findsOneWidget);
    });

    testWidgets('renders WeatherPopulated for WeatherStatus.success',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(
        WeatherState(
          status: WeatherStatus.sucess,
          weather: weather,
        ),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      expect(find.byType(WeatherPopulated), findsOneWidget);
    });

    testWidgets('renders WeatherError for WeatherStatus.failure',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(
        WeatherState(
          status: WeatherStatus.failure,
        ),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      expect(find.byType(WeatherError), findsOneWidget);
    });

    testWidgets('navigates to SettingsPage when settings icon is tapped',
        (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState());
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('calls updateTheme when whether changes', (tester) async {
      whenListen(
        weatherCubit,
        Stream<WeatherState>.fromIterable([
          WeatherState(),
          WeatherState(status: WeatherStatus.sucess, weather: weather),
        ]),
      );
      when(() => weatherCubit.state).thenReturn(
        WeatherState(
          status: WeatherStatus.sucess,
          weather: weather,
        ),
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: themeCubit),
            BlocProvider.value(value: weatherCubit),
          ],
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      verify(() => themeCubit.updateTheme(weather)).called(1);
    });
    testWidgets('triggers refreshWeather on pull to refresh', (tester) async {
      when(() => weatherCubit.state).thenReturn(
        WeatherState(
          status: WeatherStatus.sucess,
          weather: weather,
        ),
      );
      when(() => weatherCubit.refreshWeather()).thenAnswer((_) async {});
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      await tester.fling(
        find.text('London'),
        const Offset(0, 500),
        1000,
      );
      await tester.pumpAndSettle();
      verify(() => weatherCubit.refreshWeather()).called(1);
    });

    testWidgets('triggers fetch on search pop', (tester) async {
      when(() => weatherCubit.state).thenReturn(WeatherState());
      when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});
      await tester.pumpWidget(
        BlocProvider.value(
          value: weatherCubit,
          child: const MaterialApp(home: WeatherView()),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Chicago');
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();
      verify(() => weatherCubit.fetchWeather('Chicago')).called(1);
    });
  });
}
