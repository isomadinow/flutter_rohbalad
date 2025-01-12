import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stops/views/stop_card.dart';
import '../../stops/viewmodels/stop_viemodel.dart';
import '../viewmodels/app_viewmodel.dart';
import '../../routes/viewmodels/route_viewmodel.dart';
import '../../regions/viewmodels/region_viewmodel.dart';
import '../../routes/views/route_card.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);
    final regionViewModel = appViewModel.regionViewModel;
    final routeViewModel = appViewModel.routeViewModel;
    final stopViewModel = appViewModel.stopViewModel;

    return Scaffold(
      appBar: _buildAppBar(regionViewModel, routeViewModel, stopViewModel),
      body: Column(
        children: [
          _buildSearchBar(appViewModel, routeViewModel, stopViewModel),
          _buildTabBar(appViewModel),
          Expanded(
            child: appViewModel.activeTab == "routes"
                ? _buildRoutesList(routeViewModel)
                : _buildStopsList(stopViewModel),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(RegionViewModel regionViewModel, RouteViewModel routeViewModel,
      StopViewModel stopViewModel) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.black),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: regionViewModel.selectedRegionId,
            underline: const SizedBox(),
            items: regionViewModel.regions
                .map(
                  (region) => DropdownMenuItem(
                    value: region.id,
                    child: Text(
                      region.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              if (value != null) {
                regionViewModel.setSelectedRegion(value);
                routeViewModel.fetchRoutes();
                stopViewModel.fetchStops();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppViewModel appViewModel, RouteViewModel routeViewModel,
      StopViewModel stopViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: appViewModel.activeTab == "routes"
              ? "Найти маршрут..."
              : "Найти остановку...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onSubmitted: (value) {
          if (appViewModel.activeTab == "routes") {
            routeViewModel.searchRoutes(value);
          } else {
            stopViewModel.searchStops(value);
          }
        },
      ),
    );
  }

  Widget _buildTabBar(AppViewModel appViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabButton(
            title: "Маршруты",
            isActive: appViewModel.activeTab == "routes",
            onTap: () => appViewModel.setActiveTab("routes"),
          ),
          _TabButton(
            title: "Остановки",
            isActive: appViewModel.activeTab == "stops",
            onTap: () => appViewModel.setActiveTab("stops"),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesList(RouteViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.filteredRoutes.isEmpty) {
      return const Center(child: Text("Нет маршрутов"));
    }
    return ListView.builder(
      itemCount: viewModel.filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = viewModel.filteredRoutes[index];
        return RouteCard(
          routeNumber: route.number,
          firstStop: route.stops.first,
          lastStop: route.stops.last,
          isFavorite: viewModel.favoriteRoutes.contains(route.number),
          onFavoriteTap: () => viewModel.toggleFavoriteRoute(route.number),
        );
      },
    );
  }

  Widget _buildStopsList(StopViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.filteredStops.isEmpty) {
      return const Center(child: Text("Нет остановок"));
    }
    return ListView.builder(
      itemCount: viewModel.filteredStops.length,
      itemBuilder: (context, index) {
        final stop = viewModel.filteredStops[index];
        return StopCard(
          stopName: stop.name,
          routeNumbers: stop.routes.map((route) => route.number).toList(),
          isFavorite: viewModel.favoriteStops.contains(stop.id),
          onFavoriteTap: () => viewModel.toggleFavoriteStop(stop.id),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black26, blurRadius: 4.0)]
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
