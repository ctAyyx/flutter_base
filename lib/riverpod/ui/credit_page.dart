import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/common_widget.dart';
import 'package:flutter_base/riverpod/mvi/state/credit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mvi/viewmodel/credit_viewmodel.dart';

/// 优化列表中 item改变
@RoutePage()
class CreditPage extends ConsumerStatefulWidget {
  const CreditPage({super.key});

  @override
  ConsumerState createState() => _CreditPageState();
}

class _CreditPageState extends ConsumerState<CreditPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(creditViewModel.notifier).queryOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, ref, child) {
          final uiState = ref.watch(
            creditViewModel.select((state) => state.uiState),
          );
          debugPrint("===>>重组LoadingContainer$uiState");
          return LoadingContainer(
            isLoading: uiState == CreditUiState.loading,
            child: child,
          );
        },
        child: Consumer(
          builder: (_, ref, _) {
            final size = ref.watch(
              creditViewModel.select((state) => state.options?.length ?? 0),
            );
            debugPrint("===>>重组ListView");
            return ListView.builder(
              itemCount: size,
              itemBuilder: (context, index) {
                final item = ref.read(creditViewModel).options?[index];
                return OptionItemWidget(id: item!.id);
              },
            );
          },
        ),
      ),
    );
  }
}

class OptionItemWidget extends ConsumerWidget {
  final String id;

  const OptionItemWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final item = ref.watch(
    //   creditViewModel.select((state) {
    //     debugPrint("===>>>筛选数据:$id");
    //     return state.options?.firstWhere((e) => e.id == id);
    //   }),
    // );
    final item = ref.watch(itemNotifier(id));
    debugPrint("===>>重组OptionItemWidget$id");
    return ListTile(
      title: Text(
        item?.isSelected == true ? "选中:${item?.title}" : "${item?.title}",
      ),
      onTap: () {
        ref.read(creditViewModel.notifier).selectedItem(id);
      },
    );
  }
}
