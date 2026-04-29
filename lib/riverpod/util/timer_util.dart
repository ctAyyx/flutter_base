import 'dart:async';

class TimerUtil {
  Timer? _timer;
  int _downTime = 0;

  void startCountdown({required int downTime, Function(int time)? onTick}) {
    cancel();
    _downTime = downTime;
    onTick?.call(_downTime);
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _downTime -= 1000;
      if (_downTime >= 1000) {
        onTick?.call(_downTime);
      } else {
        cancel();
        onTick?.call(0);
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
