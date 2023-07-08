import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/blocs/notebook/to_visit_state.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';
import 'package:flutter_journey_diary/repositories/notebook/to_visit_repository.dart';

class ToVisitCubit extends Cubit<ToVisitState> {
  ToVisitCubit(this.toVisitRepository) : super(ToVisitState.loading());

  final ToVisitRepository toVisitRepository;

  Future<void> getVisits() async {
    try {
      emit(ToVisitState.loading());

      final List<GooglePointOfInterest> visits =
          await toVisitRepository.getVisits();

      emit(ToVisitState.loaded(visits));
    } catch (e) {
      log(e.toString());

      emit(ToVisitState.error());
    }
  }

  Future<void> addToVisits(GooglePointOfInterest visit) async {
    await toVisitRepository.addToVisits(visit);
  }

  Future<void> removeFromVisits(GooglePointOfInterest visit) async {
    await toVisitRepository.removeFromVisits(visit);
  }
}
