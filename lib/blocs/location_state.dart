import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/location.dart';

class LocationState {
  DataState dataState;
  List<Location>? locations;

  LocationState(this.dataState, [this.locations]);

  factory LocationState.loading() => LocationState(DataState.loading);

  factory LocationState.loaded(List<Location> locations) =>
      LocationState(DataState.loading, locations);

  factory LocationState.error() => LocationState(DataState.error);
}
