import 'dart:developer';

import '../../../core/api_service.dart';
import '../../../core/base_viewmodel.dart';
import '../models/stop.dart';

class StopViewModel extends BaseViewModel {
  final ApiService apiService;

  StopViewModel({required this.apiService});

  List<Stop> _stops = [];
  List<Stop> _filteredStops = [];
  final Set<String> _favoriteStops = {};

  List<Stop> get stops => _stops;
  List<Stop> get filteredStops => _filteredStops;
  Set<String> get favoriteStops => _favoriteStops;

  Future<void> fetchStops() async {
    setLoading(true);
    try {
      // Загружаем остановки из API или fallback на заглушки
      _stops = await apiService.fetchData(
        'stops', // Ключ для API и заглушки
        (json) => Stop.fromJson(json), // Преобразование JSON в модель Stop
      );
      _filteredStops = List.from(_stops);
    } catch (e) {
      log('Ошибка загрузки остановок: $e');
    } finally {
      setLoading(false);
    }
  }

  void searchStops(String query) {
    _filteredStops = _stops
        .where((stop) => stop.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void toggleFavoriteStop(String stopId) {
    if (_favoriteStops.contains(stopId)) {
      _favoriteStops.remove(stopId);
    } else {
      _favoriteStops.add(stopId);
    }
    notifyListeners();
  }
}