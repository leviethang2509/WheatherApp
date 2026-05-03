class LocationSuggestion {
  final String name;
  final String country;
  final String state;
  final double latitude;
  final double longitude;

  LocationSuggestion({
    required this.name,
    required this.country,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      latitude: (json['lat'] ?? 0).toDouble(),
      longitude: (json['lon'] ?? 0).toDouble(),
    );
  }

  String get title {
    if (country.isEmpty) {
      return name;
    }

    return '$name, $country';
  }

  String get subtitle {
    final parts = [
      if (state.isNotEmpty) state,
      '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
    ];

    return parts.join(' - ');
  }

  String get query {
    if (country.isEmpty) {
      return name;
    }

    return '$name,$country';
  }
}
