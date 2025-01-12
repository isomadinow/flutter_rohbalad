/// Модель данных `Region`, представляющая регион.
class Region {
  /// Уникальный идентификатор региона.
  final String id;

  /// Название региона.
  final String name;

  /// Конструктор для инициализации объекта `Region`.
  Region({required this.id, required this.name});

  /// Фабричный метод для создания объекта `Region` из JSON.
  /// 
  /// - [json] - JSON-объект с данными о регионе.
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'], // Получение значения идентификатора из JSON.
      name: json['name'], // Получение названия региона из JSON.
    );
  }
}
