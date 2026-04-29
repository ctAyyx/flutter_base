import 'package:flutter/material.dart';
import 'package:flutter_base/riverpod/dialog/dialog_login_success.dart';

class PopupHelper {
  PopupHelper._();

 static Future<bool?> showLoginSuccessDialog({required BuildContext context}) async {
    return await showModalBottomSheet(
      context: context,
      builder: (_) => LoginSuccessDialog(),
    );
  }
}
