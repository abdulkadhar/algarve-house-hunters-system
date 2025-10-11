import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasteDetector extends TextInputFormatter {
  final void Function(String pastedText) onPaste;

  PasteDetector({required this.onPaste});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length - oldValue.text.length > 1) {
      // Likely a paste (sudden multiple chars)
      final pastedText = newValue.text.replaceFirst(oldValue.text, '');
      onPaste(pastedText);
    }
    return newValue;
  }
}
