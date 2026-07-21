import 'package:flutter/cupertino.dart';
import 'package:flutter_base/riverpod/mvi/bean/option_item.dart';
import 'package:flutter_base/riverpod/mvi/state/credit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get/get.dart';
import 'package:log_sys/core/log_manager.dart';

final creditViewModel = StateNotifierProvider.autoDispose(
  (ref) => CreditNotifier(CreditState.init()),
);

final itemNotifier = Provider.family<OptionItem?, String>((ref, id) {
  return ref.watch(
    creditViewModel.select(
      (state) => state.options?.firstWhereOrNull((e) {
        LogManager.logI("筛选数据ItemNotifier：$e");
        return e.id == id;
      }),
    ),
  );
});

class CreditNotifier extends StateNotifier<CreditState> {
  CreditNotifier(super.state);

  Future<void> queryOptions() async {
    state = state.copyWith(uiState: CreditUiState.loading);
    await Future.delayed(Duration(seconds: 3));
    state = state.copyWith(
      uiState: CreditUiState.success,
      options: List.generate(
        50,
        (index) =>
            OptionItem(id: "$index", title: "选项:$index", isSelected: false),
      ),
    );
  }

  void selectedItem(String targetId) {
    final options = state.options;
    if (options == null) {
      return;
    }
    state = CreditState(
      uiState: state.uiState,
      options: options.map((data) {
        if (data.id == targetId) {
          return data.copyWith(isSelected: !data.isSelected);
        } else if (data.isSelected) {
          return data.copyWith(isSelected: false);
        } else {
          return data;
        }
      }).toList(),
    );
  }
}
