import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';
import 'package:flutter_base/riverpod/util/timer_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:log_sys/log_export.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  int _time = 0;
  TimerUtil? _timer;

  @override
  void initState() {
    super.initState();
    _timer = TimerUtil();
    _timer?.startCountdown(
      downTime: 10 * 60 * 1000,
      onTick: (time) {
        if (time > 0) {
          setState(() {
            _time = time;
          });
        } else {
          //context.pushRoute(HomeRoute());
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  String _formatTime({required int time}) {
    Duration duration = Duration(milliseconds: time);
    final hours = (duration.inHours % 24).toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    LogManager.logW("倒计时:${"$hours:$minutes:$seconds"}");
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    LogManager.logI("===>>>");
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 24,
            children: [
              SubmitButton.general(
                text: "登录界面",
                onClick: () {
                  context.pushRoute(LoginRoute());
                },
              ),
              SubmitButton.general(
                text: "列表界面",
                onClick: () {
                  context.pushRoute(CreditRoute());
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("倒计时:${_formatTime(time: _time)}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
