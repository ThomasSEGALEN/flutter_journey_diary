class GooglePrediction {
  String? placeId;
  String description;

  GooglePrediction({
    required this.placeId,
    required this.description,
  });

  factory GooglePrediction.fromJson(Map<String, dynamic> json) =>
      GooglePrediction(
        placeId: json['place_id'],
        description: json['description'],
      );

  @override
  String toString() =>
      'GooglePrediction{placeId: $placeId, description: $description}';
}
