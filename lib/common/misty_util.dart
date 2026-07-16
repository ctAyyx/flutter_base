import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;

import '../constants.dart';

extension StringMisty on String? {
  // String decrypt() {
  //   return MistyUtil.decodeByBase64AES(inputStr: this);
  // }
  //
  // String encrypt() {
  //   return MistyUtil.encrypt(inputStr: this);
  // }

  String encrypt({String keyStr = Constants.keyCrypt}) =>
      MistyUtil.encodeByBase64AES(this, keyStr);

  String decrypt({String keyStr = Constants.keyCrypt}) =>
      MistyUtil.decodeByBase64AES(this, keyStr);
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

  static const enc.AESMode _aesMode = enc.AESMode.ecb;
  static const String _aesPadding = 'PKCS7';

  static String encodeByBase64AES(String? encrypt, String? keyStr) {
    if (encrypt == null || keyStr == null) {
      return encrypt ?? "";
    }
    try {
      final keyBytes = utf8.encode(keyStr);
      if (keyBytes.length != 16 &&
          keyBytes.length != 24 &&
          keyBytes.length != 32) {
        return encrypt;
      }
      final key = enc.Key(Uint8List.fromList(keyBytes));
      final encrypter = enc.Encrypter(
        enc.AES(key, mode: _aesMode, padding: _aesPadding),
      );
      final encrypted = encrypter.encrypt(encrypt); // 默认使用 UTF-8 编码 src
      return encrypted.base64;
    } catch (e) {
      return encrypt;
    }
  }

  static String decodeByBase64AES(String? encrypt, String? keyStr) {
    if (encrypt == null || encrypt.isEmpty || keyStr == null) {
      return encrypt ?? "";
    }
    try {
      final keyBytes = utf8.encode(keyStr);
      if (keyBytes.length != 16 &&
          keyBytes.length != 24 &&
          keyBytes.length != 32) {
        return encrypt;
      }
      final key = enc.Key(Uint8List.fromList(keyBytes));

      final encrypter = enc.Encrypter(
        enc.AES(key, mode: _aesMode, padding: _aesPadding),
      );
      final decrypted = encrypter.decrypt(enc.Encrypted.fromBase64(encrypt));
      return decrypted;
    } catch (e) {
      return encrypt;
    }
  }
}
