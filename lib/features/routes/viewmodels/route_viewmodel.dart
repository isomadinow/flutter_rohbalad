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

    // Если оба маршрута не в избранном, сортируем по "естественному порядку".
    return _naturalSort(a.number, b.number);
  });
}

/// Метод для естественной сортировки строк.
int _naturalSort(String a, String b) {
  final regExp = RegExp(r'(\d+|\D+)'); // Разделяем строки на числа и текст.
  final aParts = regExp.allMatches(a).map((m) => m.group(0)!).toList();
  final bParts = regExp.allMatches(b).map((m) => m.group(0)!).toList();

  for (var i = 0; i < aParts.length && i < bParts.length; i++) {
    final aPart = aParts[i];
    final bPart = bParts[i];

    // Если оба элемента числа, сравниваем их как числа.
    final aInt = int.tryParse(aPart);
    final bInt = int.tryParse(bPart);

    if (aInt != null && bInt != null) {
      final compare = aInt.compareTo(bInt);
      if (compare != 0) return compare;
    } else {
      // Если элементы текстовые, сравниваем как строки.
      final compare = aPart.compareTo(bPart);
      if (compare != 0) return compare;
    }
  }

  // Если все части равны, сравниваем длину.
  return aParts.length.compareTo(bParts.length);
}


}
