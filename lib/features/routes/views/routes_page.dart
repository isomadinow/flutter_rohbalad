import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/routes_viewmodel.dart';
import 'widgets/route_card.dart';

class RoutesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RoutesViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Маршруты'),
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.routes.length,
              itemBuilder: (context, index) {
                final route = viewModel.routes[index];
                return RouteCard(route: route);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.fetchRoutes,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
