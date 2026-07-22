class TimeUtil {
  static String getFormatTime(DateTime time) {
    String year = time.year.toString();
    String month = time.month.toString().padLeft(2, '0');
    String day = time.day.toString().padLeft(2, '0');

    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    // 毫秒是3位数，所以用 padLeft(3, '0')
    String millisecond = time.millisecond.toString().padLeft(3, '0');

    String formatted = "$year-$month-$day $hour:$minute:$second:$millisecond";

    return formatted;
  }
}
