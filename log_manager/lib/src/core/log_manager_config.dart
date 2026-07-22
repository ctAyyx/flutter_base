class LogManagerConfig {
  final String? fsApi;

  // 最大日志数量
  final int maxLogs;

  // 日志刷新间隔 避免频繁刷新导致ANR
  final int throttleTime;

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

  LogManagerConfig._(
      {this.fsApi,
      required this.maxLogs,
      required this.throttleTime,
      required this.logInfoColor,
      required this.logErrorColor,
      required this.logWaringColor,
      required this.httpResponseColor,
      required this.httpRequestColor});

  factory LogManagerConfig.init(
          {
          // 飞书webhook 用来发送日志到飞书
          String? fsApi,
          // 最大日志条数
          int maxLogs = 500,
          // 日志刷新间隔
          int throttleTime = 1000,
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
      LogManagerConfig._(
          fsApi: fsApi,
          maxLogs: maxLogs,
          throttleTime: throttleTime,
          logInfoColor: logInfoColor,
          logErrorColor: logErrorColor,
          logWaringColor: logWaringColor,
          httpResponseColor: httpResponseColor,
          httpRequestColor: httpRequestColor);
}
