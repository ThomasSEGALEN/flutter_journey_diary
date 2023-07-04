import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_journey_diary/repositories/user_repository.dart';

class UserCubit extends Cubit<bool> {
  UserCubit(this.userRepository) : super(false);

  final UserRepository userRepository;

  Future<void> init() async {
    emit(await userRepository.init());
  }

  Future<bool> login(String email, String password) async {
    final bool loginState = await userRepository.login(email, password);
    emit(loginState);

    return loginState;
  }

  Future<bool> register(String email, String password) async {
    final bool registerState = await userRepository.register(email, password);

    return registerState;
  }

  Future<bool> logout() async {
    final bool logoutState = await userRepository.logout();
    emit(logoutState);

    return logoutState;
  }

  Future<bool> resetPassword(String username) async {
    final bool resetPasswordState = await userRepository.resetPassword(username);

    return resetPasswordState;
  }
}
