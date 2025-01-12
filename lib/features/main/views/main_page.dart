import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/views/route_card.dart';
import '../../stops/views/stop_card.dart';
import '../viewmodels/app_viewmodel.dart';
import 'widgets/region_dropdown.dart';
import 'widgets/tab_bar_switcher.dart';
import 'widgets/search_bar.dart';
import 'package:flutter_rohbalad/features/main/views/widgets/search_bar.dart' as custom;
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: RegionDropdown(
          onRegionSelected: (regionId) {
            final appViewModel = context.read<AppViewModel>();
            appViewModel.routeViewModel.fetchRoutes();
            appViewModel.stopViewModel.fetchStops();
          },
        ),
      ),
      body: Column(
        children: [
          Consumer<AppViewModel>(
            builder: (context, appViewModel, child) {
              return custom.SearchBar(
                hintText: appViewModel.activeTab == "routes"
                    ? "Найти маршрут..."
                    : "Найти остановку...",
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                  if (appViewModel.activeTab == "routes") {
                    appViewModel.routeViewModel.searchRoutes(query);
                  } else {
                    appViewModel.stopViewModel.searchStops(query);
                  }
                },
              );
            },
          ),
          Consumer<AppViewModel>(
            builder: (context, appViewModel, child) {
              return TabBarSwitcher(
                activeTab: appViewModel.activeTab,
                onTabSelected: (tab) {
                  setState(() {
                    // При переключении вкладки инициировать поиск с текущим запросом
                    appViewModel.setActiveTab(tab);
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
          Expanded(
            child: Consumer<AppViewModel>(
              builder: (context, appViewModel, child) {
                return appViewModel.activeTab == "routes"
                    ? _buildRoutesList(appViewModel)
                    : _buildStopsList(appViewModel);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesList(AppViewModel appViewModel) {
    if (appViewModel.routeViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (appViewModel.routeViewModel.filteredRoutes.isEmpty) {
      return const Center(child: Text("Нет маршрутов"));
    }
    return ListView.builder(
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
          },
        );
      },
    );
  }

  Widget _buildStopsList(AppViewModel appViewModel) {
    if (appViewModel.stopViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (appViewModel.stopViewModel.filteredStops.isEmpty) {
      return const Center(child: Text("Нет остановок"));
    }
    return ListView.builder(
      itemCount: appViewModel.stopViewModel.filteredStops.length,
      itemBuilder: (context, index) {
        final stop = appViewModel.stopViewModel.filteredStops[index];
        return StopCard(
          stopName: stop.name,
          routeNumbers: stop.routes.map((route) => route.number).toList(),
          isFavorite: appViewModel.stopViewModel.favoriteStops.contains(stop.id),
          onFavoriteTap: () {
            appViewModel.stopViewModel.toggleFavoriteStop(stop.id);
          },
        );
      },
    );
  }
}
