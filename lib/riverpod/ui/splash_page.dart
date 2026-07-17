import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';
import 'package:flutter_base/riverpod/util/timer_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  int _time = 140 * 60 * 1000;
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
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Column(
          children: [
            const SizedBox(height: 48),
            SubmitButton.general(
              text: "登录界面",
              onClick: () {
                context.pushRoute(LoginRoute());
              },
            ),
            const SizedBox(height: 24),
            SubmitButton.general(
              text: "列表界面",
              onClick: () {
                context.pushRoute(CreditRoute());
              },
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            SubmitButton.general(text: "测试飞书消息", onClick: () {}),
            const SizedBox(height: 48),
            Text("倒计时:${_formatTime(time: _time)}"),
          ],
        ),
      ),
    );
  }
}
