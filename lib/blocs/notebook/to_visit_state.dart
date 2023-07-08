import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';

class ToVisitState {
  DataState dataState;
  List<GooglePointOfInterest>? visits;

  ToVisitState(this.dataState, [this.visits]);

  factory ToVisitState.loading() => ToVisitState(DataState.loading);

  factory ToVisitState.loaded(List<GooglePointOfInterest> visits) =>
      ToVisitState(DataState.loaded, visits);

  factory ToVisitState.error() => ToVisitState(DataState.error);
}
