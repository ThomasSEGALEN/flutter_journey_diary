import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/place_state.dart';
import 'package:flutter_journey_diary/repositories/place_repository.dart';

import '../models/place.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit(this.placeRepository) : super(PlaceState.loading());

  final PlaceRepository placeRepository;
  List<Place> listPlace = [];

  Future<void> savePlace(Place place) async{
    await placeRepository.savePlace(place);
    emit(PlaceState.loaded(listPlace));
  }

  Future<void> getPlaces() async{
    try{
      emit(PlaceState.loading());
      listPlace = await placeRepository.getPlaces();
      emit(PlaceState.loaded(listPlace));
      print(listPlace.length);
    }
    catch (e) {
      log(e.toString());
      emit(PlaceState.error());
    }

  }

}