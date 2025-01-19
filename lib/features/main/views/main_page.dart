import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/views/route_card.dart';
import '../../stops/views/stop_card.dart';
import '../viewmodels/app_viewmodel.dart';
import 'widgets/region_dropdown.dart';
import 'widgets/tab_bar_switcher.dart';
import 'package:flutter_rohbalad/features/main/views/widgets/search_bar.dart' as custom;

import 'widgets/theme_selector.dart';

/// Главный экран приложения `MainPage`.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Строка для хранения текущего поискового запроса.
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<AppViewModel>().isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0, // Убираем тень.
        backgroundColor: Colors.grey, // Серый фон AppBar.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Здесь вместо выпадающего списка просто отображаем текст текущего региона.
            RegionDropdown(
              regionName: "Худжанд", // Текущий регион (можно динамически подгружать из ViewModel).
            ),
            ThemeSelector(
              onThemeSelected: (isDarkTheme) {
                final appViewModel = Provider.of<AppViewModel>(context, listen: false);
                appViewModel.setTheme(isDarkTheme);
                setState(() {}); // Перерисовываем интерфейс при смене темы.
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
      return const Center(child: CircularProgressIndicator());
    }
    if (appViewModel.routeViewModel.filteredRoutes.isEmpty) {
      return const Center(child: Text("Нет маршрутов"));
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: appViewModel.routeViewModel.filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = appViewModel.routeViewModel.filteredRoutes[index];
        return RouteCard(
          routeNumber: route.number,
          firstStop: route.stops.first,
          lastStop: route.stops.last,
          isFavorite: appViewModel.routeViewModel.favoriteRoutes.contains(route.number),
          onFavoriteTap: () {
            appViewModel.routeViewModel.toggleFavoriteRoute(route.number);
            setState(() {});
          },
        );
      },
    );
  }

  /// Метод для построения списка остановок.
  Widget _buildStopsList(AppViewModel appViewModel) {
    if (appViewModel.stopViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (appViewModel.stopViewModel.filteredStops.isEmpty) {
      return const Center(child: Text("Нет остановок"));
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: appViewModel.stopViewModel.filteredStops.length,
      itemBuilder: (context, index) {
        final stop = appViewModel.stopViewModel.filteredStops[index];
        return StopCard(
          stopName: stop.name,
          routeNumbers: stop.routes.map((route) => route.number).toList(),
          isFavorite: appViewModel.stopViewModel.favoriteStops.contains(stop.id),
          onFavoriteTap: () {
            appViewModel.stopViewModel.toggleFavoriteStop(stop.id);
            setState(() {});
          },
        );
      },
    );
  }
}
