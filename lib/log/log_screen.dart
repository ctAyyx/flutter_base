import 'package:flutter/material.dart';
import 'package:flutter_base/log/log_controller.dart';
import 'package:flutter_base/log/log_manager.dart';

import 'widget/log_search.dart';
import 'widget/log_tab.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  late final LogController _logController;

  @override
  void initState() {
    super.initState();
    _logController = LogController();
    _logController.init();
  }

  @override
  void dispose() {
    _logController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("App运行日志", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          LogTab(onTabClick: _logController.onFilter),
          const SizedBox(height: 8),
          LogSearch(controller: _logController.keyController),
          Expanded(
            child: ValueListenableBuilder(
              key: ValueKey("A"),
              valueListenable: _logController.filterLogs,
              builder: (context, filterLogs, _) {
                return ListView.separated(
                  key: ValueKey("A"),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: filterLogs.length,
                  itemBuilder: (context, index) {
                    final item = filterLogs[index];
                    return _buildItem(context, index, item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 获取颜色
  Color _getLogColor(LogEntity entity) {
    switch (entity.level) {
      case LogLevel.info:
        return Colors.lightBlueAccent;
      case LogLevel.warning:
        return Colors.yellowAccent;
      case LogLevel.error:
      case LogLevel.httpError:
        return Colors.redAccent;
      case LogLevel.httpRequest:
        return Color(0xFF00FFFF);
      case LogLevel.httpResponse:
        return Color(0xFF00FF00);
    }
  }

  /// 创建Item
  Widget _buildItem(BuildContext context, int index, LogEntity entity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white60),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entity.time, style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(width: 8),
          Text(
            entity.getRMessage(),
            style: TextStyle(color: _getLogColor(entity), fontSize: 12),
          ),
          Row(
            children: [
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.white70,
                child: IconButton(
                  iconSize: 18,
                  onPressed: () async {
                    LogManager.send2Fs(entity);
                  },
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
