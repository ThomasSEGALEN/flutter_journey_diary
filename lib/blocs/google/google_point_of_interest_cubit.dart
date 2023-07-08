import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/google/google_point_of_interest_state.dart';
import 'package:flutter_journey_diary/models/google_place.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';
import 'package:flutter_journey_diary/repositories/google/google_place_repository.dart';

class GooglePointOfInterestCubit extends Cubit<GooglePointOfInterestState> {
  GooglePointOfInterestCubit(this.googlePlaceRepository)
      : super(GooglePointOfInterestState.loading());

  final GooglePlaceRepository googlePlaceRepository;

  Future<void> getPointsOfInterest(GooglePlace place) async {
    try {
      emit(GooglePointOfInterestState.loading());

      final List<GooglePointOfInterest> pointOfInterest =
          await googlePlaceRepository.fetchPointsOfInterest(place);

      emit(GooglePointOfInterestState.loaded(pointOfInterest));
    } catch (e) {
      log(e.toString());

      emit(GooglePointOfInterestState.error());
    }
  }

  String getImageUrl(String? photoReference) {
    try {
      final String url = googlePlaceRepository.getImageUrl(photoReference ?? '');

      return url;
    } catch (e) {
      log(e.toString());

      return '';
    }
  }
}
