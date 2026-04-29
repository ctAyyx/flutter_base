import 'package:flutter_base/riverpod/mvi/bean/user.dart';

enum LoginUiState { init, loading, loginSuccess, loginFail }

class LoginState {
  final LoginUiState uiState;
  final UserVo? user;

  LoginState({required this.uiState, this.user});

  static LoginState init() {
    return LoginState(uiState: LoginUiState.init);
  }

  LoginState copyWith({required LoginUiState uiState,UserVo? user, }) {
    return LoginState(uiState: uiState, user: user ?? this.user);
  }
}
