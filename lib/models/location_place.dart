class LocationPlace {
  String name;
  String category;
  int rank;
  List<dynamic> tags;

  LocationPlace({
    required this.name,
    required this.category,
    required this.rank,
    required this.tags,
  });

  factory LocationPlace.fromJson(Map<String, dynamic> json) => LocationPlace(
        name: json['name'],
        category: json['category'],
        rank: json['rank'],
        tags: json['tags'],
      );

  @override
  String toString() {
    return 'LocationPlace{name: $name, category: $category, rank: $rank, tags: $tags}';
  }
}
