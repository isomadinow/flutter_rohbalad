class TransportRoute {
  final String number;
  final List<String> stops;

  TransportRoute({required this.number, required this.stops});

  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    return TransportRoute(
      number: json['number'],
      stops: List<String>.from(json['stops'].map((stop) => stop['name'])),
    );
  }
}
