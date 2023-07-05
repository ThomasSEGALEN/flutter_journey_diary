import 'dart:io';

class Place {
  String name;
  String? description;
  List<File>? images;
  String locality;
  List<String>? urls;

  Place({required this.locality,required this.name, this.description,this.images, this.urls});


  @override
  String toString() {
    return 'Place{name: $name, description: $description, images: $images, locality: $locality}';
  }
}
