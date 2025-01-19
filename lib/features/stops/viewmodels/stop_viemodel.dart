import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_service.dart';
import '../../../core/base_viewmodel.dart';
import '../models/stop.dart';

class StopViewModel extends BaseViewModel {
  final ApiService apiService;

  StopViewModel({required this.apiService});

  List<Stop> _stops = [];
  List<Stop> _filteredStops = [];
  final Set<String> _favoriteStops = {};

  List<Stop> get filteredStops => _filteredStops;
  Set<String> get favoriteStops => _favoriteStops;

  Future<void> fetchStops() async {
    setLoading(true);
    try {
      _stops = await apiService.fetchData(
        'stops',
        (json) => Stop.fromJson(json),
      );
      _filteredStops = List.from(_stops);
      await _loadFavoriteStops();
      _sortStops(); // Сортируем остановки с учетом избранного.
    } catch (e) {
      log('Ошибка загрузки остановок: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void searchStops(String query) {
    if (query.isEmpty) {
      _filteredStops = List.from(_stops);
    } else {
      _filteredStops = _stops
          .where((stop) => stop.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    _sortStops(); // Сортируем после поиска.
    notifyListeners();
  }

  void toggleFavoriteStop(String stopId) {
    if (_favoriteStops.contains(stopId)) {
      _favoriteStops.remove(stopId);
    } else {
      _favoriteStops.add(stopId);
    }
    _saveFavoriteStops();
    _sortStops(); // Пересортируем остановки.
    notifyListeners();
  }

  Future<void> _loadFavoriteStops() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favoriteStops');
    if (favorites != null) {
      _favoriteStops.addAll(favorites);
    }
  }

  Future<void> _saveFavoriteStops() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteStops', _favoriteStops.toList());
  }

  void _sortStops() {
  _filteredStops.sort((a, b) {
    final aFavorite = _favoriteStops.contains(a.id);
    final bFavorite = _favoriteStops.contains(b.id);

    if (aFavorite && !bFavorite) return -1;
    if (!aFavorite && bFavorite) return 1;

    // Если оба остановки не в избранном, сортируем по "естественному порядку" их названий.
    return _naturalSort(a.name, b.name);
  });
}

/// Метод для естественной сортировки строк (используется и здесь).
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
