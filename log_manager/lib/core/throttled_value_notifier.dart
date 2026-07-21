import 'dart:async';

import 'package:flutter/foundation.dart';

class ThrottledValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
  int _maxNum = 0;
  int _milTime = 0;
  final List<T> _value = [];
  final Set<T> _set = {};
  Timer? _timer;
  bool startNotifier = false;

  ThrottledValueNotifier() {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
    setThrottleConfig();
  }

  void _initTimer() {
    _timer = Timer(Duration(milliseconds: _milTime), () {
      _timer = null;
      notifyListeners();
    });
  }

  @override
  List<T> get value => List.unmodifiable(_value);

  void setThrottleConfig({int maxSize = 500, int throttleTime = 1000}) {
    if (maxSize > 0) {
      _maxNum = maxSize;
    }
    if (throttleTime > 0) {
      _milTime = throttleTime;
    }
  }

  void clear() {
    _value.clear();
    _set.clear();
    notifyListeners();
  }

  void setValue(T newValue) {
    if (_set.contains(newValue)) {
      return;
    }
    if (_value.length >= _maxNum) {
      final oldValue = _value.removeAt(0);
      _set.remove(oldValue);
    }
    _value.add(newValue);
    _set.add(newValue);

    if (!startNotifier) {
      return;
    }

    if (_timer?.isActive != true) {
      notifyListeners();
      _initTimer();
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';

  @override
  void dispose() {
    startNotifier = false;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
