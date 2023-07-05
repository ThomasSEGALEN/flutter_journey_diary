import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/location.dart';
import 'package:flutter_journey_diary/models/location_place.dart';

class LocationState {
  DataState dataState;
  List<Location>? locations;
  List<LocationPlace>? places;

  LocationState(this.dataState, [this.locations, this.places]);

  factory LocationState.loading() => LocationState(DataState.loading);

  factory LocationState.loaded(
          {List<Location>? locations, List<LocationPlace>? places}) =>
      LocationState(DataState.loaded, locations, places);

  factory LocationState.error() => LocationState(DataState.error);
}
