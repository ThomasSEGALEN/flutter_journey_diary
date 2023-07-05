import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_state.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/repositories/place_repository.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit(this.placeRepository) : super(PlaceState.loading());

  final PlaceRepository placeRepository;

  Future<void> getPlaces() async {
    try {
      emit(PlaceState.loading());
      final List<Place> places = await placeRepository.getPlaces();
      emit(PlaceState.loaded(places));
    } catch (e) {
      log(e.toString());
      emit(PlaceState.error());
    }
  }

  Future<void> savePlace(Place place) async {
    await placeRepository.savePlace(place);
  }

  Future<void> deletePlace(Place place) async {
    await placeRepository.deletePlace(place);
  }
}
