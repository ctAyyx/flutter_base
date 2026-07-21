import 'package:flutter/material.dart';
import '../core/log_manager.dart';
import '../log_bean.dart';

class LogController {
  // 日志状态过滤
  final ValueNotifier<List<LogType>> levelFilter = ValueNotifier([]);

  // 关键字
  final ValueNotifier<String> searchFilter = ValueNotifier("");

  late final Listenable listenable;

  final ValueNotifier<List<LogEntity>> filterLogs = ValueNotifier([]);

  late final TextEditingController keyController;

  void init() {
    listenable = Listenable.merge([
      LogManager.getNotifier(),
      searchFilter,
      levelFilter,
    ]);

    listenable.addListener(onSourceChanged);
    filterLogs.value = _applyFilter();

    keyController = TextEditingController();
    keyController.addListener(onTextChanged);
  }

  void onSourceChanged() {
    final result = _applyFilter();

    filterLogs.value = result;
  }

  void onTextChanged() {
    final text = keyController.text.trim();
    if (text != searchFilter.value) {
      searchFilter.value = text;
    }
  }

  void clear() {
    LogManager.getNotifier()?.value = [];
  }

  List<LogEntity> _applyFilter() {
    final List<LogEntity> preResult = [];
    final logs = LogManager.getNotifier()?.value.reversed;
    if (logs == null) {
      return [];
    }
    final levelKeys = levelFilter.value;
    if (levelKeys.isNotEmpty) {
      final list = logs.where((entity) {
        return levelKeys.contains(entity.level);
      });
      preResult.addAll(list);
    } else {
      preResult.addAll(logs);
    }
    final searchKey = searchFilter.value.trim();
    if (searchKey.isEmpty) {
      return preResult;
    }

    return preResult
        .where((entity) => entity.getRMessage().contains(searchKey))
        .toList();
  }

  void dispose() {
    listenable.removeListener(onSourceChanged);
    keyController.removeListener(onTextChanged);
    keyController.dispose();
  }

  void onFilter(List<LogType> filter) {
    levelFilter.value = filter;
  }
}
