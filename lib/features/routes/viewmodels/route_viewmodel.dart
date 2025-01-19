import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
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
      await _loadFavoriteRoutes();
      _sortRoutes(); // Сортируем маршруты с учетом избранного.
    } catch (e) {
      log('Ошибка загрузки маршрутов: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void searchRoutes(String query) {
    if (query.isEmpty) {
      _filteredRoutes = List.from(_routes);
    } else {
      _filteredRoutes = _routes
          .where((route) =>
              route.number.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    _sortRoutes(); // Сортируем после поиска.
    notifyListeners();
  }

  void toggleFavoriteRoute(String routeNumber) {
    if (_favoriteRoutes.contains(routeNumber)) {
      _favoriteRoutes.remove(routeNumber);
    } else {
      _favoriteRoutes.add(routeNumber);
    }
    _saveFavoriteRoutes();
    _sortRoutes(); // Пересортируем маршруты.
    notifyListeners();
  }

  Future<void> _loadFavoriteRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favoriteRoutes');
    if (favorites != null) {
      _favoriteRoutes.addAll(favorites);
    }
  }

  Future<void> _saveFavoriteRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteRoutes', _favoriteRoutes.toList());
  }

  void _sortRoutes() {
    _filteredRoutes.sort((a, b) {
      final aFavorite = _favoriteRoutes.contains(a.number);
      final bFavorite = _favoriteRoutes.contains(b.number);
      if (aFavorite && !bFavorite) return -1;
      if (!aFavorite && bFavorite) return 1;
      return 0;
    });
  }
}
