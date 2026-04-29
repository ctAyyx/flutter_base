import 'package:flutter_base/riverpod/mvi/bean/home_vo.dart';
import 'package:flutter_base/riverpod/mvi/repository/home_repository.dart';
import 'package:flutter_base/riverpod/mvi/state/home_state.dart';
import 'package:flutter_base/riverpod/provider/repository_provider.dart';
import 'package:flutter_base/riverpod/util/timer_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final homeViewModel = StateNotifierProvider.autoDispose(
  (ref) => HomeNotifier(ref, ref.watch(homeRepository), HomeState.init()),
);

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;
  final HomeRepository repository;

  HomeNotifier(this.ref, this.repository, super.state);

  Future<void> onRefresh(int applyState) async {
    state = state.copyWith(uiState: HomeUiState.loading);
    final result = await repository.loadHomeInfo(applyState);
    if (result.applyState == 1) {
      ref.read(homeTimer.notifier).startTimer(result);
    }
    state = state.copyWith(uiState: HomeUiState.success, homeVo: result);
  }
}

final homeTimer = StateNotifierProvider.autoDispose(
  (ref) => HomeTimerNotifier(HomeTimerState.init()),
);

class HomeTimerNotifier extends StateNotifier<HomeTimerState> {
  HomeTimerNotifier(super.state);

  TimerUtil? _timerUtil;

  @override
  void dispose() {
    _timerUtil?.cancel();
    _timerUtil = null;
    super.dispose();
  }

  static int localTime = 0;

  Future<void> startTimer(HomeVo homeVo) async {
    final (downTime, uiState) = getDownTime(homeVo);
    _timerUtil?.cancel();
    _timerUtil = null;
    if (uiState == HomeTimerUiState.firstStep ||
        uiState == HomeTimerUiState.secondStep) {
      _timerUtil = TimerUtil();
      _timerUtil?.startCountdown(
        downTime: downTime,
        onTick: (time) {
          if (time > 0) {
            state = state.copyWith(uiState: uiState, downTime: time);
          } else {
            state = state.copyWith(uiState: HomeTimerUiState.reLoad);
          }
        },
      );
    } else {
      state = state.copyWith(uiState: HomeTimerUiState.end);
    }
  }

  (int, HomeTimerUiState) getDownTime(HomeVo homeVo) {
    if (homeVo.applyState != 1) return (0, HomeTimerUiState.end);
    final int firstDownTime = 1 * 30 * 1000;
    final int secondDownTime = 1 * 60 * 1000;
    final int targetTime = localTime;
    if (targetTime == 0) {
      localTime =
          DateTime.now().millisecondsSinceEpoch +
          firstDownTime +
          secondDownTime;
      return (firstDownTime, HomeTimerUiState.firstStep);
    } else {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final residueTime = targetTime - currentTime;
      if (residueTime - secondDownTime > 1000) {
        return (residueTime - secondDownTime, HomeTimerUiState.firstStep);
      }
      if (residueTime > 1000) {
        return (residueTime, HomeTimerUiState.secondStep);
      }
    }
    return (0, HomeTimerUiState.end);
  }
}
