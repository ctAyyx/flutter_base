import 'package:flutter_base/riverpod/mvi/repository/login_repository.dart';
import 'package:flutter_base/riverpod/mvi/state/login_state.dart';
import 'package:flutter_base/riverpod/provider/repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final loginViewModel = StateNotifierProvider.autoDispose(
  (ref) => LoginNotifier(ref.watch(loginRepository), LoginState.init()),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginRepository _repository;

  LoginNotifier(this._repository, super.state);

  Future<void> login({required String phone, required String pwd}) async {
    state = state.copyWith(uiState: LoginUiState.loading);
    final result = await _repository.login(phone, pwd);
    state = state.copyWith(uiState: LoginUiState.loginSuccess, user: result);
  }
}
