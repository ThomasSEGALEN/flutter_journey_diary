import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/location_state.dart';
import 'package:flutter_journey_diary/repositories/location_repository.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this.locationRepository) : super(LocationState.loading());

  final LocationRepository locationRepository;
}
