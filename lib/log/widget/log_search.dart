import 'package:flutter/material.dart';

class LogSearch extends StatefulWidget {
  final TextEditingController controller;

  const LogSearch({super.key, required this.controller});

  @override
  State<LogSearch> createState() => _LogSearchState();
}

class _LogSearchState extends State<LogSearch> {
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: Colors.white, fontSize: 12),
        decoration: InputDecoration(
          border: InputBorder.none,
          hint: Text(
            "关键字过滤",
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
