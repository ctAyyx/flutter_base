import 'package:flutter/material.dart';
import 'package:flutter_base/log/log_manager.dart';

class LogController {
  // 日志状态过滤
  final ValueNotifier<List<LogLevel>> levelFilter = ValueNotifier([]);

  // 关键字
  final ValueNotifier<String> searchFilter = ValueNotifier("");

  //late final Listenable listenable;

  final ValueNotifier<List<LogEntity>> filterLogs = ValueNotifier([]);

  late final TextEditingController keyController;

  void init() {
    // listenable = Listenable.merge([
    //   LogManager.instance.logsNotifier,
    //   searchFilter,
    //   levelFilter,
    // ]);
    LogManager.logsNotifier.addListener(() {
      print("===>>>logsNotifier 开始重新过滤");
      onSourceChanged();
    });
    searchFilter.addListener(() {
      print("===>>>searchFilter 开始重新过滤");
      onSourceChanged();
    });
    levelFilter.addListener(() {
      print("===>>>levelFilter 开始重新过滤");
      onSourceChanged();
    });
    // listenable.addListener(onSourceChanged);
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

  List<LogEntity> _applyFilter() {
    final List<LogEntity> preResult = [];
    final logs = LogManager.logsNotifier.value.reversed;
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
    //listenable.removeListener(onSourceChanged);
    keyController.removeListener(onTextChanged);
    keyController.dispose();
  }

  void onFilter(List<LogLevel> filter) {
    levelFilter.value = filter;
  }
}
