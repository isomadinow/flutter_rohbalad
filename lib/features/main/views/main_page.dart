import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/views/route_card.dart';
import '../../stops/views/stop_card.dart';
import '../viewmodels/app_viewmodel.dart';
import 'widgets/region_dropdown.dart';
import 'widgets/tab_bar_switcher.dart';
import 'package:flutter_rohbalad/features/main/views/widgets/search_bar.dart' as custom;

import 'widgets/theme_selector.dart';

/// Главный экран приложения `MainPage`, позволяющий пользователю взаимодействовать
/// с маршрутами и остановками через поисковую строку, переключатель вкладок и список данных.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Строка для хранения текущего поискового запроса.
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 100) {
      setState(() {
        _appBarColor = Provider.of<AppViewModel>(context, listen: false).isDarkTheme ? Colors.black : Colors.white;
      });
    } else {
      setState(() {
        _appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<AppViewModel>().isDarkTheme ? Colors.black : Colors.white, // Фон приложения.
      appBar: AppBar(
        elevation: 0, // Убираем тень.
        backgroundColor: _appBarColor, // Фон AppBar.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegionDropdown(
              onRegionSelected: (regionId) {
                // При выборе региона обновляем данные маршрутов и остановок.
                final appViewModel = Provider.of<AppViewModel>(context, listen: false);
                appViewModel.routeViewModel.fetchRoutes();
                appViewModel.stopViewModel.fetchStops();
                setState(() {}); // Обновляем состояние, чтобы перерисовать список.
              },
            ),
            ThemeSelector(
              onThemeSelected: (isDarkTheme) {
                // Обработка смены темы.
                final appViewModel = Provider.of<AppViewModel>(context, listen: false);
                appViewModel.setTheme(isDarkTheme);
                setState(() {}); // Обновляем состояние, чтобы перерисовать интерфейс.
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Поисковая строка.
          Consumer<AppViewModel>(
            builder: (context, appViewModel, child) {
              return custom.SearchBar(
                hintText: appViewModel.activeTab == "routes"
                    ? "Найти маршрут..." // Подсказка для вкладки маршрутов.
                    : "Найти остановку...", // Подсказка для вкладки остановок.
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query; // Обновляем текущий поисковый запрос.
                  });
                  if (appViewModel.activeTab == "routes") {
                    appViewModel.routeViewModel.searchRoutes(query); // Поиск маршрутов.
                  } else {
                    appViewModel.stopViewModel.searchStops(query); // Поиск остановок.
                  }
                },
              );
            },
          ),
          // Переключатель вкладок.
          Consumer<AppViewModel>(
            builder: (context, appViewModel, child) {
              return TabBarSwitcher(
                activeTab: appViewModel.activeTab, // Текущая активная вкладка.
                onTabSelected: (tab) {
                  setState(() {
                    appViewModel.setActiveTab(tab); // Устанавливаем активную вкладку.
                    // Инициируем поиск с текущим запросом при переключении вкладки.
                    if (tab == "routes") {
                      appViewModel.routeViewModel.searchRoutes(_searchQuery);
                    } else {
                      appViewModel.stopViewModel.searchStops(_searchQuery);
                    }
                  });
                },
              );
            },
          ),
          // Динамический список маршрутов или остановок.
          Expanded(
            child: Consumer<AppViewModel>(
              builder: (context, appViewModel, child) {
                return appViewModel.activeTab == "routes"
                    ? _buildRoutesList(appViewModel) // Построение списка маршрутов.
                    : _buildStopsList(appViewModel); // Построение списка остановок.
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Метод для построения списка маршрутов.
  Widget _buildRoutesList(AppViewModel appViewModel) {
    if (appViewModel.routeViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator()); // Отображаем индикатор загрузки.
    }
    if (appViewModel.routeViewModel.filteredRoutes.isEmpty) {
      return const Center(child: Text("Нет маршрутов")); // Сообщение при отсутствии маршрутов.
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: appViewModel.routeViewModel.filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = appViewModel.routeViewModel.filteredRoutes[index];
        return RouteCard(
          routeNumber: route.number, // Номер маршрута.
          firstStop: route.stops.first, // Первая остановка маршрута.
          lastStop: route.stops.last, // Последняя остановка маршрута.
          isFavorite: appViewModel.routeViewModel.favoriteRoutes.contains(route.number), // Проверка избранного.
          onFavoriteTap: () {
            appViewModel.routeViewModel.toggleFavoriteRoute(route.number); // Переключение состояния избранного.
            setState(() {}); // Обновляем состояние, чтобы перерисовать список.
          },
        );
      },
    );
  }

  /// Метод для построения списка остановок.
  Widget _buildStopsList(AppViewModel appViewModel) {
    if (appViewModel.stopViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator()); // Отображаем индикатор загрузки.
    }
    if (appViewModel.stopViewModel.filteredStops.isEmpty) {
      return const Center(child: Text("Нет остановок")); // Сообщение при отсутствии остановок.
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: appViewModel.stopViewModel.filteredStops.length,
      itemBuilder: (context, index) {
        final stop = appViewModel.stopViewModel.filteredStops[index];
        return StopCard(
          stopName: stop.name, // Название остановки.
          routeNumbers: stop.routes.map((route) => route.number).toList(), // Список номеров маршрутов.
          isFavorite: appViewModel.stopViewModel.favoriteStops.contains(stop.id), // Проверка избранного.
          onFavoriteTap: () {
            appViewModel.stopViewModel.toggleFavoriteStop(stop.id); // Переключение состояния избранного.
            setState(() {}); // Обновляем состояние, чтобы перерисовать список.
          },
        );
      },
    );
  }
}
