import 'package:flutter/material.dart';
import '../../../core/api_service.dart';
import '../models/transport_route.dart';

class RoutesViewModel extends ChangeNotifier {
  final ApiService apiService;

  RoutesViewModel({required this.apiService});

  List<TransportRoute> _routes = [];
  bool _isLoading = false;

  List<TransportRoute> get routes => _routes;
  bool get isLoading => _isLoading;

  Future<void> fetchRoutes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.fetchData('routes');
      _routes = data.map((item) => TransportRoute.fromJson(item)).toList();
    } catch (e) {
      print("Error fetching routes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
