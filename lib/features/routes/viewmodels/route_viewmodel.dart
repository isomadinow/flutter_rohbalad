import 'dart:developer'; // Импорт для использования логирования.
import '../../../core/api_service.dart'; // Импорт сервиса для работы с API.
import '../../../core/base_viewmodel.dart'; // Импорт базовой модели представления.
import '../models/transport_route.dart'; // Импорт модели маршрута транспорта.

/// Класс `RouteViewModel`, наследуемый от `BaseViewModel`, отвечает за управление данными маршрутов.
class RouteViewModel extends BaseViewModel {
  /// Экземпляр сервиса для работы с API.
  final ApiService apiService;

  /// Конструктор класса `RouteViewModel`.
  RouteViewModel({required this.apiService});

  /// Список всех маршрутов.
  List<TransportRoute> _routes = [];

  /// Список отфильтрованных маршрутов.
  List<TransportRoute> _filteredRoutes = [];

  /// Множество избранных маршрутов (их номера).
  final Set<String> _favoriteRoutes = {};

  /// Геттер для получения списка отфильтрованных маршрутов.
  List<TransportRoute> get filteredRoutes => _filteredRoutes;

  /// Геттер для получения множества избранных маршрутов.
  Set<String> get favoriteRoutes => _favoriteRoutes;

  /// Метод для загрузки маршрутов с сервера.
  Future<void> fetchRoutes() async {
    setLoading(true); // Устанавливаем статус загрузки.
    try {
      // Запрос к API для получения данных о маршрутах.
      _routes = await apiService.fetchData(
        'routes', // Конечная точка API.
        (json) => TransportRoute.fromJson(json), // Маппинг JSON в объект TransportRoute.
      );

      // Изначально все маршруты попадают в отфильтрованный список.
      _filteredRoutes = List.from(_routes);
      log('Маршруты загружены: ${_routes.length}'); // Логируем количество маршрутов.
    } catch (e) {
      // Логируем ошибку при загрузке данных.
      log('Ошибка загрузки маршрутов: $e');
    } finally {
      // Завершаем загрузку и уведомляем слушателей об изменениях.
      setLoading(false);
      notifyListeners();
    }
  }

  /// Метод для поиска маршрутов по заданному запросу.
  /// 
  /// - [query] — строка поиска.
  void searchRoutes(String query) {
    if (query.isEmpty) {
      // Если запрос пустой, показываем все маршруты.
      _filteredRoutes = List.from(_routes);
    } else {
      // Фильтруем маршруты по номеру, с учетом регистра.
      _filteredRoutes = _routes
          .where((route) =>
              route.number.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Уведомляем слушателей об изменениях в списке маршрутов.
  }

  /// Метод для добавления/удаления маршрута из избранного.
  /// 
  /// - [routeNumber] — номер маршрута.
  void toggleFavoriteRoute(String routeNumber) {
    if (_favoriteRoutes.contains(routeNumber)) {
      // Если маршрут уже в избранном, удаляем его.
      _favoriteRoutes.remove(routeNumber);
    } else {
      // Если маршрута нет в избранном, добавляем его.
      _favoriteRoutes.add(routeNumber);
    }
    log('Избранные маршруты: $_favoriteRoutes'); // Логируем обновленное избранное.
    notifyListeners(); // Уведомляем слушателей об изменениях в избранном.
  }
}
