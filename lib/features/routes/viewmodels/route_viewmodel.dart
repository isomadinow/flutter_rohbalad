import 'dart:developer';
import '../../../core/api_service.dart';
import '../../../core/base_viewmodel.dart';
import '../models/transport_route.dart';

class RouteViewModel extends BaseViewModel {
  final ApiService apiService;

  RouteViewModel({required this.apiService});

  List<TransportRoute> _routes = [];
  List<TransportRoute> _filteredRoutes = [];
  final Set<String> _favoriteRoutes = {};

  List<TransportRoute> get filteredRoutes => _filteredRoutes;
  Set<String> get favoriteRoutes => _favoriteRoutes;

  Future<void> fetchRoutes() async {
    setLoading(true);
    try {
      _routes = await apiService.fetchData(
        'routes',
        (json) => TransportRoute.fromJson(json),
      );
      _filteredRoutes = List.from(_routes);
      log('Маршруты загружены: ${_routes.length}');
    } catch (e) {
      log('Ошибка загрузки маршрутов: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void searchRoutes(String query) {
    _filteredRoutes = _routes
        .where((route) => route.number.toLowerCase().contains(query.toLowerCase()))
        .toList();
    log('Найденные маршруты: ${_filteredRoutes.length}');
    notifyListeners();
  }

  void toggleFavoriteRoute(String routeNumber) {
    if (_favoriteRoutes.contains(routeNumber)) {
      _favoriteRoutes.remove(routeNumber);
    } else {
      _favoriteRoutes.add(routeNumber);
    }
    log('Избранные маршруты: $_favoriteRoutes');
    notifyListeners();
  }
}
