import 'package:flutter/material.dart';
import 'package:log_manager/log_bean.dart';

class LogTab extends StatefulWidget {
  final ValueChanged<List<LogType>> onTabClick;

  const LogTab({super.key, required this.onTabClick});

  @override
  State<LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          _buildTab(
            title: "All",
            index: 0,
            onTap: () {
              widget.onTabClick.call([]);
            },
          ),
          _buildTab(
            title: "Http Request",
            index: 1,
            onTap: () {
              widget.onTabClick.call([LogType.httpRequest]);
            },
          ),
          _buildTab(
            title: "Http Response",
            index: 2,
            onTap: () {
              widget.onTabClick.call([LogType.httpResponse]);
            },
          ),
          _buildTab(
            title: "Error",
            index: 3,
            onTap: () {
              widget.onTabClick.call([LogType.httpError, LogType.error]);
            },
          ),
          _buildTab(
            title: "Info",
            index: 4,
            onTap: () {
              widget.onTabClick.call([LogType.info, LogType.warning]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required int index,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        if (selectIndex != index) {
          setState(() {
            selectIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectIndex == index ? Colors.redAccent : Colors.white70,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: selectIndex == index ? Colors.redAccent : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
