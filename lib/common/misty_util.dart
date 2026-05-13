extension StringMisty on String? {
  String decrypt() {
    return MistyUtil.decrypt(inputStr: this);
  }

  String encrypt() {
    return MistyUtil.encrypt(inputStr: this);
  }
}

class MistyUtil {
  MistyUtil._();

  static String encrypt({
    required String? inputStr,
    String key = "",
    String nonce = "",
  }) {
    return "";
  }

  static String decrypt({
    required String? inputStr,
    String key = "",
    String nonce = "",
  }) {
    return "";
  }
}
