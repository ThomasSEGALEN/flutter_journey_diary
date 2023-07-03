import 'dart:io';

class Place {
  String name;
  String? description;
  List<File> images;
  String locality;

  Place({
    required this.name,
    this.description,
    required this.images,
    required this.locality,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        name: json['name'],
        description: json['description'],
        images: json['images'],
        locality: json['locality'],
      );

  @override
  String toString() {
    return 'Place{name: $name, description: $description, images: $images, locality: $locality}';
  }
}
