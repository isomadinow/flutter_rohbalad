import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_service.dart';
import 'features/main/viewmodels/app_viewmodel.dart';
import 'features/routes/viewmodels/route_viewmodel.dart';
import 'features/stops/viewmodels/stop_viemodel.dart';
import 'features/regions/viewmodels/region_viewmodel.dart';
import 'features/main/views/main_page.dart';
import 'features/main/views/widgets/theme_selector.dart'; // Импортируем виджет выбора темы.

/// Точка входа в приложение.
void main() {
  runApp(const MyApp());
}

/// Главный виджет приложения.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Провайдер для API-сервиса, используемого для взаимодействия с данными.
        Provider<ApiService>(
          create: (_) => ApiService(
            baseUrl: "https://api.example.com", // Базовый URL API.
            useMockData: true, // Использовать ли моковые данные.
          ),
        ),
        // Провайдер для основного AppViewModel, инициализирующего данные приложения.
        ChangeNotifierProvider(
          create: (context) {
            final appViewModel = AppViewModel(apiService: context.read<ApiService>());
            appViewModel.initialize(); // Загружаем начальные данные.
            return appViewModel;
          },
        ),
        // Провайдер для RouteViewModel, отвечающего за управление маршрутами.
        ChangeNotifierProvider(
          create: (context) => RouteViewModel(apiService: context.read<ApiService>()),
        ),
        // Провайдер для StopViewModel, отвечающего за управление остановками.
        ChangeNotifierProvider(
          create: (context) => StopViewModel(apiService: context.read<ApiService>()),
        ),
        // Провайдер для RegionViewModel, отвечающего за управление регионами.
        ChangeNotifierProvider(
          create: (context) => RegionViewModel(apiService: context.read<ApiService>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false, // Убираем баннер режима отладки.
            title: 'Routes App', // Название приложения.
            theme: ThemeData.light(), // Основная светлая тема приложения.
            darkTheme: ThemeData.dark(), // Основная темная тема приложения.
            themeMode: context.watch<AppViewModel>().isDarkTheme ? ThemeMode.dark : ThemeMode.light, // Устанавливаем тему.
            home: const MainPage(), // Главный экран приложения.
          );
        },
      ),
    );
  }
}
