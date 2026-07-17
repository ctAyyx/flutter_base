class LogManagerConfig {
  final String? fsApi;
  final int maxLogs;

  // 普通日志颜色
  final String logInfoColor;

  // 错误日志颜色
  final String logErrorColor;

  // 警告日志颜色
  final String logWaringColor;

  // Http响应日志颜色
  final String httpResponseColor;

  // Http请求日志颜色
  final String httpRequestColor;

  LogManagerConfig(
      {this.fsApi,
        required this.maxLogs,
        required this.logInfoColor,
        required this.logErrorColor,
        required this.logWaringColor,
        required this.httpResponseColor,
        required this.httpRequestColor});

  factory LogManagerConfig.init(
      {String? fsApi,
        int maxLogs = 500,
        // 普通日志颜色 蓝色
        String logInfoColor = '\x1b[34m',
        // 错误日志颜色 红色
        String logErrorColor = '\x1b[31m',
        // 警告日志颜色 黄色
        String logWaringColor = '\x1b[33m',
        // Http响应日志颜色 绿色
        String httpResponseColor = '\x1b[32m',
        // Http请求日志颜色 青色
        String httpRequestColor = '\x1b[36m'}) =>
      LogManagerConfig(
          fsApi: fsApi,
          maxLogs: maxLogs,
          logInfoColor: logInfoColor,
          logErrorColor: logErrorColor,
          logWaringColor: logWaringColor,
          httpResponseColor: httpResponseColor,
          httpRequestColor: httpRequestColor);
}