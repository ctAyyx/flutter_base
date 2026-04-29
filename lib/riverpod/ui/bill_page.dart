import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class BillPage extends ConsumerStatefulWidget {
  const BillPage({super.key});

  @override
  ConsumerState<BillPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<BillPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("账单"));
  }
}