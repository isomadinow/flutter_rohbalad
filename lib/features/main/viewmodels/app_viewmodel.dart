import 'package:flutter/material.dart';
import '../../../core/api_service.dart';
import '../../regions/viewmodels/region_viewmodel.dart';
import '../../routes/viewmodels/route_viewmodel.dart';
import '../../stops/viewmodels/stop_viemodel.dart';

/// Класс `AppViewModel` отвечает за управление состоянием приложения и объединяет ViewModel для различных разделов.
class AppViewModel extends ChangeNotifier {
  /// ViewModel для управления регионами.
  final RegionViewModel regionViewModel;

  /// ViewModel для управления маршрутами.
  final RouteViewModel routeViewModel;

  /// ViewModel для управления остановками.
  final StopViewModel stopViewModel;

  /// Текущая активная вкладка.
  String _activeTab = "routes";

  /// Конструктор `AppViewModel`.
  /// 
  /// Принимает [apiService] для передачи во вложенные ViewModel.
  AppViewModel({required ApiService apiService})
      : regionViewModel = RegionViewModel(apiService: apiService),
        routeViewModel = RouteViewModel(apiService: apiService),
        stopViewModel = StopViewModel(apiService: apiService);

  /// Геттер для получения названия текущей активной вкладки.
  String get activeTab => _activeTab;

  /// Метод для установки активной вкладки.
  /// 
  /// - [tab] — название вкладки, которую необходимо активировать.
  /// Уведомляет слушателей об изменении состояния.
  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners(); // Уведомляем подписчиков об изменении активной вкладки.
  }

  /// Метод для поиска по текущей активной вкладке.
  /// 
  /// - [query] — строка поиска.
  /// Выполняет поиск в зависимости от выбранной вкладки (`routes` или `stops`).
  void search(String query) {
    if (_activeTab == "routes") {
      routeViewModel.searchRoutes(query);
    } else if (_activeTab == "stops") {
      stopViewModel.searchStops(query);
    }
  }

  /// Метод для инициализации всех данных приложения.
  /// 
  /// Загружает данные для регионов, маршрутов и остановок.
  /// После завершения загрузки уведомляет слушателей об изменениях.
  Future<void> initialize() async {
    await regionViewModel.fetchRegions();
    await routeViewModel.fetchRoutes();
    await stopViewModel.fetchStops();
    notifyListeners(); // Уведомляем подписчиков о завершении инициализации.
  }
}
