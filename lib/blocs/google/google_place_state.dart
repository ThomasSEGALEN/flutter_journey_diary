import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/google_place.dart';

class GooglePlaceState {
  DataState dataState;
  GooglePlace? place;

  GooglePlaceState(this.dataState, [this.place]);

  factory GooglePlaceState.loading() => GooglePlaceState(DataState.loading);

  factory GooglePlaceState.loaded(GooglePlace place) =>
      GooglePlaceState(DataState.loaded, place);

  factory GooglePlaceState.error() => GooglePlaceState(DataState.error);
}
