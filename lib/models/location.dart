class Location {
  String name;
  Map<String, dynamic> address;
  Map<String, dynamic> geoCode;

  Location({
    required this.name,
    required this.address,
    required this.geoCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json['name'],
        address: json['address'],
        geoCode: json['geoCode'],
      );

  @override
  String toString() {
    return 'Location{name: $name, address: $address, geoCode: $geoCode}';
  }
}
