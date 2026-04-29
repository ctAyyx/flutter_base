import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("设置"));
  }
}