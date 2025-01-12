import 'package:flutter/material.dart';
import '../../../core/api_service.dart';
import '../../regions/viewmodels/region_viewmodel.dart';
import '../../routes/viewmodels/route_viewmodel.dart';
import '../../stops/viewmodels/stop_viemodel.dart';

class AppViewModel extends ChangeNotifier {
  final RegionViewModel regionViewModel;
  final RouteViewModel routeViewModel;
  final StopViewModel stopViewModel;

  String _activeTab = "routes";

  AppViewModel({required ApiService apiService})
      : regionViewModel = RegionViewModel(apiService: apiService),
        routeViewModel = RouteViewModel(apiService: apiService),
        stopViewModel = StopViewModel(apiService: apiService);

  String get activeTab => _activeTab;

  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }
void search(String query) {
  if (_activeTab == "routes") {
    routeViewModel.searchRoutes(query);
  } else if (_activeTab == "stops") {
    stopViewModel.searchStops(query);
  }
}

  Future<void> initialize() async {
    await regionViewModel.fetchRegions();
    await routeViewModel.fetchRoutes();
    await stopViewModel.fetchStops();
    notifyListeners();
  }
}
