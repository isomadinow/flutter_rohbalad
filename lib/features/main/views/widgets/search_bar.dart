import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final void Function(String) onSearch;

  const SearchBar({
    super.key,
    required this.hintText,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5), // Светло-серый фон
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6.0,
              offset: const Offset(0, 3), // Смещение тени вниз
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
            border: InputBorder.none, // Убираем рамки
          ),
          onChanged: onSearch, // Реакция на изменение текста
        ),
      ),
    );
  }
}
