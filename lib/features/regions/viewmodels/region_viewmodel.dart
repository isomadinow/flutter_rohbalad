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
      _regions = await apiService.fetchData(
        'regions',
        (json) => Region.fromJson(json),
      );
      if (_regions.isNotEmpty) {
        _selectedRegionId = _regions.first.id;
        log('Регионы загружены: ${_regions.length}');
      }
    } catch (e) {
      log('Ошибка загрузки регионов: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void setSelectedRegion(String regionId) {
    _selectedRegionId = regionId;
    log('Выбран регион: $regionId');
    notifyListeners();
  }
}
