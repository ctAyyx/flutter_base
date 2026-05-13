import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupHelper {
  PopupHelper._();

  static Future<T?> showBottomSheetDialog<T>({required Widget content}) async {
    return Get.bottomSheet(
      content,
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  static Future<bool?> showDialog({required Widget content}) async {
    return Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: content,
      ),
    );
  }
}
