import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для чтения JSON из assets
import '../models/route.dart';
import '../services/api_service.dart';

class RoutesViewModel extends ChangeNotifier {
  final ApiService apiService;

  RoutesViewModel({required this.apiService});

  List<TransportRoute> _routes = [];
  bool _isLoading = false;
  String _selectedCity = "San Francisco"; // Город по умолчанию

  List<TransportRoute> get routes => _routes;
  bool get isLoading => _isLoading;
  String get selectedCity => _selectedCity;

  // Устанавливаем выбранный город
  void setSelectedCity(String city) {
    _selectedCity = city;
    fetchRoutes(); // Перезагружаем маршруты для выбранного города
    notifyListeners();
  }

  Future<void> fetchRoutes() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Подгружаем данные с API
      _routes = await apiService.fetchRoutes();
    } catch (e) {
      print("Error fetching routes from API: $e");

      // Если ошибка, загружаем данные из локального JSON
      _routes = await _loadStaticRoutes();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<TransportRoute>> _loadStaticRoutes() async {
    try {
      // Читаем локальный JSON из assets
      final String response = await rootBundle.loadString('assets/static_routes.json');
      final List<dynamic> data = json.decode(response);
      return data.map((item) => TransportRoute.fromJson(item)).toList();
    } catch (e) {
      print("Error loading static routes: $e");
      return [];
    }
  }

  void toggleFavorite(String id) {
    final index = _routes.indexWhere((route) => route.id == id);
    if (index != -1) {
      _routes[index] = TransportRoute(
        id: _routes[index].id,
        from: _routes[index].from,
        to: _routes[index].to,
        isFavorite: !_routes[index].isFavorite,
      );
      notifyListeners();
    }
  }
}
