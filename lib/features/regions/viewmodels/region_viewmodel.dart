import 'dart:developer'; // Импорт для использования логирования.
import '../../../core/api_service.dart'; // Импорт сервиса для работы с API.
import '../../../core/base_viewmodel.dart'; // Импорт базовой модели представления.
import '../models/region.dart'; // Импорт модели региона.

/// Класс `RegionViewModel`, наследуемый от `BaseViewModel`, отвечает за управление данными регионов.
class RegionViewModel extends BaseViewModel {
  /// Экземпляр сервиса для работы с API.
  final ApiService apiService;

  /// Конструктор класса с обязательным параметром `apiService`.
  RegionViewModel({required this.apiService});

  List<Region> _regions = []; // Список регионов, изначально пустой.
  String? _selectedRegionId; // Идентификатор выбранного региона.

  /// Геттер для получения списка регионов.
  List<Region> get regions => _regions;

  /// Геттер для получения идентификатора выбранного региона.
  String? get selectedRegionId => _selectedRegionId;

  /// Метод для загрузки списка регионов.
  Future<void> fetchRegions() async {
    setLoading(true); // Устанавливаем статус загрузки.
    try {
      // Запрос к API для получения данных о регионах.
      _regions = await apiService.fetchData(
        'regions', // Конечная точка API.
        (json) => Region.fromJson(json), // Маппинг JSON в объект Region.
      );

      // Если список регионов не пустой, устанавливаем первый регион как выбранный.
      if (_regions.isNotEmpty) {
        _selectedRegionId = _regions.first.id;
        log('Регионы загружены: ${_regions.length}'); // Логируем количество загруженных регионов.
      }
    } catch (e) {
      // Логируем ошибку в случае исключения.
      log('Ошибка загрузки регионов: $e');
    } finally {
      // Отключаем статус загрузки и уведомляем слушателей об изменении состояния.
      setLoading(false);
      notifyListeners();
    }
  }

  /// Метод для установки выбранного региона.
  void setSelectedRegion(String regionId) {
    _selectedRegionId = regionId; // Обновляем идентификатор выбранного региона.
    log('Выбран регион: $regionId'); // Логируем выбор региона.
    notifyListeners(); // Уведомляем слушателей об изменении состояния.
  }
}
