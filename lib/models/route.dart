class TransportRoute {
  final String id;
  final String from;
  final String to;
  final bool isFavorite;

  TransportRoute({
    required this.id,
    required this.from,
    required this.to,
    required this.isFavorite,
  });

  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    return TransportRoute(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      isFavorite: json['isFavorite'],
    );
  }
}
