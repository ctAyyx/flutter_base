import 'dart:async';

import 'package:flutter/foundation.dart';

class ThrottledValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
  int _maxNum = 0;
  int _milTime = 0;
  final List<T> _value = [];
  final Set<T> _set = {};
  Timer? _timer;

  bool _hasPendingChanges = false;
  bool _isDisposed = false;

  ThrottledValueNotifier() {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
    setThrottleConfig();
  }

  void _initTimer() {
    if (!hasListeners) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    _timer = Timer(Duration(milliseconds: _milTime), () {
      if (_isDisposed) return;
      _timer = null;
      if (_hasPendingChanges && hasListeners) {
        _hasPendingChanges = false;
        _notifier();
        _initTimer();
      }
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
    _hasPendingChanges = false;
    _timer?.cancel();
    _timer = null;
    _notifier();
  }

  void _notifier() {
    if (!_isDisposed && hasListeners) {
      scheduleMicrotask(() {
        if (!_isDisposed && hasListeners) {
          notifyListeners();
        }
      });
    }
  }

  void setValue(T newValue) {
    if (_isDisposed || _set.contains(newValue)) {
      return;
    }
    if (_value.length >= _maxNum) {
      final oldValue = _value.removeAt(0);
      _set.remove(oldValue);
    }
    _value.add(newValue);
    _set.add(newValue);

    if (!hasListeners) {
      _hasPendingChanges = false;
      return;
    }

    if (_timer?.isActive != true) {
      _hasPendingChanges = false;
      _notifier();
      _initTimer();
    } else {
      _hasPendingChanges = true;
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isDisposed = true;
    super.dispose();
  }
}
