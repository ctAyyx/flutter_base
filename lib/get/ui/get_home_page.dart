import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/get/app_routers.dart';
import 'package:flutter_base/get/controller/get_home_controller.dart';
import 'package:get/get.dart';

class GetHomePage extends StatefulWidget {
  const GetHomePage({super.key});

  @override
  State<GetHomePage> createState() => _GetHomePageState();
}

class _GetHomePageState extends State<GetHomePage> {
  final GetHomeController _controller = Get.find<GetHomeController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleTapDetector(
        onTap: () {
          Get.toNamed(AppRouters.login);
        },
        child: Text("首页"),
      ),
    );
  }
}
