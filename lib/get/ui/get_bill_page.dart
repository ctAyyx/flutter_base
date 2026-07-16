import 'package:flutter/material.dart';
import 'package:flutter_base/get/controller/get_bill_controller.dart';
import 'package:get/get.dart';

class GetBillPage extends StatefulWidget {
  const GetBillPage({super.key});

  @override
  State<GetBillPage> createState() => _GetBillPageState();
}

class _GetBillPageState extends State<GetBillPage> {
  final GetBillController _controller = Get.find<GetBillController>();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("账单"));
  }
}
