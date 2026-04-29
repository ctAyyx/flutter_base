import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Column(
          children: [
            SizedBox(height: 48,),
            SubmitButton(
              text: "登录界面",
              onClick: () {
                context.pushRoute(LoginRoute());
              },
            ),
          ],
        ),
      ),
    );
  }
}
