import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/get/controller/get_login_controller.dart';
import 'package:get/get.dart';

class GetLoginPage extends StatefulWidget {
  const GetLoginPage({super.key});

  @override
  State<GetLoginPage> createState() => _GetLoginPageState();
}

class _GetLoginPageState extends State<GetLoginPage> {
  final LoginController _controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ObxLoadingContainer(
      isLoading: _controller.isLoadingObx,
      child: Scaffold(
        appBar: AppBar(title: Text("测试Get")),
        body: Column(
          children: [
            Text("时间:${DateTime.now().millisecondsSinceEpoch}"),
            TextField(controller: _controller.phoneController),
            TextField(controller: _controller.pwdController),
            SubmitButton.general(text: "提交", onClick: _controller.login),
            Obx(() {
              if (_controller.loginErrorInfo.value.isNotEmpty) {
                return Text(_controller.loginErrorInfo.value);
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}

class LoginReplace extends StatelessWidget {
  const LoginReplace({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController _controller = Get.find<LoginController>();
    _controller.loginErrorInfo.listen((data) {});
    return Obx(() {
      return LoadingContainer(
        isLoading: _controller.isLoading,
        child: Column(
          children: [
            Container(
              child: Obx(() {
                if (_controller.loginErrorInfo.isNotEmpty)
                  return Text("复杂布局");
                else
                  return Text("复杂布局2");
              }),
            ),
          ],
        ),
      );
    });
  }
}
