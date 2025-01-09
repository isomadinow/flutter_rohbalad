import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/route.dart';
import '../viewmodels/routes_viewmodel.dart';

class RoutesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RoutesViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: viewModel.selectedCity,
                  icon: Icon(Icons.arrow_drop_down),
                  underline: SizedBox(),
                  items: ["San Francisco", "New York", "Los Angeles"]
                      .map((city) => DropdownMenuItem(
                            value: city,
                            child: Text(
                              city,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ))
                      .toList(),
                  onChanged: (city) {
                    if (city != null) {
                      viewModel.setSelectedCity(city);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.routes.length,
              itemBuilder: (context, index) {
                final route = viewModel.routes[index];
                return _buildRouteCard(route, context, viewModel);
              },
            ),
    );
  }

  Widget _buildRouteCard(TransportRoute route, BuildContext context, RoutesViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: route.isFavorite ? Colors.purple : Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              route.id,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            route.from,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(route.to),
          trailing: IconButton(
            icon: Icon(
              route.isFavorite ? Icons.star : Icons.star_border,
              color: route.isFavorite ? Colors.yellow : Colors.grey,
            ),
            onPressed: () {
              viewModel.toggleFavorite(route.id);
            },
          ),
        ),
      ),
    );
  }
}
