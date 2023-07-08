import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/google/google_place_state.dart';
import 'package:flutter_journey_diary/models/google_place.dart';
import 'package:flutter_journey_diary/repositories/google/google_place_repository.dart';

class GooglePlaceCubit extends Cubit<GooglePlaceState> {
  GooglePlaceCubit(this.googlePlaceRepository)
      : super(GooglePlaceState.loading());

  final GooglePlaceRepository googlePlaceRepository;

  Future<void> getPlace(String placeId) async {
    try {
      emit(GooglePlaceState.loading());

      final GooglePlace place = await googlePlaceRepository.fetchPlace(placeId);

      emit(GooglePlaceState.loaded(place));
    } catch (e) {
      log(e.toString());

      emit(GooglePlaceState.error());
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
