import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsetsGeometry.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

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
            child: AbsorbPointer(
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: const LoadingWidget(),
              ),
            ),
          ),
      ],
    );
  }
}

class ObxLoadingContainer extends StatelessWidget {
  final Rx<bool>? isLoading;
  final Widget child;

  const ObxLoadingContainer({super.key, this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading != null)
          Obx(() {
            if (isLoading?.value == true) {
              return Positioned.fill(
                child: AbsorbPointer(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsetsGeometry.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
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
          _lastClickTime = currentTime;
          widget.onTap?.call();
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
  final TextStyle? textStyle;
  final VoidCallback? onClick;
  final EdgeInsets? padding;

  const SubmitButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.padding,
    this.decoration,
    this.textStyle,
    this.onClick,
  });

  factory SubmitButton.general({
    required String text,
    double? width = double.infinity,
    double? height = 54,
    EdgeInsets? padding,
    Decoration? decoration = const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(Radius.circular(54)),
    ),
    TextStyle? textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    VoidCallback? onClick,
  }) {
    return SubmitButton(
      text: text,
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      textStyle: textStyle,
      onClick: onClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleTapDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: decoration,
        child: Center(child: Text(text, style: textStyle)),
      ),
    );
  }
}

class Interval extends StatelessWidget {
  const Interval({super.key});

  factory Interval.horizontal({double width = 1}) {
    return Interval();
  }

  factory Interval.vertical({double width = 1}) {
    return Interval();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
