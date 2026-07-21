import 'util/time_util.dart';

/// 日志类型
enum LogType {
  info(key: "I:"),
  warning(key: "W:"),
  error(key: "E:"),
  httpRequest(key: "[HttpRequest]"),
  httpResponse(key: "[HttpResponse]"),
  httpError(key: "[HttpError]");

  final String key;

  const LogType({required this.key});
}

/// 日志实体
class LogEntity {
  final String message;
  final LogType level;
  final String time;

  LogEntity(this.message, this.level)
      : time = TimeUtil.getFormatTime(DateTime.now());

  String getRMessage() {
    RegExp regExp = RegExp(r"^(W:|I:|E:|N:)");
    return message.replaceFirst(regExp, "");
  }
}
