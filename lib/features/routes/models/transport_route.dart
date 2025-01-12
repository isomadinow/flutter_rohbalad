/// Модель данных `TransportRoute`, представляющая маршрут транспорта.
class TransportRoute {
  /// Номер маршрута.
  final String number;

  /// Список остановок маршрута.
  final List<String> stops;

  /// Конструктор для инициализации объекта `TransportRoute`.
  TransportRoute({required this.number, required this.stops});

  /// Фабричный метод для создания объекта `TransportRoute` из JSON.
  /// 
  /// - [json] — JSON-объект с данными о маршруте.
  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    return TransportRoute(
      number: json['number'], // Получение номера маршрута из JSON.
      stops: List<String>.from(
        json['stops'].map((stop) => stop['name']), // Преобразование списка остановок из JSON в список строк.
      ),
    );
  }
}
