class Location {
  String name;
  double latitude;
  double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json['name'],
        latitude: json['geoCode']['latitude'],
        longitude: json['geoCode']['longitude'],
      );

  @override
  String toString() {
    return 'Location{name: $name, latitude: $latitude, longitude: $longitude}';
  }
}
