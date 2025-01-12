import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/app_viewmodel.dart';

class RegionDropdown extends StatelessWidget {
  final void Function(String regionId) onRegionSelected;

  const RegionDropdown({super.key, required this.onRegionSelected});

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: Color(0xFF87CEEB), // Мягкий голубой
          size: 24.0,
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // Светло-серый фон
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: const Color(0xFFB0C4DE)), // Светло-голубая рамка
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<String>(
            value: appViewModel.regionViewModel.selectedRegionId,
            items: appViewModel.regionViewModel.regions
                .map(
                  (region) => DropdownMenuItem(
                    value: region.id,
                    child: Text(
                      region.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF4B4B4B), // Темно-серый текст
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                appViewModel.regionViewModel.setSelectedRegion(value);
                onRegionSelected(value);
              }
            },
            dropdownColor: const Color(0xFFF8F8FF), // Очень светлый голубой
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF87CEEB), // Голубой
            ),
            underline: const SizedBox(),
          ),
        ),
      ],
    );
  }
}
