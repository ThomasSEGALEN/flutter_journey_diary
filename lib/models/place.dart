import 'dart:io';

class Place {
  String id;
  String name;
  String? description;
  String locality;
  List<File>? images;
  List<String>? urls;

  Place({
    required this.id,
    required this.name,
    this.description,
    required this.locality,
    this.images,
    this.urls,
  });

  @override
  String toString() {
    return 'Place{name: $name, description: $description, images: $images, locality: $locality}';
  }
}
