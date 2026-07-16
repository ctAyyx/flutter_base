import 'package:flutter/services.dart';

/// 银行卡格式化
/// 限制了只能输入数字  长度为20  每4位间隔一个空格

class CardFormatter extends TextInputFormatter {
  final String divider;
  final int maxLength;
  final String pattern;
  String Function(String text, String divider) formatText;

  CardFormatter({
    this.divider = ' ',
    this.maxLength = 20,
    this.pattern = r'[^0-9]',
    this.formatText = _formatBankCard,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    String oldText = oldValue.text;
    int oldOffset = oldValue.selection.start;

    String newText = newValue.text;
    int newOffset = newValue.selection.start;
    final isDeleting = oldText.length - newText.length == 1;
    // debugPrint(
    //   "当前输入框校验前旧文本:$oldText 光标: $oldOffset -新文本:$newText 光标:$newOffset ",
    // );
    if (isDeleting && newOffset > 0 && oldText[newOffset] == divider) {
      // 也要移除新光标前的字符
      newText = newText.replaceRange(newOffset - 1, newOffset, '');
      newOffset -= 1;
    }

    // debugPrint(
    //   "当前输入框校验后旧文本:$oldText 光标: $oldOffset -新文本:$newText 光标:$newOffset ",
    // );
    String cleanNewText = newText.replaceAll(divider, '');
    if (RegExp(pattern).hasMatch(cleanNewText) ||
        cleanNewText.length > maxLength) {
      return oldValue;
    }
    final formattedText = _formatBankCard(cleanNewText, divider);
    int offset = formattedText.length;
    if (isDeleting) {
      if (newOffset < offset) {
        offset = newOffset;
      }
    } else {
      offset = newOffset + formattedText.length - newText.length;
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}

///=========================
String _formatBankCard(String cleanNewText, String divider) {
  final formattedBuffer = StringBuffer();
  for (int i = 0; i < cleanNewText.length; i++) {
    formattedBuffer.write(cleanNewText[i]);
    final nonZeroIndex = i + 1;
    if (nonZeroIndex % 4 == 0 && nonZeroIndex != cleanNewText.length) {
      formattedBuffer.write(divider);
    }
  }
  final formattedText = formattedBuffer.toString();
  return formattedText;
}
