import 'dart:developer'; // Импорт для логирования.
import '../../../core/api_service.dart'; // Импорт API-сервиса.
import '../../../core/base_viewmodel.dart'; // Импорт базовой модели представления.
import '../models/stop.dart'; // Импорт модели остановки.

/// Класс `StopViewModel`, наследуемый от `BaseViewModel`, отвечает за управление данными остановок.
class StopViewModel extends BaseViewModel {
  /// Экземпляр сервиса для работы с API.
  final ApiService apiService;

  /// Конструктор класса `StopViewModel`.
  StopViewModel({required this.apiService});

  /// Список всех остановок.
  List<Stop> _stops = [];

  /// Список отфильтрованных остановок.
  List<Stop> _filteredStops = [];

  /// Множество избранных остановок (их идентификаторы).
  final Set<String> _favoriteStops = {};

  /// Геттер для получения списка отфильтрованных остановок.
  List<Stop> get filteredStops => _filteredStops;

  /// Геттер для получения множества избранных остановок.
  Set<String> get favoriteStops => _favoriteStops;

  /// Метод для загрузки остановок с сервера.
  Future<void> fetchStops() async {
    setLoading(true); // Устанавливаем статус загрузки.
    try {
      // Запрос к API для получения данных об остановках.
      _stops = await apiService.fetchData(
        'stops', // Конечная точка API.
        (json) => Stop.fromJson(json), // Маппинг JSON в объект `Stop`.
      );

      // Изначально все остановки попадают в отфильтрованный список.
      _filteredStops = List.from(_stops);
      log('Остановки загружены: ${_stops.length}'); // Логируем количество остановок.
    } catch (e) {
      // Логируем ошибку при загрузке данных.
      log('Ошибка загрузки остановок: $e');
    } finally {
      // Завершаем загрузку и уведомляем слушателей об изменениях.
      setLoading(false);
      notifyListeners();
    }
  }

  /// Метод для поиска остановок по заданному запросу.
  /// 
  /// - [query] — строка поиска.
  void searchStops(String query) {
    if (query.isEmpty) {
      // Если запрос пустой, показываем все остановки.
      _filteredStops = List.from(_stops);
    } else {
      // Фильтруем остановки по названию, с учетом регистра.
      _filteredStops = _stops
          .where((stop) => stop.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Уведомляем слушателей об изменениях в списке остановок.
  }

  /// Метод для добавления/удаления остановки из избранного.
  /// 
  /// - [stopId] — идентификатор остановки.
  void toggleFavoriteStop(String stopId) {
    if (_favoriteStops.contains(stopId)) {
      // Если остановка уже в избранном, удаляем её.
      _favoriteStops.remove(stopId);
    } else {
      // Если остановки нет в избранном, добавляем её.
      _favoriteStops.add(stopId);
    }
    log('Избранные остановки: $_favoriteStops'); // Логируем обновленное избранное.
    notifyListeners(); // Уведомляем слушателей об изменениях в избранном.
  }
}
