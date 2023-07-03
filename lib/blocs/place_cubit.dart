import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/repositories/place_repository.dart';

import '../models/place.dart';

class PlaceCubit extends Cubit<bool> {
  PlaceCubit(this.placeRepository) : super(false);

  final PlaceRepository placeRepository;
  
  Future<void> savePlace(Place place) async{
    emit(await placeRepository.savePlace(place));
  }

}