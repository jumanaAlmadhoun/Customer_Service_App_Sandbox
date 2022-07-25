import 'package:flutter/services.dart';

class UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class OneDigitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length >= 2) {
      String lastLetter = newValue.text;
      if (!lastLetter.contains('.')) {
        String newText = newValue.text.substring(0, 1);

        return newValue.replaced(
            TextRange(start: 1, end: newValue.text.length), "");
      }
    }
    return newValue.copyWith(text: newValue.text);
  }
}
