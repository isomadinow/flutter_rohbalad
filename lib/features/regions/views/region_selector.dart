import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/region_viewmodel.dart';

class RegionSelector extends StatelessWidget {
  final void Function(String regionId) onRegionSelected;

  const RegionSelector({super.key, required this.onRegionSelected});

  @override
  Widget build(BuildContext context) {
    final regionViewModel = Provider.of<RegionViewModel>(context);

    if (regionViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (regionViewModel.regions.isEmpty) {
      return const Center(
        child: Text(
          "Нет доступных регионов",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return DropdownButton<String>(
      value: regionViewModel.selectedRegionId,
      items: regionViewModel.regions
          .map(
            (region) => DropdownMenuItem(
              value: region.id,
              child: Text(region.name),
            ),
          )
          .toList(),
      onChanged: (String? value) {
        if (value != null) {
          regionViewModel.setSelectedRegion(value);
          onRegionSelected(value);
        }
      },
    );
  }
}
