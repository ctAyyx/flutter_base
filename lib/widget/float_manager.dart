import 'package:flutter/material.dart';
import 'main.dart';

class FloatManager {
  static final FloatManager _instance = FloatManager._();

  static FloatManager get instance => _instance;

  FloatManager._();

  OverlayState? get _overlayState => navigatorKey.currentState?.overlay;

  OverlayEntry? _loadingView;

  //显示Loading
  void showLoading({
    String? tag,
    OverlayEntry? loading,
    bool interceptorTap = true,
  }) {

    try {
      OverlayEntry loadingView = loading ?? buildDefaultLoadingView();
      final overlay = _overlayState;
      if (overlay != null && overlay.mounted) {
        overlay.insert(loadingView);
        _loadingView = loadingView;
      }
    } catch (_) {}
  }

  // 隐藏Loading

  void hideLoading({String? tag}) {
    final loadingView = _loadingView;
    _loadingView = null;
    if (loadingView == null) {
      return;
    }
    try {
      if (loadingView.mounted) {
        loadingView.remove();
      }
    } catch (_) {}
  }

  OverlayEntry buildDefaultLoadingView() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              color: Color(0x99000000),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
