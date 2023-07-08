import 'package:flutter_journey_diary/models/data_state.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';

class GooglePointOfInterestState {
  DataState dataState;
  List<GooglePointOfInterest>? pointsOfInterest;

  GooglePointOfInterestState(this.dataState, [this.pointsOfInterest]);

  factory GooglePointOfInterestState.loading() =>
      GooglePointOfInterestState(DataState.loading);

  factory GooglePointOfInterestState.loaded(
          List<GooglePointOfInterest> pointsOfInterest) =>
      GooglePointOfInterestState(DataState.loaded, pointsOfInterest);

  factory GooglePointOfInterestState.error() =>
      GooglePointOfInterestState(DataState.error);
}
