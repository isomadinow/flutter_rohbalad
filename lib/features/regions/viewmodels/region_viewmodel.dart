import 'dart:developer';

import '../../../core/api_service.dart';
import '../../../core/base_viewmodel.dart';
import '../models/region.dart';

class RegionViewModel extends BaseViewModel {
  final ApiService apiService;

  RegionViewModel({required this.apiService});

  List<Region> _regions = [];
  String? _selectedRegionId;

  List<Region> get regions => _regions;
  String? get selectedRegionId => _selectedRegionId;

  Future<void> fetchRegions() async {
    setLoading(true);
    try {
      // Загружаем регионы из API или fallback на заглушки
      _regions = await apiService.fetchData(
        'regions', // Ключ для API и заглушки
        (json) => Region.fromJson(json), // Преобразование JSON в модель Region
      );
      if (_regions.isNotEmpty) {
        _selectedRegionId = _regions.first.id; // Установить первый регион по умолчанию
      }
    } catch (e) {
      log('Ошибка загрузки регионов: $e');
    } finally {
      setLoading(false);
    }
  }

  void setSelectedRegion(String regionId) {
    _selectedRegionId = regionId;
    notifyListeners();
  }
}
