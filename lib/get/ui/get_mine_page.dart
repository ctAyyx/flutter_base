import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/get_mine_controller.dart';

class GetMinePage extends StatefulWidget {
  const GetMinePage({super.key});

  @override
  State<GetMinePage> createState() => _GetMinePageState();
}

class _GetMinePageState extends State<GetMinePage> {
  final GetMineController _controller = Get.find<GetMineController>();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("我的"));
  }
}
