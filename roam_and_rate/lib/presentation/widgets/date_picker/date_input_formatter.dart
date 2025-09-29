// date_input_formatter.dart
import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.isEmpty) {
      return const TextEditingValue();
    }

    String formatted = '';
    int selectionIndex = 0;

    for (int i = 0; i < text.length && i < 8; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
        if (newValue.selection.baseOffset > i + (i ~/ 2)) {
          selectionIndex++;
        }
      }
      formatted += text[i];
      if (newValue.selection.baseOffset > i) {
        selectionIndex++;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: selectionIndex.clamp(0, formatted.length),
      ),
    );
  }
}
