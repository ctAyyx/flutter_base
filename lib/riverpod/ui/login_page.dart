import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/helper/popup_helper.dart';
import 'package:flutter_base/riverpod/mvi/state/login_state.dart';
import 'package:flutter_base/riverpod/mvi/viewmodel/login_viewmodel.dart';
import 'package:flutter_base/riverpod/router/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _phoneController;
  late TextEditingController _pwdController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _pwdController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModel);

    ref.listen(loginViewModel, (pre, next) async {
      switch (next.uiState) {
        case LoginUiState.loginSuccess:
          final result = await PopupHelper.showLoginSuccessDialog(
            context: context,
          );
          if (result == true && context.mounted) {
            context.router.replaceAll([MainRoute()]);
          }
          break;
        default:
          break;
      }
    });

    return LoadingContainer(
      isLoading: loginState.uiState == LoginUiState.loading,
      child: Scaffold(
        appBar: AppBar(title: Text("注册登录")),
        body: Column(
          children: [
            TextField(controller: _phoneController),
            TextField(controller: _pwdController),
            SubmitButton(
              text: "提交",
              onClick: () {
                final viewModel = ref.read(loginViewModel.notifier);
                viewModel.login(
                  phone: _phoneController.text,
                  pwd: _pwdController.text,
                );
              },
            ),
            Text("登录的用户信息:${loginState.user?.phone} - ${loginState.user?.pwd}"),
          ],
        ),
      ),
    );
  }
}
