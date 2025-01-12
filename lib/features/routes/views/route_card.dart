import 'package:flutter/material.dart';

/// Виджет `RouteCard` представляет карточку маршрута с информацией и функционалом добавления в избранное.
class RouteCard extends StatelessWidget {
  /// Номер маршрута.
  final String routeNumber;

  /// Название первой остановки маршрута.
  final String firstStop;

  /// Название последней остановки маршрута.
  final String lastStop;

  /// Флаг, указывающий, находится ли маршрут в избранном.
  final bool isFavorite;

  /// Коллбэк, вызываемый при нажатии на иконку избранного.
  final VoidCallback onFavoriteTap;

  /// Конструктор для создания виджета `RouteCard`.
  const RouteCard({
    super.key,
    required this.routeNumber,
    required this.firstStop,
    required this.lastStop,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1, // Уровень теней для карточки.
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Внешние отступы.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Скругление углов карточки.
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Внутренние отступы для содержимого карточки.
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Выравнивание по вертикали.
          children: [
            // Круглый контейнер с номером маршрута и иконкой автобуса.
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.green, // Фон контейнера.
                shape: BoxShape.circle, // Форма контейнера — круг.
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Центровка содержимого.
                children: [
                  // Номер маршрута.
                  Text(
                    routeNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  // Иконка автобуса.
                  const Icon(
                    Icons.directions_bus,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0), // Отступ между контейнером и текстовой частью.
            // Основной контент карточки с информацией о маршруте.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание текста по левому краю.
                children: [
                  // Первая остановка.
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.green, // Цвет иконки первой остановки.
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          firstStop,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis, // Текст в одну строку с многоточием.
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0), // Отступ между остановками.
                  // Последняя остановка.
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.blue, // Цвет иконки последней остановки.
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          lastStop,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis, // Текст в одну строку с многоточием.
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0), // Отступ между текстом и иконкой избранного.
            // Иконка избранного с обработкой нажатий.
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border, // Иконка избранного.
                color: isFavorite ? Colors.yellow : Colors.grey, // Цвет иконки в зависимости от состояния.
              ),
              onPressed: onFavoriteTap, // Обработка нажатия.
            ),
          ],
        ),
      ),
    );
  }
}
