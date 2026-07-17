import 'package:flutter/material.dart';

import 'log_screen.dart';

class FloatButton {
  static OverlayEntry? _overlayEntry;
  static Offset _offset = const Offset(-1, -1);

  static void show(OverlayState? overlayState) {
    if (_overlayEntry != null || overlayState == null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        if (_offset.dx == -1 && _offset.dy == -1) {
          final size = MediaQuery.of(context).size;
          _offset += Offset(size.width - 56, size.height - 76);
        }

        return Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              _offset += details.delta;
              _overlayEntry?.markNeedsBuild();
            },
            child: Material(
              elevation: 4.0,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => LogScreen()));
                  },
                  icon: const Icon(Icons.ads_click, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  static void hide() {}
}
