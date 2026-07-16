import 'package:flutter_base/riverpod/mvi/bean/option_item.dart';

enum CreditUiState { init, loading, success, fail }

class CreditState {
  final CreditUiState uiState;
  final List<OptionItem>? options;

  CreditState({required this.uiState, this.options});

  static CreditState init() {
    return CreditState(uiState: CreditUiState.init);
  }

  CreditState copyWith({
    required CreditUiState uiState,
    List<OptionItem>? options,
  }) {
    return CreditState(uiState: uiState, options: options ?? this.options);
  }
}
