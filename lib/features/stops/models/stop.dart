import '../../routes/models/transport_route.dart';

/// Модель данных `Stop`, представляющая остановку транспорта.
class Stop {
  /// Уникальный идентификатор остановки.
  final String id;

  /// Название остановки.
  final String name;

  /// Список маршрутов, проходящих через данную остановку.
  final List<TransportRoute> routes;

  /// Конструктор для инициализации объекта `Stop`.
  Stop({required this.id, required this.name, required this.routes});

  /// Фабричный метод для создания объекта `Stop` из JSON.
  /// 
  /// - [json] — JSON-объект с данными об остановке.
  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'], // Получение идентификатора остановки из JSON.
      name: json['name'], // Получение названия остановки из JSON.
      routes: List<TransportRoute>.from(
        json['routes'].map((route) => TransportRoute.fromJson(route)), 
        // Преобразование списка маршрутов из JSON в список объектов `TransportRoute`.
      ),
    );
  }
}
