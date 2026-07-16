import 'package:flutter/material.dart';
import 'package:flutter_base/log/log_manager.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  Color _getLogColor(LogEntity entity) {
    switch (entity.level) {
      case LogLevel.info:
        if (entity.message.contains("[HTTP REQUEST]")) {
          return Color(0xFF00FFFF);
        } else if (entity.message.contains("[HTTP RESPONSE]")) {
          return Color(0xFF00FF00);
        }
        return Colors.lightBlueAccent;
      case LogLevel.warning:
        return Colors.yellowAccent;
      case LogLevel.error:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("App运行日志", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                _buildTab(
                  "All",
                  onTap: () {
                    final filters = LogManager.instance.filter.value;
                    LogManager.instance.filter.value = [filters[0], ""];
                  },
                ),
                _buildTab(
                  "Http Request",
                  onTap: () {
                    final filters = LogManager.instance.filter.value;
                    LogManager.instance.filter.value = [
                      filters[0],
                      "[HTTP REQUEST]",
                    ];
                  },
                ),
                _buildTab(
                  "Http Response",
                  onTap: () {
                    final filters = LogManager.instance.filter.value;
                    LogManager.instance.filter.value = [
                      filters[0],
                      "[HTTP RESPONSE]",
                    ];
                  },
                ),
                _buildTab(
                  "Error",
                  onTap: () {
                    final filters = LogManager.instance.filter.value;
                    LogManager.instance.filter.value = [
                      filters[0],
                      "[HTTP ERROR]",
                      "E:",
                    ];
                  },
                ),
                _buildTab(
                  "Info",
                  onTap: () {
                    final filters = LogManager.instance.filter.value;
                    LogManager.instance.filter.value = [filters[0], "I:", "W:"];
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: LogManager.instance.logsNotifier,
              builder: (context, logs, _) {
                return ValueListenableBuilder(
                  valueListenable: LogManager.instance.filter,
                  builder: (context, filters, _) {
                    final keys = filters
                        .where((key) => key.isNotEmpty)
                        .toList();
                    final filterLogs = logs.where((entity) {
                      if (keys.isEmpty) {
                        return true;
                      } else {
                        for (var key in keys) {
                          if (entity.message.contains(key)) {
                            return true;
                          }
                        }
                        return false;
                      }
                    }).toList();
                    return ListView.separated(
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filterLogs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final rIndex = filterLogs.length - 1 - index;
                        final item = filterLogs[rIndex];
                        return _buildItem(context, rIndex, item);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, LogEntity entity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white60),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entity.getFormatTime(),
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(width: 8),
                Text(
                  entity.getRMessage(),
                  style: TextStyle(color: _getLogColor(entity), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              LogManager.instance.send2Fs(entity);
            },
            icon: const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
