class LocationModel {
  final double latitude;
  final double longitude;
  final String name;
  final DateTime timestamp;
  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.name,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Creating a default location to (Colombo, Sri Lanka)
  factory LocationModel.defaultLocation() {
    return LocationModel(
      latitude: 6.9271,
      longitude: 79.8612,
      name: 'Colombo',
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return '$name ($latitude, $longitude)';
  }
}
