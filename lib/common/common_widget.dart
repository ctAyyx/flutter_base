import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final bool? isLoading;
  final Widget child;

  const LoadingContainer({super.key, this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading == true)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: Center(
                child: Container(
                  padding: const EdgeInsetsGeometry.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SingleTapDetector extends StatefulWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final int debounceTime;
  final HitTestBehavior? behavior;

  const SingleTapDetector({
    super.key,
    this.child,
    this.onTap,
    this.debounceTime = 200,
    this.behavior,
  });

  @override
  State<SingleTapDetector> createState() => _SingleTapDetectorState();
}

class _SingleTapDetectorState extends State<SingleTapDetector> {
  int _lastClickTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: () {
        int currentTime = DateTime.now().millisecondsSinceEpoch;
        if (currentTime - _lastClickTime > widget.debounceTime) {
          widget.onTap?.call();
        } else {
          _lastClickTime = currentTime;
        }
      },
      child: widget.child,
    );
  }
}

class SubmitButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Decoration? decoration;
  final String text;
  final TextStyle? style;
  final VoidCallback? onClick;

  const SubmitButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.decoration,
    this.style,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 54,
        decoration:
            decoration ??
            BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(54),
            ),
        child: Center(
          child: Text(
            text,
            style: style ?? TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
