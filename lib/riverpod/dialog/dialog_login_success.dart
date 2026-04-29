import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../common/common_widget.dart';

class LoginSuccessDialog extends StatelessWidget {
  const LoginSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "登录成功",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 56),
          SubmitButton(
            text: "回到上一页",
            onClick: () {
              context.pop(true);
            },
          ),
        ],
      ),
    );
    ;
  }
}
