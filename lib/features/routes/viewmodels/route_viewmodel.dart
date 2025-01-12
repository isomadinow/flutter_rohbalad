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
      // Загружаем маршруты из API или fallback на заглушки
      _routes = await apiService.fetchData(
        'routes', // Ключ для API и заглушки
        (json) => TransportRoute.fromJson(json), // Преобразование JSON в модель TransportRoute
      );
      _filteredRoutes = List.from(_routes);
    } catch (e) {
      log('Ошибка загрузки маршрутов: $e');
    } finally {
      setLoading(false);
    }
  }

  void searchRoutes(String query) {
    _filteredRoutes = _routes
        .where((route) => route.number.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void toggleFavoriteRoute(String routeNumber) {
    if (_favoriteRoutes.contains(routeNumber)) {
      _favoriteRoutes.remove(routeNumber);
    } else {
      _favoriteRoutes.add(routeNumber);
    }
    notifyListeners();
  }
}
