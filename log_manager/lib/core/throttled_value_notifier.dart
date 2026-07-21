import 'dart:async';

import 'package:flutter/foundation.dart';

class ThrottledValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
  final int maxNum;
  final int milTime;
  final List<T> _value = [];
  final Set<T> _set = {};
  Timer? _timer;

  ThrottledValueNotifier({this.maxNum = 500, this.milTime = 500}) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  void initTimer() {
    _timer = Timer(Duration(milliseconds: milTime), () {
      _timer = null;
      notifyListeners();
    });
  }

  @override
  List<T> get value => List.unmodifiable(_value);

  void clear() {
    _value.clear();
    _set.clear();
    notifyListeners();
  }

  void setValue(T newValue) {
    if (_set.contains(newValue)) {
      return;
    }
    if (_value.length >= maxNum) {
      final oldValue = _value.removeAt(0);
      _set.remove(oldValue);
    }
    _value.add(newValue);
    _set.add(newValue);

    if (_timer?.isActive != true) {
      notifyListeners();
      initTimer();
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
