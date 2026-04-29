import 'package:flutter_base/riverpod/mvi/bean/home_vo.dart';

enum HomeUiState { init, loading, success, fail }

class HomeState {
  final HomeUiState uiState;
  final HomeVo? homeVo;

  HomeState({
    required this.uiState,
    this.homeVo,
  });

  static HomeState init() {
    return HomeState(uiState: HomeUiState.init);
  }

  HomeState copyWith({
    required HomeUiState uiState,
    HomeVo? homeVo,
    int? downTime,
    int? creditingDownTimeStep,
  }) {
    return HomeState(
      uiState: uiState,
      homeVo: homeVo ?? this.homeVo,
    );
  }
}

enum HomeTimerUiState { init, reLoad, firstStep, secondStep, end }

class HomeTimerState {
  final int downTime;
  final HomeTimerUiState uiState;

  HomeTimerState({required this.uiState, required this.downTime});

  static HomeTimerState init() =>
      HomeTimerState(uiState: HomeTimerUiState.init, downTime: 0);

  HomeTimerState copyWith({required HomeTimerUiState uiState, int? downTime}) {
    return HomeTimerState(
      uiState: uiState,
      downTime: downTime ?? this.downTime,
    );
  }
}
