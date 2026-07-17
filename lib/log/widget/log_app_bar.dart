import 'package:flutter/material.dart';

class LogAppBar extends StatefulWidget {
  const LogAppBar({super.key});

  @override
  State<LogAppBar> createState() => _LogAppBarState();
}

class _LogAppBarState extends State<LogAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(height: 54, width: double.infinity);
  }
}
