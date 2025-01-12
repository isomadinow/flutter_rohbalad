import 'package:flutter/material.dart';

/// Виджет `SearchBar` представляет поисковую строку с текстовым полем и иконкой поиска.
///
/// - [hintText] — текст подсказки внутри поля.
/// - [onSearch] — коллбэк, вызываемый при изменении текста.
class SearchBar extends StatelessWidget {
  /// Текст подсказки внутри текстового поля.
  final String hintText;

  /// Коллбэк, вызываемый при изменении текста в строке поиска.
  final void Function(String) onSearch;

  /// Конструктор для создания виджета `SearchBar`.
  const SearchBar({
    super.key,
    required this.hintText,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Внешние отступы для компонента.
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5), // Светло-серый фон текстового поля.
          borderRadius: BorderRadius.circular(30.0), // Скругленные углы.
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Полупрозрачная тень.
              blurRadius: 6.0, // Радиус размытия тени.
              offset: const Offset(0, 3), // Смещение тени вниз.
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText, // Установка текста подсказки.
            prefixIcon: const Icon(
              Icons.search, // Иконка поиска слева.
              color: Colors.grey, // Цвет иконки.
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0), // Отступы внутри текстового поля.
            border: InputBorder.none, // Убираем стандартные рамки текстового поля.
          ),
          onChanged: onSearch, // Вызов коллбэка при изменении текста.
        ),
      ),
    );
  }
}
