import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/place.dart';

class PlaceState {
  DataState dataState;
  List<Place>? places;

  PlaceState(this.dataState, [this.places]);

  factory PlaceState.loading() => PlaceState(DataState.loading);

  factory PlaceState.loaded(List<Place> places) =>
      PlaceState(DataState.loaded, places);

  factory PlaceState.error() => PlaceState(DataState.error);
}
