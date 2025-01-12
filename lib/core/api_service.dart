import 'dart:convert'; // Импорт для работы с JSON.
import 'dart:developer'; // Импорт для логирования.
import 'package:flutter/services.dart'; // Импорт для работы с локальными файлами.
import 'package:http/http.dart' as http; // Импорт для выполнения HTTP-запросов.

/// Сервис `ApiService` для взаимодействия с API или чтения данных из заглушек.
class ApiService {
  /// Базовый URL для API.
  final String baseUrl;

  /// Флаг, указывающий, использовать ли моковые данные вместо запросов к API.
  final bool useMockData;

  /// Конструктор для создания экземпляра `ApiService`.
  ApiService({required this.baseUrl, this.useMockData = false});

  /// Универсальный метод для получения данных.
  /// 
  /// - [endpoint] — конечная точка API или ключ для заглушки.
  /// - [fromJson] — функция для преобразования JSON в объект типа `T`.
  /// 
  /// Возвращает список объектов типа `T`.
  Future<List<T>> fetchData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      if (useMockData) {
        // Если включен режим заглушек, читаем данные из локальных файлов.
        return _fetchMockData<T>(endpoint, fromJson);
      }
      // В противном случае выполняем запрос к API.
      return _fetchApiData<T>(endpoint, fromJson);
    } catch (e) {
      // В случае ошибки логируем её и пытаемся загрузить данные из заглушек.
      log('Ошибка загрузки данных ($endpoint): $e');
      return _fetchMockData<T>(endpoint, fromJson);
    }
  }

  /// Метод для выполнения запроса к API.
  /// 
  /// - [endpoint] — конечная точка API.
  /// - [fromJson] — функция для преобразования JSON в объект типа `T`.
  Future<List<T>> _fetchApiData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    // Выполнение GET-запроса.
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      // Если ответ успешный, декодируем JSON.
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => fromJson(item)).toList();
    } else {
      // Если код ответа не 200, выбрасываем исключение.
      throw Exception('Ошибка API: ${response.statusCode}');
    }
  }

  /// Метод для чтения моковых данных из локальных файлов.
  /// 
  /// - [endpoint] — ключ для определения файла с заглушкой.
  /// - [fromJson] — функция для преобразования JSON в объект типа `T`.
  Future<List<T>> _fetchMockData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    // Карта, связывающая конечные точки с локальными файлами.
    final mockPaths = {
      'routes': 'assets/static_routes.json',
      'stops': 'assets/static_stops.json',
      'regions': 'assets/static_regions.json',
    };

    // Получаем путь к файлу на основе endpoint.
    final path = mockPaths[endpoint];
    log('Чтение файла: $path');
    if (path == null) {
      // Если endpoint неизвестен, выбрасываем исключение.
      throw Exception('Неизвестный endpoint для заглушек: $endpoint');
    }

    try {
      // Чтение содержимого файла из assets.
      final response = await rootBundle.loadString(path);
      // Декодирование JSON.
      final List<dynamic> data = json.decode(response);
      log('Загружено ${data.length} элементов из $endpoint');
      return data.map((item) => fromJson(item)).toList();
    } catch (e) {
      // Логируем и выбрасываем исключение в случае ошибки чтения файла.
      log('Ошибка чтения файла $path: $e');
      throw Exception('Ошибка чтения файла: $path');
    }
  }
}
