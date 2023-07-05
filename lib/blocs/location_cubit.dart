import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/location_state.dart';
import 'package:flutter_journey_diary/models/location.dart';
import 'package:flutter_journey_diary/models/location_place.dart';
import 'package:flutter_journey_diary/repositories/location_repository.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this.locationRepository) : super(LocationState.loading());

  final LocationRepository locationRepository;

  Future<void> loadLocations(String locationName) async {
    try {
      emit(LocationState.loading());
      final List<Location> locations =
          await locationRepository.fetchLocations(locationName);
      emit(LocationState.loaded(locations: locations));
    } catch (e) {
      log(e.toString());
      emit(LocationState.error());
    }
  }

  Future<void> loadPlaces(Location location) async {
    try {
      emit(LocationState.loading());
      final List<LocationPlace> places =
          await locationRepository.fetchPlaces(location);
      emit(LocationState.loaded(places: places));
    } catch (e) {
      log(e.toString());
      emit(LocationState.error());
    }
  }
}
