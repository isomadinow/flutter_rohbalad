import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_viewmodel.dart';

/// Виджет `RegionDropdown` предоставляет выпадающий список для выбора региона.
///
/// - [onRegionSelected] — коллбэк, вызываемый при выборе региона.
class RegionDropdown extends StatelessWidget {
  /// Коллбэк для обработки выбора региона.
  final void Function(String regionId) onRegionSelected;

  /// Конструктор для создания виджета `RegionDropdown`.
  const RegionDropdown({super.key, required this.onRegionSelected});

  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр `AppViewModel` из контекста.
    final appViewModel = Provider.of<AppViewModel>(context);

    return Row(
      children: [
        // Иконка местоположения.
        const Icon(
          Icons.location_on,
          color: Color(0xFF87CEEB), // Мягкий голубой цвет.
          size: 24.0,
        ),
        const SizedBox(width: 8), // Отступ между иконкой и выпадающим списком.
        // Контейнер с выпадающим списком.
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // Светло-серый фон контейнера.
            borderRadius: BorderRadius.circular(8.0), // Скругленные углы.
            border: Border.all(
              color: const Color(0xFFB0C4DE), // Светло-голубая рамка.
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Внутренние отступы контейнера.
          // Выпадающий список для выбора региона.
          child: DropdownButton<String>(
            value: appViewModel.regionViewModel.selectedRegionId, // Текущий выбранный регион.
            items: appViewModel.regionViewModel.regions
                .map(
                  (region) => DropdownMenuItem(
                    value: region.id, // Идентификатор региона.
                    child: Text(
                      region.name, // Название региона.
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF4B4B4B), // Темно-серый текст.
                        fontWeight: FontWeight.w500, // Полужирное начертание.
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              // Обработка изменения выбранного региона.
              if (value != null) {
                appViewModel.regionViewModel.setSelectedRegion(value); // Устанавливаем выбранный регион.
                onRegionSelected(value); // Вызываем переданный коллбэк.
                // Обновляем состояние, чтобы перерисовать список.
                (context as Element).markNeedsBuild();
              }
            },
            dropdownColor: const Color(0xFFF8F8FF), // Очень светлый голубой цвет для выпадающего списка.
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF87CEEB), // Голубая стрелка вниз.
            ),
            underline: const SizedBox(), // Убираем стандартное подчеркивание.
          ),
        ),
      ],
    );
  }
}
