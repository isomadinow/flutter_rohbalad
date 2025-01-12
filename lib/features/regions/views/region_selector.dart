import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/region_viewmodel.dart';

/// Виджет `RegionSelector` представляет выпадающий список для выбора региона.
/// 
/// - [onRegionSelected] — коллбэк, вызываемый при выборе региона.
class RegionSelector extends StatelessWidget {
  /// Коллбэк для обработки выбора региона.
  final void Function(String regionId) onRegionSelected;

  /// Конструктор класса `RegionSelector`.
  const RegionSelector({super.key, required this.onRegionSelected});

  @override
  Widget build(BuildContext context) {
    // Получение экземпляра `RegionViewModel` из контекста.
    final regionViewModel = Provider.of<RegionViewModel>(context);

    // Если данные загружаются, отображается индикатор загрузки.
    if (regionViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Если список регионов пуст, отображается сообщение об отсутствии данных.
    if (regionViewModel.regions.isEmpty) {
      return const Center(
        child: Text(
          "Нет доступных регионов", // Сообщение о пустом списке.
          style: TextStyle(color: Colors.red, fontSize: 16), // Красный цвет текста.
        ),
      );
    }

    // Отображение выпадающего списка для выбора региона.
    return DropdownButton<String>(
      value: regionViewModel.selectedRegionId, // Текущее выбранное значение.
      items: regionViewModel.regions
          .map(
            (region) => DropdownMenuItem(
              value: region.id, // Уникальный идентификатор региона.
              child: Text(region.name), // Название региона.
            ),
          )
          .toList(),
      onChanged: (String? value) {
        // Обработка изменения выбора региона.
        if (value != null) {
          regionViewModel.setSelectedRegion(value); // Обновление выбранного региона.
          onRegionSelected(value); // Вызов коллбэка.
        }
      },
    );
  }
}
