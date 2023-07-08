class GooglePlace {
  String? placeId;
  String? name;
  String? address;
  List<dynamic>? photos;
  Map<String, dynamic>? location;

  GooglePlace({
    required this.placeId,
    required this.name,
    required this.address,
    required this.photos,
    required this.location,
  });

  factory GooglePlace.fromJson(Map<String, dynamic> json) => GooglePlace(
        placeId: json['place_id'],
        name: json['name'],
        address: json['formatted_address'],
        photos: json['photos'],
        location: {
          'latitude': json['geometry']['location']['lat'],
          'longitude': json['geometry']['location']['lng'],
        },
      );

  @override
  String toString() =>
      'GooglePlace{placeId: $placeId, name: $name, address: $address, photos: $photos, location: $location}';
}
