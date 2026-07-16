import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/common/toast_util.dart';
import 'package:flutter_base/get/controller/get_main_controller.dart';
import 'package:flutter_base/get/ui/get_bill_page.dart';
import 'package:flutter_base/get/ui/get_home_page.dart';
import 'package:flutter_base/get/ui/get_mine_page.dart';
import 'package:get/get.dart';

class GetMainPage extends StatefulWidget {
  const GetMainPage({super.key});

  @override
  State<GetMainPage> createState() => _GetMainPageState();
}

class _GetMainPageState extends State<GetMainPage> {
  final GetMainController _controller = Get.find<GetMainController>();
  DateTime? _lastTime;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            final lastTime = _lastTime;
            if (lastTime == null ||
                DateTime.now().difference(lastTime) >
                    const Duration(seconds: 2)) {
              _lastTime = DateTime.now();
              ToastUtil.toast(content: "Ketuk sekali lagi untuk keluar");
              return;
            }
            exit(0);
          }
        },
        child: Scaffold(
          bottomNavigationBar: Obx(
            () => MainBottomBar(
              selectedIndex: _controller.curPosition.value,
              onTabClick: _controller.onTabClick,
            ),
          ),
          body: PageView.builder(
            controller: _controller.pageController,
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (pageContext, index) {
              switch (index) {
                case 0:
                  return GetHomePage();
                case 1:
                  return GetBillPage();
                case 2:
                  return GetMinePage();
                default:
                  return null;
              }
            },
          ),
        ),
      ),
    );
  }
}

class MainBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabClick;

  const MainBottomBar({
    super.key,
    required this.selectedIndex,
    this.onTabClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(selectedIndex == 0, "首页", () {
              onTabClick?.call(0);
            }),
          ),
          Expanded(
            child: _buildTabItem(selectedIndex == 1, "账单", () {
              onTabClick?.call(1);
            }),
          ),
          Expanded(
            child: _buildTabItem(selectedIndex == 2, "我的", () {
              onTabClick?.call(2);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(bool isSelected, String title, VoidCallback onTap) {
    return SingleTapDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
