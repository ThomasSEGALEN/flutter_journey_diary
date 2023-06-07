import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/repositories/user_repository.dart';

class UserCubit extends Cubit<bool> {
  UserCubit(this.userRepository) : super(false);

  final UserRepository userRepository;

  Future<void> init() async {
    emit(await userRepository.init());
  }

  Future<void> login(String email, String password) async {
    emit(await userRepository.login(email, password));
  }

  Future<bool> register(String email, String password) async {
    bool registerState = await userRepository.register(email, password);

    return registerState;
  }

  Future<void> logout() async {
    emit(await userRepository.logout());
  }
}
